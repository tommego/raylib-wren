import "../scenegraph2d" for SgItem,SgEvent
import "../rectangle" for SgRectangle
import "./button" for SgButton
import "../../signalslot" for Signal
import "./style" for ControlStyle
import "../layout" for SgColumn
import "./label" for SgLabel
import "./popup" for SgPopup
import "./listmodel" for ListModel
import "cico.raylib" for Raylib,Font,Rectangle,Vector2,Color,ValueList

class SgComboBoxDelegate is SgRectangle {
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
                }
            }
        }
        return ret 
    }
}

class SgComboBoxPopup is SgPopup {
    construct new() {
        super()
        initComboBoxPopupProps_()
    }

    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initComboBoxPopupProps_()
        if(dynamic is Map) {
            parse(dynamic)
        }
    }

    construct new(parent, map) {
        super(parent)
        initComboBoxPopupProps_()
        parse(map)
    }

    initComboBoxPopupProps_() {
        _model = ListModel.new()
        this.width = 150
        _col = SgColumn.new(this)
        _col.width = this.width
        _col.x = 2
        _col.y = 1
        _modelChanged = Signal.new(this)
        _delegate = SgComboBoxDelegate
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

class SgComboBox is SgButton {
    construct new() {
        super()
        initComboBoxProps_()
    }

    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initComboBoxProps_()
        if(dynamic is Map) {
            parse(dynamic)
        }
    }

    construct new(parent, map) {
        super(parent)
        initComboBoxProps_()
        parse(map)
    }

    initComboBoxProps_() {
        _extend = false 
        _accepted = Signal.new(this)
        _modelChanged = Signal.new(this)
        _currentIndex = 0
        _currentIndexChanged = Signal.new(this)
        _validated = Signal.new(this)

        _popup = SgComboBoxPopup.new()
        _popup.modelChanged.connect{|e,v|_modelChanged.emit(v)}
        this.geometryChanged.connect{|e,v|
            _popup.x = finalBounds.x 
            _popup.y = finalBounds.y + finalBounds.height + 1
        }

        this.clicked.connect{|e,v| 
            this.extend = !_extend 
            if(_extend) {
                _popup.open()
            } else {
                _popup.close()
            }
        }

        this.width = 150
        this.height = 25

        _label = SgLabel.new(this,{
            "fontSize": 14,
            "color": Color.new(88, 88, 88, 255)
        })
        _label.x = this.width / 2 - _label.width / 2 - 10
        _label.y = this.height / 2  - _label.height / 2
        _popup.itemSelected.connect{|e,v|
            if(_currentIndex != v) {
                _currentIndex = v 
                var item = _popup.model.itemAt(_currentIndex)
                _label.text = (item is Map ? item["text"]: "%(item)")
                _label.x = this.width / 2 - _label.width / 2 - 10
                _label.y = this.height / 2  - _label.height / 2
                _currentIndexChanged.emit(v)
            }
            _popup.close()
            this.extend = false 
            _validated.emit(_currentIndex)
        }
        _popup.closed.connect{|e,v| this.extend = false }

        _arrowPoints = ValueList.new()
        _arrowPoints.create(Raylib.VALUE_TYPE_VECTOR2, 4)
        _arrowColor = Color.new(88, 88, 88, 255)

        _extendChanged = Signal.new(this)

        _slotRefreshArrowPoints = Fn.new{|e,v| refreshArrowPoints()}
        _extendChanged.connect(_slotRefreshArrowPoints)
        this.geometryChanged.connect(_slotRefreshArrowPoints)
        refreshArrowPoints()
    }

    model{_popup.model}
    model=(val){_popup.model = val}
    delegate{_popup.delegate}
    delegate=(val){_popup.delegate=val}
    extend{_extend}
    extend=(val) {
        if(_extend != val) {
            _extend = val 
            _extendChanged.emit(val)
        }
    }
    showLabel{_label.visible}
    showLabel=(val){_label.visible = val}
    indicatorColor{_arrowColor}
    indicatorColor=(val){_arrowColor=val}
    currentIndex{_currentIndex}
    currentIndex=(val){_currentIndex = val}
    currentIndexChanged{_currentIndexChanged}
    validated{_validated}

    open() {
        this.extend = true 
        _popup.open()
    }

    refreshArrowPoints() {
        var bounds = finalBounds
        if(_extend) {
            _arrowPoints.set(0, Vector2.new(bounds.x + bounds.width - 15, bounds.y + bounds.height / 2 - 4))
            _arrowPoints.set(1, Vector2.new(bounds.x + bounds.width - 15 - 5, bounds.y + bounds.height / 2 + 4))
            _arrowPoints.set(2, Vector2.new(bounds.x + bounds.width - 15 + 5, bounds.y + bounds.height / 2 + 4))
            _arrowPoints.set(3, Vector2.new(bounds.x + bounds.width - 15, bounds.y + bounds.height / 2 - 4))
        } else {
            _arrowPoints.set(0, Vector2.new(bounds.x + bounds.width - 15, bounds.y + bounds.height / 2 + 4))
            _arrowPoints.set(1, Vector2.new(bounds.x + bounds.width - 15 + 5, bounds.y + bounds.height / 2 - 4))
            _arrowPoints.set(2, Vector2.new(bounds.x + bounds.width - 15 - 5, bounds.y + bounds.height / 2 - 4))
            _arrowPoints.set(3, Vector2.new(bounds.x + bounds.width - 15, bounds.y + bounds.height / 2 + 4))
        }
    }

    parse(map) {
        super.parse(map)
        if(map.keys.contains("model")) { this.model = map["model"] }
        if(map.keys.contains("delegate")) { this.delegate = map["delegate"] }
        if(map.keys.contains("showLabel")) { this.showLabel = map["showLabel"]}
        if(map.keys.contains("options"))  {
            for(opt in map["options"]) { this.model.add(opt) }
        }
        if(map.keys.contains("indicatorColor")) { this.indicatorColor = map["indicatorColor"]}
    }

    onRender() {
        super.onRender() 
        Raylib.DrawTriangleFan(_arrowPoints, _arrowPoints.count, _arrowColor)
    }
}