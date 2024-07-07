import "cico.raylib" for Raylib, Vector2, Color, Rectangle, Font, Camera2D, Shader
import "../signalslot" for Signal
import "cico/engine/timer" for Timer 

class Border {
    construct new(width, color) {
        _bw = width 
        _bc = color 
    }
    width{_bw}
    width = (val) {_bw = val}
    color{_bc}
    color=(val) {_bc = val}
}

class Anchors {
    construct new(target) {
        _target = target 
        _left = null
        _right = null
        _top = null
        _bottom = null
        _centerIn = null 
        _horizontalCenter = null 
        _verticalCenter = null 
        _leftMargin = 0 
        _rightMargin = 0
        _topMargin = 0
        _bottomMargin = 0
        _fill = null 
        _refreshBinding = Fn.new{|target, val| refreshGeo()}
        _target.widthChanged.connect(_refreshBinding)
        _target.heightChanged.connect(_refreshBinding)
    }
    parse(map) {
        if(map.contanis("right")) { this.right = map["right"] }
        if(map.contains("left")) { this.left = map["left"] }
        if(map.contains("top")) { this.top = map["top"] }
        if(map.contains("bottom")) { this.bottom = map["bottom"] }
        if(map.contains("centerIn")) { this.centerIn = map["centerIn"]}
        if(map.contains("horizontalCenter")) { this.horizontalCenter = map["horizontalCenter"] }
        if(map.contains("verticalCenter")) { this.verticalCenter = map["verticalCenter"] }
        if(map.contains("rightMargin")) { this.rightMargin = map["rightMargin"]}
        if(map.contains("topMargin")) { this.topMargin = map["topMargin"]}
        if(map.contains("leftMargin")) { this.leftMargin = map["leftMargin"]}
        if(map.contains("bottomMargin")) { this.bottomMargin = map["bottomMargin"]}
    }
    static Left{0}
    static Right{1}
    static Top{2}
    static Bottom{3}
    static HorizontalCenter{4}
    static VerticalCenter{5}
    leftMargin{_leftMargin}
    leftMargin=(val){_leftMargin = val}
    rightMargin{_rightMargin}
    rightMargin=(val){_rightMargin = val}
    topMargin{_topMargin}
    topMargin=(val){_topMargin = val}
    bottomMargin{_bottomMargin}
    bottomMargin=(val){_bottomMargin = val}
    left{_left}
    left=(val){left(val)}
    left(val) {
        if(_left is Map) { _left["target"].geometryChanged.disconnect(_refreshBinding) }
        if(val is Map && val["target"] is SgItem && val["value"] is Num) {
            _left = val
            if(val["target"] != null) { val["target"].geometryChanged.connect(_refreshBinding) }
        } else {
            _left = null 
        }
        refreshGeo()
    }
    right{_right}
    right=(val) {right(val)}
    right(val) {
        if(_right is Map) { _right["target"].geometryChanged.disconnect(_refreshBinding) }
        if(val is Map && val["target"] is SgItem && val["value"] is Num) {
            _right = val
            if(val["target"] != null) { val["target"].geometryChanged.connect(_refreshBinding) }
        } else {
            _right = null 
        }
        refreshGeo()
    }
    top{_top}
    top=(val) {top(val)}
    top(val) {
        if(_top is Map && val["target"] is SgItem && val["value"] is Num) { _top["target"].geometryChanged.disconnect(_refreshBinding) }
        if(val is Map) {
            _top = val
            if(val["target"] != null) { val["target"].geometryChanged.connect(_refreshBinding) }
        } else {
            _top = null 
        }
        refreshGeo()
    }
    bottom{_bottom}
    bottom=(val){bottom(val)}
    bottom(val) {
        if(_bottom is Map && val["target"] is SgItem && val["value"] is Num) { _bottom["target"].geometryChanged.disconnect(_refreshBinding) }
        if(val is Map) {
            _bottom = val
            if(val["target"] != null) { val["target"].geometryChanged.connect(_refreshBinding) }
        } else {
            _bottom = null 
        }
        refreshGeo()
    }
    centerIn{_centerIn} 
    centerIn=(val){centerIn(val)}
    centerIn(val) {
        if(_centerIn is SgItem) { _centerIn.geometryChanged.disconnect(_refreshBinding) }
        _centerIn  = (val is SgItem ? (val.parent == _target.parent || _target.parent ==  val ? val : null) : null)
        if(_centerIn is SgItem) { _centerIn.geometryChanged.connect(_refreshBinding) }
        refreshGeo()
    }
    horizontalCenter{_horizontalCenter}
    horizontalCenter=(val){horizontalCenter(val)}
    horizontalCenter(val) {
        if(_horizontalCenter is Map && val["target"] is SgItem && val["value"] is Num) { _horizontalCenter["target"].geometryChanged.disconnect(_refreshBinding) }
        if(val is Map) {
            _horizontalCenter = val
            if(val["target"] != null) { val["target"].geometryChanged.connect(_refreshBinding) }
        } else {
            _horizontalCenter = null 
        }
        refreshGeo()
    }
    verticalCenter{_verticalCenter}
    verticalCenter=(val){verticalCenter(val)}
    verticalCenter(val) {
        if(_verticalCenter is Map && val["target"] is SgItem && val["value"] is Num) { _verticalCenter["target"].geometryChanged.disconnect(_refreshBinding) }
        if(val is Map) {
            _verticalCenter = val
            if(val["target"] != null) { val["target"].geometryChanged.connect(_refreshBinding) }
        } else {
            _verticalCenter = null 
        }
        refreshGeo()
    }
    fill{_fill}
    fill=(val) {fill(val)}
    fill(val) {
        if(_fill) {_fill.geometryChanged.disconnect(_refreshBinding)}
        _fill = val 
        if(_fill) {_fill.geometryChanged.connect(_refreshBinding)}
        refreshGeo()
    }
    aval(target, t) {
        if(t == Anchors.Left) { 
            return target.left 
        } else if(t == Anchors.Right) {
            return target.right 
        } else if(t == Anchors.Top) {
            return target.top 
        } else if(t == Anchors.Bottom) {
            return target.bottom
        } else if(t == Anchors.VerticalCenter) {
            return target.verticalCenter
        } else if(t == Anchors.HorizontalCenter) {
            return target.horizontalCenter
        } else {
            return t
        }
    }
    refreshGeo() {
        if(_fill is SgItem) {
            _target.width = _fill.width 
            _target.height = _fill.height 
            if(_target.parent == _fill.parent) {
                _target.x = _fill.x 
                _target.y = _fill.y
            } else if(_target.parent == _fill) {
                _target.x = 0 
                _target.y = 0
            }
        }else if(_centerIn is SgItem) {
            if(_centerIn.parent == _target.parent) {
                _target.x = _centerIn.x + _centerIn.width / 2 - _target.width / 2
                _target.y = _centerIn.y + _centerIn.height / 2 - _target.height / 2
            } else if(_target.parent == _centerIn) {
                _target.x = _centerIn.width / 2 - _target.width / 2
                _target.y = _centerIn.height / 2 - _target.height / 2
            }
        } else {
            if(_horizontalCenter is Map) {
                var src = _horizontalCenter["target"]
                var v = aval(src, _horizontalCenter["value"])
                if(_target.parent == src.parent) {
                    _target.x = src.x + v - _target.width / 2
                } else if(_target.parent == src) {
                    _target.x = v - _target.width / 2
                }
            } else {
                if(_left is Map) {
                    var src = _left["target"]
                    var v = aval(src, _left["value"])
                    if(src == _target.parent) { 
                        _target.x = src.x + v + _leftMargin 
                    } else if(_target.parent == src) {
                        _target.x = v + _leftMargin 
                    }
                }
                if(_right is Map) {
                    var src = _right["target"]
                    var v = aval(src, _right["value"])
                    if(src == _target.parent) { 
                        _target.x = src.x + v - _target.width - _rightMargin 
                    } else if(_target.parent == src) {
                        _target.x = v - _rightMargin - _target.width
                    }
                }
            }
            if(_verticalCenter is Map) {
                var src = _verticalCenter["target"]
                var v = aval(src, _verticalCenter["value"])
                if(_target.parent == src.parent) {
                    _target.y = src.y + v - _target.height / 2
                } else if(_target.parent == src) {
                    _target.y = v - _target.height / 2
                }
            } else {
                if(_top is Map) {
                    var src = _top["target"]
                    var v = aval(src, _top["value"])
                    if(src.parent == _target.parent) { 
                        _target.y = src.y + v + _topMargin 
                    } else if(_target.parent == src) {
                        _target.y = v + _topMargin
                    }
                }
                if(_bottom is Map) {
                    var src = _bottom["target"]
                    var v = aval(src, _bottom["value"])
                    if(src.parent == _target.parent) { 
                        _target.y = src.y + v - _target.height - _bottomMargin 
                    } else if(_target.parent == src) {
                        _target.y = v - _bottomMargin - _target.height
                    }
                }
            }
        }
    }
}

