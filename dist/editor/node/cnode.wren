import "cico.raylib" for Vector2, Vector3, Vector4,Raylib,Rectangle,Camera2D,Color,Font 
class Control {
    construct new() {
        _pan = Vector2.new(0, 0)
        _offset = Vector2.new(0, 0)
        _zoom = 2
    }
    pan {_pan}
    pan = (val) {_pan = val}
    zoom {_zoom}
    zoom = (val) {_zoom = val}
    offset{_offset}
    offset=(val) {_offset = val}
}

class NodeButton {

}

class NodeSocket {
    construct new(id_, nodeId_, name_, type_, display_, direction_, color_, defaultValue_, steps) {
        _id = id_
        _nodeId = nodeId_
        _name = name_
        _type = type_
        _color = color_
        _defaultValue = defaultValue_
        _display = display_
        _toolTips = ""
        _direction = direction_
        _defaultValueChanged = null 
        _node = null
        _steps = steps 
        _bindedPins = []
    }
    construct new(id_, nodeId_, name_, type_, display_, direction_, color_, defaultValue_) {
        _id = id_
        _nodeId = nodeId_
        _name = name_
        _type = type_
        _color = color_
        _defaultValue = defaultValue_
        _display = display_
        _toolTips = ""
        _direction = direction_
        _defaultValueChanged = null 
        _node = null
        _steps = 1 
        _bindedPins = []
    }
    static DirInput {-1}
    static DirNone {0}
    static DirOutput {1}
    id{_id}
    id=(val){_id=val}
    name{_name}
    name=(val){_name=val}
    nodeId{_nodeId}
    nodeId=(val){_nodeId=val}
    type{_type}
    type=(val){_type=(val)}
    color{_color}
    color=(val){_color=val}
    defaultValue{_defaultValue}
    defaultValue=(val){
        _defaultValue = val
        for(pin in _bindedPins) { 
            if(pin) { pin.defaultValue = val }
        }    
        if(direction == NodeSocket.DirInput || direction == NodeSocket.DirNone) { 
            if(_node && _node.logicFn) { _node.logicFn.call(_node) } 
        }
    }
    min{_min}
    min=(val){_min=val}
    max{_max}
    max=(val){_max=val}
    precision{_precision}
    precision=(val){_precision=val}
    display{_display}
    display=(val){_display=val}
    toolTips{_toolTips}
    toolTips=(val){_toolTips=val}
    direction{_direction}
    direction=(val){_direction=val}
    defaultValueChanged{_defaultValueChanged}
    defaultValueChanged=(val){_defaultValueChanged = val}
    node{_node}
    node=(val){_node = val}
    steps{_steps}
    steps=(val){_steps = val}
    bindedPins{_bindedPins}
    bindedPins=(val){_bindedPins = val}
    bind(pin) { 
        defaultValue = pin.defaultValue
        pin.bindedPins.add(this)
    }
    unbind(pin) { 
        if(pin.bindedPins.contains(this)) {
            pin.bindedPins.remove(this)
        }
    }
}

class NodePreview {
    construct new(size, data, renderFn) {
        _size = Vector2.new(size.x, size.y)
        _data = data 
        _renderFn = renderFn 
    }
    size{_size}
    size=(val){_size = val}
    data{_data}
    data=(val){_data = val}
    renderFn{_renderFn}
    renderFn=(val){_renderFn = val}
}

class Node {
    construct new(id_, name_, type_, pos_, toolTips_, color_, inputs_, outputs_, logicFn_) {
        _id = id_
        _name = name_
        _type = type_
        _pos = Vector2.new(pos_.x, pos_.y)
        _inputs = inputs_
        _outputs = outputs_
        _buttons = []
        _color = color_
        _toolTips = toolTips_
        _bounds = Rectangle.new(0, 0, 0, 0)
        _font = Font.new()
        Raylib.GetFontDefault(_font)
        _logicFn = logicFn_
        _controlSize = Vector2.new(60, 15)
        _preview = null 
        _previewBounds = Rectangle.new(0, 0, 0, 0)
        for(pin in _inputs) { pin.node = this }
        for(pin in _outputs) { pin.node = this }
        recaculatebounds_()
    }
    id{_id}
    id=(val){_id = val}
    name{_name}
    name=(val){_name = val}
    type{_type}
    type=(val){_type = val}
    pos{_pos}
    pos=(val){
        _pos = val
        _bounds.x = _pos.x 
        _bounds.y = _pos.y
    }
    toolTips{_toolTips}
    toolTips=(val){_toolTips = val}
    inputs{_inputs}
    inputs=(val){
        _inputs = val
        for(pin in _inputs) { pin.node = this }
        recaculatebounds_()
    }
    outputs{_outputs}
    outputs=(val) {
        _outputs = val
        for(pin in _outputs) { pin.node = this }
        recaculatebounds_()
    }
    buttons{_buttons}
    buttons=(val) {_buttons = val}
    color{_color}
    color=(val){_color = val}
    bounds{_bounds}
    bounds=(val){_bounds = val}
    font{_font}
    font=(val){
        _font=val
        recaculatebounds_()
    }
    controlSize{_controlSize}
    controlSize=(val){_controlSize = val}
    preview{_preview}
    preview=(val){
        _preview = val
        recaculatebounds_()
    }
    previewBounds{_previewBounds}
    logicFn{_logicFn}

