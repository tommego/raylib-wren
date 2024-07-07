import "cico/engine/signalslot" for Signal 

class Workspace {
    static init() {
        if(!__inited) {
            __inited = true 
            __hoverIndex = -1
            __selectedIndex = -1
            __maxSize = 1024
            __math = 0
            __scale = 1
            __alphaMode = 0
            __hoverIndexChanged = Signal.new(this)
            __selectedIndexChanged = Signal.new(this)
            __maxSizeChanged = Signal.new(this)
            __mathChanged = Signal.new(this)
            __scaleChanged = Signal.new(this)
            __alphaModeChanged = Signal.new(this)
        }
    }
    static hoverIndex{__hoverIndex}
    static hoverIndex=(val){
        if(__hoverIndex != val) {
            __hoverIndex = val 
            __hoverIndexChanged.emit(val)
        }
    }
    static hoverIndexChanged{__hoverIndexChanged}
    static selectedIndex{__selectedIndex}
    static selectedIndex=(val){
        if(__selectedIndex != val) {
            __selectedIndex = val 
            __selectedIndexChanged.emit(val)
        }
    }
    static selectedIndexChanged{__selectedIndexChanged}
    static maxSize{__maxSize}
    static maxSize=(val){
        if(__maxSize != val){
            __maxSize = val 
            __maxSizeChanged.emit(val)
        }
    }
    static maxSizeChanged{__maxSizeChanged}
    static math{__math}
    static math=(val) {
        if(__math != val) {
            __math = val 
            __mathChanged.emit(val)
        }
    }
    static mathChanged{__mathChanged}
    static scale{__scale}
    static scale=(val){
        if(__scale != val){
            __scale = val 
            __scaleChanged.emit(val)
        }
    }
    static scaleChanged{__scaleChanged}
    static alphaMode{__alphaMode}
    static alphaMode=(val) {
        if(__alphaMode != val) {
            __alphaMode = val 
            __alphaModeChanged.emit(val)
        }
    }
    alphaModeChanged{__alphaModeChanged}
}
Workspace.init()