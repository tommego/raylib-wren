import "cico.raylib" for Raylib,Vector2,Vector3,Vector4,Color,Font,Rectangle,ValueList

class Style {
    construct new() {
        _textSize = 10
        _textColor = Color.new(166, 166, 166, 255)
        _textCursorColor = Color.new(200, 200, 200, 255)
        _valueBoxColorNormal = Color.new(55, 55 , 55, 255)
        _valueBoxColorActivate = Color.new(66, 66, 66, 255)
    }
    textSize{_textSize}
    textColor{_textColor}
    textCursorColor{_textCursorColor}
    valueBoxColorNormal{_valueBoxColorNormal}
    valueBoxColorActivate{_valueBoxColorActivate}
}

class ControlResult {
    construct new(c, vals) {
        _code = c 
        _values = vals 
    }
    code{_code}
    values{_values}
}

class MenuContent {
    construct new(pos_, items_, subs_) {
        _pos = pos_
        _items = items_
        _bounds = Rectangle.new(_pos.x, _pos.y, 160, items_.count * 30)
        _subs = subs_
        _cindex = -1
        _csubindex = -1
        _selectedIndex = -1
        _selectedSubIndex = -1
        _itemHeight = 30
    }
    pos{_pos}
    items{_items}
    bounds{_bounds}
    subs{_subs}
    cindex{_cindex}
    cindex=(val){_cindex=val}
    csubindex{_csubindex}
    csubindex=(val){_csubindex=val}
    itemHeight{_itemHeight}
    selectedIndex{_selectedIndex}
    selectedIndex=(val){_selectedIndex = val}
    selectedSubIndex{_selectedSubIndex}
    selectedSubIndex=(val){_selectedSubIndex=val}
}

class NodeUI {
    construct new() {
        _mousePos = null 
        _mouseWorldPos = null 
        _editingVal = null 
        _editingSource = null 
        _lockingBounds = null
        _editingBounds = null
        _editResultVal = null 
        _checkDoubleClickBounds = null  
        _camera = null 
        _hasDrag = null 
        _font = Font.new()
        _mouseDelta = Vector2.new()
        _lastCheckDoubleClickBoundsTime = 0
        _style = Style.new()
        _capsLock = false 
        _pressedKeys = []
        Raylib.GetFontDefault(_font)
        _arrowPoints = ValueList.new()
        _arrowPoints.create(Raylib.VALUE_TYPE_VECTOR2, 4)
        _arrowColor = Color.new(188, 188, 188, 255)
    }
    font {_font}
    font = (val) {_font = val}

    processInputs(mpos, mworldPos, camera) {
        _mousePos = mpos 
        _mouseWorldPos = mworldPos
        _camera = camera
        
        if(_editingBounds) { // only process key event on edting mode 
            var keyPress = Raylib.GetKeyPressed()
            if(!_pressedKeys.contains(keyPress)) { _pressedKeys.add(keyPress) }
            var delList = []
            for(k in _pressedKeys) { 
                if(Raylib.IsKeyReleased(k)) { // remove released key 
                    delList.add(k)
                } else if(Raylib.IsKeyPressedRepeat(k)) { // handle repeat key 
                    if(_editingSource is Num) {
                        numEditInputProcess(k, true)
                    } else if(_editingSource is String) {
                        textEditInputProcess(k, true)
                    }
                } 
            }
            for(d in delList) {_pressedKeys.remove(d)}

            if(keyPress > 0) { // hande key first press

                if(_editingSource is Num) {
                    numEditInputProcess(keyPress, false)
                } else if(_editingSource is String) {
                    textEditInputProcess(keyPress, false)
                }
            }
        }
    }

    Label(bounds, text, fontSize) {

    }

    Button(bounds, text) {

    }   

    Slider(bounds, textLeft, textRight, value, min, max) {

    }

