import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem, Anchors
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/layout" for SgRow,SgFlowLayout, SgColumn 
import "cico/engine/sg2d/control/scrollview" for SgScrollView
import "cico/engine/sg2d/control/button" for SgButton
import "cico/engine/sg2d/control/tabbar" for SgTabBar, SgTab
import "cico/engine/math" for Math
import "cico.raylib" for Raylib, Color
import "cico/engine/sg2d/control/swipeview" for SgSwipeView
import "cico/engine/sg2d/control/label" for SgLabel
import "./titlebar"  for TitleBar
import "cico/engine/signalslot" for Signal
import "cico/engine/tween" for Tween,EasingType

class ExtendView is SgItem {
    construct new() {
        super()
        initExtendViewProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initExtendViewProps_()
        if(dynamic is Map) {
            parse()
        }
    }
    construct new(parent, map) {
        super(parent)
        initExtendViewProps_()
        parse(map)
    }
    initExtendViewProps_() {
        _col = SgColumn.new(this) 
        _col.heightChanged.connect{|e,v| this.height = _col.height }
        _titleBar = TitleBar.new(_col, { "width": this.width, "height": 30 })
        _contentHeight = 200
        _contentHeightChanged = Signal.new(this)
        _extended = true 
        _extendedChanged = Signal.new(this)
        _titleBar.clicked.connect{|e,v|  this.extended = !_extended }
        _content = SgItem.new(_col, { "width": this.width, "height": _contentHeight, "clip": true})
        this.widthChanged.connect{|e,v| 
            _titleBar.width = this.width 
            _content.width = this.width 
        }
        _contentItem = null 
    }

    title{_titleBar.title}
    title=(val){_titleBar = val}
    extended{_extended}
    extended=(val) {
        if(_extended != val) {
            _extended = val
            if(_extended) {
                Tween.create({
                    "easing": EasingType.OutQuad,
                    "target": _content,
                    "fnChanged": Fn.new{|target, val| target.height = val * _contentHeight },
                    "duration": 0.2
                })
            } else {
                Tween.create({
                    "easing": EasingType.OutQuad,
                    "target": _content,
                    "fnChanged": Fn.new{|target, val| target.height = _contentHeight - val * _contentHeight },
                    "duration": 0.2
                })
            }
            _extendedChanged.emit(val)
        }
    }
    extendedChanged{_extendedChanged}
    contentHeight{_contentHeight}
    contentHeight=(val) {
        _contentHeight = val 
        if(_extended) {
            _content.height = _contentHeight
        }
    }
    contentHeightChanged{_contentHeightChanged}
    content{_content}
    contentItem{_contentItem}
    contentItem=(val) {
        if(_contentItem) {_contentItem.parent = null}
        _contentItem = val 
        if(_contentItem) {_contentItem.parent = _content}
        _contentItem.anchors.fill(_content)
    }
    iconSource{_titleBar.iconSource}
    iconSource=(val){_titleBar.iconSource = val}

    parse(map) {
        super.parse(map)
        if(map.keys.contains("extended")) {this.extended = map["extended"]}
        if(map.keys.contains("contentHeight")) {this.contentHeight = map["contentHeight"]}
        if(map.keys.contains("contentItem")) {this.contentItem = map["contentItem"]}
        var mtitleBar = {}
        mtitleBar["title"] = map["title"]
        mtitleBar["options"] = map["options"]
        mtitleBar["iconSource"] = map["iconSource"]
        _titleBar.parse(mtitleBar)
    }
}