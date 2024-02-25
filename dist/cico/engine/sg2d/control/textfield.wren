import "../scenegraph2d" for SgItem,SceneGraph2D,SgEvent,Border
import "../rectangle" for SgRectangle
import "./button" for SgButton
import "../../signalslot" for Signal
import "./style" for ControlStyle
import "../layout" for SgRow
import "./label" for SgLabel
import "cico.raylib" for Raylib,Font,Rectangle,Vector2,Vector3,Vector4,Color,ValueList

class SgTextField is SgRectangle {
    construct new() {
        super()
        initTextFieldProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initTextFieldProps_() 
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initTextFieldProps_()
        parse(map)
    }

    initTextFieldProps_() {
        this.width = 120
        this.height = 25 
        this.border.width = 1
        this.border.color = Color.new(188, 188, 188, 255)

        _text = ""
        _cursor = 0
        _fullTextSize = Vector2.new()
        _cursorTextSize = Vector2.new()

        _textChanged = Signal.new(this)
        _cursorChanged = Signal.new(this)

        _label = SgLabel.new(this, {
            "fontSize": 12,
            "color": Color.new(122, 122, 122, 255),
            "x" : 15,
            "y": 7
        })
        _label.textChanged.connect{|e,v| 
            _textChanged.emit(v)
            refreshRenderData()
        }
        _cursorChanged.connect{|e,v| refreshRenderData()}

        this.clip = true 

        _cursorColor = Color.new(66,200, 255, 255)
        _p0 = Vector2.new()
        _p1 = Vector2.new()

        this.focusChanged.connect{|e,v|
            if(v) {
                this.border.color = Color.new(111, 111, 111, 255)
            } else {
                this.border.color = Color.new(188, 188, 188, 255)
            }
        }
    }

    text{_label.text}
    text=(val) {
        _label.text = val 
    }
    cursor{_cursor}
    cursor=(val) {
        if(_cursor != val) {
            _cursor = val 
            _cursorChanged.emit(val)
        }
    }

    refreshRenderData() {

    }

    parse(map) {
        super.parse(map)
    }

    onEvent(event) {
        var ret = super.onEvent(event)
        if(event.type == SgEvent.MousePressed && event.data["key"] == Raylib.MOUSE_BUTTON_LEFT) {
            ret = 1
            _pressTime = Raylib.GetTime()
        } else if(event.type == SgEvent.MouseRelease && event.data["key"] == Raylib.MOUSE_BUTTON_LEFT) {
            var now = Raylib.GetTime() 
            if(now - _pressTime < 0.15) {
                this.focus = true
                _cursor = this.text.count 
            }
        } else if(event.type == SgEvent.KeyPress) {
            ret = 1
            var key = event.data["key"]
            var skey = ""
            if(key >= 65 && key <= 90) {  
                skey = String.fromByte(_capsLock || Raylib.IsKeyDown(Raylib.KEY_LEFT_SHIFT) ? key : key + 32)
            } else if(key >= 48 && key <= 57) {
                skey = (key - 48).toString
            } else if(key >= 320 && key <= 329) {
                skey = (key - 320).toString
            } else if(key == Raylib.KEY_CAPS_LOCK) {
                if(!_capsLock) { _capsLock = false }
                _capsLock = !_capsLock
            } else if(key == Raylib.KEY_SLASH) {
                skey = "/"
            } else if(key == Raylib.KEY_PERIOD) {
                skey = "."
            } else if(key == Raylib.KEY_ESCAPE || key == Raylib.KEY_TAB) {
                this.focus = false
            }
            if(skey.count > 0) {
                this.text = this.text +  skey 
            } else {
                if(key == Raylib.KEY_BACKSPACE) {
                    if(this.text.count > 0) {
                        this.text = this.text[0...-1]
                    }
                }
            }
        }
        return ret 
    }

    onRender() {
        super.onRender()

        if(this.focus) {
            _p0.x = _label.finalBounds.x + _label.finalBounds.width + 3
            _p0.y = _label.finalBounds.y 
            _p1.x = _p0.x 
            _p1.y = _p0.y + _label.finalBounds.height 
            
            Raylib.DrawLineEx(_p0, _p1, 1, _cursorColor)
        }
    }
}