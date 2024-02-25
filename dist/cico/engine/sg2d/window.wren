import "./scenegraph2d" for SgItem, SceneGraph2D, SgEvent
import "./layout" for SgColumn, SgRow
import "./rectangle" for SgRectangle
import "./control/menubar" for SgMenuBar
import "../signalslot" for Signal 
import "./control/style" for ControlStyle
import "./control/toolbar" for SgToolBar
import "./control/statusbar" for SgStatusBar
import "cico.raylib" for Raylib, Color, Vector2, Vector3, Vector4, Rectangle

class SgWindow is SgRectangle{
    construct new(title) {
        _title = title 
        super()
        initWindowProps_()
    }
    construct new(dynamic, title) {
        _title = title 
        if(dynamic is SgItem) { 
            super(dynamic)
        } else {
            super()
        }
        initWindowProps_()
        if(dynamic is Map) { parse(dynamic) } 
    }
    construct new(parent, map, title) {
        _title = title 
        super(parent)
        initWindowProps_()
        parse(map)
    }

    initWindowProps_() {
        _menuBar = null 
        _toolBar = null 
        _statusBar = null 
        _content = SgItem.new(this)

        _menuBarChanged = Signal.new(this)
        _toolBarChanged = Signal.new(this)
        _statusBarChanged = Signal.new(this)

        _refreshContentSlot = Fn.new{|e,v| refreshContentSize_()}

        this.childAdded.connect{|e,v| 
            if(v != _menuBar && v != _toolBar && v != _statusBar && v != _content) { v.parent = _content }
        }
        this.geometryChanged.connect(_refreshContentSlot)
        _menuBarChanged.connect(_refreshContentSlot)
        _toolBarChanged.connect(_refreshContentSlot)
        _statusBarChanged.connect(_refreshContentSlot)

        this.color = ControlStyle["window"]["backgroundColor"]

        this.width = 1280
        this.height = 720
        _fps = 60
        // _flags = Raylib.FLAG_WINDOW_RESIZABLE | Raylib.FLAG_MSAA_4X_HINT | Raylib.FLAG_WINDOW_HIGHDPI
        _flags = Raylib.FLAG_WINDOW_RESIZABLE | Raylib.FLAG_MSAA_4X_HINT | Raylib.FLAG_INTERLACED_HINT
        Raylib.SetConfigFlags(_flags)
        Raylib.InitWindow(this.width, this.height, _title)
        Raylib.SetConfigFlags(_flags)
        SceneGraph2D.init()
        Raylib.SetTargetFPS(_fps)
        SceneGraph2D.root.addNode(this)
    }

    menuBar{_menuBar}
    menuBar=(val){
        if(_menuBar != val) {
            if(_menuBar) {_menuBar.geometryChanged.disconnect(_refreshContentSlot)}
            _menuBar = val 
            val.z = 3
            this.addNode(_menuBar)
            _menuBarChanged.emit(val)
        }
    }
    toolBar{_toolBar}
    toolBar=(val){
        if(_toolBar != val) {
            if(_toolBar) {_toolBar.geometryChanged.disconnect(_refreshContentSlot)} 
            _toolBar = val
            val.z = 2
            this.addNode(_toolBar)
            _toolBarChanged.emit(val)
        }
    }
    statusBar{_statusBar}
    statusBar=(val){
        if(_statusBar != val) {
            if(_statusBar) {_statusBar.geometryChanged.disconnect(_refreshContentSlot)}
            _statusBar = val 
            this.addNode(_statusBar)
            _statusBarChanged.emit(val)
        }
    }
    screenCount{Raylib.GetMonitorCount()}
    setScreen(index){ Raylib.SetWindowMonitor(index) }

    refreshContentSize_() {
        _content.width = this.width 
        var cy = 0
        var ch = this.height 
        if(_menuBar) { 
            ch = ch - _menuBar.height
            cy = cy + _menuBar.height 
            _menuBar.parse({
                "width": this.width,
                "x": 0,
                "y": 0
            })
        }
        if(_toolBar) {
            ch = ch - _toolBar.height
            cy = cy + _toolBar.height 
            _toolBar.parse({
                "width": this.width,
                "x": 0,
                "y": _menuBar.height
            })
        }
        if(_statusBar) {
            ch = ch - _statusBar.height
            _statusBar.parse({
                "width": this.width,
                "x": 0,
                "y": this.height - _statusBar.height
            })
        }
        _content.height = ch 
        _content.y = cy 
    }

    contentWidth{_content.width}
    contentHeight{_content.height}
    content{_content}

    parse(map) {
        super.parse(map)
        if(map.keys.contains("menuBar")) { this.menuBar = map["menuBar"] }
        if(map.keys.contains("toolBar")) { this.toolBar = map["toolBar"] }
        if(map.keys.contains("statusBar")) { this.statusBar = map["statusBar"] }
    }

    onRender() {
        super.onRender() 
        if(this.parent == SceneGraph2D.root) {
            var w = Raylib.GetRenderWidth()
            var h = Raylib.GetRenderHeight()
            this.width = w 
            this.height = h 
        }
    }
    fps{_fps}
    fps=(val) {
        _fps = val 
        Raylib.SetTargetFPS(_fps)
    }

    onEvent(event) {
        var ret = super.onEvent(event)
        if(event.type == SgEvent.MousePressed && event.data["key"] == Raylib.MOUSE_BUTTON_LEFT) {
            ret = 1
            this.focus = true 
        }
        return ret 
    }
}