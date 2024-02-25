
import "cico.raylib" for Vector2, Vector3, Vector4,Raylib,Rectangle,Camera2D,Color,Font 
import "./cnodeui" for NodeUI, ControlResult, MenuContent
import "./cnode" for Control,Node,NodeSocket,NodeLink
import "./csysnode" for SysNode
class Style {
    construct new () {
        _backgroundColor = Color.new(30, 35, 39, 255)
        _nodeBorderColorNormal = Color.new(0, 0, 0, 40)
        _nodeBorderColorSelected = Color.new(200, 130, 33, 255)
        _textColor = Color.new(166, 166, 166, 255)
        _linkColor = Color.new(255, 255, 255, 255)
        _lineColor = Color.new(255, 255, 255, 40)
        _roundRectMode = true 
    }
    backgroundColor{_backgroundColor}
    textColor{_textColor}
    linkColor{_linkColor}
    lineColor{_lineColor}
    nodeBorderColorNormal{_nodeBorderColorNormal}
    nodeBorderColorSelected{_nodeBorderColorSelected}
    roundRectMode{_roundRectMode}
}

class NodeRegistCtx {
    construct new(name_, type_, createFn_) {
        _name = name_
        _type = type_ 
        _createFn = createFn_
    }
    name{_name}
    type{_type}
    createFn{_createFn}
}

class NodeManager {
    construct new() {
        _name = "" 
        _nodes = []
        _links = []
        _control = Control.new()
        _style = Style.new()
        _camera = Camera2D.new()
        _mouseDelta = Vector2.new()
        _mousePos = Vector2.new()
        _mouseWorldPos = Vector2.new()
        _ui = NodeUI.new() 
        _linkIdCounter = 0
        _nodeIdCounter = 0
        _processDelay = 0
        _renderDelay = 0
        _nodeRegisteredMap = {}
        _nodeCategories = []
        _selectedNodes = []
        _copiedNodes = []
        _uiBlocking = false 
        _font = null
        _hoveredNode = null
        _dragNode = null
        _hoveredSocket = null 
        _linkStartSocket = null
        _menuContex = null 
        _selectRect = null 
        _selectStartPos = Vector2.new()
        for(r in SysNode.InternalNodeFactories) { registerNode(r["name"], r["type"], r["category"], r["fn"]) }
    }

    name {_name}
    name = (val) {_name = val}
    nodes {_nodes}
    nodes = (val) {_nodes = val}
    links {_links}
    links = (val) {_links = val}
    control {_control}
    control = (val) {_control = val}
    style{_style}
    style = (val) {_style = val}
    font{_font}
    font=(val) {
        _font = val
        _ui.font = val 
    }
    // profile
    processDelay{_processDelay}
    renderDelay{_renderDelay}

    // register node for factory
    registerNode(name, type, category, craeteFn) {
        var ctx = NodeRegistCtx.new(name, type, craeteFn)
        if(!_nodeRegisteredMap.containsKey(category)) { _nodeRegisteredMap[category] = {"names":[], "regists": []} }
        _nodeRegisteredMap[category]["names"].add(name)
        _nodeRegisteredMap[category]["regists"].add(ctx)
        if(!_nodeCategories.contains(category)) { _nodeCategories.add(category) }
    }

    // add a node object
    addNode(node) {
        node.font = _font 
        if(!_nodes.contains(node)) { _nodes.add(node) }
    }

    // remove a node, and unlink removed nodes'sockets 
    removeNode(node) {
        System.print("[cnode] removing node: %(node.id)")
        if(_nodes.contains(node)) {
            var delList = []
            for(link in _links) {
                System.print("[cnode] check remove link: %(link.fromNode) %(link.toNode)")
                if(link.fromNode == node.id || link.toNode == node.id) { delList.add(link)}
            }
            for(d in delList) { 
                unbindPin(d.fromNode, d.fromSocket)
                removeLink(d) 
            }
            _nodes.remove(node)
        }
    }

