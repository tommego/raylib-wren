import "cico.math" for Easing 
import "cico.raylib" for Raylib, Vector2, Vector3, Vector4, Color

class EasingType {
    static Linear{0}
    static InQuad{1}
    static OutQuad{2}
    static InOutQuad{3}
    static InCubic{4}
    static OutCubic{5}
    static InOutCubic{6}
    static InQuart{7}
    static OutQuart{8}
    static InOutQuart{9}
    static InQuint{10}
    static OutQuint{11}
    static InOutQuint{12}
    static InSine{13}
    static OutSine{14}
    static InOutSine{15}
    static InExpo{16}
    static OutExpo{17}
    static InOutExpo{18}
    static InCirc{19}
    static OutCirc{20}
    static InOutCirc{21}
    static InBack{22}
    static OutBack{23}
    static InOutBack{24}
    static InElastic{25}
    static OutElastic{26}
    static InOutElastic{27}
    static InBounce{28}
    static OutBounce{29}
    static InOutBounce{30}
}

class Anim {
    construct new(easing, from, to, fnChanged, fnFinished, duration, target) {
        _ease = easing
        _cbChanged = fnChanged
        _cbFinished = fnFinished
        _duration = duration
        _isPlaying = false 
        _isDone = false 
        _from = from
        _to = to 
        _time = Raylib.GetTime()
        _target = target
        _loops = 1
        _loopsLeft = 1
    }
    construct new(easing, from, to, fnChanged, fnFinished, duration, target, loops) {
        _ease = easing
        _cbChanged = fnChanged
        _cbFinished = fnFinished
        _duration = duration
        _isPlaying = false 
        _isDone = false 
        _from = from
        _to = to 
        _time = Raylib.GetTime()
        _target = target
        _loops = loops
        _loopsLeft = loops
    }
    ease{_ease}
    from{_from}
    to{_to}
    cbChanged{_cbChanged}
    cbFinished{_cbFinished}
    duration{_duration}
    time{_time}
    time=(val){_time = val}
    isDone{_isDone}
    isDone=(val){_isDone = val}
    isPlaying{_isPlaying}
    isPlaying=(val){_isPlaying = val}
    target{_target}
    loops{_loops}
    loops=(val){_loops = val}
    loopsLeft{_loopsLeft}
    loopsLeft=(val){_loopsLeft = val}
}

class Tween {
    static init() {
        __anims = []
        // cal value cached 
        __v2 = Vector2.new()
        __v3 = Vector3.new()
        __v4 = Vector4.new()
        __c = Color.new() 
    }
    static anims {__anims}
    static update() {
        var lstDel = []
        for(ani in __anims) {
            var t = Raylib.GetTime() - ani.time 
            var lastIsDone = ani.isDone
            ani.isDone = t >= ani.duration 
            ani.isPlaying = t <= ani.duration  && !ani.isDone
            var p = 0
            var vchanged = false
            var finished = false
            if(ani.isPlaying) { 
                p = t / ani.duration 
                vchanged = true
            }  
            if(ani.isDone && lastIsDone != ani.isDone) {
                p = 1
                vchanged = true
                finished = true
            }

            if(vchanged) {
                var val = Easing.easing_(p, ani.ease)
                var ret = null 
                if(ani.from is Num) { 
                    ret = ani.from + (ani.to - ani.from) * val 
                } else if(ani.from is Vector2) {
                    __v2.x = ani.from.x + (ani.to.x - ani.from.x) * val
                    __v2.y = ani.from.y + (ani.to.y - ani.from.y) * val
                    ret = __v2
                } else if(ani.from is Vector3) {
                    __v3.x = ani.from.x + (ani.to.x - ani.from.x) * val
                    __v3.y = ani.from.y + (ani.to.y - ani.from.y) * val
                    __v3.z = ani.from.z + (ani.to.z - ani.from.z) * val
                    ret = __v3
                } else if(ani.from is Vector4) {
                    __v4.x = ani.from.x + (ani.to.x - ani.from.x) * val
                    __v4.y = ani.from.y + (ani.to.y - ani.from.y) * val
                    __v4.z = ani.from.z + (ani.to.z - ani.from.z) * val
                    __v4.w = ani.from.w + (ani.to.w - ani.from.w) * val
                    ret = __v4
                } else if(ani.from is Color) {
                    __c.r = ani.from.r + (ani.to.r - ani.from.r) * val
                    __c.g = ani.from.g + (ani.to.g - ani.from.g) * val
                    __c.b = ani.from.b + (ani.to.b - ani.from.b) * val
                    __c.a = ani.from.a + (ani.to.a - ani.from.a) * val
                    ret = __c
                }
                if(ani.cbChanged) { ani.cbChanged.call(ani.target, ret) }
            }

            if(finished) { 
                ani.loopsLeft = ani.loopsLeft -1 
                if(ani.loops > 0) {
                    if(ani.loopsLeft > 0) { 
                        ani.time = Raylib.GetTime() 
                    } else {
                        if(ani.cbFinished) { ani.cbFinished.call(ani.target) }
                        lstDel.add(ani)
                    }
                } else {
                    ani.time = Raylib.GetTime()
                }
            }
        }

        // remove finished animation 
        for(ani in lstDel) { __anims.remove(ani) }
    }
    static add(ani) {
        if(!__anims.contains(ani)) {
            __anims.add(ani)
        }
    }
    static remove(ani) {
        if(__anims.contains(ani)) {
            __anims.remove(ani)
        }
    }
    static create(map) {
        var easing = EasingType.Linear
        var from = 0
        var to = 1
        var fnChanged = null 
        var fnFinished = null
        var duration = 0.2
        var target = null
        var loops = 1
        if(map.keys.contains("easing")) { easing = map["easing"] }
        if(map.keys.contains("from")) { from = map["from"] }
        if(map.keys.contains("to")) { easing = map["to"] }
        if(map.keys.contains("fnChanged")) { fnChanged = map["fnChanged"] }
        if(map.keys.contains("fnFinished")) { fnFinished = map["fnFinished"] }
        if(map.keys.contains("duration")) { duration = map["duration"] }
        if(map.keys.contains("target")) { target = map["target"] }
        if(map.keys.contains("loops")) { loops = map["loops"] }
        var ani = Anim.new(easing, from, to, fnChanged, fnFinished, duration, target, loops)
        Tween.add(ani)
        return ani 
    }
    static createArgs(args) {
        var ani = Anim.new(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7])
        Tween.add(ani)
        return ani 
    }
    static reset() {
        for(ani in __anims) {
            if(ani.cbFinished) { ani.cbFinished.call(ani.target) }
        }
        __anims = []
    }
}