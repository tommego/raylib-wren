import "../scenegraph2d" for SgItem,SceneGraph2D,SgEvent,Anchors 
import "../rectangle" for SgRectangle
import "../../signalslot" for Signal
import "./style" for ControlStyle
import "cico.raylib" for Raylib,Font,Rectangle,Vector2,Vector3,Vector4,Color
import "../icon" for SgIcon
class SgIconButton is SgRectangle {
    construct new() {
        super()
        iconButtonProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        iconButtonProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        iconButtonProps_() 
        parse(map)
    }

    iconButtonProps_() {
        _mousePressedTime = Raylib.GetTime()
        _pressed = false 
        _pressedChanged = Signal.new(this)
        _clicked = Signal.new(this)
        _icon = SgIcon.new(this)
        _icon.anchors.fill(this)
        _setColor = Color.fromString("#ffffff")
        _icon.color = _setColor * 1.0
        _enabled = true 
        this.radius = 4
        this.color = Color.fromString("#00000000")
        _checked = false 
        _checkEnabled = true 
        _checkedChanged = Signal.new(this)
        _checkOnClicked = false 
        _checkedChanged.connect{|e,v| 
            if(_checked && _checkEnabled                                                                                                   ) {
                this.color.parse("#33ffffff")
            } else {
                this.color.parse("#00000000")
            }
        }
    }

    clicked{_clicked}
    pressed{_pressed}
    pressedChanged{_pressedChanged}
    iconColor{_setColor}
    iconColor=(val) {
        _setColor = val 
        refreshRenderColor_()
    }
    source{_icon.source}
    source=(val){_icon.source=val}
    enabled{_enabled}
    enabled=(val){
        _enabled = val 
        refreshRenderColor_()
    }
    checked{_checked}
    checked=(val){
        if(_checked != val) {
            _checked = val
            _checkedChanged.emit(val)
        }
    }
    checkEnabled{_checkEnabled}
    checkEnabled=(val){
        _checkEnabled=val
        if(!_checkEnabled) {
            this.color.parse("#00000000")
        }
    }
    checkOnClicked{_checkOnClicked}
    checkOnClicked=(val){_checkOnClicked=val}

    refreshRenderColor_() {
        if(_enabled) {
            if(_pressed) {
                _icon.color = _setColor * 0.98 
            } else {
                _icon.color = _setColor * 1
            }
        } else {
            _icon.color = Color.fromString("#777777")
        }
    }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("clicked")) { _clicked.connect(map["clicked"]) }
        if(map.keys.contains("iconColor")) { this.iconColor = map["iconColor"] }
        if(map.keys.contains("source")) { this.source = map["source"] }
        if(map.keys.contains("enabled")) { this.enabled = map["enabled"] }  
        if(map.keys.contains("checked")) { this.checked = map["checked"]}
        if(map.keys.contains("checkEnabled")) { this.checkEnabled = map["checkEnabled"]}
    }

    onEvent(event) {
        var ret = super.onEvent(event)
        if(_enabled) {
            if(event.type == SgEvent.MousePressed) {
                _icon.color = _setColor * 0.95
                _mousePressedTime = Raylib.GetTime()
                ret = 1
                _pressed = true 
                _pressedChanged.emit(true)
            } else if(event.type == SgEvent.MouseRelease) {
                _icon.color = _setColor * 1.0
                ret = 1
                _pressed = false 
                _pressedChanged.emit(false)
                var now = Raylib.GetTime()
                if(now - _mousePressedTime < 0.150) { _clicked.emit() }
                if(_checkEnabled && _checkOnClicked) { this.checked = !_checked }
            }
        }
        return ret 
    }
}