import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem, Anchors
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/sprite" for SgSprite
import "cico/engine/sg2d/layout" for SgRow,SgFlowLayout, SgColumn 
import "cico/engine/sg2d/control/scrollview" for SgScrollView
import "cico/engine/sg2d/control/button" for SgButton
import "cico/engine/sg2d/control/tabbar" for SgTabBar, SgTab
import "cico/engine/math" for Math
import "cico.raylib" for Raylib, Color,Vector2
import "cico/engine/sg2d/control/listview" for SgListView
import "cico/engine/sg2d/control/label" for SgLabel
import "cico/engine/signalslot" for Signal
import "./workspace" for Workspace
import "cico/engine/timer" for Timer  

class FileDelegate is SgButton{
    construct new(listview, index, modelData) {
        super()
        _index = index
        _control = listview 
        _modelData = modelData
        _prev = null

        this.width = _control.width 
        this.height = 30
        _refreshPos = Fn.new{|emiter, val| 
            if(_prev) {  
                if(_control.direction == SgListView.Vertical) {
                    this.y = _prev.y + _prev.height + _control.spacing 
                } else {
                    this.x = _prev.x + _prev.width + _control.spacing 
                }
            }
        }
        _renderText = ""
        _modelDataChanged = Signal.new(this)
        _indexChanged = Signal.new(this)

        _onContentChanged = Fn.new{|emitter,val| _renderText = _modelData }

        _modelDataChanged.connect(_onContentChanged)
        _indexChanged.connect(_onContentChanged)

        _modelDataChanged.emit(modelData)

        _row = SgRow.new(this, {"spacing": 10})
        _row.x = 16
        _row.anchors.verticalCenter({"target": this, "value": Anchors.VerticalCenter})

        _sprite = SgSprite.new(_row, {"width": 44, "height": 44, "source": _modelData})

        _label = SgLabel.new(_row, {"y": 10})
        _label.text = _modelData.split("\\")[-1]
        _label.fontSize = 16
        _label.color.parse("#bcbcbc")
        _line = SgRectangle.new(this,{"width": this.width, "height": 1, "color": "#3f000000"})
        _line.anchors.bottom({"target":this, "value": Anchors.Bottom})
        this.backgroundColor = Color.fromString(_index == _control.currentIndex ? "#424242" : "#363636")
        this.height = 35
        this.width = _control.width - 1
        this.border.width = 0
        _control.widthChanged.connect{|e,v| 
            this.width = _control.width - 1
            _line.width = this.width
        }
        _control.currentIndexChanged.connect{|e,v| this.backgroundColor = Color.fromString(_index == _control.currentIndex ? "#424242" : "#363636")}
        this.clicked.connect{|e,v| Workspace.selectedIndex = _index }
        onDefaultBinding()
    } 
    index{_index}   
    // only set by listview
    index=(val){
        _index = val
        _indexChanged.emit(val)
        this.backgroundColor = _index == _control.currentIndex ? Color.new(66, 66, 66, 255) : Color.new(55, 55, 55, 255)
    }
    control{_control}
    modelData{_modelData}
    modelData=(val){
        _modelData = val
        _label.text = _modelData.split("\\")[-1]
        _modelDataChanged.emit(val)
    }
    prev{_prev}
    prev=(val){
        if(_prev) { _prev.geometryChanged.disconnect(_refreshPos) }
        _prev = val 
        if(_prev) { 
            if(_control.direction == SgListView.Vertical) {
                this.y = _prev.y + _prev.height + _control.spacing 
            } else {
                this.x = _prev.x + _prev.width + _control.spacing
            }
            _prev.geometryChanged.connect(_refreshPos) 
        }
    }
    modelDataChanged{_modelDataChanged}

    onDefaultBinding() {
        _refreshSize = Fn.new{|emitter, val| 
            this.width = _control.width 
            // this.hegiht = _control.height 
        }
        _control.widthChanged.connect(_refreshSize)
        _control.heightChanged.connect(_refreshSize)
        this.parentChanged.connect{|value| 
            if(value != _control) { 
                _control.widthChanged.disconnect(_refreshSize) 
                _control.heightChanged.disconnect(_refreshSize) 
            }
        }
    }

    onModelPropertyDataChanged(props, values) {
        _renderText = _modelData
    }
}

class FileListView is SgListView {
    construct new() {
        super()
        initFileListViewProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initFileListViewProps_()
        if(dynamic is Map) {parse(dynamic)}
    }
    construct new(parent, map) {
        super(parent)
        initFileListViewProps_()
        parse(map)
    }

    initFileListViewProps_() {
        this.delegate = FileDelegate
        this.smooth = 12
        this.currentIndex = Workspace.selectedIndex
        Workspace.selectedIndexChanged.connect{|e,v|
            this.currentIndex = Workspace.selectedIndex
        }
        _timer = Timer.new({
            "repeat": true,
            "interval": 0.016
        })
        _loadIndex = 0
        _files = []
        _timer.triggered.connect{|e,v|
            var file = _files[_loadIndex]
            this.model.add(file)
            _loadIndex = _loadIndex + 1
            if(_loadIndex >= _files.count) {
                _timer.stop()
                _loadIndex= 0
            }
        }
    }

    loadFiles(files) {
        _timer.stop()
        if(this.model.count > 0) {
            this.model.clear()
        }
        _files = files 
        _loadIndex = 0
        _timer.start()
    }
}