class SgEvent {
    construct new(type, data) {
        _type = type 
        _data = data
    }
    type{_type}
    type=(val){_type = val}
    data{_data}
    data=(val){_data = val}

    static None{-1}
    // mouse 
    static HoverEnter{0}
    static MousePressed{1}
    static MouseRelease{2}
    static MouseMove{3}
    static MouseWheel{4}
    static HoverExit{5}
    static DragStart{6}
    static DragEnd{7}

    // key 
    static KeyPress{7}
    static KeyRelease{8}
}

class SgNode2D {
    construct new() {
        initNodeDefault_()
        if(_id == 0) {
            _parent = null 
        } else {
            this.parent = SceneGraph2D.root 
        }
          
    }
    construct new(parent) {
        initNodeDefault_()
        this.parent = parent 
    }

    initNodeDefault_() {
        _rotation = 0
        _scale = 1
        _opacity = 1
        _children = []
        _name = ""
        _visible = true 
        _width = 0
        _height = 0
        _z = 0
        _x = 0
        _y = 0
        _clip = false 
        _debug = false 
        _dragEnabled = false 
        _hoverEnabled = false
        _finalPosition = Vector2.new()
        _finalBounds = Rectangle.new()
        _id = SceneGraph2D.genId()

        _extra = {}

        // signals 
        _parentChanged = Signal.new(this)
        _rotationChanged = Signal.new(this)
        _scaleChanged = Signal.new(this)
        _opacityChanged = Signal.new(this)
        _childrenChanged = Signal.new(this)
        _childAdded = Signal.new(this)
        _childRemoved = Signal.new(this)
        _nameChanged = Signal.new(this)
        _visibleChanged = Signal.new(this)
        _widthChanged = Signal.new(this)
        _heightChanged = Signal.new(this)
        _xChanged = Signal.new(this)
        _yChanged = Signal.new(this)
        _zChanged = Signal.new(this)
        _clipChanged = Signal.new(this)
        _debugChanged = Signal.new(this)
        _dragEnabledChanged = Signal.new(this)
        _hoverEnabledChanged = Signal.new(this)
        _geometryChanged = Signal.new(this)
        _focusChanged = Signal.new(this)
        _hoverEntered = Signal.new(this)
        _hoverExited = Signal.new(this)
        _skipRenderChild = false 
        _absoluteCoordinate = false
        _mouseInbounds = false 

        _refreshGeometry = Fn.new{|emitter, val| recaculateFindalBounds() }

        _zorderTimer = Timer.new({ "interval": 0.1, "repeat": false, "triggered": Fn.new{|e,v| zorder()} })

        // binding nested geometry boundins refreshing 
        _parentChanged.connect{|emitter, val| 
            if(val) { val.geometryChanged.connect(_refreshGeometry) }
        }
        _geometryChanged.connect{|emitter, val| 
            recaculateFindalBounds()
            for(child in _children) { child.geometryChanged.emit() }
        }
        _childrenChanged.connect{|e,v| _zorderTimer.restart() }
        
        // anchors
        _anchors = Anchors.new(this)
    }
    
