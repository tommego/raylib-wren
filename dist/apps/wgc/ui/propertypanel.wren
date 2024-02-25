import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/layout" for SgRow,SgFlowLayout, SgColumn 
import "cico/engine/sg2d/control/scrollview" for SgScrollView
import "cico/engine/sg2d/control/button" for SgButton
import "cico/engine/math" for Math
import "cico.raylib" for Raylib, Color
import "cico/engine/sg2d/control/tabbar" for SgTab,SgTabBar

class PropertyPanel is SgRectangle {
    construct new() {
        super()
        initPropertyPanleProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) { super(dynamic) }
        initPropertyPanleProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initPropertyPanleProps_()
        parse(map)
    }
    initPropertyPanleProps_() {
        _col = SgColumn.new(this)
        _contentCol = SgColumn.new(_scrollView)
        _tabbar = SgTabBar.new(_col, {
            "width": this.width,
            "height": 30,
            "color": Color.new(40, 40, 40, 255),
            "tabs": [ SgTab.new({ "text": "属性" }), SgTab.new({ "text": "标注" }) ]
        })
        _scrollView = SgScrollView.new(_col, {})
        this.widthChanged.connect{|e,v|
            _tabbar.width = this.width
            _scrollView.width = this.width
            for(item in _contentCol.children) { item.width = this.width }
        }
        this.heightChanged.connect{|e,v|
            _scrollView.height = this.height - 30
        }
    }
}