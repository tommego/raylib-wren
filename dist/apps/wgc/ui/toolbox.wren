import "cico/engine/app" for App
import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem, Anchors
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/layout" for SgRow,SgFlowLayout, SgColumn 
import "cico/engine/sg2d/control/scrollview" for SgScrollView
import "cico/engine/sg2d/control/button" for SgButton
import "cico/engine/math" for Math
import "cico.raylib" for Raylib, Color
import "cico/engine/sg2d/control/menubar" for SgMenuBar, SgMenu, SgMenuItem
import "cico/engine/sg2d/control/toolbar" for SgToolBar 
import "cico/engine/sg2d/control/iconbutton" for SgIconButton
import "cico/engine/sg2d/control/combobox" for SgComboBox
import "../editor" for Editor
import "cico/engine/sg2d/control/group" for SgGroup

import "../shapes/rect" for ShapeRect
import "../shapes/line" for ShapeLine
import "../shapes/triangle" for ShapeTriangle

class ToolBox is SgRectangle {
    construct new() {
        super()
        initToolBoxProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initToolBoxProps_()
        if(dynamic is Map) {
            parse(dynamic)
        }
    }
    construct new(parent, map) {
        super(parent)
        initToolBoxProps_()
        parse(map)
    }
    initToolBoxProps_() {
        _row = SgRow.new(this)
        _row.anchors.verticalCenter({"target": this, "value": Anchors.VerticalCenter})
        _row.x = 10
        _row.spacing = 6
        _iconColor = Color.fromString("#cccccc")
        _shapes = [ ShapeLine,ShapeRect,ShapeTriangle ]
        // common
        SgIconButton.new(_row, { "name": "save", "source": "icons/badges/file.png", "width": 22, "height": 22, "iconColor": _iconColor, "checkEnabled": false})
        SgIconButton.new(_row, { "name": "undo", "source": "icons/badges/undo.png", "width": 22, "height": 22, "iconColor": _iconColor, "checkEnabled": false})
        SgIconButton.new(_row, { "name": "redo", "source": "icons/badges/redo.png", "width": 22, "height": 22, "iconColor": _iconColor, "checkEnabled": false})
        SgRectangle.new(_row, {"width": 1, "height": 22, "color": Color.fromString("#666666")})
        // view tool
        SgIconButton.new(_row, { "name": "fit", "source": "icons/badges/fit-to-width.png", "width": 22, "height": 22, "iconColor": _iconColor})
        SgIconButton.new(_row, { "name": "pan", "source": "icons/badges/hand-up.png", "width": 22, "height": 22, "iconColor": _iconColor})
        SgRectangle.new(_row, {"width": 1, "height": 22, "color": Color.fromString("#666666")})
        // paint tool
        SgIconButton.new(_row, { "name": "select","source": "icons/badges/select-cursor.png", "width": 22, "height": 22, "iconColor": _iconColor, "checked": true})
        SgRectangle.new(_row, {"width": 1, "height": 16, "color": Color.fromString("#000000")})
        SgComboBox.new(_row, {
            "width": 22, 
            "height": 22, 
            "backgroundColor": Color.fromString("#00000000"), 
            "border": Border.new(0, Color.fromString("#00000000")),
            "showLabel": false,
            "options": [{"text": "Select Object"}, {"text": "Select Point"}],
            "indicatorColor": Color.fromString("#cccccc")
        })

        SgIconButton.new(_row, { "name": "shape","source": "icons/badges/border-horizontal.png", "width": 22, "height": 22, "iconColor": _iconColor})
        SgRectangle.new(_row, {"width": 1, "height": 16, "color": Color.fromString("#000000")})
        _shapeCombo = SgComboBox.new(_row, {
            "width": 22, 
            "height": 22, 
            "backgroundColor": Color.fromString("#00000000"), 
            "border": Border.new(0, Color.fromString("#00000000")),
            "showLabel": false,
            "options": [{"text": "Line"}, {"text": "Rectangle"}, {"text": "Triangle"}],
            "indicatorColor": Color.fromString("#cccccc")
        })

        SgIconButton.new(_row, { "name": "vector","source": "icons/badges/pen.png", "width": 22, "height": 22, "iconColor": _iconColor})
        SgRectangle.new(_row, {"width": 1, "height": 16, "color": Color.fromString("#000000")})
        SgComboBox.new(_row, {
            "width": 22, 
            "height": 22, 
            "backgroundColor": Color.fromString("#00000000"), 
            "border": Border.new(0, Color.fromString("#00000000")),
            "showLabel": false,
            "options": [{"text": "Pen"}, {"text": "Beizier"}, {"text": "Draw"}],
            "indicatorColor": Color.fromString("#cccccc")
        })

        SgIconButton.new(_row, { "name": "text","source": "icons/badges/type.png", "width": 22, "height": 22, "iconColor": _iconColor})

        SgIconButton.new(_row, { "name": "image","source": "icons/badges/edit-image.png", "width": 22, "height": 22, "iconColor": _iconColor})

        SgRectangle.new(_row, {"width": 1, "height": 22, "color": Color.fromString("#666666")})
        // layout&transform
        SgIconButton.new(_row, { "name": "vflip","source": "icons/badges/flip-vertical.png", "width": 22, "height": 22, "iconColor": _iconColor})
        SgIconButton.new(_row, { "name": "hflip","source": "icons/badges/flip-vertical.png", "width": 22, "height": 22, "iconColor": _iconColor, "rotation": 90})
        SgRectangle.new(_row, {"width": 1, "height": 22, "color": Color.fromString("#666666")})
        // boolean operation 
        SgRectangle.new(_row, {"width": 1, "height": 22, "color": Color.fromString("#666666")})
        // layer
        SgIconButton.new(_row, { "name": "front","source": "icons/badges/front-sorting.png", "width": 22, "height": 22, "iconColor": _iconColor})
        SgIconButton.new(_row, { "name": "back","source": "icons/badges/front-sorting.png", "width": 22, "height": 22, "iconColor": _iconColor})
        SgRectangle.new(_row, {"width": 1, "height": 22, "color": Color.fromString("#666666")})
        // others
        SgIconButton.new(_row, { "name": "export","source": "icons/badges/folder.png", "width": 22, "height": 22, "iconColor": _iconColor, "checkEnabled": false})

        _group = SgGroup.new()
        _group.items = _row.childrenByType(SgIconButton)
        _group.clicked.connect{|e,v| 
            if(v.name == "select") {
                _group.selectByName("select")
            } else if(v.name == "shape") {
                v.checked = false 
                _shapeCombo.open() 
            }
         }
        _shapeCombo.validated.connect{|e,v|
            _group.selectByName("shape")
            Editor.changeOperator(_shapes[v]) 
        }

        Editor.operatorChanged.connect{|e,v| 
            if(!v) {
                _group.selectByName("select")
            }
        }
    }

    parse(map) {
        super.parse(map)
    }
}