    parent {_parent}
    parent = (val) {
        if(_parent) {
            if(_parent.children.contains(this)) { 
                _parent.children.remove(this) 
                _parent.childRemoved.emit(this)
                _parent.childrenChanged.emit()
                _parent.geometryChanged.disconnect(_refreshGeometry)
            }
        }
        _parent = val
        if(_parent) {
            if(!_parent.children.contains(this)) { 
                _parent.children.add(this) 
                _parent.childAdded.emit(this)
                _parent.childrenChanged.emit()
            }
        } else {
            // if(SceneGraph2D.root != this) {
            //     if(!SceneGraph2D.root.children.contains(this)) { SceneGraph2D.root.children.add(this) }
            // }
        }
        _parentChanged.emit(val)
    }
    position{Vector2.new(_x, _y)}
    position=(val) {
        _x = val.x 
        _y = val.y
    } 
    x{_x}
    x=(val){
        if(_x != val) {
            _x = val
            _geometryChanged.emit(null)
            _xChanged.emit(val)
        }
    }
    y{_y}
    y=(val){
        if(_y != val) {
            _y = val
            _geometryChanged.emit(null)
            _yChanged.emit(val)
        }
    }
    width {_width}
    width = (val) {
        if(_width != val) {
            _width = val
            _geometryChanged.emit(null)
            _widthChanged.emit(val)
        }
    }
    height {_height}
    height = (val) {
        if(_height != val) {
            _height = val
            _geometryChanged.emit(null)
            _heightChanged.emit(val)
        }
    }
    name {_name}
    name = (val) {
        if(_name != val) {
            _name = val 
            _nameChanged.emit(val)
        }
    }
    rotation {_rotation}
    rotation = (val) {
        if(_rotation != val) {
            _rotation = val
            _rotationChanged.emit(val)
        }
    }
    scale{_scale}
    scale=(val) {
        if(_scale != val) {
            _scale = val
            _scaleChanged.emit(val)
        }
    }
    opacity{_opacity}
    opacity = (val) {
        if(_opacity != val) {
            _opacity = val
            _opacityChanged.emit(val)
        }
    }
    visible {_visible}
    visible = (val) {
        if(_visible != val) {
            _visible = val
            _visibleChanged.emit(val)
        }
    }
    children {_children}
    z{_z}
    z = (val) {
        if(_z != val) {
            _z = val
            _zChanged.emit(val)
        }
    }
    clip{_clip}
    clip = (val) {
        if(_clip != val) {
            _clip = val
            _clipChanged.emit(val)
        }
    }
    focus{SceneGraph2D.focusNode == this}
    focus=(val){
        if(val) {
            SceneGraph2D.focusOn(this)
        } else {
            SceneGraph2D.focusOn(null)
        }
    }
    debug{_debug}
    debug=(val){
        if(_debug != val) {
            _debug = val
            _debugChanged.emit(val)
        }
    }
    dragEnabled{_dragEnabled}
    dragEnabled=(val){
        if(_dragEnabled != val) {
            _dragEnabled = val
            _dragEnabledChanged.emit(val)
        }
    }
    id{_id}
    hoverEnabled{_hoverEnabled}
    hoverEnabled=(val){
        if(_hoverEnabled != val) {
            _hoverEnabled = val
            _hoverEnabledChanged.emit(val)
        }
    }
    extra{_extra}
    extra=(val) {_extra = val}
    left{_x}
    right{_width}
    top{_y}
    bottom{_height}
    verticalCenter{_height / 2}
    horizontalCenter{_width / 2}
    anchors{_anchors}
    anchors=(val){_anchors = val}
    skipRenderChild{_skipRenderChild}
    skipRenderChild=(val){_skipRenderChild = val}
    absoluteCoordinate{_absoluteCoordinate}
    absoluteCoordinate=(val){
        _absoluteCoordinate=val
        recaculateFindalBounds()
    }
    mouseInbounds{_mouseInbounds}
    mouseInbounds=(val) {_mouseInbounds = val}

