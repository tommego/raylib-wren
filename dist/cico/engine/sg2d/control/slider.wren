import "../scenegraph2d" for SgItem,SceneGraph2D,SgEvent, Border
import "../rectangle" for SgRectangle
import "../../signalslot" for Signal
import "./style" for ControlStyle
import "cico.raylib" for Raylib,Font,Rectangle,Vector2,Vector3,Vector4,Color
class SgSlider is SgItem {
    construct new() {
        super()
        initSliderProps_()
    }
    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynamic)
        } else {
            super()
        }
        initSliderProps_()
        if(dynamic is Map) { parse(dynamic) }
    }
    construct new(parent, map) {
        super(parent)
        initSliderProps_() 
        parse(map)
    }

    initSliderProps_() {
        this.width = 200
        this.height = 30
        _background = SgRectangle.new(this, {
            "width": 200,
            "height": 12,
            "radius": 12,
            "y": 9,
            "color": ControlStyle["slider"]["background"]["color"]
        })

        _slot = SgRectangle.new(this, {
            "width": 0,
            "height": 12,
            "radius": 12,
            "y": 9,
            "color": ControlStyle["slider"]["slot"]["color"]
        })

        _indicator = SgRectangle.new(this, {
            "width": 30,
            "height": 30,
            "color": ControlStyle["slider"]["indicator"]["color"],
            "radius": 30,
            "border": Border.new(ControlStyle["default"]["border"]["width"], ControlStyle["default"]["border"]["color"]),
            "x": -15
        })

        _minValue = 0
        _maxValue = 1
        _value = 0
        _pressed = false 

        _minValueChanged = Signal.new(this)
        _maxValueChanged = Signal.new(this)
        _valueChanged = Signal.new(this)

        _mousePos = null 
        _dragging = false 

        _refreshGeo = Fn.new{|e,v|
            _background.width = this.width 
            if(_minValue != _maxValue) {
                var percent = (_value - _minValue) / (_maxValue - _minValue)
                var cw = _background.width * percent 
                _indicator.x = cw - _indicator.width / 2
                _indicator.x = _indicator.x.min( _background.width - _indicator.width / 2)
                _slot.width = cw
                _slot.width = _slot.width.min(_background.width)
            }
        }

        _minValueChanged.connect(_refreshGeo)
        _maxValueChanged.connect(_refreshGeo)
        _valueChanged.connect(_refreshGeo)
        this.widthChanged.connect(_refreshGeo)
        this.heightChanged.connect(_refreshGeo)
    }

    minValue{_minValue}
    minValue=(val){
        if(_minValue != val) {
            _minValue = val 
            _minValueChanged.emit(val)
        }
    }
    maxValue{_maxValue}
    maxValue=(val) {
        if(_maxValue != val) {
            _maxValue = val 
            _maxValueChanged.emit(val)
        }
    }
    value{_value}
    value=(val){
        if(_value != val) {
            _value = val 
            _valueChanged.emit(val)
        }
    }
    background{_background}
    slot{_slot}
    indicator{_indicator}

    static Horizontal{0}
    static Vertical{1}

    parse(map) {
        super.parse(map)
        if(map.contains("minValue")) { this.minValue = map["minValue"]}
        if(map.contains("maxValue")) { this.maxValue = map["maxValue"]}
        if(map.contains("value")) { this.value = map["value"]}
    }

    onEvent(event) {
        var ret = super.onEvent(event)
        if(event.type == SgEvent.MousePressed && event.data["key"] == Raylib.MOUSE_BUTTON_LEFT) {
            var pos = event.data["position"]
            _mousePos = pos 
            if(Raylib.CheckCollisionPointRec(pos, Rectangle.new(_indicator.x, _indicator.y, _indicator.width, _indicator.height))) { 
                _dragging = true 
            }
            ret = 1
        } else if(event.type == SgEvent.MouseRelease && event.data["key"] == Raylib.MOUSE_BUTTON_LEFT) {
            ret = 1
            if(!_dragging) {
            }
            var p = _mousePos.x / _background.width 
            var step = p * (_maxValue - _minValue)
            var real = step.max(_minValue)
            real =  real.min(_maxValue)
            this.value = real
            _dragging = false 
        } else if(event.type == SgEvent.MouseMove && _dragging) {
            var pos = event.data["position"]
            var p = pos.x / _background.width 
            var step = p * (_maxValue - _minValue)
            var real = step.max(_minValue)
            real =  real.min(_maxValue)
            this.value = real
        }
        return ret 
    }
}