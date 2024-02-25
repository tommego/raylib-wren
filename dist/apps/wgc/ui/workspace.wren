import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem, Anchors
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/layout" for SgRow,SgFlowLayout, SgColumn 
import "cico/engine/sg2d/control/scrollview" for SgScrollView
import "cico/engine/sg2d/control/button" for SgButton
import "cico/engine/math" for Math
import "cico.raylib" for Raylib, Color
import "./layerpanel" for LayerPanel
import "./propertypanel" for PropertyPanel
import "./canvas" for Canvas
import "../editor" for Editor 

class WorkSpace is SgRectangle {
    construct new() {
        super()
        initWorkSpaceProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) { super(dynamic) }
        initWorkSpaceProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initWorkSpaceProps_()
        parse(map)
    }

    initWorkSpaceProps_() {
        _row = SgRow.new(this)
        _row.anchors.bottom({"target": this, "value": Anchors.Bottom})
        _layerPanel = LayerPanel.new(_row, {
            "color": Color.new(45, 45, 45, 255),
            "width": 300,
            "heigth": this.height - 1
        })
        _canvas = Canvas.new(_row, {
            "color": Color.new(66, 66, 66 , 255),
            "width": 500,
            "height": this.height
        })
        _propPanel = PropertyPanel.new(_row, {
            "color": Color.new(45, 45, 45, 255),
            "width": 300,
            "heigth": this.height - 1
        })
        this.heightChanged.connect{|e,v| 
            _layerPanel.height = this.height - 1
            _canvas.height = this.height - 1
            _propPanel.height = this.height - 1
        }
        this.widthChanged.connect{|e,v| 
            _canvas.width = this.width - _layerPanel.width - _propPanel.width 
        }

        Editor.canvas = _canvas
    }
}