import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem, Anchors
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/sprite" for SgSprite
import "cico/engine/sg2d/layout" for SgRow,SgFlowLayout, SgColumn 
import "cico/engine/sg2d/control/scrollview" for SgScrollView
import "cico/engine/sg2d/control/button" for SgButton
import "cico/engine/sg2d/control/tabbar" for SgTabBar, SgTab
import "cico/engine/math" for Math
import "cico.raylib" for Raylib, Color,RenderTexture,Camera2D,Vector2,Vector3,Matrix,Texture,Rectangle,ValueList
import "cico/engine/sg2d/control/listview" for SgListView
import "cico/engine/sg2d/control/label" for SgLabel
import "cico/engine/signalslot" for Signal
import "cico/engine/timer" for Timer  

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

class Canvas is SgRectangle {
    construct new() {
        super()
        initCanvasProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) { super(dynamic) }
        initCanvasProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initCanvasProps_()
        parse(map)
    }
    initCanvasProps_() {
        _rtt = RenderTexture.new() 
        _rtex = Texture.new() 
        // reGenTexture()
        _camera = Camera2D.new()
        _camera.zoom = 0.3
        _control = Control.new()
        _mouseWorldPos = Vector2.new()
        _mouseDelta = Vector2.new()
        _mousePos = Vector2.new()
        _dstRect = Rectangle.new()
        _srcRect = Rectangle.new()
        _origin = Vector2.new()
        _tint = Color.fromString("#ffffff")
        _zoomChanged = Signal.new(this)
        _editor = null 
        this.skipRenderChild = true 
        this.name = "canvas"
        this.geometryChanged.connect{|e,v|
            _rttGenTimer.restart()
        }
        _rttGenTimer = Timer.new({
            "repeat": false,
            "interval": 0.1,
            "triggered": Fn.new{
                Raylib.UnloadRenderTexture(_rtt)
                reGenTexture()
            }
        })
        _rttGenTimer.start()
    }
    reGenTexture() {
        Raylib.LoadRenderTexture(_rtt, this.width, this.height)
        _rtt.getTexture(_rtex)
    }
    onRender() {
        handelInput()
        var bounds = finalBounds
        _srcRect.x = 0
        _srcRect.y = 0
        _srcRect.width = _rtex.width 
        _srcRect.height = -_rtex.height 

        _dstRect.x = bounds.x + bounds.width / 2
        _dstRect.y = bounds.y + bounds.height / 2
        _dstRect.width = bounds.width
        _dstRect.height = bounds.height 
        _origin.x = bounds.width / 2
        _origin.y = bounds.height / 2

        resetRenderState() 
        Raylib.BeginTextureMode(_rtt)
        Raylib.ClearBackground(this.color)
        Raylib.BeginMode2D(_camera) 
        for(child in children) { 
            SceneGraph2D.renderNode_(child) 
        }
        Raylib.EndMode2D()
        Raylib.EndTextureMode()

        resetRenderState() 
        Raylib.DrawTexturePro(_rtex, _srcRect, _dstRect, _origin, 0, _tint)
    }
    zoom{_control.zoom}
    zoom=(val){
        _control.zoom = val
        _zoomChanged.emit(val)
    }
    zoomChanged{_zoomChanged}

    onEvent(event) {
        var ret = super.onEvent(event)

        return ret 
    }
    editor{_editor}
    editor=(val){_editor = val}

    handelInput() {
        Raylib.GetMousePosition(_mousePos)
        _mousePos.x = _mousePos.x - finalBounds.x 
        _mousePos.y = _mousePos.y - finalBounds.y 
        Raylib.GetScreenToWorld2D(_mouseWorldPos, _mousePos, _camera)
        var inBounds = Raylib.CheckCollisionPointRec(SceneGraph2D.mouseWorldPos, finalBounds)

        // relate 
        if(inBounds) {
            
            // process input for editor 
            if(_editor) { _editor.processInput(_camera, _mousePos, _mouseWorldPos) }

            // panning
            if(Raylib.IsMouseButtonDown(Raylib.MOUSE_BUTTON_RIGHT)) {
                Raylib.GetMouseDelta(_mouseDelta)
                _mouseDelta.x = _mouseDelta.x * -1.0 / _control.zoom
                _mouseDelta.y = _mouseDelta.y * -1.0 / _control.zoom
                _control.pan.x = _control.pan.x + _mouseDelta.x
                _control.pan.y = _control.pan.y + _mouseDelta.y
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

                    var zoomIncrement = 0.065
                    _control.zoom = _control.zoom + (wheel * zoomIncrement)
                    if(_control.zoom < zoomIncrement) {
                        _control.zoom = zoomIncrement
                    }
                    if(_control.zoom < 0.1) { _control.zoom = 0.1 }
                    if(_control.zoom > 3 ) {_control.zoom = 3}
                }
            }

            // canvas view port
            {
                _camera.target = _control.pan 
                _camera.offset = _control.offset
                var diff = _control.zoom - _camera.zoom 
                if(diff != 0) {
                    var step = diff / 6
                    _camera.zoom  = _camera.zoom  + step
                    _zoomChanged.emit(_control.zoom)
                }
            }
        }
    }

    parse(map) {
        super.parse(map)
    }
}