    [key]{
        if(key == "x"){
            return _x
        } else if(key == "xChanged"){
            return _xChanged
        } else if(key == "y") {
            return _y 
        } else if(key == "yChanged"){
            return _yChanged
        }else if(key == "width") {
            return _width 
        } else if(key == "widthChanged"){
            return _widthChanged
        } else if(key == "height") {
            return _height
        } else if(key == "heightChanged"){
            return _heightChanged
        } else if(key == "clip") {
            return _clip
        } else if(key == "clipChanged") {
            return _clipChanged
        } else if(key == "visible") {
            return _visible 
        } else if(key == "visibleChanged") {
            return _visibleChanged
        } else if(key == "dragEnabled") {
            return _dragEnabled
        } else if(key == "dragEnabledChanged") {
            return _dragEnabledChanged
        } else if(key == "hoverEnabled") {
            return _hoverEnabled
        } else if(key == "hoverEnabledChanged") {
            return _hoverEnabledChanged
        } else if(key == "z") {
            return _z 
        } else if(key == "zChanged") {
            return _zChanged
        } else if(key == "id") {
            return _id 
        } else if(key == "children") {
            return _children
        } else if(key == "childrenChanged") {
            return _childrenChanged
        } else if(key == "rotation") {
            return _rotation
        } else if(key == "rotationChanged") {
            return _rotationChanged
        } else if(key == "scale") {
            return _scale 
        } else if(key == "scaleChanged") {
            return _scaleChanged
        } else if(key == "geometry") {
            return _finalBounds
        } else if(key == "geometryChanged") {
            return _geometryChanged
        } else {
            return null 
        }
    }
    [key]=(val){
        if(key == "x"){
            this.x = val 
        } else if(key == "y") {
            this.y = val 
        } else if(key == "width") {
            this.width = val  
        } else if(key == "height") {
            this.height = val 
        } else if(key == "clip") {
            this.clip = val 
        } else if(key == "visible") {
            this.visible = val 
        } else if(key == "dragEnabled") {
            this.dragEnabled = val 
        } else if(key == "hoverEnabled") {
            this.hoverEnabled = val 
        } else if(key == "z") {
            this.z = val 
        } else if(key == "id") {
            // do nothing 
        } else if(key == "children") {
            // do nothing 
        } else if(key == "rotation") {
            this.rotation = val 
        } else if(key == "scale") {
            this.scale = val 
        } else {
            // do nothing 
        }
    }

    // add a child node
    addNode(child) {
        if(!_children.contains(child) && child != this) { 
            if(child.parent) { child.parent.geometryChanged.disconnect(child.refreshGeometry) }
            child.parent = this 
            _childrenChanged.emit()
            _childAdded.emit(child)
        }
    }
    // remove a child node 
    removeNode(child) {
        if(_children.contains(child) && child != this) { 
            if(child.parent) { child.parent.geometryChanged.disconnect(child.refreshGeometry) }
            child.parent = null 
            _childrenChanged.emit()
            _childRemoved.emit(child)
        }
    }

    removeAllNodes() {
        var del = []
        for(c in _children) { del.add(c) }
        for(c in del) { removeNode(c) }
    }

    // removeNode with index
    removeNodeByIndex(index) {
        if(index >= 0 && index < _children.count) {
            var child = _children[index]
            _childrenChanged.emit()
            _childRemoved.emit(child)
        }
    }