    ComboBox(bounds, items, currentIndex, controlMap) {
        var code = 0
        var bgColor = null
        var controlling = false 
        var inBound = Raylib.CheckCollisionPointRec(_mouseWorldPos, bounds)

        if(inBound) {
            bgColor = _style.valueBoxColorActivate
        } else {
            bgColor = _style.valueBoxColorNormal
        }
        var text = items[currentIndex]
        var valTextSize = Vector2.new()
        Raylib.MeasureTextEx(valTextSize, _font, text, 10, 0)
        var textPos = Vector2.new(bounds.x + bounds.width / 2 - valTextSize.x / 2, bounds.y + bounds.height / 2 - valTextSize.y / 2)
        Raylib.DrawRectangleRounded(bounds, 0.125, 20, bgColor)
        Raylib.DrawTextEx(_font, text, textPos, _style.textSize, 0, _style.textColor)

        if(controlMap["active"] == null) { controlMap["active"] = false }

        // combo arrow shape 
        if(controlMap["active"] == true) {
            _arrowPoints.set(0, Vector2.new(bounds.x + bounds.width - 15, bounds.y + bounds.height / 2 - 4))
            _arrowPoints.set(1, Vector2.new(bounds.x + bounds.width - 15 - 5, bounds.y + bounds.height / 2 + 4))
            _arrowPoints.set(2, Vector2.new(bounds.x + bounds.width - 15 + 5, bounds.y + bounds.height / 2 + 4))
            _arrowPoints.set(3, Vector2.new(bounds.x + bounds.width - 15, bounds.y + bounds.height / 2 - 4))
            Raylib.DrawTriangleFan(_arrowPoints, _arrowPoints.count, _arrowColor)
        } else {
            _arrowPoints.set(0, Vector2.new(bounds.x + bounds.width - 15, bounds.y + bounds.height / 2 + 4))
            _arrowPoints.set(1, Vector2.new(bounds.x + bounds.width - 15 + 5, bounds.y + bounds.height / 2 - 4))
            _arrowPoints.set(2, Vector2.new(bounds.x + bounds.width - 15 - 5, bounds.y + bounds.height / 2 - 4))
            _arrowPoints.set(3, Vector2.new(bounds.x + bounds.width - 15, bounds.y + bounds.height / 2 + 4))
            Raylib.DrawTriangleFan(_arrowPoints, _arrowPoints.count, _arrowColor)
        }

        var sInBound = false 
        var sindex = currentIndex 
        if(controlMap["active"]) {
            var sh = items.count * 20
            var sw = bounds.width 
            var sx = bounds.x 
            var sy = bounds.y + bounds.height + 1
            var sr = Rectangle.new(sx, sy, sw, sh)
            Raylib.DrawRectangleRec(sr, _style.valueBoxColorNormal)
            sInBound = Raylib.CheckCollisionPointRec(_mouseWorldPos, sr)
            if(sInBound) { sindex = ((_mouseWorldPos.y - sy) / 20).floor }
            var i = 0
            for(text in items) {
                Raylib.MeasureTextEx(valTextSize, _font, text, 10, 0)
                var ssr = Rectangle.new(sr.x, sr.y + 20 * i, sr.width, 20) 
                var textPos = Vector2.new(ssr.x + ssr.width / 2 - valTextSize.x / 2, ssr.y + ssr.height / 2 - valTextSize.y / 2)
                if(i == sindex) { Raylib.DrawRectangleRec(ssr, Color.new(255, 255, 255, 70)) }
                Raylib.DrawTextEx(_font, text, textPos, _style.textSize, 0, _style.textColor)
                i = i + 1
            }
        }

        if(inBound || sInBound) {code = 1}

        if(Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_LEFT)) {
            if(inBound) {
                controlMap["active"] = !controlMap["active"] 
            } else {
                if(sInBound) { 
                    code = 2
                    controlMap["active"] = false 
                } else {
                    controlMap["active"] = false 
                }
            }
        }

