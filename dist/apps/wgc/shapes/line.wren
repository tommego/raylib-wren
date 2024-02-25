import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/scenegraph2d" for SgItem
import "./objectbase" for ObjectBase
import "cico.raylib" for Raylib, Color, RenderTexture,Camera2D,Vector2,Vector3,Matrix,Texture,Rectangle

class ShapeLine is ObjectBase {
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

    onRender() {
        var p0 = _p0 
        var p1 = _p1 
        if(!_finished) {
            p0 = _startPoint
            p1 = _endPoint
        }
        Raylib.DrawLineEx(p0, p1, _lineWidth, _lineColor)
        if(this.selected) {
            Raylib.DrawRectangleRounded(_hotSpot0, 1, this.hotSpotSize, this.selectedColor)
            Raylib.DrawRectangleRounded(_hotSpot1, 1, this.hotSpotSize, this.selectedColor)
        }
    }

    initShapeProps_() {
        _startPoint = Vector2.new(0, 0)
        _endPoint = Vector2.new(0, 0)
        _startPos = Vector2.new(0, 0)
        _lineColor = Color.fromString("#000000")
        _lineWidth = 1
        _p0 = Vector2.new(0, 0)
        _p1 = Vector2.new(0, 0)
        _finished = false 
        _hotSpot0 = Rectangle.new()
        _hotSpot0.width = this.hotSpotSize
        _hotSpot0.height = this.hotSpotSize
        _hotSpot1 = Rectangle.new()
        _hotSpot1.width = this.hotSpotSize
        _hotSpot1.height = this.hotSpotSize

        this.geometryChanged.connect{|e,v|
            _p0.x = _startPoint.x + finalBounds.x 
            _p0.y = _startPoint.y + finalBounds.y 
            _p1.x = _endPoint.x + finalBounds.x 
            _p1.y = _endPoint.y + finalBounds.y  
            _hotSpot0.x = _p0.x - this.hotSpotSize / 2
            _hotSpot0.y = _p0.y - this.hotSpotSize / 2
            _hotSpot1.x = _p1.x - this.hotSpotSize / 2
            _hotSpot1.y = _p1.y - this.hotSpotSize/ 2
        }
    }

    parse(map) {
        super.parse(map)
        _lineColor.parse(this.color)
        this.color.parse("#00000000")
    }

    onStart(camera, mousePos, mouseWorldPos) {
        _startPos = Vector2.new(mouseWorldPos.x, mouseWorldPos.y)
        _startPoint.x = _startPos.x 
        _startPoint.y = _startPos.y
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
            _endPoint.x = mouseWorldPos.x - 1
            _endPoint.y = mouseWorldPos.y - 1 
            _hotSpot0.x = _startPoint.x - this.hotSpotSize / 2
            _hotSpot0.y = _startPoint.y - this.hotSpotSize / 2
            _hotSpot1.x = _endPoint.x - this.hotSpotSize / 2
            _hotSpot1.y = _endPoint.y - this.hotSpotSize / 2
    }
    onFinished() {
        _finished = true 
        _startPoint.x = _startPoint.x - finalBounds.x 
        _startPoint.y = _startPoint.y - finalBounds.y 
        _endPoint.x = _endPoint.x - finalBounds.x 
        _endPoint.y = _endPoint.y - finalBounds.y
        _p0.x = _startPoint.x + finalBounds.x 
        _p0.y = _startPoint.y + finalBounds.y 
        _p1.x = _endPoint.x + finalBounds.x 
        _p1.y = _endPoint.y + finalBounds.y  
        _hotSpot0.x = _p0.x - this.hotSpotSize / 2
        _hotSpot0.y = _p0.y - this.hotSpotSize / 2
        _hotSpot1.x = _p1.x - this.hotSpotSize / 2
        _hotSpot1.y = _p1.y - this.hotSpotSize / 2
    }

}
