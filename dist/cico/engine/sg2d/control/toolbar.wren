import "../scenegraph2d" for SgItem
import "../rectangle" for SgRectangle

class SgToolBar is SgRectangle {
    construct new() {
        super() 
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        if(dynamic is Map) { parse(dynamic) }
    }

    parse(map) {
        super.parse(map)
    }
}