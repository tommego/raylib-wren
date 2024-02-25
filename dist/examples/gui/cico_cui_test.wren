import "cico/cui" for CUI,ControlResult,DrawType,GuiControl,GuiProperty,GuiStyle
import "cico.raylib" for Raylib,Rectangle,Vector2,Color,Value,ValueList,Font

var w = 1280
var h = 720
var title = "test cui"

Raylib.InitWindow(w, h, title)
var ui = CUI.new()
var curScroll = Vector2.new(0, 0)
var curView = Rectangle.new(0, 0, 200, 100)

var tabActive = 0
var tabBarItems = ValueList.new()
tabBarItems.create(Raylib.VALUE_TYPE_STRING, 10)
for(i in 0...9) {
    tabBarItems.set(i, "tab%(i)")
}

var ctextColor = Raylib.ColorToInt(Raylib.BLACK)
CUI.LoadInternalStyle(GuiStyle.Lavanda)
CUI.SetFont(ui.font)

while(!Raylib.WindowShouldClose()) {
    Raylib.BeginDrawing()

        ui.Window(Rectangle.new(0, 0, w, h), "test window")
        // ui.Group(Rectangle.new(0, 30, 100, 100), "test group")
        // ui.ScrollPanel(Rectangle.new(0, 30, 200, 100), "text scroll panel", Rectangle.new(0, 0, 1000, 1000), curScroll, curView)
        var ret = ui.TabBar(Rectangle.new(0, 30, 200, 30), tabBarItems, tabActive)
        tabActive = ret.values[0]
        if(ret.code >= 0) { System.print("tab delete invodked del index: %(ret.code)")}
        // ui.Icon(1, 100, 100, 2, Raylib.RED)
        ui.LabelButton(Rectangle.new(1, 100, 100, 20), "test label button")

    Raylib.EndDrawing()
}

Raylib.CloseWindow()