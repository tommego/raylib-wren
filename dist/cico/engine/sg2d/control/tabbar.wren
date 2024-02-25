import "../scenegraph2d" for SgItem,SceneGraph2D,SgEvent,Border,Anchors
import "../rectangle" for SgRectangle
import "../../signalslot" for Signal
import "../layout" for SgRow 
import "./button" for SgButton
import "./label" for SgLabel
import "./style" for ControlStyle
import "../../tween" for Tween,EasingType,Anim
import "cico.raylib" for Raylib,Font,Rectangle,Vector2,Vector3,Vector4,Color

class SgTab is SgButton {
    construct new() {
        super()
        initTabProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) { 
            super(dynamic) 
        } else {
            super()
        }
        initTabProps_()
        if(dynamic is Map) {parse(dynamic)}
    }

    initTabProps_() {
        _control = null 
        _index = -1
        _onControlCurrentIndexChanged = Fn.new{|e,v| refreshRenderStatus()}
        _selectedBgColor = Color.new(222, 33, 88, 255)
        _normalBgColor = Color.new(0, 0, 0, 0)
        _selectedTextColor = Color.new(255, 255, 255, 255)
        _normalTextColor = Color.new(200, 200, 200, 255)
        this.border.width = 0
        this.clicked.connect{|e,v| _control.currentIndex = _index}
    }
    control{_control}
    control=(val){
        if(_control) {_control.currentIndexChanged.disconnect(_onControlCurrentIndexChanged)}
        _control = val
        if(_control) {_control.currentIndexChanged.connect(_onControlCurrentIndexChanged)}
        refreshRenderStatus()
    }
    index{_index}
    index=(val){_index=val}
    parse(map) {
        super.parse(map)
    }

    refreshRenderStatus() {
        this.backgroundColor = _control.currentIndex == _index ? _selectedBgColor : _normalBgColor
        this.textColor = _control.currentIndex == _index ? _selectedTextColor : _normalTextColor
    }
    
}

class SgTabBar is SgRectangle {
    construct new() {
        super()
        initTaBarProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) { 
            super(dynamic) 
        } else {
            super()
        }
        initTaBarProps_()
        if(dynamic is Map) {parse(dynamic)}
    }
    construct new(parent, map) {
        super(parent)
        initTaBarProps_()
        parse(map)
    }

    initTaBarProps_() {
        _row = SgRow.new(this)
        _tabs = []
        this.widthChanged.connect{|e,v| refreshTabSize()}
        this.heightChanged.connect{|e,v| refreshTabSize()}
        _currentIndex = 0
        _currentIndexChanged = Signal.new(this)

        _line = SgRectangle.new(this, { "width": this.width, "height": 1, "color": Color.new(222, 33, 88, 255) })
        _line.anchors.bottom({"target": this, "value": Anchors.Bottom})
    }

    currentIndex{_currentIndex}
    currentIndex=(val){
        if(_currentIndex != val) {
            _currentIndex = val 
            _currentIndexChanged.emit(val)
        }
    }
    currentIndexChanged{_currentIndexChanged}

    parse(map) {
        super.parse(map)
        if(map.keys.contains("tabs")) {
            var idx = _tabs.count 
            for(tab in map["tabs"]) {
                tab.parent = _row 
                tab.index = idx  
                _tabs.add(tab)
                idx = idx + 1
                tab.control = this
            }
        }
        refreshTabSize()
    }

    refreshTabSize() {
        var avWidth = this.width / _tabs.count 
        for(tab in _tabs) {
            tab.width = avWidth 
            tab.height = this.height
        }
        _line.width = this.width
    }
}