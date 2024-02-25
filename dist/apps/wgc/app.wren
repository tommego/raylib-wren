import "cico/engine/app" for App
import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D, Anchors
import "cico/engine/sg2d/window" for SgWindow
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/control/label" for SgLabel
import "cico/engine/sg2d/control/fpslabel" for FpsLabel
import "cico.raylib" for Raylib, Color
import "cico/engine/sg2d/control/menubar" for SgMenuBar, SgMenu, SgMenuItem
import "cico/engine/sg2d/control/toolbar" for SgToolBar 
import "./ui/workspace" for WorkSpace
import "./ui/toolbox" for ToolBox
import "./editor" for Editor

class cico {
    static init() {
        __app = App.new()
        __bgColor = Color.new(111, 111, 111, 255)
        __mainWindow = SgWindow.new({
            "color": Color.new(66, 66, 66, 255)
        },"WGC")
        __mainWindow.fps = 60

        var mainWindow = __mainWindow
        mainWindow.fps = 120
        // if(mainWindow.screenCount > 1) { mainWindow.setScreen(1) }

        Editor.init()

        var menuBar = SgMenuBar.new({
            "height": 30,
            "color": Color.new(45, 45, 45, 255),
            "border": Border.new(1, Color.new(255, 255, 255, 15)),
            "menus": [
                SgMenu.new({
                    "text": "文件",
                    "options": [
                        SgMenuItem.new({"title": "新建", "onTriggered": Fn.new{System.print("Menu Item New triggered")}}),
                        SgMenuItem.new({"title": "打开", "onTriggered": Fn.new{System.print("Menu Item Open triggered")}}),
                        SgMenuItem.new({"title": "打开最近", "onTriggered": Fn.new{System.print("Menu Item Open Recent triggered")}}),
                        SgMenuItem.new({"title": "保存", "onTriggered": Fn.new{System.print("Menu Item Save triggered")}}),
                        SgMenuItem.new({"title": "保存为", "onTriggered": Fn.new{System.print("Menu Item Save As triggered")}}),
                        SgMenuItem.new({"title": "导入", "onTriggered": Fn.new{System.print("Menu Item Import triggered")}}),
                        SgMenuItem.new({"title": "导出", "onTriggered": Fn.new{System.print("Menu Item Export triggered")}})
                    ]
                }),
                SgMenu.new({
                    "text": "编辑"
                }),
                SgMenu.new({
                    "text": "修改"
                }),
                SgMenu.new({
                    "text": "视图"
                }),
                SgMenu.new({
                    "text": "帮助"
                })
            ]
        })

        var toolBar = ToolBox.new({
            "height": 35,
            "color": Color.new(45, 45, 45, 255)
        })

        var statusBar = SgRectangle.new({
            "height": 25,
            "color": Color.new(45, 45, 45, 255),
            "border": Border.new(1, Color.new(255, 255, 255, 15))
        })

        var fpsLabel = FpsLabel.new(statusBar, { "fontSize": 12, "color": Color.fromString("#33aaff"), "x": 25 })
        fpsLabel.anchors.verticalCenter({"target": statusBar, "value": Anchors.VerticalCenter})

        mainWindow.menuBar = menuBar
        mainWindow.toolBar = toolBar 
        mainWindow.statusBar = statusBar
        var workspace = WorkSpace.new(mainWindow, {
            "color": Color.new(66, 66, 66, 255),
            "width": mainWindow.contentWidth,
            "height": mainWindow.contentHeight
        })

        mainWindow.content.geometryChanged.connect{|e,v|
            workspace.width = mainWindow.contentWidth
            workspace.height = mainWindow.contentHeight 
        }
    }

    static eventLoop() {
        var windowClosed = Raylib.WindowShouldClose()
        __app.loop()
        return windowClosed ? 1 : 0
    }

    static exit() {
        __app.exit()
    }
}