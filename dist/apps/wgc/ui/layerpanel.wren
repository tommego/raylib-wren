import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem
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
import "./layer/graphiclayerview" for GraphicLayerView

class LibraryContainer is SgItem {
    construct new() {
        super()
        initLibraryContainerProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initLibraryContainerProps_()
        if(dynamic is Map) {parse(dynamic)}
    }
    construct new(parent, map) {
        super(parent)
        initLibraryContainerProps_()
        parse(map)
    }

    initLibraryContainerProps_() {
        _label = SgLabel.new(this, { "text": "Library", "color": Color.new(255, 255, 255, 255) })
        _label.anchors.centerIn(this)
    }
}

class SigContainer is SgItem {
    construct new() {
        super()
        initSigContainerProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initSigContainerProps_()
        if(dynamic is Map) {parse(dynamic)}
    }
    construct new(parent, map) {
        super(parent)
        initSigContainerProps_()
        parse(map)
    }

    initSigContainerProps_() {
        _label = SgLabel.new(this, { "text": "Sig", "color": Color.new(255, 255, 255, 255) })
        _label.anchors.centerIn(this)
    }
}

class LayerPanel is SgRectangle {
    construct new() {
        super()
        initLayerPanelProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) { super(dynamic) }
        initLayerPanelProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initLayerPanelProps_()
        parse(map)
    }
    initLayerPanelProps_() {
        _col = SgColumn.new(this)
        _tabbar = SgTabBar.new(_col, {
            "width": this.width,
            "height": 30,
            "color": Color.new(40, 40, 40, 255),
            "tabs": [ SgTab.new({ "text": "图层" }), SgTab.new({ "text": "库" }), SgTab.new({ "text": "符号" }) ]
        })

        _swipe = SgSwipeView.new(_col, {
            "children": [
                GraphicLayerView.new({}),
                LibraryContainer.new({}),
                SigContainer.new({})
            ],
            "clip": false
        })
        this.widthChanged.connect{|e,v|
            _tabbar.width = this.width 
            _swipe.width = this.width
        }
        this.heightChanged.connect{|e,v|
            _swipe.height = this.height - _tabbar.height 
        }
        _tabbar.currentIndexChanged.connect{|e,v| _swipe.currentIndex = _tabbar.currentIndex}

        _swipe.currentIndex = _tabbar.currentIndex
    }
}