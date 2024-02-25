import "cico.os.vinput" for VKeyboard,VInputMode
import "cico.raylib" for Raylib

var vkb = VKeyboard.new() 
var count = 10
vkb.init(VInputMode.Atom)

var keys = [
    "KEY_ENTER",
    "KEY_F",
    "KEY_LEFT",
    "KEY_RIGHT",
    "KEY_UP",
    "KEY_DOWN",
    "KEY_J",
    "KEY_K"
]

Raylib.SetRandomSeed(123456)

while(true) {
    var rand = Raylib.GetRandomValue(0, keys.count-1)
    vkb.triggerKeyEx(keys[rand])
    Raylib.WaitTime(0.15)
}