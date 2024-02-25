import "cico.os.file" for File 
import "cico.os.sys" for Platform 
import "cico.json" for  Json 
import "cico/utils/serializer" for Serializer
import "cico.raylib" for Raylib,Image,Color,FilePathList

if(Platform.argv.count < 2) {
    System.print("Usage: cico_app.exe path/to/sm2timestamp.wren input")
    return
}

var indir = Platform.argv[1]
var outdir = Platform.argv[2]

var dir = FilePathList.new()
Raylib.LoadDirectoryFiles(dir, indir)
System.print("======== %(dir.paths)")

var img = Image.new() 
for(imgPath in dir.paths) {
    var filePath = imgPath.split("\\")[-1]

    var savePath = "%(outdir)/%(filePath)"
    Raylib.LoadImage(img, imgPath)
    System.print("converting %(filePath) to %(savePath)")

    var color = Color.new()
    for(x in 0...img.width) {
        for(y in 0...img.height) {
            Raylib.GetImageColor(color, img, x, y)
            color.r = color.a > 0 ? 255 : 0
            color.g = color.a > 0 ? 255 : 0
            color.b = color.a > 0 ? 255 : 0
            Raylib.ImageDrawPixel(img, x, y, color)
        }
    }
    Raylib.ExportImage(img, savePath)
    Raylib.UnloadImage(img)

}

