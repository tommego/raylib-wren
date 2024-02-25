import "../scenegraph2d" for SgItem,SceneGraph2D,SgEvent,Border
import "../rectangle" for SgRectangle
import "./button" for SgButton
import "../../signalslot" for Signal
import "./style" for ControlStyle
import "../layout" for SgRow
import "./label" for SgLabel
import "cico.raylib" for Raylib,Font,Rectangle,Vector2,Vector3,Vector4,Color,ValueList

class SgSpinBox is SgRow {
    construct new() {
        super()
        initSpinBoxProps_()
    }

    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(parent)
        } else {
            super() 
        }
        initSpinBoxProps_()
        if(dynamic is Map) {
            parse(map)
        }
    }

    construct new(parent, map) {
        super(parent)
        initSpinBoxProps_()
        parse(map)
    }

    initSpinBoxProps_() {
        _min = 0
        _max = 100
        _stepSize = 1
        _value = 0

        _leftBtn = SgButton.new(this, {
            "text": "-",
            "fontSize": 18,
            "width": 25,
            "height": 25,
            "clicked": Fn.new{|e,v| stepLeft()},
            "textColor": Color.new(88, 88, 88, 255)
        })
        _content = SgRectangle.new(this, {
            "width": 80,
            "height": 25,
            "border": Border.new(1, Color.new(188, 188, 188, 255)),
            "children": [
                SgLabel.new(_content, {
                    "text": "%(_value)",
                    "fontSize": 14,
                    "color": Color.new(88, 88, 88, 255),
                    "y": 5,
                    "x": 45
                })
            ]
        }) 
        _rightBtn = SgButton.new(this, {
            "text": "+",
            "fontSize": 18,
            "width": 25,
            "height": 25,
            "clicked": Fn.new{|e,v| stepRight()},
            "textColor": Color.new(88, 88, 88, 255)
        })

        _content.children[0].x = _content.width / 2 - _content.children[0].width / 2
        _content.children[0].y = _content.height / 2 - _content.children[0].height / 2

        _valueChanged = Signal.new(this)
        _minChanged = Signal.new(this)
        _maxChanged = Signal.new(this)
        _stepSizeChanged = Signal.new(this)
        _valueChanged.connect{|e,v|
            _content.children[0].text = "%(v)"
            _content.children[0].x = _content.width / 2 - _content.children[0].width / 2
            _content.children[0].y = _content.height / 2 - _content.children[0].height / 2
        }

    }

    value{_value}
    value=(val) {
        if(_value != val) {
            _value = val 
            _valueChanged.emit(val)
        }
    }
    min{_min}
    min=(val) {
        if(_min != val) {
            _min = val 
            _minChanged.emit(val)
            this.value = _value.max(_min)
        }
    }
    max{_max}
    max=(val) {
        if(_max != val) {
            _max = val 
            _maxChanged.emit(val)
            this.value = _value.min(_max)
        }
    }
    stepSize{_stepSize}
    stepSize=(val){
        if(_stepSize != val) {
            _stepSize = val 
            _stepSizeChanged.emit(val)
        }
    }
    minChanged{_minChanged}
    maxChanged{_maxChanged}
    valueChanged{_valueChanged}
    stepSizeChanged{_stepSizeChanged}
    stepLeft() { this.value = (_value - _stepSize).max(_min) }
    stepRight() { this.value = (_value + _stepSize).min(_max) }
    parse(map) {
        super.parse(map)
        if(map.keys.contains("min")) { this.min = map["min"] }  
        if(map.keys.contains("max")) { this.max = map["max"] }  
        if(map.keys.contains("value")) { this.value = map["value"] }
        if(map.keys.contains("stepSize")) { this.stepSize = map["stepSize"] }    
    }
}