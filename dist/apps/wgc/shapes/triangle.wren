import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/scenegraph2d" for SgItem
import "./objectbase" for ObjectBase
import "cico.raylib" for Vector2,Vector3,Vector4,Color,Rectangle,Raylib 

class ShapeTriangle is ObjectBase {
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
        _v1 = Vector2.new()
        _v2 = Vector2.new()
        _v3 = Vector2.new()
        _triangleColor = Color.fromString("#aaaaaa")
        _r1 = Vector2.new()
        _r2 = Vector2.new() 
        _r3 = Vector2.new() 
        this.geometryChanged.connect{|e,v|
            _r1.x = _v1.x + finalBounds.x
            _r1.y = _v1.y + finalBounds.y 
            _r2.x = _v2.x + finalBounds.x
            _r2.y = _v2.y + finalBounds.y 
            _r3.x = _v3.x + finalBounds.x
            _r3.y = _v3.y + finalBounds.y 
        }
    }

    parse(map) {
        super.parse(map)
        _triangleColor.parse(this.color)
        this.color.parse("#00000000")
    }

    onRender() {
        Raylib.DrawTriangle(_r1, _r2, _r3, _triangleColor)
        if(this.selected) { Raylib.DrawTriangleLines(_r1, _r2, _r3, this.border.color) }
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
            _v1.x = this.width / 2 
            _v1.y = h < 0 ? this.height : 0
            _v2.x = h < 0 ? this.width : 0
            _v2.y = h < 0 ? 0 : this.height
            _v3.x = h < 0 ? 0 : this.width
            _v3.y = h < 0 ? 0 : this.height
            _r1.x = _v1.x + finalBounds.x
            _r1.y = _v1.y + finalBounds.y 
            _r2.x = _v2.x + finalBounds.x
            _r2.y = _v2.y + finalBounds.y 
            _r3.x = _v3.x + finalBounds.x
            _r3.y = _v3.y + finalBounds.y 
    }
    onFinished() {
    }
}
