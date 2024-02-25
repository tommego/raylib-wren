import "./shapes/line" for ShapeLine
import "./shapes/page" for Page 
import "./shapes/rect" for ShapeRect
import "./shapes/objectbase" for ObjectBase
import "./shapes/triangle" for ShapeTriangle
import "cico/engine/signalslot" for Signal 
import "cico.raylib" for Raylib, Color, RenderTexture,Camera2D,Vector2,Vector3,Matrix,Texture,Rectangle
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/scenegraph2d" for Border

class Editor {
    static init() {
        __canvas = null 
        __shapeCounter = {}
        __operatorMap = {
            ShapeLine: Fn.new{|c,mp,mwp,ip,ir| Editor.shapeOperator(ShapeLine, c, mp, mwp, ip, ir)},
            ShapeRect: Fn.new{|c,mp,mwp,ip,ir| Editor.shapeOperator(ShapeRect, c, mp, mwp, ip, ir)},
            ShapeTriangle: Fn.new{|c,mp,mwp,ip,ir| Editor.shapeOperator(ShapeTriangle, c, mp, mwp, ip, ir)}
        }
        __operator = null 
        __operatorChanged = Signal.new(null)
        __pages = []
        __currentPage = null
        __pageCounter = 1
        __pagesChanged = Signal.new(null)
        __currentPageChanged = Signal.new(null)
        __pageAdded = Signal.new(null)
        __pageRemoved = Signal.new(null)
        __currentPageIndex = 0
        __currentPageIndexChanged = Signal.new(null)
        __cpos = Vector2.new()
        __draggingShapes = []
        __mouseDelta = Vector2.new()
    }
    static canvas{__canvas}
    static canvas=(val){
        __canvas = val 
        if(__canvas) { 
            __canvas.editor = Editor 
            __selectRect = ObjectBase.new(__canvas, {
                "color": Color.fromString("#3333aaff"),
                "border": Border.new(1.5 / __canvas.zoom, Color.fromString("#33aaff")),
                "visible": false,
                "z": 33,
                "name": "selectRect" 
            })
        }
    }
    static pages{__pages}
    static currentPageIndex{__currentPageIndex}

    static createShape(shape, map) {
        if(!__shapeCounter[shape]) {__shapeCounter[shape] = 1} 
        var shapeName = map["name"]
        map["canvas"] = __canvas
        map["dragEnabled"] = true 
        if(!map.keys.contains("name")) {
            map["name"] = "%(shape)%(__shapeCounter[shape])" 
            shapeName = map["name"]
        }
        var inst = shape.new(__currentPage, map)
        inst.dragEnabled = true 
        __shapeCounter[shape] = __shapeCounter[shape] + 1
        __currentPage.selectShape(inst)
        System.print("Shape %(shapeName) created")
        return inst 
    }
    static createPage(map) {
        map["name"] = "页%(__pageCounter)"
        map["canvas"] = __canvas
        var page = Page.new(__canvas, map)
        if(__pages.count > 0) {
            page.x = __pages[-1].x + __pages[-1].width + 100
        } else {
            page.x = 50
        }
        page.y = 50
        __pages.add(page)
        __pagesChanged.emit(__pages)
        __pageAdded.emit(page)
        Editor.selectPage(__pages.count -1)
        __pageCounter = __pageCounter + 1
    }
    static removePage(index) {
        __canvas.removeNode(__pages[index])
        __pages.removeAt(index)
        __pageRemoved.emit(index)
        index = index.min(__pages.count -1)
        Editor.selectPage(index)
        var cx = 50
        for(p in __pages) {
            p.x = cx 
            cx = cx + p.width + 100
        }
    }
    static selectPage(index) {
        if(index < __pages.count && index >= 0) {
            __currentPage = __pages[index]
        } else {
            __currentPage = null 
        }
        if(__currentPageIndex != index) {
            __currentPageIndex = index 
            __currentPageChanged.emit(__currentPage)
            __currentPageIndexChanged.emit(__currentPageIndex)
            for(i in 0...__pages.count) { __pages[i].selected = (i == __currentPageIndex)}
        }
    }
    static changeOperator(shape) {
        if(__operatorMap.keys.contains(shape)) {
            __operator = __operatorMap[shape]
        } else {
            __operator = null 
        }
        __operatorChanged.emit(__operator)
    }

    static processInput(camera, mousePos, mouseWorldPos) {
        if(!__mousePressedPos) {__mousePressedPos = Vector2.new()}
        if(!__inputCounter) {__inputCounter = 0} 
        if(!__mousePressed) { __mousePressed = false} 
        var isMousePressed = Raylib.IsMouseButtonPressed(Raylib.MOUSE_BUTTON_LEFT)
        var isMouseReleased = Raylib.IsMouseButtonReleased(Raylib.MOUSE_BUTTON_LEFT)
        if(isMousePressed) {
            for(idx in 0...__pages.count) {
                var inPage = (mouseWorldPos.x >= __pages[idx].x && mouseWorldPos.x <= __pages[idx].x + __pages[idx].width && mouseWorldPos.y >= __pages[idx].y && mouseWorldPos.y <= __pages[idx].y + __pages[idx].height)
                if(inPage) {  Editor.selectPage(idx) }
            }
        }
        if(__currentPage) {
            __cpos.x = mouseWorldPos.x - __currentPage.x 
            __cpos.y = mouseWorldPos.y - __currentPage.y 
        }

        if(__currentPage) {
            if(__operator) { 
                __operator.call(camera, mousePos, mouseWorldPos, isMousePressed, isMouseReleased)
            } else { // select, drag
                Editor.defaultOperator(camera, mousePos, mouseWorldPos, isMousePressed, isMouseReleased)
            }
        }
    }

