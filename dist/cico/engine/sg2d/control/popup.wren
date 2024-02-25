import "../scenegraph2d" for SgItem,SceneGraph2D,SgEvent
import "../rectangle" for SgRectangle
import "../../signalslot" for Signal
import "./style" for ControlStyle
import "cico.raylib" for Raylib,Font,Rectangle,Vector2,Vector3,Vector4,Color

class SgPopup is SgRectangle {
    construct new() {
        super()
        iniPopupProps_()
        this.z = 1000
    }

    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        iniPopupProps_()
        if(dynamic is Map) {
            parse(dynamic)
        }
    }

    construct new(parent, map) {
        super(parent)
        iniPopupProps_()
        parse(map)
    }

    iniPopupProps_() {
        this.border.width = 1
        this.border.color = Color.new(188, 188, 188, 255)
        this.visible = false 

        _opened = Signal.new(this)
        _closed = Signal.new(this)

        this.focusChanged.connect{|e,v|
            if(!v) { this.close() }
        }
    }

    opened{_opened}
    closed{_closed}

    parse(map) {
        super.parse(map)

    }

    open() {
        if(!this.visible) {
            this.visible = true 
            _opened.emit()
            this.focus = true 
        }
    }
    close() {
        if(this.visible) {
            this.visible = false 
            _closed.emit()
        }
    }
    isOpen{this.visible}
}