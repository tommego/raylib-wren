import "cico.os.file" for File 
import "cico.os.sys" for Platform 
import "cico.json" for  Json 
import "cico/utils/serializer" for Serializer

var datas = []

if(Platform.argv.count < 3) {
    System.print("Usage: cico_app.exe path/to/sm2timestamp.wren input")
    return
}

var input = Platform.argv[1]
var output = Platform.argv[2]

var fin = File.new()
fin.open(input, "r")
var i = 0
while(!fin.atend) {
    if(i > 3) {
        var line = fin.readline()
        var items = line.split(",")
        for(j in 0...items.count) {
            items[j] = items[j].trim()
        }
        var acc = items[3...6]
        for(j in 0...3) {
            var val = Num.fromString(acc[j])
            if(val is Num) {
                acc[j] = (Num.fromString(acc[j]) * 9.8).toString
            }
        }
        var gyro = items[6...9]
        var mag = items[9...12]
        // acc[2] = "0"
        // acc.swap(1, 2)
        // mag.swap(1, 2)
        // gyro.swap(1, 2)

        datas.add({"acc": acc, "gyro": gyro, "mag": mag})
    }
    i = i + 1
}

var strdata = ""
for(d in datas) {
    var s = ""
    for (item in d["acc"]) {
        s = s + item + ","
    }
    for (item in d["gyro"]) {
        s = s + item + ","
    }
    for (item in d["mag"]) {
        s = s + item + ","
    }
    s = s[0...s.count-1]
    strdata = strdata + s + "\t\r"
}
var fout = File.new()
fout.open(output, "w")
fout.write(strdata)
fout.flush()
fout.close()