import "../scenegraph2d" for SgItem,SgEvent,SceneGraph2D
import "./listmodel" for ListModel
import "../../signalslot" for Signal
import "cico.raylib" for Raylib,Color,Vector2,Rectangle

class DelegateBase is SgItem{
    construct new(listview, index, modelData) {
        super()
        _index = index
        _control = listview 
        _modelData = modelData
        _prev = null
        _colors = [Color.new(255, 255, 255, 255), Color.new(188, 188, 188, 255)] 
        _textColor = Color.new(0, 0, 0, 255)
        _textPos = Vector2.new()
        this.width = _control.width 
        this.height = 20
        // this.height = _control.height
        _refreshPos = Fn.new{|emiter, val| 
            if(_prev) {  
                if(_control.direction == SgListView.Vertical) {
                    this.y = _prev.y + _prev.height + _control.spacing 
                } else {
                    this.x = _prev.x + _prev.width + _control.spacing 
                }
            }
        }
        _renderText = ""
        _modelDataChanged = Signal.new(this)
        _indexChanged = Signal.new(this)

        _onContentChanged = Fn.new{|emitter,val| _renderText = _index.toString + "  %(_modelData)" }

        _modelDataChanged.connect(_onContentChanged)
        _indexChanged.connect(_onContentChanged)

        _modelDataChanged.emit(modelData)
        onDefaultBinding()
    } 
    index{_index}   
    // only set by listview
    index=(val){
        _index = val
        _indexChanged.emit(val)
    }
    control{_control}
    modelData{_modelData}
    modelData=(val){
        _modelData = val
        _modelDataChanged.emit(val)
    }
    prev{_prev}
    prev=(val){
        if(_prev) { _prev.geometryChanged.disconnect(_refreshPos) }
        _prev = val 
        if(_prev) { 
            if(_control.direction == SgListView.Vertical) {
                this.y = _prev.y + _prev.height + _control.spacing 
            } else {
                this.x = _prev.x + _prev.width + _control.spacing
            }
            _prev.geometryChanged.connect(_refreshPos) 
        }
    }
    modelDataChanged{_modelDataChanged}

    onDefaultBinding() {
        _refreshSize = Fn.new{|emitter, val| 
            this.width = _control.width 
            // this.hegiht = _control.height 
        }
        _control.widthChanged.connect(_refreshSize)
        _control.heightChanged.connect(_refreshSize)
        this.parentChanged.connect{|value| 
            if(value != _control) { 
                _control.widthChanged.disconnect(_refreshSize) 
                _control.heightChanged.disconnect(_refreshSize) 
            }
        }
    }

    onModelPropertyDataChanged(props, values) {
        System.print("onModelPropertyDataChanged  %(props) %(values)")
        _renderText = _index.toString + "  %(_modelData) updated by prop"
    }

    onRender() {
        var mod = (index - (index / 2).floor * 2).ceil 
        var color = _colors[mod]
        Raylib.DrawRectangleRec(finalBounds, color)
        _textPos.x = finalBounds.x + 10
        _textPos.y = finalBounds.y + 5
        Raylib.DrawTextEx(SceneGraph2D.font, _renderText, _textPos, 12, 0, _textColor)
    }
}

class SgListView is SgItem {
    construct new() {
        super()
        initProps_()
        this.hoverEnabled = true
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initProps_()
        if(dynamic is Map) { parse(dynamic) }
        this.hoverEnabled = true
    }
    construct new(parent, map) {
        super(parent)
        initProps_()
        parse(map)
        this.hoverEnabled = true
    }

    initProps_() {
        _model = ListModel.new()
        _spacing = 0
        _direction = SgListView.Vertical 
        _targetWheel = 0
        _items = []
        _reuseItems = []
        _smooth = 1
        _currentIndex = 0
        // _delegate = Fn.new{|listView, index, itemData| 
        //     return DelegateBase.new(listView, index, itemData)
        // }
        _delegate = DelegateBase

        _currentIndexChanged = Signal.new(this)
        _modelChanged = Signal.new(this)
        _spacingChanged = Signal.new(this)
        _delegateChanged = Signal.new(this)
        _directionChanged = Signal.new(this)
        _smoothChanged = Signal.new(this)

        _delegateItemCreated = Signal.new(this)
        _delegateItemDestroyed = Signal.new(this)

        bindModel_(_model)
    }