    // move child node 
    moveNode(from, to) {
        var i0 = from < to ? from : to 
        var i1 = to > from ? to : from
        if(from >= 0 && from < _children.count && to >= 0 && to < _children.count) {
            var tmp = _children[i0]
            for(i in i0+1..i1) { _children[i-1] = _children[i] }
            _children[i1] = tmp
        }
    }

    // swap child node 
    swapNode(from, to) {
        if(from >= 0 && from < _children.count && to >= 0 && to < _children.count) {
            var tmp = _children[from]
            _children[from] = _children[to]
            _children[to] = tmp 
        }
    }

    // find children node by name, return a list found 
    findChildrenByName(name, recursive) {
        var c = []
        for(child in _children) {
            if(child.name == name) { c.add(child)  }
            if(recursive) {
                for(cc in child.children) { 
                    var sc = cc.findChildByName(name) 
                    if(sc.count > 0) { c.add(sc) }
                }
            }
        }
        return c 
    }

    indexOf(child) {
        var ret = -1 
        for(i in 0..._children.count-1) {
            if(child == _children[i]) {
                ret = i 
                break
            }
        }
        return ret 
    }

    zorder() {
        if(_children.count >= 2) {
            for(i in 0..._children.count-1) {
                for(j in i+1..._children.count) {
                    if(_children[i].z > _children[j].z) {
                        moveNode(i, j)
                    }
                }
            }
        }
    }
    
    // final transform with parent inher 
    finalRotation { _rotation + (_parent ? _parent.finalRotation : 0) }
    finalScale { _scale * (_parent ? _parent.finalScale : 1) }
    finalOpacity { _opacity * (_parent ? _parent.finalOpacity : 1) }
    finalX { _x + (parent != null ? parent.x : 0) }
    finalY { _y = (parent != null ? parent.y : 0)}
    finalBounds { _finalBounds }

    // recaculate node geometry for rendering 
    recaculateFindalBounds() {
        if(_absoluteCoordinate) {
            _finalBounds.x = _x 
            _finalBounds.y = _y 
        } else {
            _finalBounds.x = parent ? parent.finalBounds.x + _x : _x 
            _finalBounds.y = parent ? parent.finalBounds.y + _y : _y 
        }
        _finalBounds.width = _width 
        _finalBounds.height = _height 
    }

    // reimplement this to render 
    onRender() { }
    resetRenderState() {
        Raylib.EndShaderMode() 
        Raylib.EndMode2D()
    }

    // reimplement this to process event 
    onEvent(event) { 
        var ret = 0
        if(event.type == SgEvent.DragStart && _dragEnabled) {
            ret = 1
        } else if(event.type == SgEvent.DragEnd && _dragEnabled) {
            ret = 1
        } else if(event.type == SgEvent.HoverEnter && (_dragEnabled || _hoverEnabled)) {
            ret = 1
            _hoverEntered.emit(null)
        } else if(event.type == SgEvent.HoverExit && (_dragEnabled || _hoverEnabled)) {
            ret = 1
            _hoverExited.emit(null)
        } else if(event.type == SgEvent.MouseMove && (_dragEnabled || _hoverEnabled)) {
            ret = 1
        }
        return ret 
    }

    // parse properties from map 
    parse(map) {
        if(map.keys.contains("x")) { this.x = map["x"] }
        if(map.keys.contains("y")) { this.y = map["y"] }
        if(map.keys.contains("z")) { this.z = map["z"] }
        if(map.keys.contains("rotation")) { this.rotation = map["rotation"] }
        if(map.keys.contains("scale")) { this.scale = map["scale"] }
        if(map.keys.contains("opacity")) { this.opacity = map["opacity"] }
        if(map.keys.contains("parent")) { this.parent = map["parent"] }
        if(map.keys.contains("name")) { this.name = map["name"] }
        if(map.keys.contains("visible")) { this.visible = map["visible"] }
        if(map.keys.contains("width")) { this.width = map["width"] }
        if(map.keys.contains("height")) { this.height = map["height"] }
        if(map.keys.contains("clip")) { this.clip = map["clip"] }
        if(map.keys.contains("dragEnabled")) { this.dragEnabled = map["dragEnabled"] }
        if(map.keys.contains("hoverEnabled")) { this.hoverEnabled = map["hoverEnabled"] }
        if(map.keys.contains("children")) {
            for(c in map["children"]) {
                this.addNode(c)
            }
        }
        if(map.keys.contains("anchors")) {
            this.anchors = map["anchors"]
        }
    }

    childrenByType(type) {
        var ret = []
        for(c in _children) {
            if(c is type) { ret.add(c) }
        }
        return ret 
    }