class SpriteItem is SgSprite {
    construct new() {
        super()
        initSpriteItemProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initSpriteItemProps_()
        if(dynamic is Map) {parse(dynamic)}
    }
    construct new(parent, map) {
        super(parent)
        initSpriteItemProps_()
        parse(map)
    }

    initSpriteItemProps_() {
        _index = 0
    }

    index{ _index }
    index=(val) { _index = val }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("index")) { this.index = map["index"] } 
    }
}

class PreviewPanel is SgRectangle {
    construct new() {
        super()
        initPreviewProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initPreviewProps_()
        if(dynamic is Map) {parse(dynamic)}
    }
    construct new(parent, map) {
        super(parent)
        initPreviewProps_()
        parse(map)
    }

    initPreviewProps_() {
        _canvas = Canvas.new(this, { "color": Color.fromString("#222222") })
        _canvas.width = this.width
        _canvas.height = this.height 
        this.geometryChanged.connect{|e,v| 
            _canvas.width = this.width
            _canvas.height = this.height 
        }
        _rect = SgRectangle.new(_canvas, {
            "border": Border.new(1, Color.fromString("#33aaff")),
            "color": Color.fromString("#09ffffff")
        })
        _canvas.zoomChanged.connect{|e,v|
            _rect.border.width = 2.0 / _canvas.zoom 
        }
    }

    loadFiles(files) {
        _rect.removeAllNodes()
        var i = 0
        var inputs = ValueList.new()
        var outputs = ValueList.new()
        var crect = Rectangle.new()
        if(files.count > 0) {  inputs.create(Raylib.VALUE_TYPE_RECTANGLE, files.count) }
        for(file in files) {
            var csprite = SpriteItem.new(_rect, { "source": file, "index": i })
            csprite.width = csprite.sourceSize.width 
            csprite.height = csprite.sourceSize.height 
            crect.width = csprite.width
            crect.height = csprite.height 
            inputs.set(i, crect)
            i = i + 1
        }
        var rw = 2048
        var rh = 2048
        var max_w = 0
        var max_h = 0
        Raylib.PackRectangles(inputs, outputs, rw, rh, 1)
        for(i in 0...outputs.count) {
            outputs.get(crect, i)
            _rect.children[i].x = crect.x 
            _rect.children[i].y = crect.y 
            if(crect.x + crect.width > rw || crect.y + crect.height > rh) { 
                // _rect.children[i].opacity = 0.6
            } else {
                max_w = max_w.max(crect.x + crect.width)
                max_h = max_h.max(crect.y + crect.height)
            }
        }

        _rect.width = max_w 
        _rect.height = max_h
    }
}