    // link socket with fromNode, fromSocket, toNode, toSocket (id)
    link(fromNode, fromSocket, toNode, toSocket) {
        var hasLink = false
        var delList = []
        for(link in _links) {
            if(link.toNode == toNode && link.toSocket == toSocket) { delList.add(link) }
        }
        for(d in delList) {
            unbindPin(d.fromNode, d.fromSocket) 
            removeLink(d) 
        }
        var l = NodeLink.new(_linkIdCounter, fromNode, fromSocket, toNode, toSocket)
        _linkIdCounter = _linkIdCounter + 1
        _links.add(l)
        var output = getNodeById(fromNode).getOutput(fromSocket)
        var input = getNodeById(toNode).getInput(toSocket)
        input.bind(output)
    }

    // check for unlink socket
    checkUnlink(socket) {
        var delList = []
        for(link in _links) {
            if(link.toNode == socket.nodeId) {
                if(socket.direction == NodeSocket.DirInput && link.toSocket == socket.id) {
                    delList.add(link)
                } else if(socket.direction == NodeSocket.DirOutput && link.fromSocket == socket.id) {
                    delList.add(link)
                }
            } 
        }
        for(d in delList) { 
            unbindPin(d.fromNode, d.fromSocket)
            removeLink(d) 
        }
    }

    removeLink(d) {
        _links.remove(d)
    }

    unbindPin(fromNode, fromSocket) {
        var node = getNodeById(fromNode)
        var pin = node.getInput(fromSocket)
        if(pin) { pin.defaultValueChanged = null }
    }

    getNodeById(id) {
        var node = null 
        for(n in _nodes) {
            if(n.id == id) { 
                node = n
                break
            }
        }
        return node 
    }

    // link sockets between a b
    link(socketA, socketB) {
        var fromNode = null 
        var toNode = null 
        var fromSocket = null 
        var toSocket = null 
        if(socketA.direction == NodeSocket.DirOutput) {
            fromNode = socketA.nodeId
            fromSocket = socketA.id
            toNode = socketB.nodeId
            toSocket = socketB.id
        } else {
            fromNode = socketB.nodeId
            fromSocket = socketB.id
            toNode = socketA.nodeId
            toSocket = socketA.id
        }
        link(fromNode, fromSocket, toNode, toSocket)
    }

    // render nodes, links, controls, node buttons
    render() {
        var pstart = Raylib.GetTime()
        _uiBlocking = false 
        Raylib.BeginMode2D(_camera)            
            // render select rect 
            if(_style.roundRectMode) {  
                if(_selectRect) { Raylib.DrawRectangleRounded(_selectRect, 0, 5, Color.new(0, 133, 199, 40)) }
            } else {
                if(_selectRect) { Raylib.DrawRectangleRec(_selectRect, Color.new(0, 133, 199, 40)) }
            }
            // render links
            for(link in _links) { renderLink(link) }
            // render nodes, node buttons, node controls
            for(node in _nodes) { renderNode(node) }
            // render popups 
            if(_menuContex) {
                var result = _ui.MenuPopup(_menuContex)
                if(result.code > 0) { // add node
                    System.print("[cnode] menu item triggered %(_menuContex.selectedIndex) %(_menuContex.selectedSubIndex)")
                    var ctx = _nodeRegisteredMap[_nodeRegisteredMap.keys.toList[_menuContex.selectedIndex]]["regists"][_menuContex.selectedSubIndex]
                    var node = ctx.createFn.call(_nodeIdCounter, _menuContex.pos)
                    addNode(node)
                    _nodeIdCounter = _nodeIdCounter + 1
                    _menuContex = null
                }
            }
        Raylib.EndMode2D()
        var pend = Raylib.GetTime()
        _renderDelay = ((pend - pstart) * 1000000).floor / 1000
    }

