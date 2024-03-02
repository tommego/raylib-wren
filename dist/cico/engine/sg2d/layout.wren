import "cico.raylib" for Raylib
import "./scenegraph2d" for SgItem
import "../signalslot" for Signal 
import "../math" for Math

class SgColumn is SgItem{
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
        _spacing = 0
        _slotRefreshLayout = Fn.new{|e,v| refreshLayout()}
        _slotChildAdded = Fn.new{|e,v|
            v.widthChanged.connect(_slotRefreshLayout)
            v.heightChanged.connect(_slotRefreshLayout)
            refreshLayout()
        }
        _slotChildRemoved = Fn.new{|e,v|
            v.widthChanged.disconnect(_slotRefreshLayout)
            v.heightChanged.disconnect(_slotRefreshLayout)
            refreshLayout()
        }
        this.childAdded.connect(_slotChildAdded)
        this.childRemoved.connect(_slotChildRemoved)
    }

    spacing{_spacing}
    spacing=(val){
        _spacing=val
        refreshLayout()
    }

    refreshLayout() {
        var cy = 0
        var h = 0
        var w = Num.smallest
        for(child in children) {
            child.y = cy 
            child.x = 0
            h = cy + child.height
            cy = cy + child.height + _spacing 
            w = w.max(child.width)
        }
        this.width = w 
        this.height = h
    }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("spacing")) { this.spacing = map["spacing"] }
    }
}

class SgRow is SgItem{
    construct new() {
        super()
        initProps_()
    }

    construct new(dynamic) {
        if(dynamic is SgItem) { super(dynamic) } else {
            super()
        }
        initProps_()
        if(dynamic is Map) { parse(dynamic)}
    }

    construct new(parent, map) {
        super(parent)
        initProps_()
        parse(map)
    }

    initProps_() {
        _spacing = 0
        _slotRefreshLayout = Fn.new{|e,v| refreshLayout()}
        _slotChildAdded = Fn.new{|e,v|
            v.widthChanged.connect(_slotRefreshLayout)
            v.heightChanged.connect(_slotRefreshLayout)
            refreshLayout()
        }
        _slotChildRemoved = Fn.new{|e,v|
            v.widthChanged.disconnect(_slotRefreshLayout)
            v.heightChanged.disconnect(_slotRefreshLayout)
            refreshLayout()
        }
        this.childAdded.connect(_slotChildAdded)
        this.childRemoved.connect(_slotChildRemoved)
    }

    spacing{_spacing}
    spacing=(val){
        _spacing=val
        refreshLayout()
    }

    refreshLayout() {
        var cx = 0
        var h = Num.smallest
        var w = 0
        for(child in children) {
            // child.y = 0
            child.x = cx
            w = cx + child.width
            cx = cx + child.width + _spacing 
            h = h.max(child.height)
        }
        this.width = w 
        this.height = h
    }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("spacing")) { this.spacing = map["spacing"] }
    }
}

class SgFlowLayout is SgItem {
    construct new() {
        super()
        initFlowLayoutProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initFlowLayoutProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initFlowLayoutProps_()
        parse(map)
    }

    initFlowLayoutProps_() {
        _cellWidth = 50
        _cellHeight = 50
        _spacing = 0

        _cellWidthChanged = Signal.new(this)
        _cellHeightChanged = Signal.new(this)
        _spacingChanged = Signal.new(this)

        _cellWidthChanged.connect{|e,v| refreshLayout()}
        _cellHeightChanged.connect{|e,v| refreshLayout()}
        _spacingChanged.connect{|e,v| refreshLayout()}

        this.widthChanged.connect{|e,v| refreshLayout()}
        this.childAdded.connect{|e,v| handleChildAdded(v)}
        this.childRemoved.connect{|e,v| handleChildRemoved(v)}
    }

    cellWidth{_cellWidth}
    cellWidth=(val){
        if(_cellWidth != val) {
            _cellWidth = val 
            _cellWidthChanged.emit(val)
        }
    }
    cellHeight{_cellHeight}
    cellHeight=(val){
        if(_cellHeight != val) {
            _cellHeight = val 
            _cellHeightChanged.emit(val)
        }
    }
    spacing{_spacing}
    spacing=(val){
        if(_spacing != val) {
            _spacing = val 
            _spacingChanged.emit(val)
        }
    }

    refreshLayout() {
        var cols = (width / (_spacing + _cellWidth)).floor
        var stepX = _cellWidth + _spacing
        var stepY = _cellHeight + spacing
        var cx = 0
        var cy = 0
        for(i in 0...children.count) {
            cx = Math.mod(i, cols) * stepX 
            cy = (i / cols).floor * stepY 
            children[i].x = cx 
            children[i].y = cy 
        }
        this.height = cy + _cellHeight
    }

    handleChildAdded(child) {
        var cols = (width / (_spacing + _cellWidth)).floor
        var stepX = _cellWidth + _spacing
        var stepY = _cellHeight + spacing
        var idx = indexOf(child)
        var cx = 0
        var cy = 0
        for(i in idx...children.count) {
            cx = Math.mod(i, cols) * stepX 
            cy = (i / cols).floor * stepY 
            children[i].x = cx 
            children[i].y = cy 
        }
        this.height = this.height.max(cy + _cellHeight)
    }

    handleChildRemoved(child) {
        var cols = (width / (_spacing + _cellWidth)).floor
        var stepX = _cellWidth + _spacing
        var stepY = _cellHeight + spacing
        var cx = 0
        var cy = 0

        for(i in 0...children.count) {
            cx = Math.mod(i, cols) * stepX 
            cy = (i / cols).floor * stepY 
            children[i].x = cx 
            children[i].y = cy 
        }
        this.height = cy + _cellHeight
    }
    
    parse(map) {
        super.parse(map)
        if(map.keys.contains("cellWidth")) { this.cellWidth = map["cellWidth"] }
        if(map.keys.contains("cellHeight")) { this.cellHeight = map["cellHeight"] }
        if(map.keys.contains("spacing")) { this.spacing = map["spacing"] }
    }

    [key]{
        if(key == "cellWidth") {
            return _cellWidth
        } else if(key == "cellWidthChanged") {
            return _cellWidthChanged
        } else if(key == "cellHeight") {
            return _cellHeight
        } else if(key == "cellHeightChanged") {
            return _cellHeightChanged
        } else if(key == "spaccing") {
            return _spacing
        } else if(key == "spacingChanged") {
            return _spacingChanged
        } else {
            return super[key]
        }
    }
    [key]=(val) {
        if(key == "cellWidth") {
            this.cellWidth = val 
        } else if(key == "cellHeight") {
            this.cellHeight = val 
        } else if(key == "spacing") {
            this.spacing = val 
        } else {
            super[key] = val 
        }
    }
}