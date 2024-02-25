import "cico.raylib" for Raylib

class Signal {
    construct new(emitter) { 
        _emitter = emitter 
        _id = SignalMgr.genId()
    }
    emitter{_emitter}
    emitter=(val){_emitter = val}
    emit(args) { SignalMgr.emit(_id, _emitter, args) } 
    emit() { SignalMgr.emit(_id, _emitter, null) }
    connect(fn) { SignalMgr.connect(_id, fn) }
    disconnect(fn) { SignalMgr.disconnect(_id, fn) }
    disconnect() { SignalMgr.disconnect(_id) }
}

class SignalMgr {
    static connect(signal, fn) {
        checkInit()
        if(!__signalMap.keys.contains(signal)) { __signalMap[signal] = [] }
        if(!__signalMap[signal].contains(fn)) { __signalMap[signal].add(fn) }
    }
    static disconnect(signal, fn) {
        checkInit()
        if(!__signalMap.keys.contains(signal)) { __signalMap[signal] = [] }
        if(__signalMap[signal].contains(fn)) { __signalMap[signal].remove(fn) }
    }
    static disconnect(signal) {
        checkInit()
        __signalMap[signal] = []
    }
    static emit(signal, emitter, args) {
        checkInit()
        if(!__signalMap.keys.contains(signal)) { __signalMap[signal] = [] }
        for(fn in __signalMap[signal]) { 
            __cmds.add({"id": signal, "fn": fn, "emitter": emitter, "args": args})
        }
    }
    static genId() {
        checkInit()
        var ret = __idcounter
        __idcounter = __idcounter + 1
        return ret 
    }
    static checkInit() {
        if(!__signalMap) { 
            __signalMap = {} 
            __idcounter = 0
            __cmds = []
            __loop = Fiber.new{
                while(true) {
                    while(__cmds.count > 0) {
                        var cmd = __cmds[0]
                        __cmds.removeAt(0)
                        cmd["fn"].call(cmd["emitter"], cmd["args"])
                    }
                    Fiber.yield()
                }
            }
        }
    }

    static trigger() {
        __loop.call()
        // while(__cmds.count > 0) {
        //     var cmd = __cmds[0]
        //     __cmds.removeAt(0)
        //     cmd["fn"].call(cmd["emitter"], cmd["args"])
        // }
    }
}
