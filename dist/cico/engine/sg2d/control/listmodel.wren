import "../../signalslot" for Signal
class ListModel {
    construct new() {
        _items = []
        _itemAdded = Signal.new(this)
        _itemRemoved = Signal.new(this)
        _itemMoved = Signal.new(this)
        _itemSwaped = Signal.new(this)
        _itemCleared = Signal.new(this)
        _dataChanged = Signal.new(this)
    }
    // roles only fix on first item data
    roleNames{_items.count > 0 ? _items[0].keys : []}
    // add a map item data
    add(item) {
        if(!_items.contains(item)) {  
            _items.add(item)
            _itemAdded.emit(item)
        }
    }
    // remove an item data
    remove(item) {
        if(_items.contains(item)) {
            var index = 0
            for(i in _items.count) {
                if(item == _items[i]) {
                    index = i
                    break
                }
            }
            _itemRemoved.emit(index)
            _item.remove(item)
        }
    }
    // remove item data at index 
    removeAt(index) {
        if(index >= 0 && index < _items.count) { 
            _items.removeAt(index) 
            _itemRemoved.emit(index)
        }
    }
    // get item data at index 
    itemAt(index) { _items[index] }
    // swap two item data
    swap(from, to) {
        if(from >= 0 && from < _items.count && to >= 0 && to < _items.count && from != to) {
            var tmp = _items[from]
            _items[from] = _items[to]
            _items[to] = tmp 
            _itemSwaped.emit([from, to])
        }
    }
    // move an item to destinate index
    move(from, to) {
        var i0 = from < to ? from : to 
        var i1 = to > from ? to : from
        if(from >= 0 && from < _items.count && to >= 0 && to < _items.count && i0 != i1 && from != to) {
            var tmp = _items[i0]
            for(i in i0+1..i1+1) { _items[i-1] = _items[i] }
            _items[i1] = tmp
            _itemMoved.emit([from, to])
        }
    }
    // clear all item datas
    clear() {
        while(count > 0) {
            removeAt(0)
        }
    }
    // set item map data with key,value
    setProperty(index, prop, value) {
        if(index >= 0 && index < _items.count) {
            _items[index][prop] = value 
            _dataChanged.emit([index, [prop], [value]])
        }
    }
    // set item map data with keys,values
    setProperties(index, props, values) {
        for(i in 0...props.count) {
            this.setProperty(index, props[i], values[i])
        }
    }
    // get item data with key 
    getProperty(index, prop) {
        if(index >= 0 && index < _items.count) {
            return _items[index][prop]
        } else {
            return null 
        }
    }

    count{_items.count}

    itemAdded{_itemAdded}
    itemRemoved{_itemRemoved}
    itemSwaped{_itemSwaped}
    itemMoved{_itemMoved}
    itemCleared{_itemCleared}
    dataChanged{_dataChanged}
}