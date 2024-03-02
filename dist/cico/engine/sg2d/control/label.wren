import "cico/engine/sg2d/scenegraph2d" for SgItem,SceneGraph2D
import "cico.raylib" for Raylib,Vector2,Color
import "cico/engine/signalslot" for Signal 
class SgLabel is SgItem {
    construct new() {
        super()
        initProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initProps_()
        parse(map)
    }

    initProps_() {
        _text = ""
        _font = null 
        _color = Raylib.WHITE 
        _autoSize = true 
        _fontSize = 10
        _fontSpacing = 0 
        _textSize = Vector2.new()

        _renderPos = Vector2.new()
        _renderOrigin = Vector2.new()

        _textChanged = Signal.new(this)
    }

    text{_text}
    text=(val){
        if(_text != val) {
            _text=val
            if(_autoSize) { recaculateSize() }
            _textChanged.emit(val)
        }
    }
    font{_font}
    font=(val){_font = val}
    color{_color}
    color=(val){_color = val}
    autoSize{_autoSize}
    autoSize=(val){_autoSize = val}
    fontSize{_fontSize}
    fontSize=(val){
        _fontSize = val
        if(_autoSize) { recaculateSize() }
    }
    fontSpacing{_fontSpacing}
    fontSpacing=(val){_fontSpacing = val}

    textChanged{_textChanged}

    parse(map) {
        super.parse(map)
        if(map.keys.contains("text")) { this.text = map["text"] }
        if(map.keys.contains("font")) { this.font = map["font"] }
        if(map.keys.contains("color")) { this.color = map["color"] }
        if(map.keys.contains("autoSize")) { this.autoSize = map["autoSize"] }
        if(map.keys.contains("fontSize")) { this.fontSize = map["fontSize"] }
        if(map.keys.contains("fontSpacing")) { this.fontSpacing = map["fontSpacing"] }
    }

    recaculateSize() {
        if(_font) {
            Raylib.MeasureTextEx(_textSize, _font, _text, _fontSize, _fontSpacing)
        } else {
            Raylib.MeasureTextEx(_textSize, SceneGraph2D.font, _text, _fontSize, _fontSpacing)
        }
        this.width = _textSize.x
        this.height = _textSize.y
    }

    onRender() {
        super.onRender()
        var bounds = finalBounds
        _renderPos.x = bounds.x + bounds.width / 2
        _renderPos.y = bounds.y + bounds.height / 2
        _renderOrigin.x = bounds.width / 2
        _renderOrigin.y = bounds.height / 2
        var font = SceneGraph2D.font
        if(_font) { font = _font }
        Raylib.DrawTextPro(font, _text, _renderPos, _renderOrigin, finalRotation, _fontSize, _fontSpacing, _color)
    }
}