    renderNode(node) {
        // draw node panel
        var borderColor = _selectedNodes.contains(node) ? _style.nodeBorderColorSelected : _style.nodeBorderColorNormal
        if(_style.roundRectMode) {
            Raylib.DrawRectangleRounded(node.bounds, 0.125, 5, node.color)
            Raylib.DrawRectangleRoundedLines(Rectangle.new(node.bounds.x + 1, node.bounds.y + 1, node.bounds.width - 2, node.bounds.height - 2), 0.125, 5, 2, borderColor) 
        } else {
            Raylib.DrawRectangleRec(node.bounds, node.color)
            Raylib.DrawRectangleLinesEx(Rectangle.new(node.bounds.x + 1, node.bounds.y + 1, node.bounds.width - 2, node.bounds.height - 2), 2, borderColor)
        }
        // draw lines
        Raylib.DrawLine(node.bounds.x + 4, node.bounds.y + 25, node.bounds.x + node.bounds.width - 4, node.bounds.y + 25, _style.lineColor)
        Raylib.DrawLine(node.bounds.x + 4, node.bounds.y + node.bounds.height - 35, node.bounds.x + node.bounds.width - 4, node.bounds.y + node.bounds.height - 35, _style.lineColor)
        // draw title
        Raylib.DrawTextEx(_font, node.name, Vector2.new(node.bounds.x + 12, node.bounds.y + 5), 12, 0, _style.textColor)

        // render preview 
        if(node.preview) {
            if(node.preview.renderFn) {
                var bounds = Rectangle.new(node.bounds.x + node.previewBounds.x, node.bounds.y + node.previewBounds.y, node.previewBounds.width, node.previewBounds.height)
                var code = node.preview.renderFn.call(node, _ui, bounds)
                if(code > 0) { _uiBlocking = true }
            }
        }

        // node sockets
        renderNodeSocket(node)
        // draw tmp links 
        if(_linkStartSocket) {
            for(node in _nodes) {
                if(node.id == _linkStartSocket.nodeId) {
                    if(_linkStartSocket.direction == NodeSocket.DirInput) {
                        var ci = 0
                        for(i in 0...node.inputs.count) {
                            if(node.inputs[i] == _linkStartSocket) {
                                ci = i 
                                break
                            }
                        }
                        var lrect = node.inputPinRect(ci)
                        var p = Vector2.new(lrect.x + 5, lrect.y + 5)
                        drawLinkLine(_mouseWorldPos, p, Color.new(255, 200, 160, 60))
                    } else if(_linkStartSocket.direction == NodeSocket.DirOutput) {
                        var ci = 0
                        for(i in 0...node.outputs.count) {
                            if(node.outputs[i] == _linkStartSocket) {
                                ci = i 
                                break
                            }
                        }
                        var lrect = node.outputPinRect(ci)
                        var p = Vector2.new(lrect.x + 5, lrect.y + 5)
                        drawLinkLine(p, _mouseWorldPos, Color.new(255, 200, 160, 60))
                    }
                }
            }
        }
    }