    bindPins() {
        for(pin in _inputs) { pin.node = this }
        for(pin in _outputs) { pin.node = this }
    }

    getInput(id) {
        var ret = null
        for(pin in _inputs) {
            if(pin.id == id) {
                ret = pin 
                break
            }
        }
        return ret
    }
    getOutput(id) {
        var ret = null
        for(pin in _outputs) {
            if(pin.id == id) {
                ret = pin 
                break
            }
        }
        return ret
    }

    inputPinRect(index) {
        var offy = 35 + index * 20  + index * 10
        var rect = Rectangle.new()
        rect.x = _bounds.x + 10
        rect.y = _bounds.y + offy + 12
        rect.width = 10
        rect.height = 10
        return rect 
    }

    outputPinRect(index) {
        var offy = 35 + index * 20  + index * 10
        var rect = Rectangle.new()
        rect.x = _bounds.x + _bounds.width - 20
        rect.y = _bounds.y + offy + 12
        rect.width = 10
        rect.height = 10
        return rect 
    }

    recaculatebounds_() {
        var w = 300
        var h = 0
        var socketRows = _inputs.count.max(_outputs.count)
        h = h + socketRows * 20 + (socketRows - 1) * 10
        h = h + 20 // name
        h = h + 10 // name line spacing
        h = h + 10 // buttons line spacing
        h = h + 30 // buttons
        h = h + 20 // socket content base
        var maxInputWidth = 0
        var maxOutputWidth = 0
        var nameWidth = 0
        var hasEditControl = false 
        var textSize = Vector2.new()
        Raylib.MeasureTextEx(textSize, _font, _name, 10, 0)
        nameWidth = nameWidth.max(textSize.x)
        for(pin in _inputs) { 
            Raylib.MeasureTextEx(textSize, _font, pin.name, 10, 0)
            maxInputWidth = maxInputWidth.max(textSize.x) 
            if(pin.direction == NodeSocket.DirNone) { hasEditControl = true }
        }
        for(pin in _outputs) {
            Raylib.MeasureTextEx(textSize, _font, pin.name, 10, 0)
            maxInputWidth = maxInputWidth.max(textSize.x) 
        }
        w = (_controlSize.x + maxInputWidth + maxOutputWidth).max(nameWidth + 60)
        if(_preview) {
            w = w + _preview.size.x  + 20
            h = h.max(_preview.size.y + 90)
            _previewBounds.width = _preview.size.x 
            _previewBounds.height = _preview.size.y 
            _previewBounds.x = 40 + maxInputWidth
            _previewBounds.y = _bounds.height / 2 - _preview.size.y / 2
        }
        if(hasEditControl) { 
            w = w + _controlSize.x + 20
            _previewBounds.x = _previewBounds.x + _controlSize.x
        }
        _bounds.x = _pos.x
        _bounds.y = _pos.y
        _bounds.width = w 
        _bounds.height = h 
    }

    // deep copy a node and give it a new id 
    static copy(node, id) {
        var cp = Node.new(id, "", "", Vector2.new(0, 0), "", Color.new(0, 0, 0, 0), [], [], node.logicFn)
        cp.name = node.name 
        cp.type = node.type
        cp.color = node.color 
        cp.toolTips = node.toolTips
        for(sock in node.inputs) { cp.inputs.add(NodeSocket.new(sock.id, id, sock.name, sock.type, sock.display, sock.direction, sock.color, sock.defaultValue, sock.steps)) }
        for(sock in node.outputs) { cp.outputs.add(NodeSocket.new(sock.id, id, sock.name, sock.type, sock.display, sock.direction, sock.color, sock.defaultValue, sock.steps)) }
        cp.preview = node.preview
        cp.bindPins()
        cp.pos = Vector2.new(node.pos.x, node.pos.y)
        cp.controlSize = Vector2.new(node.controlSize.x, node.controlSize.y)
        cp.recaculatebounds_()
        return cp
    }
}

class NodeLink {
    construct new(id_, fromNode_, fromSocket_, toNode_, toSocket_) {
        _id = id_
        _fromNode = fromNode_
        _fromSocket = fromSocket_
        _toNode = toNode_
        _toSocket = toSocket_
    }
    id{_id}
    fromNode{_fromNode}
    fromSocket{_fromSocket}
    toNode{_toNode}
    toSocket{_toSocket}
}
