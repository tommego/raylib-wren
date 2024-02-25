import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/scenegraph2d" for SgItem
import "./objectbase" for ObjectBase
import "cico.raylib" for Vector2,Vector3,Vector4,Color,Rectangle,Raylib 

class ShapeRect is ObjectBase {
    construct new() {
        super()
        initShapeProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic) 
        } else {
            super()
        }
        initShapeProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map){
        super(parent)
        initShapeProps_()
        parse(map)
    }

    initShapeProps_() {

    }

    parse(map) {
        super.parse(map)
    }

    onStart(camera, mousePos, mouseWorldPos) {
        _startPos = Vector2.new(mouseWorldPos.x, mouseWorldPos.y)
    }
    onMove(camera, mousePos, mouseWorldPos) {
            var w = mouseWorldPos.x - _startPos.x 
            var h = mouseWorldPos.y - _startPos.y 
            var dw = this.width - w.abs 
            var dh = this.height - h.abs 
            if(w < 0) { this.x = this.x + dw }
            if(h < 0) { this.y = this.y + dh }
            this.width = w.abs 
            this.height = h.abs
    }
    onFinished() {
    }
}
