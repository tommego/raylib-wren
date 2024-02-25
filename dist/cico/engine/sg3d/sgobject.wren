import "cico.raylib" for Matrix,Vector3

class SgObject {
    construct new() {
        initSgObjectProcs_()
    }

    initSgObjectProcs_() {
        _parent = null 
        _matrix = Matrix.MatrixIdentity()
        _pos = Vector3.new(0, 0, 0)
        _scale = Vector3.new(1, 1, 1)
        _rotation = Vector3.new(1, 1, 1)
    }

    parent{_parent}
    parent=(val) {
        if(_parent != val) {
            _parent = val 
        }
    }
    matrix{_matrix}
    matrix=(val){_matrix = val}
    pos{_pos}
    pos=(val){_pos = val}
    scale(_scale)
    scale=(val){_scale = val}
    rotation{_rotation}
    rotation=(val){_rotation = val}
}