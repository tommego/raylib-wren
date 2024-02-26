import "cico.raylib" for Raylib,Rectangle,Vector2,Color,Value,ValueList,Font
import "cico/engine/app" for App 
import "cico/engine/tween" for Tween,Anim,EasingType
import "cico/engine/sg2d/rectangle" for SgRectangle
import "cico/engine/sg2d/scenegraph2d" for Border, SceneGraph2D
import "cico/engine/sg2d/sprite" for SgSprite
import "cico/engine/sg2d/layout" for SgColumn,SgRow
import "cico/engine/sg2d/control/label" for SgLabel
import "cico/engine/sg2d/control/checkbox" for SgCheckbox
import "cico/engine/sg2d/control/switch" for SgSwitch
import "cico/engine/sg2d/control/slider" for SgSlider
import "cico/engine/sg2d/control/listview" for SgListView
import "cico/engine/sg2d/control/button" for SgButton
import "cico/engine/sg2d/control/swipeview" for SgSwipeView
import "cico/engine/sg2d/control/combobox" for SgComboBox
import "cico/engine/sg2d/control/spinbox" for SgSpinBox
import "cico/engine/sg2d/control/textfield" for SgTextField
import "cico/engine/sg2d/window" for SgWindow

class cico {
    static init() {
        __app = App.new()
        __bgColor = Color.new(111, 111, 111, 255)
        var mainWindow = SgWindow.new("Engine test")
        if(mainWindow.screenCount > 1) { mainWindow.setScreen(1) }
        var col = SgColumn.new(mainWindow, { 
            "spacing": 20, 
            "x": 30, 
            "y": 30, 
            "dragEnabled": true 
        })
        SgCheckbox.new(col, { 
            "text": "Flag", 
            "checked": true 
        })
        SgSwitch.new(col, { 
            "text": "Switch", 
            "checked": false 
        })
        SgSpinBox.new(col, {

        })
        SgTextField.new(col, {
            
        })
        var slider = SgSlider.new(col, {"width": 500})

        var row = SgRow.new(col,{
            "spacing": 20,
            // "dragEnabled": true 
        })
        var btn = SgButton.new(row, {
            "text": "left",
            "y": 40,
            "autoSize": true 
        })

        var swipeView = SgSwipeView.new(row, {
            "width": 200,
            "height": 100,
        })
        for(i in 0...10) {
            swipeView.addNode(SgRectangle.new({
                "children": [
                    SgLabel.new({
                        "text": "Page %(i)",
                        "fontSize": 40,
                        "fontColor": Color.new(88, 88, 88, 255)
                    })
                ],
                "color": Color.new(255, i * 20, i * 10, 255)
            }))
        }

        var btn1 = SgButton.new(row, {
            "text": "right",
            "y": 40,
            "autoSize": true 
        })
        btn.clicked.connect{|e,v| swipeView.swipeTo(swipeView.currentIndex - 1) }
        btn1.clicked.connect{|e,v| swipeView.swipeTo(swipeView.currentIndex + 1) }

        var combo = SgComboBox.new(col)
        for(i in 0...10) {
            combo.model.add({"text": "opt%(i)"})
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