    // signals 
    parentChanged{_parentChanged}
    rotationChanged{_rotationChanged}
    scaleChanged{_scaleChanged}
    opacityChanged{_opacityChanged}
    childrenChanged{_childrenChanged}
    childAdded{_childAdded}
    childRemoved{_childRemoved}
    nameChanged{_nameChanged}
    visibleChanged{_visibleChanged}
    widthChanged{_widthChanged}
    heightChanged{_heightChanged}
    xChanged{_xChanged}
    yChanged{_yChanged}
    zChanged{_zChanged}
    clipChanged{_clipChanged}
    debugChanged{_debugChanged}
    dragEnabledChanged{_dragEnabledChanged}
    hoverEnabledChanged{_hoverEnabledChanged}
    geometryChanged{_geometryChanged}
    focusChanged{_focusChanged}
    hoverEntered{_hoverEntered}
    hoverExited{_hoverExited}

    // inernal signals 
    refreshGeometry{_refreshGeometry}
}

class SgItem is SgNode2D {
    construct new() { super() }
    construct new(dynamic) { 
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
    }
    construct new(parent, map) {
        super(parent)
        parse(map)
    }
    // construct newMap(map) { super(map) }
    // construct newMap(parent, map) { super(parent, map) }
}

class SceneGraph2D {
    static root{ __root }
    static init() { 
        __root = SgNode2D.new() 
        __root.width = 1920
        __root.height = 1080
        __root.name = "SceneRoot"
        __font = Font.new()
        __draggingNode = null 
        __focusNode = __root 
        __mouseHoverNode = null 
        __mousePressNode = null 
        __keyPressNode = null 
        __mousePos = Vector2.new()
        __mouseDelta = Vector2.new()
        __mouseWorldPos = Vector2.new()
        __mousePress = -1
        __mouseRelease = -1
        __mouseWheelMove = Vector2.new()
        __keyPress = 0
        __keysPress = []
        __keyRelease = 0
        __camera = Camera2D.new() 
        __camera.zoom = 1
        __camera.target = Vector2.new(0, 0)
        __camera.offset = Vector2.new(0, 0)
        __debugColor = Color.new(255, 0, 0, 11)
        __debugNode = false  
        __event = SgEvent.new(SgEvent.None, {})
        __graphEventTime = Raylib.GetTime()
        __graphRenderTime = Raylib.GetTime()
        __graphEventDelay = 0
        __graphEventDelayChanged = Signal.new(this)
        __graphRenderDelay = 0 
        __graphRenderDelayChanged = Signal.new(this)

        // for w2sbounds reuse value 
        __tl = Vector2.new()
        __br = Vector2.new()
        __stl = Vector2.new()
        __sbr = Vector2.new()
        __w2srect = Rectangle.new()

        // moving value 
        __v2move = Vector2.new()
        Raylib.LoadFont(__font, "fonts/default.ttf")

        // signal 
        __focusNodeChanged = Signal.new(null)
        __hoverNodeChanged = Signal.new(null)

        __eventLoop = Fiber.new{
            while(true) {
                Raylib.GetMousePosition(__mousePos)
                Raylib.GetMouseDelta(__mouseDelta)
                Raylib.GetMouseWheelMoveV(__mouseWheelMove)
                Raylib.GetScreenToWorld2D(__mouseWorldPos, __mousePos, __camera)
                __mouseDelta.x = __mouseDelta.x * 1.0 / __camera.zoom 
                __mouseDelta.y = __mouseDelta.y * 1.0 / __camera.zoom 
                __mousePress = -1
                __mouseRelease = -1
                if(Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_LEFT)) { __mousePress = Raylib.MOUSE_BUTTON_LEFT }
                if(Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_RIGHT)) { __mousePress = Raylib.MOUSE_BUTTON_RIGHT }
                if(Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_MIDDLE)) { __mousePress = Raylib.MOUSE_BUTTON_MIDDLE }
                if(Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_SIDE)) { __mousePress = Raylib.MOUSE_BUTTON_SIDE }
                if(Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_EXTRA)) { __mousePress = Raylib.MOUSE_BUTTON_EXTRA }
                if(Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_BACK)) { __mousePress = Raylib.MOUSE_BUTTON_BACK }

                if(Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_LEFT)) { __mouseRelease = Raylib.MOUSE_BUTTON_LEFT }
                if(Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_RIGHT)) { __mouseRelease = Raylib.MOUSE_BUTTON_RIGHT }
                if(Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_MIDDLE)) { __mouseRelease = Raylib.MOUSE_BUTTON_MIDDLE }
                if(Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_SIDE)) { __mouseRelease = Raylib.MOUSE_BUTTON_SIDE }
                if(Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_EXTRA)) { __mouseRelease = Raylib.MOUSE_BUTTON_EXTRA }
                if(Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_BACK)) { __mouseRelease = Raylib.MOUSE_BUTTON_BACK }

                __keyRelease = 0
                __keyPress = Raylib.GetKeyPressed()
                if(__keyPress > 0) { __keysPress.add(__keyPress) }

                for(key in __keysPress) {
                    if(Raylib.IsKeyReleased(key)) { __keyRelease = key }
                }
                if(__keyRelease > 0) { __keysPress.remove(__keyRelease) }
                

                if(__root) { 
                    processEvent_(__root, __mouseWorldPos) 
                }
                Fiber.yield()
            }
        }

        __renderLoop = Fiber.new{
            while(true) {
                Raylib.BeginMode2D(__camera)
                if(__root) { renderNode_(__root) }
                Raylib.EndMode2D()
                Fiber.yield()
            }
        }

    }

    static mousePos{__mousePos}
    static mouseDelta{__mouseDelta}
    static mouseWheelMove{__mouseWheelMove}
    static mouseWorldPos{__mouseWorldPos}

    // render scene 
    static render() {
        var pstart = Raylib.GetTime()
        // process event for scenegraph 
        {
            __eventLoop.call()
        }
        var pend = Raylib.GetTime() 
        __graphEventDelay = ((pend - pstart) * 1000000).floor / 1000 
        __graphEventDelayChanged.emit(__graphEventDelay) 
        pstart = pend 
        
        // render node 
        {
            __renderLoop.call()
        }
        pend = Raylib.GetTime()
        __graphRenderDelay = ((pend - pstart) * 1000000).floor / 1000 
        __graphRenderDelayChanged.emit(__graphRenderDelay)
    }

    // process event for scenegraph 
    static processEvent_(node, mouseWorldPos) {
        var ret = 0

        if(node.visible) {
            var shouldIterateSubNode = true 
            if(node.clip) {
                var inBounds = Raylib.CheckCollisionPointRec(mouseWorldPos, node.finalBounds)
                if(!inBounds) {shouldIterateSubNode = false }
            }
            if(shouldIterateSubNode) {
                for(i in (node.children.count - 1)...-1) {
                    var child = node.children[i]
                    if(node.skipRenderChild) {
                        ret = processEvent_(child, node.mouseWorldPos) 
                    } else {
                        ret = processEvent_(child, mouseWorldPos) 
                    }
                    if(ret > 0) {
                        break
                    }
                }
            }
            if(ret == 0) { 
                ret = checkNodeMouseEvent_(node, mouseWorldPos) 
                if(ret > 0) { __focusNode == node }
            }
            checkNodeKeyEvent_(node)
        }
        return ret 
    }

    static checkNodeKeyEvent_(node) {
        var ret = 0
        if(__focusNode == node) {
            // key 
            if(__keyPress > 0) { ret = __focusNode.onEvent(SceneGraph2D.packEvent(SgEvent.KeyPress, {"key": __keyPress, "repeat": Raylib.IsKeyPressedRepeat(__keyPress)})) }
            if(__keyRelease > 0) { ret = __focusNode.onEvent(SceneGraph2D.packEvent(SgEvent.KeyRelease, {"key": __keyRelease})) }
        } 
        return ret
    }

    // check if is node accepted event 
    static checkNodeMouseEvent_(node, mouseWorldPos) {
        var ret = 0
        var bounds = node.finalBounds
        if(node.absoluteCoordinate && node.parent) {
            bounds.x = bounds.x + node.parent.finalBounds.x 
            bounds.y = bounds.y + node.parent.finalBounds.y 
        }

        var inBounds = Raylib.CheckCollisionPointRec(mouseWorldPos, bounds)
        
        // check hover
        if(inBounds) {
            if(node.hoverEnabled) {
                if(__mouseHoverNode != node) {
                    if(__mouseHoverNode) { 
                        __mouseHoverNode.onEvent(SceneGraph2D.packEvent(SgEvent.HoverExit, {}))
                    }
                    ret = node.onEvent(SceneGraph2D.packEvent(SgEvent.HoverEnter, {}))
                    if(ret > 0) { 
                        __mouseHoverNode = node 
                        __hoverNodeChanged.emit(node)
                    }
                } else {
                    if(__mouseDelta.x != 0 || __mouseDelta.y != 0) { 
                        __v2move.x = mouseWorldPos.x - bounds.x
                        __v2move.y = mouseWorldPos.y - bounds.y
                        ret = node.onEvent(SceneGraph2D.packEvent(SgEvent.MouseMove, {"position": __v2move, "delta": __mouseDelta}))
                    } else {
                        ret = 1
                    }
                    if(__mouseWheelMove.x != 0 || __mouseWheelMove.y != 0) {
                        ret = node.onEvent(SceneGraph2D.packEvent(SgEvent.MouseWheel, {"delta": __mouseWheelMove}))
                    }
                }
            } else {
                if(__mousePressNode == node) {
                    if(__mouseDelta.x != 0 || __mouseDelta.y != 0) { 
                        __v2move.x = mouseWorldPos.x - bounds.x
                        __v2move.y = mouseWorldPos.y - bounds.y
                        ret = node.onEvent(SceneGraph2D.packEvent(SgEvent.MouseMove, {"position": __v2move, "delta": __mouseDelta}))
                    } else {
                        ret = 1
                    }
                }
            }
        } else {
            if(__mouseHoverNode == node && node.hoverEnabled) { 
                ret = node.onEvent(SceneGraph2D.packEvent(SgEvent.HoverExit, {})) 
                __mouseHoverNode = null 
                __hoverNodeChanged.emit(null)
            }else if(__mousePressNode == node) {
                if(__mouseDelta.x != 0 || __mouseDelta.y != 0) { 
                    __v2move.x = mouseWorldPos.x - bounds.x
                    __v2move.y = mouseWorldPos.y - bounds.y
                    ret = node.onEvent(SceneGraph2D.packEvent(SgEvent.MouseMove, {"position": __v2move, "delta": __mouseDelta}))
                } else {
                    ret = 1
                }
            }
        }

        // mouse button press 
        if(__mousePress >= 0 && inBounds) {
            __v2move.x = mouseWorldPos.x - bounds.x
            __v2move.y = mouseWorldPos.y - bounds.y
            ret = node.onEvent(SceneGraph2D.packEvent(SgEvent.MousePressed, { "key": __mousePress, "position": __v2move }))
            __mousePressNode = node 
            if(__mousePress == Raylib.MOUSE_BUTTON_LEFT && node.dragEnabled) { 
                __draggingNode = node 
                ret = node.onEvent(SceneGraph2D.packEvent(SgEvent.DragStart, {}))
            }
        } 

        // mouse button release 
        if(__mouseRelease >= 0 && __mousePressNode == node) {
            ret = node.onEvent(SceneGraph2D.packEvent(SgEvent.MouseRelease, { "key": __mouseRelease }))
            __mousePressNode = null 
            if(__mouseRelease == Raylib.MOUSE_BUTTON_LEFT && __draggingNode) { 
                ret = __draggingNode.onEvent(SceneGraph2D.packEvent(SgEvent.DragEnd, {}))
                __draggingNode = null 
            }
        }

        // dragging 
        if(__draggingNode == node) { 
            node.x = node.x + __mouseDelta.x
            node.y = node.y + __mouseDelta.y
        }

        return ret 
    }

    static font{__font}
    static draggingNode{__draggingNode}
    static focusNode{__focusNode}
    static focusOn(node){
        if(__focusNode != node) {
            if(__focusNode) { __focusNode.focusChanged.emit(false)}
            __focusNode = node
            if(__focusNode) { __focusNode.focusChanged.emit(true)}
            __focusNodeChanged.emit(node)
        }
    }
    static debugNode=(val) {
        __debugNode = val 
        // SceneGraph2D.updateDebugNode(__root)
    }
    static debugNode{__debugNode}
    static updateDebugNode(node) {
        // for(child in node.children) { updateDebugNode(node) }
        // node.debug = __debugNode
    }
    static debugColor{__debugColor}
    static debugColor=(val){__debugColor = val}
    static renderDelay{__graphRenderDelay}
    static eventDelay{__graphEventDelay}
    static graphRenderDelayChanged{__graphRenderDelayChanged}
    static graphEventDelayChanged{__graphEventDelayChanged}

    // render node recursive 
    static renderNode_(node) {
        if(node.visible) {
            node.onRender()
            if(__debugNode) { Raylib.DrawRectangleLinesEx(node.finalBounds, 1, SceneGraph2D.debugColor) }
            if(!node.skipRenderChild) {
                var bounds = SceneGraph2D.w2sbounds(node.finalBounds) 
                if(node.clip) { Raylib.BeginScissorMode(bounds.x, bounds.y, bounds.width, bounds.height) }
                for(c in node.children) { renderNode_(c) }
            if(node.clip) { Raylib.EndScissorMode() }
            }
        }
    }

    // conver world bounds to screen bounds, for clipping 
    static w2sbounds(bounds) {
        __tl.x = bounds.x 
        __tl.y = bounds.y 
        __br.x = bounds.x + bounds.width 
        __br.y = bounds.y + bounds.height 
        Raylib.GetWorldToScreen2D(__stl, __tl, __camera)
        Raylib.GetWorldToScreen2D(__sbr, __br, __camera)
        __w2srect.x = __stl.x 
        __w2srect.y = __stl.y 
        __w2srect.width = __sbr.x - __stl.x
        __w2srect.height = __sbr.y - __stl.y
        return __w2srect
    }

    // pack event 
    static packEvent(type, data) {
        __event.type = type 
        __event.data = data 
        return __event
    }

    // gen node id
    static genId() {
        if(__idcounter == null) { __idcounter = 0 }
        var ret = __idcounter
        __idcounter = __idcounter + 1
        return ret 
    }

    // signals
    static focusNodeChanged{__focusNodeChanged}
    static hoverNodeChanged{__hoverNodeChanged}
}