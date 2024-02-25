import "../scenegraph2d" for SgItem,SgEvent,SceneGraph2D
import "../../signalslot" for Signal
import "../rectangle" for SgRectangle
import "cico.raylib" for Raylib,Color,Vector2,Vector3,Vector4,Rectangle

class SgScrollView is SgItem {
    construct new() {
        super()
        initScrollViewProps_()
    }

    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initScrollViewProps_()
        if(dynamic is Map) {parse(dynamic)}
    }

    construct new(parent, map) {
        super(parent)
        initScrollViewProps_()
        parse(map)
    }

    initScrollViewProps_() {
        _content = SgItem.new(this) 
        _contentWidth = 0
        _contentHeight = 0
        _content.childrenChanged.connect{|e,v| refreshConetentBoundings()}
        this.clip = true 
        this.hoverEnabled = true
        this.childAdded.connect{|e,v| 
            if(v != _content) {_content.addNode(v) }
            refreshConetentBoundings()
            v.geometryChanged.connect{|e,v| refreshConetentBoundings()}
        }
    }

    refreshConetentBoundings() {
        var maxWidth = 0
        var maxHeight = 0
        for(c in _content.children) {
            maxWidth = maxWidth.max(c.x + c.width)
            maxHeight = maxHeight.max(c.y + c.height)
        }
        _content.width = maxWidth
        _content.height = maxHeight
    }

    onEvent(event) {
        var ret = super.onEvent(event)
        if(event.type == SgEvent.MouseWheel) {
            ret = 1
            var vy = event.data["delta"].y
            var scroll = false 
            if(vy < 0) {
                if(_content.y + _content.height > this.height) {
                    
                    scroll = true 
                }
            } else {
                if(_content.y < 0) {
                    scroll = true
                }
            }
            if(scroll) {
                _content.y = _content.y + vy * 10
            }

            if(_content.y > 0 ) {_cnotent.y = 0}
            if(_content.y + _content.height < this.height){ _content.y = -_content.height + this.height }
        }
        return ret 
    }
}