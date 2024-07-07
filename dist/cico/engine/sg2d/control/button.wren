import "../scenegraph2d" for SgItem,SceneGraph2D,SgEvent
import "../rectangle" for SgRectangle
import "../../signalslot" for Signal
import "./style" for ControlStyle
import "cico.raylib" for Raylib,Font,Vector2,Color
class SgButton is SgRectangle {
    construct new() {
        super()
        initButtonProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initButtonProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initButtonProps_() 
        parse(map)
    }

    initButtonProps_() {
        _text = ""
        _font = ControlStyle["button"]["font"] 
        _textColor = ControlStyle["button"]["textColor"]
        _autoSize = false
        _fontSize = ControlStyle["button"]["fontSize"]
        _fontSpacing = ControlStyle["button"]["fontSpacing"]
        _backgroundColor = ControlStyle["button"]["backgroundColor"]
        _textSize = Vector2.new()
        _mousePressedTime = Raylib.GetTime()
        _pressed = false 
        this.radius = ControlStyle["button"]["radius"]
        super.color = _backgroundColor * 1.0
        super.border.width = ControlStyle["button"]["border"]["width"]
        super.border.color = ControlStyle["button"]["border"]["color"]

        _textChanged = Signal.new(this)
        _textColorChanged = Signal.new(this)
        _fontChanged = Signal.new(this)
        _autoSizeChanged = Signal.new(this)
        _fontSizeChanged = Signal.new(this)
        _backgroundColorChanged = Signal.new(this)
        _textSizeChanged = Signal.new(this)
        _pressedChanged = Signal.new(this)
        _clicked = Signal.new(this)
        _fontSpacingChanged = Signal.new(this)
        enabledChanged.connect{|e,v| super.color = _backgroundColor * (enabled ? (_pressed ? 0.95 : 1.0) : 0.7) }
    }

    clicked{_clicked}
    text{_text}
    text=(val){
        if(_text != val) {
            _text=val
            recaculateSize()
            _textChanged.emit(val)
        }
    }
    font{_font}
    font=(val){
        if(_font != val) {
            _font = val
            _fontChanged.emit(val)
        }
    }
    textColor{_textColor}
    textColor=(val){
        _textColor = val
        recaculateSize()
        _textColorChanged.emit(val)
    }
    autoSize{_autoSize}
    autoSize=(val){
        if(_autoSize != val) {
            _autoSize = val
            recaculateSize()
            _fontSizeChanged.emit(val)
        }
    }
    fontSize{_fontSize}
    fontSize=(val){
        if(_fontSize != val) {
            _fontSize = val
            recaculateSize()
            _fontSizeChanged.emit(val)
        }
    }
    fontSpacing{_fontSpacing}
    fontSpacing=(val){
        if(_fontSpacing != val) {
            _fontSpacing = val
            recaculateSize()
            _fontSpacingChanged.emit(val)
        }
    }
    backgroundColor{_backgroundColor}
    backgroundColor=(val){
        if(_backgroundColor != val) {
            _backgroundColor = val
            _backgroundColorChanged.emit(val)
            super.color = _backgroundColor * (enabled ? (_pressed ? 0.95 : 1.0) : 0.7)
        }
    }
    pressed{_pressed}
    pressedChanged{_pressedChanged}

    recaculateSize() {
        if(_font) {
            Raylib.MeasureTextEx(_textSize, _font, _text, _fontSize, _fontSpacing)
        } else {
            Raylib.MeasureTextEx(_textSize, SceneGraph2D.font, _text, _fontSize, _fontSpacing)
        }
        if(_autoSize) {
            this.width = _textSize.x + 20
            this.height = _textSize.y + 20
        }
    }

    onRender() {
        super.onRender()
        var bounds = super.finalBounds
        if(_font) {
            Raylib.DrawTextPro(_font, _text, Vector2.new(bounds.x + bounds.width / 2, bounds.y + bounds.height / 2), Vector2.new(bounds.width / 2, bounds.height / 2), finalRotation, _fontSize, _fontSpacing, enabled ? _textColor : _textColor * 0.4)
        } else {
            Raylib.DrawTextPro(SceneGraph2D.font, _text, Vector2.new(bounds.x + bounds.width / 2, bounds.y + bounds.height / 2), Vector2.new(_textSize.x / 2, _textSize.y / 2), finalRotation, _fontSize, _fontSpacing, enabled ? _textColor : _textColor * 0.4)
        }
    }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("backgroundColor")) { this.backgroundColor = map["backgroundColor"] }
        if(map.keys.contains("text")) { this.text = map["text"] }
        if(map.keys.contains("fontSize")) { this.fontSize = map["fontSize"] }
        if(map.keys.contains("textColor")) { this.textColor = map["textColor"] }
        if(map.keys.contains("font")) { this.font = map["font"] }
        if(map.keys.contains("autoSize")) { this.autoSize = map["autoSize"] }
        if(map.keys.contains("backgroundColor")) { this.backgroundColor = map["backgroundColor"] }
        if(map.keys.contains("fontSpacing")) { this.fontSpacing = map["fontSpacing"] }
        if(map.keys.contains("clicked")) { _clicked.connect(map["clicked"]) }
    }

    onEvent(event) {
        var ret = super.onEvent(event)

        if(event.type == SgEvent.MousePressed) {
            super.color = _backgroundColor * 0.95
            _mousePressedTime = Raylib.GetTime()
            ret = 1
            _pressed = true 
            _pressedChanged.emit(true)
        } else if(event.type == SgEvent.MouseRelease) {
            super.color = _backgroundColor * 1.0
            ret = 1
            _pressed = false 
            _pressedChanged.emit(false)
            var now = Raylib.GetTime()
            if(now - _mousePressedTime < 0.150) { _clicked.emit() }
        }
        return ret 
    }
}