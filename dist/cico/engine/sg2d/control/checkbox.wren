import "../scenegraph2d" for SgItem,SgEvent,Border
import "../rectangle" for SgRectangle
import "../../signalslot" for Signal
import "../layout" for SgRow
import "./label" for SgLabel 
import "./style" for ControlStyle
import "cico.raylib" for Raylib,Font,Rectangle,Color

class SgCheckbox is SgRow {
    construct new() {
        super(new)
        initCheckBoxProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initCheckBoxProps_()
        if(dynamic is Map) {parse(dynamic)}
    }
    construct new(parent, map) {
        super(parent)
        initCheckBoxProps_()
        parse(map)
    }

    initCheckBoxProps_() {
        this.spacing = 15
        _rect = SgRectangle.new(this, {
            "width": 30,
            "height": 30,
            "color": ControlStyle["checkbox"]["background"]["color"],
            "radius": ControlStyle["checkbox"]["background"]["radius"],
            "border": Border.new(ControlStyle["checkbox"]["background"]["border"]["width"], ControlStyle["checkbox"]["background"]["border"]["color"])
        })
        _label = SgLabel.new(this,{
            "fontSize": ControlStyle["checkbox"]["fontSize"],
            "color": ControlStyle["checkbox"]["fontColor"],
            "y": 8
        })
        _checkedRect = SgRectangle.new(_rect, {
            "width": 20,
            "height": 20,
            "radius": 4,
            "color": ControlStyle["checkbox"]["indicator"]["color"],
            "x": 6,
            "y": 6,
            "visible": false 
        })
        _text = ""
        _checked = false 
        _checkedRectBounds = Rectangle.new()

        _textChanged = Signal.new(this)
        _checkedChanged = Signal.new(this)

        _textChanged.connect{|e,v| _label.text = _text }
        _checkedChanged.connect{|e,v| _checkedRect.visible = v}

    }

    text{_text}
    text=(val) {
        if(_text != val) {
            _text = val 
            _textChanged.emit(val)
        }
    }
    checked{_checked}
    checked=(val){
        if(_checked != val) {
            _checked = val 
            _checkedChanged.emit(val)
        }
    }

    onEvent(event) {
        var ret = super.onEvent(event)
        if(event.type == SgEvent.MousePressed && event.data["key"] == Raylib.MOUSE_BUTTON_LEFT) {
            var pos = event.data["position"]
            if(Raylib.CheckCollisionPointRec(pos, Rectangle.new(_rect.x, _rect.y, _rect.width, _rect.height))) { ret = 1}
        } else if(event.type == SgEvent.MouseRelease && event.data["key"] == Raylib.MOUSE_BUTTON_LEFT) {
                this.checked = !_checked
                ret = 1
        }
        return ret 
    }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("text")) { this.text = map["text"] }
        if(map.keys.contains("checked")) { this.checked = map["checked"] }
    }

    onRender() {
        // System.print("%_checkedRect.finalBounds.x")
    }

}