    // bind model and monitor it's behavior
    bindModel_(model) {
        model.itemAdded.connect{|emitter,item| 
            if(_items.count <= 0 || _items[-1].y < height + _items[-1].height) {
                var child = _delegate.new(this, _items.count, item)
                _items.add(child)
                this.addNode(child)
                if(_items.count == 1) { child.y = 1 }
                _delegateItemCreated.emit(child)
                if(_items.count > 1) { 
                    _items[-1].prev = _items[-2] 
                } else {
                }
            }
        }
        model.itemRemoved.connect{|emitter,index| 
            var child = null 
            var vidx = -1
            for(i in 0..._items.count) {
                var item = _items[i]
                if(item.index == index) {
                    child = item 
                    vidx = i
                    break
                }
            }

            if(child) {
                child.prev = null 
                this.removeNode(child)
                child.parent = null 
                if(vidx == 0) {
                    if(vidx < _items.count -1 ) {
                        _items[vidx + 1].prev = null
                    }
                } else {
                    if(vidx < _items.count - 1) { _items[vidx + 1].prev = _items[vidx - 1] }
                }
                _reuseItems.add(child)
                _items.remove(child)
                for(i in index..._items.count) {
                    _items[i].index = i
                }
            }
            if(index == 0 && _items.count > 0) {
                _items[0].y = 1
            }
        }
        model.itemSwaped.connect{|emitter,val| 
            var from = val[0]
            var to = val[1]
            var vfrom = -1
            var vto = -1
            var itemFrom = _model.itemAt(from)
            var itemTo = _model.itemAt(to)
            for(i in 0..._items.count) {
                var item = _items[i]
                if(item.index == from) { vfrom = i }
                if(item.index == to) { vto = i }
            }
            if(vfrom >= 0) { _items[vfrom].modelData = itemFrom }
            if(vto >= 0) { _items[vto].modelData = itemTo }
        }
        model.itemMoved.connect{|emitter,val| 
            var from = val[0]
            var to = val[1]
            var i0 = from < to ? from : to 
            var i1 = to > from ? to : from
            for(i in i0...i1 + 1) {
                for(j in 0..._items.count) {
                    if(_items[j].index == i) {
                        var modelData = _model.itemAt(i)
                        _items[j].modelData = modelData
                    }
                }
            }
        }
        model.itemCleared.connect{|emitter, val|
            for(child in _items) {
                child.prev = null 
                this.removeNode(child)
                child.parent = null 
                _reuseItems.add(child)
            }
            _items = null 
        }
        model.dataChanged.connect{|emitter, val|
            var index = val[0]
            var props = val[1]
            var values = val[2]
            for(item in _items) {
                if(item.index == index) { item.onModelPropertyDataChanged(props, values) } // refresh render item's prop data
            }
        }
    }

    // unbind model's behavior
    unbindModel_(model) {
        model.itemAdded.disconnect()
        model.itemRemoved.disconnect()
        model.itemSwaped.disconnect()
        model.itemMoved.disconnect()
    }

    model{_model}
    model=(val){
        unbindModel_(_model)
        _model = val
        bindModel_(_model)
        _modelChanged.emit(val)
    }
    spacing{_spacing}
    spacing=(val){
        _spacing = val
        _spacingChanged.emit(val)
    }
    delegate{_delegate}
    delegate=(val){
        if(_delegate != val) {
            _delegate = val
            _delegateChanged.emit(val)
        }
    }
    direction{_direction}
    direction=(val){ 
        if(_direction != val) {
            _direction = val 
            _directionChanged.emit(val)
        }
    }
    smooth{_smooth}
    smooth=(val){
        if(_smooth != val) {
            _smooth = val
            _smoothChanged.emit(val)
        }
    }
    currentIndex{_currentIndex}
    currentIndex=(val){
        if(_currentIndex != val) {
            _currentIndex = val
            _currentIndexChanged.emit(val)
        }
    }

    currentIndexChanged{_currentIndexChanged}
    modelChanged{_modelChanged}
    spacingChanged{_spacingChanged}
    delegateChanged{_delegateChanged}
    directionChanged{_directionChanged}
    smoothChanged{_smoothChanged}
    delegateItemCreated{_delegateItemCreated}

    static Horizontal{0}
    static Vertical{1}

