import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/scenegraph2d" for SgItem
import "../ui/canvas" for Canvas
import "cico.raylib" for Color 

class ObjectBase is SgRectangle {
    construct new() {
        super()
        initObjectBaseProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic) 
        } else {
            super()
        }
        initObjectBaseProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map){
        super(parent)
        initObjectBaseProps_()
        parse(map)
    }

    onStart(camera, mousePos, mouseWorldPos) {

    }
    onMove(camera, mousePos, mouseWorldPos) {

    }
    onFinished() {

    }

    initObjectBaseProps_() {
        this.parentChanged.connect{|e,v|
            if(this.parent is Canvas) {
                this.absoluteCoordinate = true 
            } else {
                this.absoluteCoordinate = false 
            }
        }
        if(this.parent is Canvas) {
            this.absoluteCoordinate = true 
        } else {
            this.absoluteCoordinate = false 
        }

        _selected = false 
        border.color.parse("#00000000")
        border.width = 1.2.ceil
        _canvas = null 
        _selectedColor = Color.fromString("#33aaff")
        _hotSpotSize = 6
    }
    selected{_selected}
    selected=(val) {
        _selected = val 
        border.width = (1.2 / _canvas.zoom).ceil
        border.color.parse(_selected ? "#33aaff" : "#00000000")
    }
    selectedColor{_selectedColor}
    hotSpotSize{_hotSpotSize}

    parse(map) {
        super.parse(map)
        if(map["canvas"]) {
            _canvas = map["canvas"]
            _canvas.zoomChanged.connect{|e,v| border.width = (1.2  / v).ceil }
        }
    }
}