    renderNodeSocket(node) {
        // draw inputs
        var i = 0
        for(pin in node.inputs) {
            var rect = node.inputPinRect(i)
            var pc = pin.color 
            var textSize = Vector2.new()
            Raylib.MeasureTextEx(textSize, _font, pin.name, 10, 0)
            if(_hoveredSocket == pin) { pc = Color.new(255, 200, 150, 255) }
            if(_style.roundRectMode) {
                if(pin.direction != NodeSocket.DirNone) { Raylib.DrawRectangleRounded(rect, 1, 5, pc) }
            } else {
                if(pin.direction != NodeSocket.DirNone) { Raylib.DrawRectangleRec(rect, pc) }
            }
            if(pin.direction == NodeSocket.DirNone) {
                var bounds = Rectangle.new(node.bounds.x + 50 + textSize.x, rect.y + 3 - 3 , node.controlSize.x, node.controlSize.y)
                var result = _ui.ValueBox(bounds, pin.name, pin.defaultValue, Num.smallest, Num.largest, pin.steps)
                if(result.code > 0) { _uiBlocking = true } 
                if(result.code == 2 || result.code == 3) { 
                    pin.defaultValue = result.values[0]
                }
            }
            Raylib.DrawTextEx(_font, pin.name, Vector2.new(rect.x + 20, rect.y + 1), 10, 0, _style.textColor)
            i = i + 1
        }

        // draw outputs
        i = 0
        for(pin in node.outputs) {
            var rect = node.outputPinRect(i)
            var pc = pin.color 
            if(_hoveredSocket == pin) { pc = Color.new(255, 200, 150, 255) }
            var textRect = Vector2.new()
            Raylib.MeasureTextEx(textRect, _font, pin.name, 10, 0)
            if(_style.roundRectMode) {
                if(pin.direction != NodeSocket.DirNone) { Raylib.DrawRectangleRounded(rect, 1, 5, pc) }
            } else {
                if(pin.direction != NodeSocket.DirNone) { Raylib.DrawRectangleRec(rect, pc) }
            }
            
            Raylib.DrawTextEx(_font, pin.name, Vector2.new(rect.x - 5 - textRect.x, rect.y + 1), 10, 0, _style.textColor)
            i = i + 1
        }
    }

    // render link 
    renderLink(link) {
        var fromNode = null
        var toNode = null
        var color = _style.linkColor 
        for(node in _nodes) {
            if(node.id == link.fromNode) { fromNode = node }
            if(node.id == link.toNode) { toNode = node }
        }
        var fromRect = null
        var toRect = null
        for(i in 0...fromNode.outputs.count) {
            if(fromNode.outputs[i].id == link.fromSocket) { 
                fromRect = fromNode.outputPinRect(i)
                color = fromNode.outputs[i].color 
            }
        }
        for(i in 0...toNode.inputs.count) {
            if(toNode.inputs[i].id == link.toSocket) {
                toRect = toNode.inputPinRect(i)
            }
        }
        if(fromRect && toRect) {
            drawLinkLine(Vector2.new(fromRect.x + 5, fromRect.y + 5), Vector2.new(toRect.x + 5, toRect.y + 5), color)
        }
    }
    // draw link between 2 sockets 
    drawLinkLine(from, to, color) {
        var p1 = from 
        var p4 = to
        var c2 = Vector2.new(p1.x + 80, p1.y)
        var c3 = Vector2.new(p4.x - 80, p4.y)
        Raylib.DrawSplineSegmentBezierCubic(p1, c2, c3, p4, 2, color)
    }

    // process inputs for interaction 
    processControl() {
        var pstart = Raylib.GetTime()
        Raylib.GetMousePosition(_mousePos)
        Raylib.GetScreenToWorld2D(_mouseWorldPos, _mousePos, _camera)
        _ui.processInputs(_mousePos, _mouseWorldPos, _camera)

        // mouse button right 
        {
            if(Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_RIGHT)) {
                _draging = false 
                if(!_hoveredNode && !_draging && _dragStartPos.x == _mousePos.x && _dragStartPos.y == _mousePos.y) {
                    var names = []
                    for(key in _nodeRegisteredMap.keys) { names.add(_nodeRegisteredMap[key]["names"]) }
                    _menuContex = MenuContent.new(Vector2.new(_mouseWorldPos.x, _mouseWorldPos.y), _nodeRegisteredMap.keys.toList, names)
                }
            }

            if(Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_RIGHT)) {
                if(!_hoveredNode) {
                    _draging = true
                    _dragStartPos = Vector2.new(_mousePos.x, _mousePos.y)
                }
            }

