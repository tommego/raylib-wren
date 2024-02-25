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
import "./layerlistview" for LayerListView
import "./pagelistview" for PageListView
import "../common/extendview" for ExtendView
import "cico/engine/tween" for Tween,EasingType

class GraphicLayerView is SgItem {
    construct new() {
        super()
        initGraphicLayerViewProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initGraphicLayerViewProps_()
        if(dynamic is Map) {parse(dynamic)}
    }
    construct new(parent, map) {
        super(parent)
        initGraphicLayerViewProps_()
        parse(map)
    }

    initGraphicLayerViewProps_() {
        _col = SgColumn.new(this)
        _page = ExtendView.new(_col, {
            "title": "页面",
            "width": this.width,
            "height": 30,
            "options": [
                SgButton.new({ "width": 40, "height": 16, "text": "Del", "border": Border.new(0, Color.new(0, 0 ,0 ,0)), "backgroundColor": Color.new(255, 255, 255, 15), "textColor": Color.new(222, 46, 122, 255), "clicked": Fn.new{|e,v| _page.contentItem.delPage()}}),
                SgButton.new({ "width": 40, "height": 16, "text": "Add", "border": Border.new(0, Color.new(0, 0 ,0 ,0)), "backgroundColor": Color.new(255, 255, 255, 15), "textColor": Color.new(222, 222, 222, 255), "clicked": Fn.new{|e,v| _page.contentItem.addPage()}})
            ],
            "contentItem": PageListView.new(),
            "iconSource": "icons/badges/matt-paper.png"
        })

        _layer = ExtendView.new(_col, {
            "title": "图层元素",
            "width": this.width,
            "options": [
                SgButton.new({ "width": 40, "height": 16, "text": "Del", "border": Border.new(0, Color.new(0, 0 ,0 ,0)), "backgroundColor": Color.new(255, 255, 255, 15), "textColor": Color.new(222, 46, 122, 255), "clicked": Fn.new{|e,v| _layer.contentItem.delLayer()}}),
                SgButton.new({ "width": 40, "height": 16, "text": "Add", "border": Border.new(0, Color.new(0, 0 ,0 ,0)), "backgroundColor": Color.new(255, 255, 255, 15), "textColor": Color.new(222, 222, 222, 255), "clicked": Fn.new{|e,v| _layer.contentItem.addLayer()}})
            ],
            "contentItem": LayerListView.new(),
            "iconSource": "icons/badges/layers.png"
        })
        this.widthChanged.connect{|e,v|
            _page.width = this.width 
            _layer.width = this.width
        }
        this.heightChanged.connect{|e,v|
            _page.height = this.height / 2
            _layer.height = this.height / 2
            _page.contentHeight = this.height / 2 - 30
            _layer.contentHeight = _page.extended ?  this.height / 2 - 30 : this.height - 60
        }
        _page.content.heightChanged.connect{|e,v| 
            _layer.contentHeight = this.height - 60 - _page.content.height 
        }

    }
}