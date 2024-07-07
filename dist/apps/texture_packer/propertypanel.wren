import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem, Anchors, SgEvent 
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/sprite" for SgSprite
import "cico/engine/sg2d/layout" for SgRow,SgFlowLayout, SgColumn 
import "cico/engine/sg2d/control/combobox" for SgComboBox
import "cico/engine/sg2d/control/scrollview" for SgScrollView
import "cico/engine/sg2d/control/button" for SgButton
import "cico/engine/sg2d/control/tabbar" for SgTabBar, SgTab
import "cico/engine/math" for Math
import "cico.raylib" for Raylib, Color,RenderTexture,Camera2D,Vector2,Vector3,Matrix,Texture,Rectangle,ValueList
import "cico/engine/sg2d/control/listview" for SgListView
import "cico/engine/sg2d/control/label" for SgLabel
import "cico/engine/signalslot" for Signal
import "cico/engine/timer" for Timer  
import "./workspace" for Workspace 

class PropertyPanel is SgItem {
    construct new() {
        super()
        initPropertyPanelProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initPropertyPanelProps_()
        if(dynamic is Map) {parse(dynamic)}
    }
    construct new(parent, map) {
        super(parent)
        initPropertyPanelProps_()
        parse(map)
    }

    initPropertyPanelProps_() {
        _col = SgColumn.new(this, {"spacing": 16, "x": 20, "y": 30})
        _lpack = SgLabel.new(_col, {"text": "打包", "fontSize": 16})
        _mathOptsValue = [0, 0, 1]
        _mathRow = SgRow.new(_col, {"width": 200, "height": 20, "spacing": 20, "children":[
            SgItem.new({"width":40, "height": 1}),
            SgLabel.new({"fontSize": 14, "color": Color.fromString("#aaaaaa"), "text": "算法", "y": 4}),
            SgComboBox.new({
                "model": ["默认", "HLS", "FLS"], 
                "width": 160, 
                "height": 20, 
                "currentIndex": 0
            })
        ]})
        _mathCombo = _mathRow.children[2]
        _mathCombo.validated.connect{|e,v| 
            Workspace.math = _mathOptsValue[v]
        }
        _mathRow.anchors.right({"target": _col, "value": Anchors.Right})
        _mathRow.anchors.rightMargin = 20

        _sizeOptValues = [512, 1024, 2048, 4096]
        _sizeRow = SgRow.new(_col, {"width": 200, "height": 20, "spacing": 20, "children":[
            SgItem.new({"width":40, "height": 1}),
            SgLabel.new({"fontSize": 14, "color": Color.fromString("#aaaaaa"), "text": "最大尺寸", "y": 4}),
            SgComboBox.new({
                "model": ["512", "1024", "2048", "4096"], 
                "width": 160, 
                "height": 20, 
                "currentIndex": 0
            })
        ]})
        _sizeCombo = _sizeRow.children[2]
        _sizeCombo.validated.connect{|e,v| 
            Workspace.maxSize = _sizeOptValues[v]
        }
        _sizeRow.anchors.right({"target": _col, "value": Anchors.Right})
        _sizeRow.anchors.rightMargin = 20


        SgRectangle.new(_col, {"width": 260, "height": 1, "color": "#66ffffff"})

        // ====================== 图片导出设置 ==========================
        _limage = SgLabel.new(_col, {"text": "图片设置", "fontSize": 16})

        // 缩放
        _imgScaleValue = [0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        _imgScaleRow = SgRow.new(_col, {"width": 200, "height": 20, "spacing": 20, "children":[
            SgItem.new({"width":40, "height": 1}),
            SgLabel.new({"fontSize": 14, "color": Color.fromString("#aaaaaa"), "text": "缩放", "y": 4}),
            SgComboBox.new({
                "model": ["0.125x", "0.25x", "0.375x", "0.5x", "0.625x", "0.75x", "0.875x", "1.x"], 
                "width": 160, 
                "height": 20, 
                "currentIndex": 7
            })
        ]})
        _imgScaleCombo = _imgScaleRow.children[2]
        _imgScaleCombo.validated.connect{|e,v| 
            Workspace.scale = _imgScaleValue[v]
        }
        _imgScaleRow.anchors.right({"target": _col, "value": Anchors.Right})
        _imgScaleRow.anchors.rightMargin = 20

        // 透明设置
        _alphaModeRow = SgRow.new(_col, {"width": 200, "height": 20, "spacing": 20, "children":[
            SgItem.new({"width":40, "height": 1}),
            SgLabel.new({"fontSize": 14, "color": Color.fromString("#aaaaaa"), "text": "透明", "y": 4}),
            SgComboBox.new({
                "model": ["正常", "黑底透明"], 
                "width": 160, 
                "height": 20, 
                "currentIndex": 0
            })
        ]})
        _alphaModeCombo = _alphaModeRow.children[2]
        _alphaModeCombo.validated.connect{|e,v| 
            Workspace.alphaMode = v
        }
        _alphaModeRow.anchors.right({"target": _col, "value": Anchors.Right})
        _alphaModeRow.anchors.rightMargin = 20

        SgRectangle.new(_col, {"width": 260, "height": 1, "color": "#66ffffff"})

        // ====================== 导出设置 ==========================
        _lexport = SgLabel.new(_col, {"text": "导出设置", "fontSize": 16})

        _exportBtn = SgButton.new(_col, {"text": "导出精灵", "width": 200, "height": 30, "fontSize": 16, "radius": 4})
        _exportBtn.anchors.horizontalCenter({"target": _col, "value": Anchors.HorizontalCenter})
    }
}