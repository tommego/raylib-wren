import "cico.os.sqlite3" for Stmt, Sqlite3
import "cico.raylib" for Raylib 
import "cico.os.sys" for Platform

Raylib.InitWindow(10, 10, "ddd")

var dbfile = Platform.argv[1]

var t1 = Raylib.GetTime()
var stmt = Stmt.new()
var db = Sqlite3.new()
var ret = db.open(dbfile)
var query = "select * from songs where status=1 and tag<16 and starLevel>7 and starLevel<13"
ret = db.prepareV2(query, stmt)
var cols = db.colCount(stmt)
var queryItems = []
while(db.step(stmt) != Sqlite3.SQLITE_DONE) {
    var valueMap = {}
    for(c in 0...cols) {
        var name = db.colName(stmt, c)
        var value = db.colValue(stmt, c)
        valueMap[name] = value
    }
    queryItems.add(valueMap   )
}
var t2 = Raylib.GetTime()
var diff = t2 - t1
db.close() 
System.print("============= query cost time: %(diff)s ")
System.print("=========== %(Platform.argv)")