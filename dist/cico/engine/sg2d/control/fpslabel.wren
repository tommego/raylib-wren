import "cico/engine/sg2d/scenegraph2d" for SgItem,SceneGraph2D
import "cico/engine/sg2d/control/label" for SgLabel
import "cico.raylib" for Raylib
class FpsLabel is SgLabel {
    construct new(parent, map) {
        super(parent)
        parse(map)
    }
    onRender() {
        this.text = "FPS: %(Raylib.GetFPS()) | RenderDelay:%(SceneGraph2D.renderDelay)ms | EventDelay:%(SceneGraph2D.eventDelay)ms"
        super.onRender()
    }
}