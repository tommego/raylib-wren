import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem, Anchors
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/layout" for SgRow,SgFlowLayout, SgColumn 
import "cico/engine/sg2d/control/scrollview" for SgScrollView
import "cico/engine/sg2d/control/button" for SgButton
import "cico/engine/sg2d/control/tabbar" for SgTabBar, SgTab
import "cico/engine/math" for Math
import "cico.raylib" for Raylib, Color,Vector2
import "cico/engine/sg2d/control/listview" for SgListView
import "cico/engine/sg2d/control/label" for SgLabel
import "../common/titlebar" for TitleBar
import "cico/engine/signalslot" for Signal
import "../../editor" for Editor

class PageItemDelegate is SgButton{
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

        _label = SgLabel.new(this)
        _label.x = 16
        _label.anchors.verticalCenter({"target": this, "value": Anchors.VerticalCenter})
        _label.text = _modelData["text"]
        _label.fontSize = 13
        _label.color = Color.new(188, 188, 188, 255)
        _line = SgRectangle.new(this,{"width": this.width, "height": 1, "color": "#3f000000"})
        _line.anchors.bottom({"target":this, "value": Anchors.Bottom})
        this.backgroundColor = this.color = _index == _control.currentIndex ? Color.new(66, 66, 66, 255) : Color.new(55, 55, 55, 255)
        this.height = 35
        this.width = _control.width - 1
        this.border.width = 0
        _control.widthChanged.connect{|e,v| 
            this.width = _control.width - 1
            _line.width = this.width
        }
        _control.currentIndexChanged.connect{|e,v| this.backgroundColor = _index == _control.currentIndex ? Color.new(66, 66, 66, 255) : Color.new(55, 55, 55, 255)}
        this.clicked.connect{|e,v| Editor.selectPage(_index) }
        onDefaultBinding()
    } 
    index{_index}   
    // only set by listview
    index=(val){
        _index = val
        _indexChanged.emit(val)
        this.color = _index == _control.currentIndex ? Color.new(66, 66, 66, 255) : Color.new(55, 55, 55, 255)
    }
    control{_control}
    modelData{_modelData}
    modelData=(val){
        _modelData = val
        _label.text = _modelData["text"]
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


class PageListView is SgListView {
    construct new() {
        super()
        initPageListViewProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initPageListViewProps_()
        if(dynamic is Map) {parse(dynamic)}
    }
    construct new(parent, map) {
        super(parent)
        initPageListViewProps_()
        parse(map)
    }
    addPage() {
        System.print("adding page: %(this.currentIndex)")
        Editor.createPage({
            "width": 480,
            "height": 640,
            "color": Color.fromString("#ffffff")
        })
    }
    delPage() {
        System.print("deling page: %(this.currentIndex)")
        if(this.model.count > 0) { 
            Editor.removePage(this.currentIndex)
        }
    }

    initPageListViewProps_() {
        this.delegate = PageItemDelegate
        this.smooth = 1
        Editor.pageAdded.connect{|e,v|
            this.model.add({"text": v.name})
        }
        Editor.pageRemoved.connect{|e,v|
            this.model.removeAt(this.currentIndex) 
        }
        this.currentIndex = Editor.currentPageIndex 
        Editor.currentPageIndexChanged.connect {|e,v|
            this.currentIndex = v
        }
    }
}