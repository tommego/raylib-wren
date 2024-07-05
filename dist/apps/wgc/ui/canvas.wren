import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, SgItem
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/layout" for SgRow,SgFlowLayout, SgColumn 
import "cico/engine/sg2d/control/scrollview" for SgScrollView
import "cico/engine/sg2d/control/button" for SgButton
import "cico/engine/math" for Math
import "cico.raylib" for Raylib, Color, RenderTexture,Camera2D,Vector2,Vector3,Matrix,Texture,Rectangle
import "cico/engine/sg2d/icon" for SgIcon
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

        renderRuler()
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

    renderRuler() {
        // if(!_soffset) { 
        //     _soffset = Vector2.new()
        //     _p0 = Vector2.new()
        //     _p1 = Vector2.new() 
        //     _rulerColor = Color.fromString("#111111")
        // }

        // Raylib.GetWorldToScreen2D(_soffset, _control.offset, _camera)
        // var dp = 10
        // var dc = this.width / 10 + 1
        // for(i in 0...dc) {
        //     _p0.x = finalBounds.x + i * dp + _soffset.x 
        //     _p0.y = finalBounds.y 
        //     _p1.x = _p0.x 
        //     _p1.y = _p0.y + 10
        //     Raylib.DrawLineV(_p0, _p1, _rulerColor)
        // }
    }

    parse(map) {
        super.parse(map)
    }
}