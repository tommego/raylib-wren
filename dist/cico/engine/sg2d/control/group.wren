import "../../signalslot" for Signal
class SgGroup {
    construct new() {
        _items = []
        _cbClicked = Fn.new{|e,v|  onItemClicked(e) }
        _checkedChanged = Signal.new(this)
        _clicked = Signal.new(this)
        _checkedItem = null 
    }
    items{_items}
    items=(val) {
        unbind()
        _items = val
        bind()
    }
    checkedItem{_checkedItem}
    unbind() {
        for(item in _items) { item.clicked.disconnect(_cbClicked) }
    }
    bind() {
        for(item in _items) { item.clicked.connect(_cbClicked) }
    }
    checkedChanged{_checkedChanged}
    clicked{_clicked}
    selectByName(name) {
        for(item in _items) { item.checked = (item.name == name) }
    }

    onItemClicked(item) {
        item.checked = !item.checked
        if(item.checked) {
            for(c in _items) {
                if(c != item) {
                    c.checked = false 
                }
            }
        }
        _checkedChanged.emit(item.checked ? item : null)
        _checkedItem = item.checked ? item : null
        _clicked.emit(item)
    }

    itemByName(name) {
        var ret = null 
        for(item in _items) {
            if(item.name == name) {
                ret = item 
            }
        }
        return ret 
    }

}