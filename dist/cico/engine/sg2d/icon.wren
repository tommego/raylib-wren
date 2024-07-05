import "./scenegraph2d" for SgItem
import "cico.raylib" for Vector2,Color,Rectangle,Raylib,Texture 

class SgIcon is SgItem {
    construct new() {
        super()
        initIconProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initIconProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initIconProps_()
        parse(map)
    }

    initIconProps_(){
        _texture = null 
        _source = ""
        _dstRect = Rectangle.new()
        _srcRect = Rectangle.new()
        _origin = Vector2.new()
        _color = Color.fromString("#ffff00")
    }
    
    source{_source}
    source=(val) {
        if(_source != val) {
            _source = val 
            if(_texture) {
                Raylib.UnloadTexture(_texture)
                _texture = null 
            }
            _texture = Texture.new()
            Raylib.LoadTexture(_texture, _source)
        }
    }
    color{_color}
    color=(val) {_color = val}

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
        if(map.keys.contains("color")) { this.color = map["color"]}
    }
}