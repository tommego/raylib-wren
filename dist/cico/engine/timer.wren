import "cico.raylib" for Raylib
import "cico/engine/signalslot" for Signal 

class Timer {
    construct new() {
        initprops_()
    }
    construct new(map) {
        initprops_()
        parse(map)
    }
    initprops_() {
        _id = TimerMgr.genId()
        _repeat = true 
        _interval = 1
        _abort = false 
        _startTime = 0
        _triggered = Signal.new(this)
    }
    repeat{_repeat}
    repeat=(val){_repeat = val}
    interval{_interval}
    interval=(val){_interval = val}
    abort{_abort}
    triggered{_triggered}
    startTime{_startTime}
    startTime=(val){_startTime = val}
    start() {
        _startTime = Raylib.GetTime()
        _abort = false 
        TimerMgr.startTimer(this)
    }
    stop() {
        _abort = true 
        TimerMgr.stopTimer(this)
    }
    restart() {
        stop() 
        start()
    }
    parse(map) {
        if(map.keys.contains("interval")) {_interval = map["interval"]}
        if(map.keys.contains("repeat")) {_repeat = map["repeat"]}
        if(map.keys.contains("triggered")) {_triggered.connect(map["triggered"])}
    }

    static singleShot(interval, fn) {
        Timer.new({"interval": interval, "triggered": fn}).start()
    }
}


class TimerMgr {
    static init() {
        __idcounter = 0
        __timers = []
    }

    static tick() {
        var now = Raylib.GetTime()
        var dels = []
        for(timer in __timers) {
            if(timer.abort) {
                dels.add(timer)
            } else {
                if(now - timer.startTime >= timer.interval) {
                    timer.startTime = now 
                    timer.triggered.emit(null)
                    if(!timer.repeat) {
                        dels.add(timer)
                    }
                }
            }
        }

        for(d in dels) { __timers.remove(d) }
    }

    static genId() {
        var ret = __idcounter
        __idcounter = __idcounter + 1
        return ret 
    }

    static startTimer(timer) {
        __timers.add(timer)
    }

    static stopTimer(timer) {
        if(__timers.contains(timer)) { __timers.remove(timer) }
    }
}