            // panning
            if(Raylib.IsMouseButtonDown(Raylib.MOUSE_BUTTON_RIGHT) && _draging) {
                Raylib.GetMouseDelta(_mouseDelta)
                _menuContex = null 
                _mouseDelta.x = _mouseDelta.x * -1.0 / _control.zoom
                _mouseDelta.y = _mouseDelta.y * -1.0 / _control.zoom
                _control.pan.x = _control.pan.x + _mouseDelta.x
                _control.pan.y = _control.pan.y + _mouseDelta.y
            }
        }

        // wheeling 
        {
            // zooming
            var wheel = Raylib.GetMouseWheelMove()
            if(wheel != 0) {
                _control.pan.x = _mouseWorldPos.x 
                _control.pan.y = _mouseWorldPos.y 
                _control.offset.x = _mousePos.x 
                _control.offset.y = _mousePos.y 

                var zoomIncrement = 0.125
                _control.zoom = _control.zoom + (wheel * zoomIncrement)
                if(_control.zoom < zoomIncrement) {
                    _control.zoom = zoomIncrement
                }
                if(_control.zoom < 0.3) { _control.zoom = 0.3 }
                if(_control.zoom > 3 ) {_control.zoom = 3}
            }
        }

        // canvas view port
        {
            _camera.target = _control.pan 
            _camera.offset = _control.offset
            var diff = _control.zoom - _camera.zoom 
            if(diff != 0) {
                var step = diff / 12
                _camera.zoom  = _camera.zoom  + step
            }
        }

        // check node hover
        var hn = null 
        var hs = null 
        for(node in _nodes) { 
            if(Raylib.CheckCollisionPointRec(_mouseWorldPos, node.bounds)) { hn = node } 
            for(i in 0...node.inputs.count) {
                var rect = node.inputPinRect(i)
                if(Raylib.CheckCollisionPointRec(_mouseWorldPos, rect)) { hs = node.inputs[i] } 
            }
            for(i in 0...node.outputs.count) {
                var rect = node.outputPinRect(i)
                if(Raylib.CheckCollisionPointRec(_mouseWorldPos, rect)) { hs = node.outputs[i] } 
            }
        }
        _hoveredNode = hn 
        _hoveredSocket = hs
        
        // mouse button left 
        {
            // dragging 
            if(Raylib.IsMouseButtonDown(Raylib.MOUSE_BUTTON_LEFT)) {
                if(_selectedNodes.count > 0 && _hoveredSocket == null && _linkStartSocket == null) {
                    Raylib.GetMouseDelta(_mouseDelta)
                    // skip on menucontext
                    if(_menuContex && !Raylib.CheckCollisionPointRec(_mouseWorldPos, _menuContex.bounds)) { _menuContex = null  }
                    _mouseDelta.x = _mouseDelta.x * 1.0 / _control.zoom
                    _mouseDelta.y = _mouseDelta.y * 1.0 / _control.zoom
                    if(!_selectRect && !_uiBlocking) { // dragging nodes 
                        for(node in _selectedNodes) { node.pos = Vector2.Vector2Add(node.pos, _mouseDelta) }
                    }
                }
                if(_selectRect) {
                    var minX = _mouseWorldPos.x.min(_selectStartPos.x)
                    var maxX = _mouseWorldPos.x.max(_selectStartPos.x)
                    var minY = _mouseWorldPos.y.min(_selectStartPos.y)
                    var maxY = _mouseWorldPos.y.max(_selectStartPos.y)
                    _selectRect.x = minX 
                    _selectRect.y = minY
                    _selectRect.width = maxX - minX
                    _selectRect.height = maxY - minY
                }
            }

            // selecting
            if(Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_LEFT)) {
                if(!_uiBlocking) {
                    if(_menuContex && !Raylib.CheckCollisionPointRec(_mouseWorldPos, _menuContex.bounds)) {
                        _menuContex = null 
                    }
                    _dragNode = _hoveredNode 
                    _linkStartSocket = _hoveredSocket
                    if(!_dragNode) { _selectedNodes = [] }
                    if(_dragNode) { 
                        if(!_selectedNodes.contains(_dragNode)) {
                            if(!Raylib.IsKeyDown(Raylib.KEY_LEFT_CONTROL)) { _selectedNodes = [] }
                            _selectedNodes.add(_dragNode)
                        }
                    } else { // selecting
                        _selectStartPos = Vector2.new(_mouseWorldPos.x, _mouseWorldPos.y)
                        _selectRect = Rectangle.new(_mouseWorldPos.x, _mouseWorldPos.y, 0, 0)
                    }
                } 
            }

            if(Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_LEFT)) { 
                _dragNode = null 
                // link check
                if(_hoveredSocket && _linkStartSocket) {
                    var src = _linkStartSocket
                    var dst = _hoveredSocket
                    if(src.nodeId == dst.nodeId || src.direction == 0 || dst.direction == 0 || src.direction == dst.direction || src.type != dst.type) {
                        System.print("[cnode] Link check invalid: [%(src.nodeId),%(src.id),%(src.direction),%(src.type)] [%(dst.nodeId),%(dst.id),%(dst.direction),%(dst.type)], skiping linking socket.")
                    } else {
                        System.print("[cnode]Start linking [%(src.nodeId),%(src.id),%(src.direction),%(src.type)] [%(dst.nodeId),%(dst.id),%(dst.direction),%(dst.type)].")
                        link(src, dst)
                    }
                }

                // break link
                if(_linkStartSocket && !_hoveredSocket) { checkUnlink(_linkStartSocket) }

                _linkStartSocket = null 
                _selectRect = null 
            }
        }

        // check selections 
        if(_selectRect) {
            for(node in _nodes) {
                if(isRectInside(_selectRect, node.bounds) && !_selectedNodes.contains(node)) {  _selectedNodes.add(node) }
            }
        }
        
        var pend = Raylib.GetTime()
        _processDelay = ((pend - pstart) * 1000000).floor / 1000

        if(!_uiBlocking) {
            var keyPress = Raylib.GetKeyPressed()
            if(keyPress == Raylib.KEY_DELETE) {
                for(node in _selectedNodes) { removeNode(node) }
                _selectedNodes = []
            }
            if(keyPress == Raylib.KEY_C) {
                if(Raylib.IsKeyDown(Raylib.KEY_LEFT_CONTROL)) {
                    System.print("[cnode] %(_selectedNodes.count) nodes copied.")
                    _copiedNodes = []
                    for(node in _selectedNodes) { _copiedNodes.add(node) }
                }
            } else if(keyPress == Raylib.KEY_V) {
                if(Raylib.IsKeyDown(Raylib.KEY_LEFT_CONTROL)) {
                    System.print("[cnode] %(_copiedNodes.count) nodes paste.")
                    pasteNodes()
                }
            }
        }
    }

    pasteNodes() {
        var minX = Num.largest
        var minY = Num.largest
        var maxX = Num.smallest
        var maxY = Num.smallest
        for(node in _copiedNodes) {
            minX = minX.min(node.pos.x)
            minY = minY.min(node.pos.y)
            maxX = maxX.max(node.bounds.x + node.bounds.width)
            maxY = maxY.max(node.bounds.y + node.bounds.height)
        }
        var cx = (minX + maxX) / 2
        var cy = (minY + maxY) / 2

        for(node in _copiedNodes) {
            var cp = Node.copy(node, _nodeIdCounter)
            cp.pos = Vector2.new(_mouseWorldPos.x + node.pos.x - cx, _mouseWorldPos.y + node.pos.y - cy)
            _nodeIdCounter = _nodeIdCounter + 1
            addNode(cp)
        }
    }

    isRectInside(box, rect) { 
        return rect.x > box.x && rect.y > box.y && rect.x + rect.width < box.x + box.width && rect.y + rect.height < box.y + box.height 
    }
}