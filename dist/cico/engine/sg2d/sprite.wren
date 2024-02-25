import "./scenegraph2d" for SgNode2D, SgItem, Border
import "cico.raylib" for Vector2,Vector3,Vector4,Color,Rectangle,Raylib,Texture,Image 

class SgSprite is SgItem {
    construct new() {
        super()
        _texture = null 
        _source = ""
        _color = Raylib.WHITE 
        _dstRect = Rectangle.new()
        _srcRect = Rectangle.new()
        _origin = Vector2.new()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initProps_()
        parse(map)
    }

    initProps_(){
        _texture = null 
        _source = ""
        _color = Raylib.WHITE 
        _dstRect = Rectangle.new()
        _srcRect = Rectangle.new()
        _origin = Vector2.new()
    }
    
    source{_source}
    source=(val) {
        if(_source != val) {
            _source = val 
            System.print("%(val), %(_source)")
            if(_texture) {
                Raylib.UnloadTexture(_texture)
                _texture = null 
            }
            _texture = Texture.new()
            Raylib.LoadTexture(_texture, _source)
        }
    }

    onRender() {
        super.onRender()
        if(_texture) {
            var bounds = finalBounds
            _srcRect.x = 0
            _srcRect.y = 0
            _srcRect.width = _texture.width 
            _srcRect.height = _texture.height 
            _dstRect.x = bounds.x + bounds.width / 2
            _dstRect.y = bounds.y + bounds.height / 2
            _dstRect.width = bounds.width 
            _dstRect.height = bounds.height 
            _origin.x = bounds.width / 2
            _origin.y = bounds.height / 2
            Raylib.DrawTexturePro(_texture, _srcRect, _dstRect, _origin, finalRotation, _color)
        }
    }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("source")) { this.source = map["source"] }
    }
}