import "../scenegraph2d" for SgItem,SgEvent
import "./listmodel" for ListModel
import "./listview" for SgListView
import "../../signalslot" for Signal
import "../../tween" for Tween,EasingType
import "../../math" for Math 
import "cico.raylib" for Raylib,Color

class SgSwipeView is SgItem {
    construct new() {
        super()
        initSwipeViewProps_()
    }

    construct new(dynamic) {
        if(dynamic is SgItem) {
            super(dynaimc)
        }
        initSwipeViewProps_()
        if(dynamic is Map) {parse(dynamic)}
    }

    construct new(parent, map) {
        super(parent)
        initSwipeViewProps_()
        parse(map)
    }

    initSwipeViewProps_() {
        this.clip = true 
        _currentIndex = 0
        this.childAdded.connect{|e,v| handleChildAdded(v)}
        this.childRemoved.connect{|e,v| handleChildRemoved(v)}
        this.widthChanged.connect{|e,v| 
            for(child in children) { child.width = this.width  }
            children[_currentIndex].visible =  true
        }
        this.heightChanged.connect{|e,v|
            for(child in children) { child.height = this.height }
            children[_currentIndex].visible =  true
        }
        _moveCurve = EasingType.OutQuad
        _moveDuration = 0.15
    }

    currentIndex{_currentIndex}
    currentIndex=(val) {
        if(_currentIndex != val) { swipeTo(val) }
    }
    moveDuration{_moveDuration}
    moveDuration=(val){_moveDuration}
    moveCurve{_moveCurve}
    moveCurve=(val){_moveCurve=val}

    parse(map) {
        super.parse(map)
        if(map.keys.contains("moveCurve")) { this.moveCurve = map["moveCurve"] }
        if(map.keys.contains("moveDuration")) { this.moveCurve = map["moveDuration"] }
    }

    handleChildAdded(child) {
        var idx = indexOf(child)
        child.width = this.width 
        child.height = this.height 
        if(idx > 0) { child.extra["prev"] = children[idx -1] }
        child.y = 0
        if(idx == _currentIndex) {
            child.x = 0
            child.visible = true 
        } else {
            child.x = idx > _currentIndex ? width : -width 
            child.visible = false 
        }
    }
    handleChildRemoved(child) {
        for(i in children.count) {
            var c = children[i]
            if(c.extra["prev"] == child) {
                if(i > 0) { 
                    c.extra["prev"] = children[i - 1] 
                } else {
                    c.extra["prev"] = null 
                }
            }
        }
    }

    swipeRight() {
        var prevIdx = _currentIndex
        _currentIndex = Math.ringIdx(_currentIndex + 1, children.count)
        children[prevIdx].visible = true 
        children[_currentIndex].visible = true 
        Tween.create({
            "easing": _moveCurve,
            "target": children[prevIdx],
            "fnChanged": Fn.new{|target, val| target.x = -(width + 1) * val },
            "fnFinished": Fn.new{|target| target.visible = false },
            "duration": _moveDuration
        })
        Tween.create({
            "easing": _moveCurve,
            "target": children[_currentIndex],
            "fnChanged": Fn.new{|target, val| 
                target.x = width - (width) * val 
                target.visible = true
            },
            "duration": _moveDuration
        })
    }

    swipeLeft() {
        var prevIdx = _currentIndex
        _currentIndex = Math.ringIdx(_currentIndex - 1, children.count)
        children[prevIdx].visible = true 
        children[_currentIndex].visible = true 
        Tween.create({
            "easing": _moveCurve,
            "target": children[prevIdx],
            "fnChanged": Fn.new{|target, val| target.x = width * val },
            "fnFinished": Fn.new{|target| target.visible = false },
            "duration": _moveDuration
        })
        Tween.create({
            "easing": _moveCurve,
            "target": children[_currentIndex],
            "fnChanged": Fn.new{|target, val| 
                target.x = width * val - width 
                target.visible = true
            },
            "duration": _moveDuration
        })
    }

    swipeTo(idx) {
        var ridx = Math.ringIdx(idx, children.count)
        var step = (_currentIndex - ridx).abs 
        var dir = ridx - _currentIndex
        for(i in 0...step) {
            if(dir > 0) {
                swipeRight()
            } else {
                swipeLeft()
            }
        }
    }
}