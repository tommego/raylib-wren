import "../scenegraph2d" for SgItem,SceneGraph2D,SgEvent,Border
import "../rectangle" for SgRectangle
import "../../signalslot" for Signal
import "../layout" for SgRow
import "./label" for SgLabel
import "./style" for ControlStyle
import "../../tween" for Tween,EasingType,Anim
import "cico.raylib" for Raylib,Font,Rectangle,Vector2,Vector3,Vector4,Color

class SgSwitch is SgRow {
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
        _label = SgLabel.new(this,{
            "fontSize": ControlStyle["switch"]["fontSize"],
            "color": ControlStyle["switch"]["fontColor"],
            "y": 8
        })
        this.spacing = 15
        _rect = SgRectangle.new(this, {
            "width": 60,
            "height": 30,
            "radius": 30,
            "color": ControlStyle["switch"]["background"]["defaultColor"],
            "border": Border.new(ControlStyle["switch"]["background"]["border"]["width"], ControlStyle["switch"]["background"]["border"]["color"])
        })
        _checkedRect = SgRectangle.new(_rect, {
            "width": 24,
            "height": 24,
            "radius": 24,
            "color": ControlStyle["switch"]["indicator"]["color"],
            "x": 5,
            "y": 4
        })
        _text = ""
        _checked = false 

        _textChanged = Signal.new(this)
        _checkedChanged = Signal.new(this)

        _textChanged.connect{|e,v| _label.text = _text }

        // animation on checked changed
        _checkedChanged.connect{|e,v| 
            var fromX = _checked ? 5 :35
            var toX = _checked ? 35 : 5
            var fromColor = _checked ? ControlStyle["switch"]["background"]["defaultColor"] : ControlStyle["switch"]["background"]["checkedColor"]
            var toColor = _checked ? ControlStyle["switch"]["background"]["checkedColor"] : ControlStyle["switch"]["background"]["defaultColor"]
            Tween.add(Anim.new(EasingType.OutQuad, fromX, toX, Fn.new{|target,val| target.x = val }, null, 0.15, _checkedRect, 1))
            Tween.add(Anim.new(EasingType.InQuad, fromColor, toColor, Fn.new{|target,val| target.color = val }, null, 0.15, _rect, 1))
        }
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
            if(Raylib.CheckCollisionPointRec(pos, Rectangle.new(_rect.x, _rect.y, _rect.width, _rect.height))) { ret = 1 }
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

}