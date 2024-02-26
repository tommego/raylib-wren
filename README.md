# raylib-wren
wren language binding for raylib.
### [wren language official site](https://wren.io/syntax.html)
I love wren language, it is very handy for working on  many kinds of projects.
### [Raylib official site](https://www.raylib.com/)
### Features 
- Full Raylib API bindings for wren.
- Full Raygui API binding for wren.
- Basic json.hpp bindign for wren.
- Serial API binding for wren.
- File API binding for wren.
- vinput(virtual input enumerating on linux) API binding for wren. (My works on arm/aarch linux device input enumerating for auto test)
- supported languages by default(codepoints)
  - english
  - 日语
  - 韩语
  - 中文简体
  - emoji
- cico/engine
  - sg2d(working on progress)
    - layout
      - row
      - column
      - flow  
    - controls
      - button
      - checkbox
      - combobox
      - fpslabel
      - group
      - inconbutton
      - label
      - listmodel
      - listview (very slow)
      - menubar
      - popup
      - progressbar (todo)
      - scrollbar (todo)
      - scrollview
      - slider
      - spinbox
      - splitview(todo)
      - stackview(todo)
      - statusbar(todo)
      - style
      - swipeview
      - switch
      - tabbar
      - tabview(todo)
      - textfield
      - textinput(todo)
      - toolbar(todo)
      - treeview(todo)
    - icon
    - sprite
    - scenegraph2d
    - rectangle
  - sg3d(working on progress)
  - math
  - app
  - signalslot
  - timer
  - tween
- cico/utils
  - serializer  



### Raylib API Basic Examples

``` wren
import "cico.raylib" for Raylib,Camera2D,Vector2,Color

// Initialization
//--------------------------------------------------------------------------------------
var screenWidth = 800
var screenHeight = 450

Raylib.InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera mouse zoom")

var camera = Camera2D.new() 
camera.zoom = 1
var target = Vector2.new()

Raylib.SetTargetFPS(120)

var delta = Vector2.new()
var mpos = Vector2.new()
while(!Raylib.WindowShouldClose()) {
    // Update
    //----------------------------------------------------------------------------------
    // Translate based on mouse right click
    if(Raylib.IsMouseButtonDown(Raylib.MOUSE_BUTTON_RIGHT)) {
        Raylib.GetMouseDelta(delta)
        
        delta = Vector2.Vector2Scale(delta, -1.0 / camera.zoom)
        target = Vector2.Vector2Add(target, delta)
        camera.target = target
    }

    // Zoom based on mouse wheel
    var wheel = Raylib.GetMouseWheelMove() 
    if(wheel != 0) {
        // Get the world point that is under the mouse
        Raylib.GetMousePosition(mpos)
        var mouseWorldPos = Vector2.new()
        Raylib.GetScreenToWorld2D(mouseWorldPos, mpos, camera)

        // Set the offset to where the mouse is
        camera.offset = mpos 

        // Set the target to match, so that the camera maps the world space point 
        // under the cursor to the screen space point under the cursor at any zoom
        camera.target = mouseWorldPos
        // Zoom increment
        var zoomIncrement = 0.125
        camera.zoom = camera.zoom + (wheel * zoomIncrement)
        if(camera.zoom < zoomIncrement) {
            camera.zoom = zoomIncrement
        }
    }

    //----------------------------------------------------------------------------------

    // Draw
    //----------------------------------------------------------------------------------
    Raylib.BeginDrawing() 
        Raylib.ClearBackground(Raylib.BLACK)
        
        Raylib.BeginMode2D(camera)

            // Draw a reference circle
            Raylib.DrawCircle(100, 100, 50, Raylib.YELLOW)
        
        Raylib.EndMode2D()

        Raylib.DrawText("Mouse right button drag to move, mouse wheel to zoom  fps: %(Raylib.GetFPS())", 10, 10, 20, Raylib.WHITE)
    
    Raylib.EndDrawing()
}

// De-Initialization
//--------------------------------------------------------------------------------------
Raylib.CloseWindow() // Close window and OpenGL context
//--------------------------------------------------------------------------------------

```

### Gallery

core_2d_camera_mouse

![core_2d_camera_mouse.zoom](screenshots/core_2d_camera_mouse_zoom.png)

core_2d_camera_platformer

![core_2d_camera_platformer](screenshots/core_2d_camera_platform.png)

raygui

![raygui](screenshots/raygui.png)

node editor

![image](screenshots/node_editor.png)

cico gui 

![image](screenshots/cico_gui_engine.png)


cico project/wgc

![image](screenshots/wgc.png)


