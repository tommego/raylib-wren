import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem, Anchors, SgEvent
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
import "cico/engine/signalslot" for Signal
import "cico/engine/sg2d/icon" for SgIcon

class TitleBar is SgRectangle {
    construct new() {
        super()
        initTitleBarProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initTitleBarProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initTitleBarProps_()
        parse(map)
    }

    initTitleBarProps_() {
        // this.color = Color.new(35, 35, 35, 255)
        this.color.parse("#222222")
        _row = SgRow.new(this)
        _row.spacing = 10
        _row.anchors.verticalCenter({"target": this, "value": Anchors.VerticalCenter})
        _row.x = 10
        _icon = SgIcon.new(_row, { "width": 22, "height": 22, "color": Color.fromString("#bbbbbb") })
        _label = SgLabel.new(_row)
        _label.color = Color.new(200, 200, 200, 255)
        _label.fontSize = 12
        _label.anchors.verticalCenter({"target": _row, "value": Anchors.VerticalCenter})

        _optRow = SgRow.new(this)
        _optRow.anchors.verticalCenter({"target": this, "value": Anchors.VerticalCenter})
        _optRow.anchors.rightMargin = 10
        _optRow.anchors.right({"target": this, "value": Anchors.Right})
        _optRow.spacing = 1
        _pressed = false 
        _clicked = Signal.new(this)
        _pressedChanged = Signal.new(this)
        // _line = SgRectangle.new(this,{"width": this.width, "height": 1, "color": Color.new(255, 255, 255, 20)})
        _line = SgRectangle.new(this,{"width": this.width, "height": 1, "color": Color.fromString("#111111")})
        this.widthChanged.connect{|e,v| _line.width = this.width}
        _line.anchors.bottom({"target": this, "value": Anchors.Bottom})
    }
    title{_label.text}
    title=(val){_label.text = val}
    clicked{_clicked}
    pressedChanged{_pressedChanged}

    parse(map) {
        super.parse(map)
        if(map.keys.contains("title")) { _label.text = map["title"] }
        if(map.keys.contains("options")) {
            for(opt in map["options"]) {
                if(opt is SgItem) { opt.parent = _optRow }
            }
        }
        if(map.keys.contains("iconSource")) {this.iconSource=map["iconSource"]}
    }

    iconSource{_icon.source}
    iconSource=(val){_icon.source=val}

    onEvent(event) {
        var ret = super.onEvent(event)

        if(event.type == SgEvent.MousePressed) {
            _mousePressedTime = Raylib.GetTime()
            ret = 1
            _pressed = true 
            _pressedChanged.emit(true)
        } else if(event.type == SgEvent.MouseRelease) {
            ret = 1
            _pressed = false 
            _pressedChanged.emit(false)
            var now = Raylib.GetTime()
            if(now - _mousePressedTime < 0.150) { _clicked.emit() }
        }
        return ret 
    }
}