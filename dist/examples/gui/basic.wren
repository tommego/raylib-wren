import "cico/engine/app" for App 
import "cico.raylib" for Raylib,Color 
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
class cico {
    static init() {
        // cico engine initialize
        // create cico app 
        __app = App.new()
        // create a window 
        __mainWIndow = SgWindow.new("Engine test")
        // create a rectangle, an define it's shape with dict(wren Map) 
        var rectangle = SgRectangle.new(__mainWIndow, {
            "width": 100, 
            "height": 100,
            "x": 300,
            "y": 200,
            "color": Color.fromString("#33aaff")
        })
    }

    static eventLoop() {
        // cico engine loop 
        var windowClosed = Raylib.WindowShouldClose()
        __app.loop()
        return windowClosed ? 1 : 0
    }
    static exit() {
        // cico engine exit
        __app.exit()
    }
}