    parse(map) {
        super.parse(map)
        if(map.keys.contains("spacing")) { this.spacing = map["spacing"]}
        if(map.keys.contains("smooth")) { this.smooth = map["smooth"]}
        if(map.keys.contains("direction")) { this.direction = map["direction"]}
    }

    onEvent(event) {
        var ret = super.onEvent(event)
        if(event.type == SgEvent.MouseWheel) {
            if(children.count > 0) { 
                if(_items[-1].index == _model.count -1 && _items[-1].y < height - _items[-1].height && event.data["delta"].y < 0) {
                    // don't scroll 
                } else {
                    _targetWheel = _targetWheel + event.data["delta"].y 
                    if(_smooth <= 1) { scrollStep(1) }
                }
            }
            
        }
        return ret 
    }

    scrollStep(smooth) {
        // scrolling animation 
        if(_model.count > 0) {
            if(_targetWheel.abs > 0) {
                var step = _targetWheel / smooth
                var scrollEnd = false 
                if(_targetWheel.abs < 0.001) { 
                    step = _targetWheel
                    scrollEnd = true
                } 
                _targetWheel = _targetWheel - step 
                if(_direction == SgListView.Vertical) {
                    _items[0].y = _items[0].y + (step * (_items[0].height + _spacing)) 
                } else {
                    _items[0].x = _items[0].x + (step * (_items[0].width + _spacing)) 
                }
                
                if(_items[0].index == 0) { 
                    if(_direction == SgListView.Vertical) {
                        _items[0].y = _items[0].y.min(0) 
                    } else {
                        _items[0].x = _items[0].x.min(0)
                    }
                }


                // check add head
                var addHead = false 
                while((_direction == SgListView.Vertical ? _items[0].y:_items[0].x) > _spacing && _items[0].index > 0) {
                    addHead = true 
                    var child = null 
                    var newIndex = _items[0].index -1 
                    var modelItem = _model.itemAt(newIndex)
                    if(_reuseItems.count > 0) {
                        child = _reuseItems[0]
                        child.modelData = modelItem
                        child.index = newIndex
                        _reuseItems.remove(child)
                    } else {
                        child = _delegate.new(this, newIndex, modelItem)
                    }
                    this.addNode(child)
                    if(_direction == SgListView.Vertical) {
                        child.y = _items[0].y - child.height - _spacing
                    } else {
                        child.x = _items[0].x - child.width - _spacing
                    }
                    _items[0].prev = child
                    _items = [child] + _items 
                }
                
                // check add tail
                var addTail = false 
                while((_direction==SgListView.Vertical?_items[-1].y:_items[-1].x) < (_direction==SgListView.Vertical?height:width) && _items[-1].index < _model.count -1) {
                    addTail = true 
                    var child = null 
                    var newIndex = _items[-1].index + 1 
                    var modelItem = _model.itemAt(newIndex)
                    if(_reuseItems.count > 0) {
                        child = _reuseItems[0]
                        _reuseItems.remove(child)
                        child.modelData = modelItem
                        child.index = newIndex
                    } else {
                        child = _delegate.new(this, newIndex, modelItem)
                    }
                    this.addNode(child)
                    if(_direction == SgListView.Vertical) {
                        child.y = _items[-1].y + child.height + _spacing
                    } else {
                        child.x = _items[-1].x + child.width + _spacing
                    }
                    child.prev = _items[-1]
                    _items.add(child)
                    _delegateItemCreated.emit(child)
                }

                // check remove head
                while((_direction==SgListView.Vertical?_items[0].y + _items[0].height: _items[0].x + _items[0].width) < -((_direction==SgListView.Vertical?_items[0].height:_items[0].width) * 6 + _spacing) && !addHead) {
                    var child = _items[0]
                    _items[1].prev = null
                    this.removeNode(child)
                    child.parent = null 
                    _reuseItems.add(child)
                    _items.remove(child)
                }

                // check remove tail 
                while((_direction==SgListView.Vertical?_items[-1].y > (height + _items[-1].height * 6 + _spacing):_items[-1].x > (width + _items[-1].width * 6 + _spacing)) && !addTail && _items[-1].index > 0) {
                    var child = _items[-1]
                    child.prev = null
                    this.removeNode(child)
                    child.parent = null 
                    _reuseItems.add(child)
                    _items.remove(child)
                }
            }
        }
    }

    onRender() {
        super.onRender()
        if(_smooth > 1) {
            scrollStep(_smooth)
        }
    }
}