    static shapeOperator(shape, camera, mousePos, mouseWorldPos, isMousePressed, isMouseReleased) {
        var inPage = (__cpos.x >= 0 && __cpos.x <= __currentPage.width && __cpos.y >= 0 && __cpos.y <= __currentPage.height)
        if(isMousePressed && !__mousePressed && inPage) {
            __mousePressed = true 
            __mousePressedPos = Vector2.new(mouseWorldPos.x, mouseWorldPos.y)
            __curShape = Editor.createShape(shape, {"width": 1, "height": 1, "color": Color.fromString("#aaaaaa"), "x": __cpos.x, "y": __cpos.y})
            __curShape.onStart(camera, mousePos, mouseWorldPos)
        }

        if(__mousePressed && __curShape) {
            __curShape.onMove(camera, mousePos, mouseWorldPos)
        }

        if(isMouseReleased && __mousePressed) {
            __mousePressed = false 
            __curShape.onFinished()
            Editor.changeOperator(null)
        }
    }

    static defaultOperator(camera, mousePos, mouseWorldPos, isMousePressed, isMouseReleased) {
        __cpos.x = mouseWorldPos.x - __currentPage.x 
        __cpos.y = mouseWorldPos.y - __currentPage.y 
        var inPage = (__cpos.x >= 0 && __cpos.x <= __currentPage.width && __cpos.y >= 0 && __cpos.y <= __currentPage.height)

        if(isMouseReleased) {
            if(!__dragging) {
                var selectedShapded = null 
                for(child in __currentPage.childrenByType(ObjectBase)) {
                    if(Raylib.CheckCollisionPointRec(mouseWorldPos, child.finalBounds)) {
                        selectedShapded = child
                    }
                }
                __currentPage.selectShape(selectedShapded)
            }
            __dragging = false 

            // 区域框多选
            if(__selectRect.width > 0 && __selectRect.height > 0) {
                var bounds= __selectRect.finalBounds
                var inboxes = []
                for(child in __currentPage.childrenByType(ObjectBase)) {
                    if(Editor.isInBox(child.finalBounds, bounds)) {
                        inboxes.add(child)
                    }
                }
                __currentPage.selectShapes(inboxes)
                __draggingShapes = inboxes
            }

            __selectRect.visible = false 
            __selectRect.width = 0
            __selectRect.height = 0
        }

        if(isMousePressed) {
            var pressedShape = null 
            for(child in __currentPage.childrenByType(ObjectBase)) {
                if(Raylib.CheckCollisionPointRec(mouseWorldPos, child.finalBounds)) {
                    pressedShape = child
                }
            }
            if(pressedShape && !__draggingShapes.contains(pressedShape)) {
                __draggingShapes = []
                __currentPage.selectShape(pressedShape)
                __draggingShapes.add(pressedShape)
            }
            if(!pressedShape) { __draggingShapes = [] }
            if(__draggingShapes.count > 0) {
                __dragging = true
            }
            if(!pressedShape) {
                __selectRect.x = mouseWorldPos.x 
                __selectRect.y = mouseWorldPos.y 
                __selectRect.width = 0
                __selectRect.height = 0
                __selectRect.visible = true 
            }            
            __mousePressedPos = Vector2.new(mouseWorldPos.x, mouseWorldPos.y)
        }

        if(__dragging && __draggingShapes.count > 0) {
            Raylib.GetMouseDelta(__mouseDelta)
            __mouseDelta.x = __mouseDelta.x * 1.0 / __canvas.zoom
            __mouseDelta.y = __mouseDelta.y * 1.0 / __canvas.zoom
            for(shape in __draggingShapes) {
                shape.x = shape.x + __mouseDelta.x
                shape.y = shape.y + __mouseDelta.y
            }
        }

        if(__selectRect.visible) {
            var w = mouseWorldPos.x - __mousePressedPos.x 
            var h = mouseWorldPos.y - __mousePressedPos.y 
            var dw = __selectRect.width - w.abs 
            var dh = __selectRect.height - h.abs 
            if(w < 0) { __selectRect.x = __selectRect.x + dw }
            if(h < 0) { __selectRect.y = __selectRect.y + dh }
            __selectRect.width = w.abs 
            __selectRect.height = h.abs
        }
    }

    // signals 
    static pageAdded{__pageAdded}
    static pageRemoved{__pageRemoved}
    static currentPageIndexChanged{__currentPageIndexChanged}
    static operatorChanged{__operatorChanged}

    static isInBox(src, dst) { src.x >= dst.x && src.x + src.width <= dst.x + dst.width && src.y >= dst.y && src.y + src.height <= dst.y + dst.height }
}