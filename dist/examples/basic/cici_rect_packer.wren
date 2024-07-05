import "cico.raylib" for Raylib,ValueList,Rectangle
var inputs = ValueList.new()
Raylib.SetRandomSeed(1230)
inputs.create(Raylib.VALUE_TYPE_RECTANGLE, 20)
var outputs = ValueList.new() 
var crect = Rectangle.new()
for  (i in 0...20) {
    var vx = Raylib.GetRandomValue(20, 100)
    var vy = Raylib.GetRandomValue(20, 100)
    crect.width = vx 
    crect.height = vy 
    inputs.set(i, crect)
}
Raylib.PackRectangles(inputs, outputs, 512, 512, Raylib.PACK_RECT_MATH_BLH)

for(i in 0...20) {
    outputs.get(crect, i)
    System.print("%(i) %(crect.x) %(crect.y) %(crect.width) %(crect.height)")
}