import "cico/cui" for CUI,ControlResult,DrawType,GuiControl,GuiProperty,GuiStyle
import "editor/node/cnode" for Node, NodeLink, NodeButton, NodeSocket
import "editor/node/cnodeeditor" for NodeManager
import "cico.raylib" for Raylib,Rectangle,Vector2, Vector3, Vector4,Color,Value,ValueList,Font

var w = 1400
var h = 720
var title = "test cui"


var flags = Raylib.FLAG_MSAA_4X_HINT | Raylib.FLAG_WINDOW_RESIZABLE
// var flags = Raylib.FLAG_WINDOW_RESIZABLE
Raylib.SetConfigFlags(flags)
Raylib.InitWindow(w, h, title)
// set monitor to 2
if(Raylib.GetMonitorCount() > 1) { Raylib.SetWindowMonitor(1) }

Raylib.SetTargetFPS(120)
var ui = CUI.new()
var curScroll = Vector2.new(0, 0)
var curView = Rectangle.new(0, 0, 200, 100)

var ctextColor = Raylib.ColorToInt(Raylib.BLACK)
CUI.LoadInternalStyle(GuiStyle.Lavanda)
CUI.SetFont(ui.font)

var nodeMgr = NodeManager.new()
nodeMgr.font = ui.font

// socket color customize 
var cpinNumber = Color.new(177, 177, 177, 255)
var cpinVector2 = Color.new(200, 100, 166, 255)
var cpinVector3 = Color.new(200, 188, 255, 255)
var cpinVector4 = Color.new(200, 255, 134, 255)
var cpinString = Color.new(111, 222, 121, 255)
var cpinObject = Color.new(100, 60, 40, 255)
var cpinExec = Raylib.YELLOW

// node color customize 
var cnodeDefault = Color.new(15, 17, 20, 200)
var cnodeEvent = Color.new(33, 21, 4, 200)


while(!Raylib.WindowShouldClose()) {
    nodeMgr.processControl()
    
    Raylib.BeginDrawing()
        Raylib.ClearBackground(nodeMgr.style.backgroundColor)
        nodeMgr.render()
    Raylib.EndDrawing()

    Raylib.DrawFPS(10, 10)
    Raylib.DrawTextEx(ui.font, "Process Delay: %(nodeMgr.processDelay) ms", Vector2.new(10, 40), 16, 0, Color.new(255, 255, 255, 255))
    Raylib.DrawTextEx(ui.font, "Render Delay: %(nodeMgr.renderDelay) ms", Vector2.new(10, 60), 16, 0, Color.new(255, 255, 255, 255))
}

Raylib.CloseWindow()