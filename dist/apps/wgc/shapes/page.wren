import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/scenegraph2d" for SgItem,Anchors
import "cico/engine/sg2d/control/label" for SgLabel 
import "./objectbase" for ObjectBase
import "cico.raylib" for Color

class Page is ObjectBase {
    construct new() {
        super()
        initShapeProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic) 
        } else {
            super()
        }
        initShapeProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map){
        super(parent)
        initShapeProps_()
        parse(map)
    }

    initShapeProps_() {
        _label = SgLabel.new(this, { "fontSize": 24, "color": Color.fromString("#ffffff"), "text": "Page0" })
        _label.anchors.topMargin = 40
        _label.anchors.horizontalCenter({"target": this, "value": Anchors.HorizontalCenter})
        _label.anchors.top({"target": this, "value": Anchors.Bottom})
        this.nameChanged.connect{|e,v| _label.text = this.name }
        this.clip = false
    }

    selectShape(shape) {
        var cs = childrenByType(ObjectBase)
        for(child in cs) { child.selected = (child == shape) }
    }
    selectShapes(shapes) {
        var cs = childrenByType(ObjectBase)
        for(child in cs) {child.selected = shapes.contains(child)}
    }

    parse(map) {
        super.parse(map)
    }
}
