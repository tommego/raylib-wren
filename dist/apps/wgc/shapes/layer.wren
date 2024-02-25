import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/scenegraph2d" for SgItem
import "./objectbase" for ObjectBase
import "cico.raylib" for Color 

class Layer is ObjectBase {
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
        this.color.parse("#00000000")
    }

    parse(map) {
        super.parse(map)
    }
}
