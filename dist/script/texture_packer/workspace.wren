import "cico/engine/signalslot" for Signal 
import "cico.os.sys" for Platform
import "cico.raylib" for Raylib,Rectangle,Image,Color
import "cico/utils/serializer" for Serializer
import "cico.json" for Json 
import "cico.os.file" for File 

class Workspace {
    static init() {
        if(!__inited) {
            __inited = true 
            __hoverIndex = -1
            __selectedIndex = -1
            __maxSize = 1024
            __math = 0
            __scale = 1
            __alphaMode = 0
            __exportEnabled = false 
            __exportRects = []
            __exportSize = Rectangle.new()
            __hoverIndexChanged = Signal.new(this)
            __selectedIndexChanged = Signal.new(this)
            __maxSizeChanged = Signal.new(this)
            __mathChanged = Signal.new(this)
            __scaleChanged = Signal.new(this)
            __alphaModeChanged = Signal.new(this)
            __exportEnabledChanged = Signal.new(this)
        }
    }
    static hoverIndex{__hoverIndex}
    static hoverIndex=(val){
        if(__hoverIndex != val) {
            __hoverIndex = val 
            __hoverIndexChanged.emit(val)
        }
    }
    static hoverIndexChanged{__hoverIndexChanged}
    static selectedIndex{__selectedIndex}
    static selectedIndex=(val){
        if(__selectedIndex != val) {
            __selectedIndex = val 
            __selectedIndexChanged.emit(val)
        }
    }
    static selectedIndexChanged{__selectedIndexChanged}
    static maxSize{__maxSize}
    static maxSize=(val){
        if(__maxSize != val){
            __maxSize = val 
            __maxSizeChanged.emit(val)
        }
    }
    static maxSizeChanged{__maxSizeChanged}
    static math{__math}
    static math=(val) {
        if(__math != val) {
            __math = val 
            __mathChanged.emit(val)
        }
    }
    static mathChanged{__mathChanged}
    static scale{__scale}
    static scale=(val){
        if(__scale != val){
            __scale = val 
            __scaleChanged.emit(val)
        }
    }
    static scaleChanged{__scaleChanged}
    static alphaMode{__alphaMode}
    static alphaMode=(val) {
        if(__alphaMode != val) {
            __alphaMode = val 
            __alphaModeChanged.emit(val)
        }
    }
    static alphaModeChanged{__alphaModeChanged}

    static exportEnabled{___exportEnabled}
    static exportEnabled=(val) {
        if(__exportEnabled != val) {
            __exportEnabled = val 
            __exportEnabledChanged.emit(val )
        }
    }
    static exportEnabledChanged{__exportEnabledChanged}

    static exportSize{__exportSize}
    static exportSize=(val){__exportSize = val}
    static exportRects{__exportRects}
    static exportRects=(val){__exportRects=(val)}

    static export() {
        var dir_dst = Platform.selectFolder()
        if(dir_dst != "") {
            var png_dst = Platform.platform == "windows" ? "%(dir_dst)\\skin.png" : "%(dir_dist)/skin.png"
            var json_dst = Platform.platform == "windows" ? "%(dir_dst)\\skin.json" : "%(dir_dist)/skin.json"
            System.print("exporting to %(dir_dst) %(png_dst) %(json_dst)")
            System.print("export size: %(exportSize.width) %(exportSize.height) sprites: %(exportRects)")
            // export json file 
            {
                var metaInfo = {
                    "app": "wren texture packer",
                    "format": "RGBA8888",
                    "image": "skin.png",
                    "scale": __scale,
                    "size": {"w": __exportSize.width, "h": __exportSize.height}
                }
                var frameInfos = []
                for(fframe in __exportRects) {
                    var frame = {}
                    frame["filename"] = fframe["filepath"].split("\\")[-1]
                    frame["frame"] = { "w": fframe["rect"].width, "h": fframe["rect"].height, "x": fframe["rect"].x, "y": fframe["rect"].y  }
                    frame["rotated"] = false 
                    frame["sourceSize"] = { "w": fframe["rect"].width, "h": fframe["rect"].height }
                    frameInfos.add(frame)
                }

                var dict = {"meta": metaInfo, "frames": frameInfos}
                var jsonDict = Serializer.Value2Json(dict)

                // write json to file
                var f = File.new() 
                if(f.open(json_dst, "w")) {
                    f.write(jsonDict.dump())
                    f.flush()
                    f.close()
                }
            }

            // export image file 
            {
                var outImg = Image.new()
                Raylib.GenImageColor(outImg, __exportSize.width, __exportSize.height, Color.fromString("#00000000"))
                __exportSize.x = 0
                __exportSize.y = 0
                var color = Color.new()
                for(frame in __exportRects) {
                    var cImg = Image.new()
                    Raylib.LoadImage(cImg, frame["filepath"])
                    var rect = frame["rect"]
                    for(y in 0...cImg.height) {
                        for(x in 0...cImg.width) {
                            Raylib.GetImageColor(color, cImg, x, y)
                            Raylib.ImageDrawPixel(outImg, rect.x + x, rect.y + y, color)
                        }
                    }
                    Raylib.UnloadImage(cImg)
                }

                // scaling
                if(__scale != 1) {
                    var newWidth = (outImg.width * __scale).floor 
                    var newHeight = (outImg.height * __scale).floor
                    Raylib.ImageResize(outImg, newWidth, newHeight)
                }

                Raylib.ExportImage(outImg, png_dst)
                Raylib.UnloadImage(outImg)
            }

            Platform.message("Export", "精灵已经导出保存！", 0, 0)
        }
    }
}
Workspace.init()