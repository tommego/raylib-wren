import "../scenegraph2d" for SgItem, Border, Anchors, SgEvent
import "../rectangle" for SgRectangle
import "cico/engine/sg2d/control/button" for SgButton 
import "cico/engine/signalslot" for Signal
import "cico/engine/sg2d/layout" for SgRow,SgFlowLayout,SgColumn
import "./listmodel" for ListModel
import "cico.raylib" for Raylib, Color
import "./label" for SgLabel
import "./popup" for SgPopup

class SgMenuItem {
    construct new(dynamic) {
        _triggered = Signal.new(this)
        _title = ""
        if(dynamic is String) {
            _title = dynamic 
        } else {
        }
        _sub = []
        _onTriggered = null 
        if((dynamic is Map)) {parse(dynamic)}
    }

    parse(map) {
        if(map.keys.contains("title")) {_title = map["title"]}
        if(map.keys.contains("sub")) {
            for(sub in map["sub"]) { _sub.add(sub) }
        }
        if(map.keys.contains("onTriggered")) { _onTriggered = map["onTriggered"] }
    }

    title{_title}
    title=(val){_title = val}
    sub{_sub}
    onTriggered{_onTriggered}
}

class SgMenuPopupDelegate is SgRectangle {
    construct new(control, index, modelData) {
        super()
        _control = control 
        _index = index 
        _modelData = modelData 
        this.width = control.width - 2
        this.height = 25
        this.hoverEnabled = true 
        _nomalColor = Color.new(244, 244, 244, 255)
        _hoverColor = Color.new(66,200, 255, 255)
        this.color = _nomalColor
        _label = SgLabel.new(this,{
            "fontSize": 12,
            "text": (_modelData is Map ? _modelData["text"] : "%(_modelData)"),
            "color": Color.new(100, 100, 100, 255)
        })
        _label.x = this.width / 2 - _label.width / 2
        _label.y = this.height / 2  - _label.height / 2
        _pressTime = 0
    }

    onEvent(event) {
        var ret = super.onEvent(event)
        if(event.type == SgEvent.HoverEnter) {
            ret = 1
            this.color = _hoverColor
        } else if(event.type == SgEvent.HoverExit) {
            ret = 1
            this.color = _nomalColor
        } else if(event.type == SgEvent.MousePressed) {
            if(event.data["key"] == Raylib.MOUSE_BUTTON_LEFT) {
                _pressTime = Raylib.GetTime()
                ret = 1
            }
        } else if(event.type == SgEvent.MouseRelease) {
            if(event.data["key"] == Raylib.MOUSE_BUTTON_LEFT) {
                ret = 1 
                var now = Raylib.GetTime()
                if(now - _pressTime < 0.15) {
                    _control.itemSelected.emit(_index)
                    if(_modelData["data"].onTriggered != null) { _modelData["data"].onTriggered.call() }
                    _control.close()
                }
            }
        }
        return ret 
    }
}

class SgMenuPopup is SgPopup {
    construct new() {
        super()
        initMenuPopupProps_()
    }

    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initMenuPopupProps_()
        if(dynamic is Map) {
            parse(dynamic)
        }
    }

    construct new(parent, map) {
        super(parent)
        initMenuPopupProps_()
        parse(map)
    }

    initMenuPopupProps_() {
        _model = ListModel.new()
        this.width = 150
        _col = SgColumn.new(this)
        _col.width = this.width
        _col.x = 2
        _col.y = 1
        _modelChanged = Signal.new(this)
        _delegate = SgMenuPopupDelegate
        _col.geometryChanged.connect{|e,v|
            this.height = _col.height + 2
        }
        _slotItemAdded = Fn.new{|e,v| handleItemAdded(v)}
        _slotItemRemoved = Fn.new{|e,v| handleItemRemoved(v)}
        _slotItemCleared = Fn.new{|e,v| handleItemCleared()}
        _itemSelected = Signal.new(this)
        bindModel(_model)
    }

    model{_model}
    model=(val) {
        if(_model != val) {
            if(_model) {bindModel(_model)}

            _model = val 
            bindModel(_model)
            _modelChanged.emit(val)
            _col.removeAllNodes()

            for(i in 0..._model.count) {
                var vitem = _delegate.new(this, i, _model.itemAt(i))
                _col.addNode(vitem)
            }
        }
    }
    modelChanged{_modelChanged}
    itemSelected{_itemSelected}

    bindModel(model) {
        model.itemAdded.connect(_slotItemAdded)
        model.itemRemoved.connect(_slotItemRemoved)
        model.itemCleared.connect(_slotItemCleared)
    }

    unBindModel(model) {
        model.itemAdded.disconnect(_slotItemAdded)
        model.itemRemoved.disconnect(_slotItemRemoved)
        model.itemCleared.disconnect(_slotItemCleared)
    }

    handleItemAdded(item) {
        var vitem = _delegate.new(this, _col.children.count, item)
        _col.addNode(vitem)
        if(_col.children.count == 1) {
            _itemSelected.emit(0)
        }
    }

    handleItemRemoved(index) {
        _col.removeNodeByIndex(index)
    }

    handleItemCleared() {
        _col.removeAllNodes()
    }
}

class SgMenu is SgButton {
    construct new() {
        super()
        initMenuProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initMenuProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent) 
        initMenuProps_()
        parse(map)
    }
    initMenuProps_() {
        this.fontSize = 14
        this.width = 60
        this.height = 20
        this.color= Color.new(0, 0, 0, 0)
        this.border.width = 0
        this.border.color = Color.new(0, 0, 0, 0)
        _extend = false 
        _pressedColor = Color.new(166, 166, 166, 255)
        _normalColor = Color.new(220, 220, 220, 255)
        _enterColor = Color.new(255, 255, 255, 30)
        _exitColor = Color.new(0, 0, 0, 0)
        this.hoverEnabled = true 
        this.textColor = _normalColor
        this.color = _exitColor
        this.pressedChanged.connect{|target,val| this.textColor = val ? _pressedColor : _normalColor } 
        this.hoverEntered.connect{|target,val| this.color = _enterColor}
        this.hoverExited.connect{|target,val| this.color = _exitColor}

        _popup = SgMenuPopup.new()
        _popup.modelChanged.connect{|e,v|_modelChanged.emit(v)}
        _popup.closed.connect{|e,v| _extend = false }
        this.geometryChanged.connect{|e,v|
            _popup.x = finalBounds.x 
            _popup.y = finalBounds.y + finalBounds.height + 1
        }

        this.clicked.connect{|e,v| 
            _extend = !_extend 
            if(_extend) {
                _popup.open()
            } else {
                _popup.close()
            }
        }
    }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("options")) {
            for(item in map["options"]) {
                addItem(item)
            }
        }
    }
    addItem(item) {
        _popup.model.add({"text": item.title, "data": item})
    }
}

class SgMenuBar is SgRectangle {
    construct new() {
        super() 
        initMenuBarProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initMenuBarProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initMenuBarProps_()
        parse(map)
    }

    initMenuBarProps_() {
        _menus = []
        _row = SgRow.new(this)
        _row.anchors.verticalCenter({"target": this, "value": Anchors.VerticalCenter})
        _row.x = 10
    }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("menus")) {
            for(menu in map["menus"]) {
                _menus.add(menu)
                menu.parent = _row 
            }
        }
    }
}