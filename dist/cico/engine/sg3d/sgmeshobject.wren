import "sgobject" for SgObject

class SgMeshObject is SgObject {
    construct new() {
        super()
        initMeshObjectProps_()
    }

    initMeshObjectProps_() {
        material = null 
        
    }
}