        return ControlResult.new(code, [sindex])
    }

    CheckBox(bounds, text, checked) {

    }

    SpinBox(bounds, text, value, min, max, step) {

    }

    ProgressBar(bounds, text, value, min, max) {
        
    }

    ValueBox(bounds, text, value, min, max, steps) {
        var code = 0
        var controlling = false 
        if(isBoundEquals(_lockingBounds, bounds)) { controlling = true }

        var inBound = Raylib.CheckCollisionPointRec(_mouseWorldPos, bounds)

        if(inBound) {code = 1}

        if(Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_LEFT)) { 
            if(inBound) {
                _lockingBounds = bounds 
                var now = Raylib.GetTime()
                if(isBoundEquals(_checkDoubleClickBounds, bounds) && !isBoundEquals(_editingBounds, bounds)) {
                    if(now - _lastCheckDoubleClickBoundsTime < 0.2) {
                        _editingBounds = bounds
                        _checkDoubleClickBounds = null 
                        _editingSource = value 
                        _editingVal = value.toString
                    }
                }
                _checkDoubleClickBounds = bounds
                _lastCheckDoubleClickBoundsTime = now 
                if(value is Num) { Raylib.HideCursor() }
            } else {
                if(isBoundEquals(_editingBounds, bounds) && _editingVal != null) {
                    if(value is Num) {
                        _editResultVal =  _editingVal.count > 0 ? Num.fromString(_editingVal) : 0
                    } else {
                        _editResultVal = _editingVal
                    }
                    Raylib.ShowCursor()
                }
            }
        }

        var valText = isBoundEquals(_checkDoubleClickBounds, bounds) ? (_editingVal ? _editingVal : (value is Num ? value.toString : value)) : (value is Num ? value.toString : value)
        var valTextSize = Vector2.new()
        Raylib.MeasureTextEx(valTextSize, _font, valText, 10, 0)
        var textPos = Vector2.new(bounds.x + bounds.width / 2 - valTextSize.x / 2, bounds.y + bounds.height / 2 - valTextSize.y / 2)
        var tmp = value 
        var bgColor = null

        var editing = false 
        if(isBoundEquals(_editingBounds, bounds)) { editing = true }

        if(Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_LEFT) && controlling) {  
            if(value is Num) { Raylib.ShowCursor() }
            _lockingBounds = null 
            if(isBoundEquals(_hasDrag, bounds)) {
                _hasDrag = null 
                _checkDoubleClickBounds = null 
            }
        }
        if(Raylib.IsMouseButtonDown(Raylib.MOUSE_BUTTON_LEFT) && controlling) {
            if(value is Num) {
                Raylib.GetMouseDelta(_mouseDelta)
                if(_mouseDelta.x.abs > 0) {
                    _hasDrag = bounds
                }
                tmp = ((tmp * 1000).round + _mouseDelta.x * steps) / 1000
                code = 2
                var oPos = Vector2.Vector2Subtract(_mousePos, _mouseDelta)
                Raylib.SetMousePosition(oPos.x, oPos.y)
            }
        }

        if(controlling) {
            bgColor = _style.valueBoxColorActivate
        } else {
            bgColor = _style.valueBoxColorNormal
        }
        Raylib.DrawRectangleRounded(bounds, 0.125, 20, bgColor)

        Raylib.DrawTextEx(_font, valText, textPos, _style.textSize, 0, _style.textColor)

        if(editing) {
            Raylib.DrawLineV(Vector2.new(textPos.x + valTextSize.x + 2, textPos.y), Vector2.new(textPos.x + valTextSize.x + 2, textPos.y + 10), _style.textCursorColor)
        }

        if(_editResultVal != null && isBoundEquals(_editingBounds, bounds)) {
            tmp = _editResultVal
            _editResultVal = null 
            _editingVal = null
            _checkDoubleClickBounds = null 
            _editingBounds = null 
            _editingSource = null 
            Raylib.ShowCursor()
            code = 3
        }
        return ControlResult.new(code, [_editingVal ? Num.fromString(_editingVal) : tmp])
    } 

    MenuPopup(ctx) {
        var code = 0
        var bounds = ctx.bounds
        var drawItems = ctx.items 
        if(ctx.selectedIndex >= 0) {
            drawItems = ctx.subs[ctx.selectedIndex]
            bounds.height = 30 * drawItems.count 
        }

        var inIdx = -1
        if(Raylib.CheckCollisionPointRec(_mouseWorldPos, bounds)) {
            inIdx = ((_mouseWorldPos.y - bounds.y) / 30).floor 
        }
        if(Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_LEFT) && inIdx >= 0) {
            if(ctx.selectedIndex < 0) {
                ctx.selectedIndex = inIdx 
            } else {
                ctx.selectedSubIndex = inIdx 
            }
        }

        if(ctx.selectedSubIndex >= 0) { code = 1 }
        if(ctx.selectedIndex >= 0 && drawItems.count <= 0) { code = 1 }

        if(drawItems.count > 0) {
            Raylib.DrawRectangleRounded(bounds, 0.025, 20, Color.new(74, 70, 76, 200))
            for(i in 0...drawItems.count) {
                var ly = i * 30
                if(i > 0) {
                    Raylib.DrawLine(bounds.x + 4, bounds.y + ly, bounds.x + bounds.width - 4, bounds.y + ly, Color.new(120, 120, 120, 255))
                }

                var txt = drawItems[i]
                var txtSize = Vector2.new()
                Raylib.MeasureTextEx(txtSize, _font, txt, 12, 0)
                var txtPos = Vector2.new(bounds.x + bounds.width / 2 - txtSize.x / 2, bounds.y + ly + 30 / 2 - txtSize.y / 2)

                var txtColor = null 
                if(inIdx == i) {
                    txtColor = Color.new(222, 222, 222, 255)
                } else {
                    txtColor = Color.new(188, 188, 188, 255)
                }

                Raylib.DrawTextEx(_font, txt, txtPos, 12, 0, txtColor)
            }
        }

        return ControlResult.new(code, [])
    }

    // bound checking 
    isBoundEquals(a, b) {
        return !a || !b ? false : a.x == b.x && a.y == b.y && a.width == b.width && a.height == b.height
    }
    
    // number value editing control
    numEditInputProcess(keyPress, repeat) {
        if( keyPress == Raylib.KEY_ESCAPE || keyPress == Raylib.KEY_TAB) {
            while(_editingVal.count > 1 && _editingVal[0] == "0") { _editingVal = _editingVal.trimStart(_editingVal[0]) } // trimming left
            if(_editingVal.endsWith(".")) { _editingVal = _editingVal + "0" } // dot handling 
            _editResultVal =  _editingVal.count > 0 ? Num.fromString(_editingVal) : 0
        }
        if(keyPress == Raylib.KEY_BACKSPACE) { 
            _editingVal = _editingVal.count > 1 ? _editingVal[0..-2] : ""
        }
        if(keyPress >= 48 && keyPress <= 57) {
            _editingVal = _editingVal + (keyPress - 48).toString
        } else if(keyPress >= 320 && keyPress <= 329) {
            _editingVal = _editingVal + (keyPress - 320).toString
        } else if(keyPress == Raylib.KEY_PERIOD) { // dot 
            if(!_editingVal.contains(".")) {
                if(_editingVal.count <= 0) { _editingVal = _editingVal + "0" }
                _editingVal = _editingVal + "."
            }
        }
    }

    // text value editing control 
    textEditInputProcess(keyPress, repeat) {
        if(keyPress > 0) {
            System.print(keyPress)
        }
        if(keyPress >= 65 && keyPress <= 90) { // A-Z
            _editingVal = _editingVal + String.fromByte(_capsLock || Raylib.IsKeyDown(Raylib.KEY_LEFT_SHIFT) ? keyPress : keyPress + 32)
        } else if(keyPress >= 48 && keyPress <= 57) { // Number
            _editingVal = _editingVal + (keyPress - 48).toString 
        } else if(keyPress >= 320 && keyPress <= 329) { // Number
            _editingVal = _editingVal + (keyPress - 320).toString 
        } else if(keyPress == Raylib.KEY_CAPS_LOCK) { // capslock
            _capsLock = !_capsLock
        } else if(keyPress == Raylib.KEY_BACKSPACE) { // backspace 
            _editingVal = _editingVal.count > 1 ? _editingVal[0..-2] : "" 
        } else if(keyPress == Raylib.KEY_ESCAPE || keyPress == Raylib.KEY_TAB) { // finish editing 
            _editResultVal = _editingVal
        } else if(keyPress == Raylib.KEY_SLASH) {
            _editingVal = _editingVal + "/"
        }
    }
}