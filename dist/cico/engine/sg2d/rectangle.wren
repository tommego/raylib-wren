import "./scenegraph2d" for SgNode2D, SgItem, Border
import "cico.raylib" for Vector2,Vector3,Vector4,Color,Rectangle,Raylib 

class SgRectangle is SgItem{
    construct new() { 
        super()
        initProps_()
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
    
    initProps_() {
        _color = Raylib.WHITE
        _radius = 0
        _border = Border.new(0, Color.new(0, 0, 0, 255))
        _borderBounds = Rectangle.new()
    }

    radius{_radius}
    radius=(val){_radius = val}
    color{_color}
    color=(val){_color = val}
    border{_border}
    border=(val){_border = val}

    // because of rectangle has border property, we reimplement finalBounds containing border arounding for scissor mode. 
    finalBounds{ 
        var bounds =  super.finalBounds
        _borderBounds.x = bounds.x - _border.width
        _borderBounds.y = bounds.y - _border.width
        _borderBounds.width = bounds.width + _border.width * 2
        _borderBounds.height = bounds.height + _border.width * 2
        return _borderBounds
    }

    onRender() {  
        super.onRender()
        if(_radius <= 0) {
            Raylib.DrawRectangleRec(super.finalBounds, _color) 
            if(_border.width > 0) { Raylib.DrawRectangleLinesEx(super.finalBounds, _border.width, _border.color) }
        } else {
            Raylib.DrawRectangleRounded(super.finalBounds, _radius / width.min(height), _radius, _color)
            if(_border.width > 0) { Raylib.DrawRectangleRoundedLines(super.finalBounds, (_radius) / width.min(height), _radius, _border.width, _border.color) }
        }
    }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("radius")) { this.radius = map["radius"] }
        if(map.keys.contains("color")) { 
            if(map["color"] is Color) {
                this.color = map["color"] 
            } else if(map["color"] is String) {
                this.color.parse(map["color"])
            }
        }
        if(map.keys.contains("border")) { this.border = map["border"] }
    }
}