import "cico.raylib" for Raylib, Vector2, Vector3, Vector4, Matrix, Color, Rectangle, Font, Camera2D, Shader, ValueList,Camera3D
import "../signalslot" for Signal
import "cico/engine/timer" for Timer 
class SceneGraph3D {
    static init() {
        __camera = Camera3D.new()
        __camera.up = Vector3.new(0, 1, 0)
        __camera.position = Vector3.new(0, 5, 10)
        __camera.target = Vector3.new(0, 0, 0)
        __camera.projection = Raylib.CAMERA_PERSPECTIVE
        __camera.fovy = 60
    }
    static render() {
        Raylib.UpdateCamera(__camera, Raylib.CAMERA_FREE)
    }

    static camera{__camera}
    static camera=(val){__camera = val}
}