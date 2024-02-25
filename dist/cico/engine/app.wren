import "./tween" for Tween,EasingType,Anim
import "cico/engine/signalslot" for SignalMgr
import "cico/engine/timer" for TimerMgr
import "./sg2d/scenegraph2d" for SceneGraph2D
import "cico/engine/sg3d/scenegraph3d" for SceneGraph3D
import "cico.raylib" for Raylib,Color
import "cico.net.mongoose" for MgMgr,MGHttpMessage,MGConnection
class App {
    construct new() {  
        TimerMgr.init()
        Tween.init()
        MgMgr.init()
        _bgColor = Color.new(111, 111, 111, 255)
        SceneGraph3D.init()
    }

    backgroundColor{_bgColor}
    backgroundColor=(val){_bgColor = val}

    tick() {
        // update tween animation 
        Tween.update()
        // trigger stored emitted fns 
        SignalMgr.trigger()
        // timer trigger
        TimerMgr.tick()

        // network 
        // MgMgr.tick()
        var result = MgMgr.tick()
        if(result) { result[0].call(result[1], result[2], result[3]) }
    }

    render() {
        Raylib.ClearBackground(_bgColor)
        // render 3d layer 
        Raylib.BeginDrawing()
            SceneGraph3D.render()
        // Raylib.EndDrawing()

        // render scene2d layer 
        // Raylib.BeginDrawing()
            SceneGraph2D.render()
        Raylib.EndDrawing()
    }

    loop() {
        // ticking
        tick()
        
        // rendering 
        render()
    }

    exit() {
        Raylib.CloseWindow()
        MgMgr.quit()
    }
}