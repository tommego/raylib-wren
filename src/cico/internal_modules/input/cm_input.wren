class EventType {
    static KeyEvent { 0 }
    static MouseEvent { 1 }
}

class Event {
    construct new(type) {
        _type = type
    }
    type { _type }
    type = (t) { _type = t }
}

class KeyEvent is Event{
    construct new(key, name, pressed, repeated) {
        super(EventType.KeyEvent)
        _name = name 
        _pressed = pressed
        _repeated = repeated
        _key = key 
    }

    key { _key }
    key = (val) { _key = key }
    name { _name }
    name = (val) { _name = val }
    pressed { _pressed }
    pressed = (val) { _pressed = val }
    repeated { _repeated }
    repeated = (val) { _repeated = val }
}

class MouseEvent is Event {
    construct new(btn, pressed) {
        super(EventType.MouseEvent)
        _btn = btn 
        _pressed = pressed
    }

    btn { _btn }
    btn = (val) { _btn = val }
    pressed { _pressed }
    pressed = (val) { _pressed = val }
}