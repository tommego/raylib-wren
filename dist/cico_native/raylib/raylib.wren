
class RLUtil {
    static str2hex(c) {
        if(!__map) {
            __map = {"0": 0,"1": 1,"2": 2,"3": 3,"4": 4,"5": 5,"6": 6,"7": 7,"8": 8,"9": 9,"a": 10,"A": 10,"b": 11,"B": 11,"c": 12,"C": 12,"d": 13,"D": 13,"e": 14,"E": 14,"f": 15,"F": 15}
        }
        return __map[c]
    }
}

foreign class Color {
    construct new() { }
    construct new(dynamic) {
        if(dynamic is String) {
            var ridx = 0
            if(dynamic.startsWith("#") && (dynamic.count == 7 || dynamic.count == 9)) {
                if(dynamic.count == 9) {ridx = 2}
                var nums = []
                for(i in 1...dynamic.count) {
                    var c = dynamic[i]
                    nums.add(RLUtil.str2hex(c))
                }
                this.r = nums[ridx+0] * 16 + nums[ridx+1]
                this.g = nums[ridx+2] * 16 + nums[ridx+3]
                this.b = nums[ridx+4] * 16 + nums[ridx+5]
                if(ridx > 0) {
                    this.a = nums[0] * 16 + nums[1]
                } else {
                    this.a = 255
                }
            } else {
                System.print("%(dynamic) is invalid")
            }
        }
    }
    construct new(r_, g_, b_, a_) {
        r = r_ 
        g = g_ 
        b = b_ 
        a = a_ 
    }
    foreign r 
    foreign r=(val)
    foreign g 
    foreign g=(val)
    foreign b 
    foreign b=(val)
    foreign a 
    foreign a=(val)
    [index]=(val) {
        if(index == 0) {
            this.r = val
        } else if(index == 1) {
            this.g = val 
        } else if(index == 2) {
            this.b = val 
        } else if(index == 3) {
            this.a = val
        }
    }
    set(vr, vg, vb, va) {
        this.r = vr 
        this.g = vg 
        this.b = vb 
        this.a = va 
    }
    *(val) {
        return Color.new(this.r * val, this.g * val, this.g * val, this.a * val)
    }
    parse(dynamic) {
        if(dynamic is String) {
            var ridx = 0
            if(dynamic.startsWith("#") && (dynamic.count == 7 || dynamic.count == 9)) {
                if(dynamic.count == 9) {ridx = 2}
                var nums = []
                for(i in 1...dynamic.count) {
                    var c = dynamic[i]
                    nums.add(RLUtil.str2hex(c))
                }
                this.r = nums[ridx+0] * 16 + nums[ridx+1]
                this.g = nums[ridx+2] * 16 + nums[ridx+3]
                this.b = nums[ridx+4] * 16 + nums[ridx+5]
                if(ridx > 0) {
                    this.a = nums[0] * 16 + nums[1]
                } else {
                    this.a = 255
                }
            } else {
                System.print("%(dynamic) is invalid")
            }
        } else if(dynamic is Color) {
            this.r= dynamic.r 
            this.g = dynamic.g 
            this.b = dynamic.b 
            this.a = dynamic.a 
        }
    }
    static fromString(dynamic) {
        var c = Color.new(255, 255, 255, 255)
        if(dynamic is String) {
            var ridx = 0
            if(dynamic.startsWith("#") && (dynamic.count == 7 || dynamic.count == 9)) {
                if(dynamic.count == 9) {ridx = 2}
                var nums = []
                for(i in 1...dynamic.count) {
                    var c = dynamic[i]
                    nums.add(RLUtil.str2hex(c))
                }
                c.r = nums[ridx+0] * 16 + nums[ridx+1]
                c.g = nums[ridx+2] * 16 + nums[ridx+3]
                c.b = nums[ridx+4] * 16 + nums[ridx+5]
                if(ridx > 0) {
                    c.a = nums[0] * 16 + nums[1]
                } else {
                    c.a = 255
                }
            } else {
                System.print("%(dynamic) is invalid")
            }
        }
        return c 
    }
}

foreign class Rectangle {
    construct new() {}
    construct new(x_, y_, width_, height_) {
        x = x_ 
        y = y_ 
        width = width_
        height = height_
    }
    foreign x 
    foreign x=(val)
    foreign y 
    foreign y=(val)
    foreign width 
    foreign width=(val)
    foreign height 
    foreign height=(val)
}

foreign class Image {
    construct new() { }
    foreign width 
    foreign width=(val)
    foreign height 
    foreign height=(val)
    foreign mipmaps 
    foreign mipmaps=(val)
    foreign format 
    foreign format=(val)
}

foreign class Texture {
    construct new () { }
    foreign id 
    foreign id=(val)
    foreign width 
    foreign width=(val)
    foreign height 
    foreign height=(val)
    foreign mipmaps 
    foreign mipmaps=(val)
    foreign format 
    foreign format=(val)
}

foreign class RenderTexture {
    construct new() { }
    foreign id 
    foreign texture=(val)
    foreign depth=(val)
    foreign getTexture(intex)
    foreign getDepthTexture(intex)
}

foreign class NPatchInfo {
    construct new() { }
    foreign source=(val)
    foreign left
    foreign left=(val)
    foreign top 
    foreign top=(val)
    foreign right 
    foreign right=(val)
    foreign bottom 
    foreign bottom=(val)
}

foreign class GlyphInfo {
    construct new () {}
    foreign value 
    foreign value=(val)
    foreign offsetX 
    foreign offsetX=(val)
    foreign offsetY 
    foreign offsetY=(val)
    foreign advanceX 
    foreign advanceX=(val)
    foreign image=(val)
}

foreign class Font {
    construct new () { }
    foreign baseSize 
    foreign baseSize=(val)
    foreign glyphCount 
    foreign glyphCount=(val)
    foreign glyphPadding
    foreign glyphPadding=(val)
    foreign texture=(val)
}

foreign class Camera3D {
    construct new() { }
    construct new(position_, target_, up_, fovy_, projection_) {
        position = position_
        target = target_ 
        up = up_ 
        fovy = fovy_ 
        projection = projection_
    }
    construct new(position_, target_, up_) {
        position = position_ 
        target = target_ 
        up = up_ 
        fovy = 1 
        projection = 0
    }
    foreign position=(val)
    foreign target=(val)
    foreign up=(val)
    foreign fovy 
    foreign fovy=(val)
    foreign projection
    foreign projection=(val)
}

foreign class Camera2D {
    construct new() { zoom = 1 }
    construct new(offset_, target_, rotation_, zoom_) {
        offset = offset_ 
        target = target_
        rotation = rotation_
        zoom = zoom_
    }
    construct new(offset_, target_, rotation) {
        offset = offset_ 
        target = target_ 
        rotation = rotation_
        zoom = 1
    }
    foreign offset=(val)
    foreign target=(val)
    foreign rotation 
    foreign rotation=(val)
    foreign zoom 
    foreign zoom=(val)
}

foreign class Mesh {
    construct new() {

    }
}

foreign class Shader {
    construct new() {

    }
}

foreign class MaterialMap {
    construct new() { }
    foreign texture=(val)
    foreign color=(val)
    foreign value 
    foreign value=(val)
}

foreign class Material {
    construct new () { }
    foreign shader=(val)
    foreign getMaps(inlist)
}

foreign class Transform {
    construct new() { }
    construct new(ts, ro, s) {
        translation = ts 
        rotation = ro 
        scale = s
    }
    foreign translation=(val)
    foreign rotation=(val)
    foreign scale=(vale)
}

foreign class BoneInfo {
    construct new () { }
    foreign parent 
    foreign parent=(val)
}

foreign class Model {
    construct new() { }
    foreign meshCount
    foreign meshCount=(val)
    foreign materialCount 
    foreign materialCount=(val)
    foreign boneCount 
    foreign boneCount=(val)
    foreign getMaterial(material, index)
    foreign setMaterial(index, material)
    foreign setMaterialShader(index, shader)
    foreign getMaterials(inlist)
}

foreign class ModelAnimation {
    construct new() {}
    foreign boneCount
    foreign frameCount
}

foreign class Ray {
    construct new() { }
    construct new(pos, dir) {
        position = pos 
        direction = dir 
    }
    foreign position=(val)
    foreign direction=(val)
}

foreign class RayCollision {
    construct new() {}
}

foreign class BoundingBox {
    construct new() { }
    construct new(from, to) {
        min = from  
        max = to
    }
    foreign min=(val)
    foreign max=(val)
}

foreign class ValueList {
    construct new () { }

    foreign count
    foreign valueType
    foreign valueType=(val)
    foreign get(input, index)
    foreign set(index, value)
    foreign create(type, count)
}

foreign class Value {
    construct new () { }
    foreign valueType
    foreign valueType=(val)
    foreign get(input)
    foreign set(value)
    foreign create(type, value)
}

foreign class FilePathList {
    construct new() { } 
    foreign count 
    foreign paths 
    foreign capacity
}

class Raylib {

    // System/Window config flags
    // NOTE: Every bit registers one state (use it with bit masks)
    // By default all flags are set to 0
    static FLAG_VSYNC_HINT {0x00000040}
    static FLAG_FULLSCREEN_MODE {0x00000002}
    static FLAG_WINDOW_RESIZABLE {0x00000004}
    static FLAG_WINDOW_UNDECORATED {0x00000008}
    static FLAG_WINDOW_HIDDEN {0x00000080}
    static FLAG_WINDOW_MINIMIZED {0x00000200}
    static FLAG_WINDOW_MAXIMIZED {0x00000400}
    static FLAG_WINDOW_UNFOCUSED {0x00000800}
    static FLAG_WINDOW_TOPMOST {0x00001000}
    static FLAG_WINDOW_ALWAYS_RUN {0x00000100}
    static FLAG_WINDOW_TRANSPARENT {0x00000010}
    static FLAG_WINDOW_HIGHDPI {0x00002000}
    static FLAG_WINDOW_MOUSE_PASSTHROUGH {0x00004000}
    static FLAG_BORDERLESS_WINDOWED_MODE {0x00008000}
    static FLAG_MSAA_4X_HINT {0x00000020}
    static FLAG_INTERLACED_HINT {0x00010000}

    // Keyboard keys (US keyboard layout)
    // NOTE: Use GetKeyPressed() to allow redefining
    // required keys for alternative layouts
    static KEY_NULL {0}
    static KEY_APOSTROPHE {39}
    static KEY_COMMA {44}
    static KEY_MINUS {45}
    static KEY_PERIOD {46}
    static KEY_SLASH {47}
    static KEY_ZERO {48}
    static KEY_ONE {49}
    static KEY_TWO {50}
    static KEY_THREE {51}
    static KEY_FOUR {52}
    static KEY_FIVE {53}
    static KEY_SIX {54}
    static KEY_SEVEN {55}
    static KEY_EIGHT {56}
    static KEY_NINE {57}
    static KEY_SEMICOLON {59}
    static KEY_EQUAL {61}
    static KEY_A {65}
    static KEY_B {66}
    static KEY_C {67}
    static KEY_D {68}
    static KEY_E {69}
    static KEY_F {70}
    static KEY_G {71}
    static KEY_H {72}
    static KEY_I {73}
    static KEY_J {74}
    static KEY_K {75}
    static KEY_L {76}
    static KEY_M {77}
    static KEY_N {78}
    static KEY_O {79}
    static KEY_P {80}
    static KEY_Q {81}
    static KEY_R {82}
    static KEY_S {83}
    static KEY_T {84}
    static KEY_U {85}
    static KEY_V {86}
    static KEY_W {87}
    static KEY_X {88}
    static KEY_Y {89}
    static KEY_Z {90}
    static KEY_LEFT_BRACKET {91}
    static KEY_BACKSLASH {92}
    static KEY_RIGHT_BRACKET {93}
    static KEY_GRAVE {96}
    static KEY_SPACE {32}
    static KEY_ESCAPE {256}
    static KEY_ENTER {257}
    static KEY_TAB {258}
    static KEY_BACKSPACE {259}
    static KEY_INSERT {260}
    static KEY_DELETE {261}
    static KEY_RIGHT {262}
    static KEY_LEFT {263}
    static KEY_DOWN {264}
    static KEY_UP {265}
    static KEY_PAGE_UP {266}
    static KEY_PAGE_DOWN {267}
    static KEY_HOME {268}
    static KEY_END {269}
    static KEY_CAPS_LOCK {280}
    static KEY_SCROLL_LOCK {281}
    static KEY_NUM_LOCK {282}
    static KEY_PRINT_SCREEN {283}
    static KEY_PAUSE {284}
    static KEY_F1 {290}
    static KEY_F2 {291}
    static KEY_F3 {292}
    static KEY_F4 {293}
    static KEY_F5 {294}
    static KEY_F6 {295}
    static KEY_F7 {296}
    static KEY_F8 {297}
    static KEY_F9 {298}
    static KEY_F10 {299}
    static KEY_F11 {300}
    static KEY_F12 {301}
    static KEY_LEFT_SHIFT {340}
    static KEY_LEFT_CONTROL {341}
    static KEY_LEFT_ALT {342}
    static KEY_LEFT_SUPER {343}
    static KEY_RIGHT_SHIFT {344}
    static KEY_RIGHT_CONTROL {345}
    static KEY_RIGHT_ALT {346}
    static KEY_RIGHT_SUPER {347}
    static KEY_KB_MENU {348}
    static KEY_KP_0 {320}
    static KEY_KP_1 {321}
    static KEY_KP_2 {322}
    static KEY_KP_3 {323}
    static KEY_KP_4 {324}
    static KEY_KP_5 {325}
    static KEY_KP_6 {326}
    static KEY_KP_7 {327}
    static KEY_KP_8 {328}
    static KEY_KP_9 {329}
    static KEY_KP_DECIMAL {330}
    static KEY_KP_DIVIDE {331}
    static KEY_KP_MULTIPLY {332}
    static KEY_KP_SUBTRACT {333}
    static KEY_KP_ADD {334}
    static KEY_KP_ENTER {335}
    static KEY_KP_EQUAL {336}
    static KEY_BACK {4}
    static KEY_MENU {82}
    static KEY_VOLUME_UP {24}
    static KEY_VOLUME_DOWN {25}

    // Mouse buttons
    static MOUSE_BUTTON_LEFT {0}
    static MOUSE_BUTTON_RIGHT {1}
    static MOUSE_BUTTON_MIDDLE {2}
    static MOUSE_BUTTON_SIDE {3}
    static MOUSE_BUTTON_EXTRA {4}
    static MOUSE_BUTTON_FORWARD {5}
    static MOUSE_BUTTON_BACK {6}

    // Mouse cursor
    static MOUSE_CURSOR_DEFAULT {0}
    static MOUSE_CURSOR_ARROW {1} 
    static MOUSE_CURSOR_IBEAM {2}
    static MOUSE_CURSOR_CROSSHAIR {3}
    static MOUSE_CURSOR_POINTING_HAND {4}
    static MOUSE_CURSOR_RESIZE_EW {5}
    static MOUSE_CURSOR_RESIZE_NS {6}
    static MOUSE_CURSOR_RESIZE_NWSE {7}
    static MOUSE_CURSOR_RESIZE_NESW {8}
    static MOUSE_CURSOR_RESIZE_ALL {9}
    static MOUSE_CURSOR_NOT_ALLOWED {10}

    // Material map index
    static MATERIAL_MAP_ALBEDO {0}
    static MATERIAL_MAP_METALNESS {1}
    static MATERIAL_MAP_NORMAL {2}
    static MATERIAL_MAP_ROUGHNESS {3}
    static MATERIAL_MAP_OCCLUSION {4}
    static MATERIAL_MAP_EMISSION {5}
    static MATERIAL_MAP_HEIGHT {6}
    static MATERIAL_MAP_CUBEMAP {7}
    static MATERIAL_MAP_IRRADIANCE {8}
    static MATERIAL_MAP_PREFILTER {9}
    static MATERIAL_MAP_BRDF {10}

    static MATERIAL_MAP_DIFFUSE { 0 }
    static MATERIAL_MAP_SPECULAR { 1}

    // Shader location index
    static SHADER_LOC_VERTEX_POSITION {0}
    static SHADER_LOC_VERTEX_TEXCOORD01 {1}
    static SHADER_LOC_VERTEX_TEXCOORD02 {2}
    static SHADER_LOC_VERTEX_NORMAL {3}
    static SHADER_LOC_VERTEX_TANGENT {4}
    static SHADER_LOC_VERTEX_COLOR {5}
    static SHADER_LOC_MATRIX_MVP {6}
    static SHADER_LOC_MATRIX_VIEW {7}
    static SHADER_LOC_MATRIX_PROJECTION {8}
    static SHADER_LOC_MATRIX_MODEL {9}
    static SHADER_LOC_MATRIX_NORMAL {10}
    static SHADER_LOC_VECTOR_VIEW {11}
    static SHADER_LOC_COLOR_DIFFUSE {12}
    static SHADER_LOC_COLOR_SPECULAR {13}
    static SHADER_LOC_COLOR_AMBIENT {14}
    static SHADER_LOC_MAP_ALBEDO {15}
    static SHADER_LOC_MAP_METALNESS {16}
    static SHADER_LOC_MAP_NORMAL {17}
    static SHADER_LOC_MAP_ROUGHNESS {18}
    static SHADER_LOC_MAP_OCCLUSION {19}
    static SHADER_LOC_MAP_EMISSION {20}
    static SHADER_LOC_MAP_HEIGHT {21}
    static SHADER_LOC_MAP_CUBEMAP {22}
    static SHADER_LOC_MAP_IRRADIANCE {23}
    static SHADER_LOC_MAP_PREFILTER {24}
    static SHADER_LOC_MAP_BRDF {25}

    // Shader uniform data type
    static SHADER_UNIFORM_FLOAT {0}
    static SHADER_UNIFORM_VEC2 {1}
    static SHADER_UNIFORM_VEC3 {2}
    static SHADER_UNIFORM_VEC4 {3}
    static SHADER_UNIFORM_INT {4}
    static SHADER_UNIFORM_IVEC2 {5}
    static SHADER_UNIFORM_IVEC3 {6}
    static SHADER_UNIFORM_IVEC4 {7}
    static SHADER_UNIFORM_SAMPLER2D {8}

    // Shader attribute data types
    static SHADER_ATTRIB_FLOAT {0}
    static SHADER_ATTRIB_VEC2 {1}
    static SHADER_ATTRIB_VEC3 {2}
    static SHADER_ATTRIB_VEC4 {3}

    // Pixel formats
    // NOTE: Support depends on OpenGL version and platform
    static PIXELFORMAT_UNCOMPRESSED_GRAYSCALE {1}
    static PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA {2}
    static PIXELFORMAT_UNCOMPRESSED_R5G6B5 {3}
    static PIXELFORMAT_UNCOMPRESSED_R8G8B8 {4}
    static PIXELFORMAT_UNCOMPRESSED_R5G5B5A1 {5}
    static PIXELFORMAT_UNCOMPRESSED_R4G4B4A4 {6}
    static PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 {7}
    static PIXELFORMAT_UNCOMPRESSED_R32 {8}
    static PIXELFORMAT_UNCOMPRESSED_R32G32B32 {9}
    static PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 {10}
    static PIXELFORMAT_UNCOMPRESSED_R16 {11}
    static PIXELFORMAT_UNCOMPRESSED_R16G16B16 {12}
    static PIXELFORMAT_UNCOMPRESSED_R16G16B16A16 {13}
    static PIXELFORMAT_COMPRESSED_DXT1_RGB {14}
    static PIXELFORMAT_COMPRESSED_DXT1_RGBA {15}
    static PIXELFORMAT_COMPRESSED_DXT3_RGBA {16}
    static PIXELFORMAT_COMPRESSED_DXT5_RGBA {17}
    static PIXELFORMAT_COMPRESSED_ETC1_RGB {18}
    static PIXELFORMAT_COMPRESSED_ETC2_RGB {19}
    static PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA {20}
    static PIXELFORMAT_COMPRESSED_PVRT_RGB {21}
    static PIXELFORMAT_COMPRESSED_PVRT_RGBA {22}
    static PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA {23}
    static PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA {24}

    // Texture parameters: filter mode
    // NOTE 1: Filtering considers mipmaps if available in the texture
    // NOTE 2: Filter is accordingly set for minification and magnification
    static TEXTURE_FILTER_POINT {0}
    static TEXTURE_FILTER_BILINEAR {1}
    static TEXTURE_FILTER_TRILINEAR {2}
    static TEXTURE_FILTER_ANISOTROPIC_4X {3}
    static TEXTURE_FILTER_ANISOTROPIC_8X {4}
    static TEXTURE_FILTER_ANISOTROPIC_16X {5}

    // Texture parameters: wrap mode
    static TEXTURE_WRAP_REPEAT {0}
    static TEXTURE_WRAP_CLAMP {1}
    static TEXTURE_WRAP_MIRROR_REPEAT {2}
    static TEXTURE_WRAP_MIRROR_CLAMP {3}

    // Cubemap layouts
    static CUBEMAP_LAYOUT_AUTO_DETECT {0}
    static CUBEMAP_LAYOUT_LINE_VERTICAL {1}
    static CUBEMAP_LAYOUT_LINE_HORIZONTAL {2}
    static CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR {3}
    static CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE {4}
    static CUBEMAP_LAYOUT_PANORAMA {5}

    // Font type, defines generation method
    static FONT_DEFAULT {0}
    static FONT_BITMAP {1}
    static FONT_SDF {2}

    // Color blending modes (pre-defined)
    static BLEND_ALPHA {0}
    static BLEND_ADDITIVE {1}
    static BLEND_MULTIPLIED {2}
    static BLEND_ADD_COLORS {3}
    static BLEND_SUBTRACT_COLORS {4}
    static BLEND_ALPHA_PREMULTIPLY {5}
    static BLEND_CUSTOM {6}
    static BLEND_CUSTOM_SEPARATE {7}

    // Camera system modes
    static CAMERA_CUSTOM {0}
    static CAMERA_FREE {1}
    static CAMERA_ORBITAL {2}
    static CAMERA_FIRST_PERSON {3}
    static CAMERA_THIRD_PERSON {4}

    // Camera projection
    static CAMERA_PERSPECTIVE {0}
    static CAMERA_ORTHOGRAPHIC {1}

    // N-patch layout
    static NPATCH_NINE_PATCH {0}
    static NPATCH_THREE_PATCH_VERTICAL {0}
    static NPATCH_THREE_PATCH_HORIZONTAL {0}

    // Some Basic Colors
    static LIGHTGRAY { Color.new(200, 200, 200, 255) }
    static GRAY { Color.new(130, 130, 130, 255) }
    static DARKGRAY { Color.new(80, 80, 80, 255) }
    static YELLOW { Color.new(253, 249, 0, 255) }
    static GOLD { Color.new(255, 203, 0, 255) }
    static ORANGE { Color.new(255, 161, 0, 255) }
    static PINK { Color.new(255, 109, 194, 255) }
    static RED { Color.new(230, 41, 55, 255) }
    static MAROON { Color.new(190, 33, 55, 255) }
    static GREEN { Color.new(0, 228, 48, 255) }
    static LIME { Color.new(0, 158, 47, 255) }
    static DARKGREEN { Color.new(0, 117, 44, 255) }
    static SKYBLUE { Color.new(102, 191, 255, 255) }
    static BLUE { Color.new(0, 121, 241, 255) }
    static DARKBLUE { Color.new(0, 82, 172, 255) }
    static PURPLE { Color.new(200, 122, 255, 255) }
    static VIOLET { Color.new(135, 60, 190, 255) }
    static DARKPURPLE { Color.new(112, 31, 126, 255) }
    static BEIGE { Color.new(211, 176, 131, 255) }
    static BROWN { Color.new(127, 106, 79, 255) }
    static DARKBROWN { Color.new(76, 63, 47, 255) }
    static WHITE { Color.new(255, 255, 255, 255) }
    static BLACK { Color.new(0, 0, 0, 255) }
    static BLANK { Color.new(0, 0, 0, 0) }
    static MAGENTA { Color.new(255, 0, 255, 255) }
    static RAYWHITE { Color.new(245, 245, 245, 255) }

    // Value Types
    static VALUE_TYPE_COLOR {0}
    static VALUE_TYPE_RECTANGLE {1}
    static VALUE_TYPE_IMAGE {2}
    static VALUE_TYPE_TEXTURE {3}
    static VALUE_TYPE_RENDERTEXTURE {4}
    static VALUE_TYPE_NPATCHINFO {5}
    static VALUE_TYPE_GLYPHINFO {6}
    static VALUE_TYPE_FONT {7}
    static VALUE_TYPE_CAMERA3D {8}
    static VALUE_TYPE_CAMERA2D {9}
    static VALUE_TYPE_MESH {10}
    static VALUE_TYPE_SHADER {11}
    static VALUE_TYPE_MATERIALMAP {12}
    static VALUE_TYPE_MATERIAL {13}
    static VALUE_TYPE_TRANSFORM {14}
    static VALUE_TYPE_BONEINFO {15}
    static VALUE_TYPE_MODEL {16}
    static VALUE_TYPE_MODELANIMATION {17}
    static VALUE_TYPE_RAY {18}
    static VALUE_TYPE_RAYCOLLISION {19}
    static VALUE_TYPE_BOUNDINGBOX {20}
    static VALUE_TYPE_VECTOR2 {21}
    static VALUE_TYPE_VECTOR3 {22}
    static VALUE_TYPE_VECTOR4 {23}
    static VALUE_TYPE_MATRIX {24}
    static VALUE_TYPE_FLOAT3 {25}
    static VALUE_TYPE_FLOAT16 {26}
    static VALUE_TYPE_FLOAT {27}
    static VALUE_TYPE_INT {28}
    static VALUE_TYPE_INDICE {29}
    static VALUE_TYPE_BOOLEAN {30}
    static VALUE_TYPE_STRING {31}

    foreign static InitWindow(width, height, title)
    foreign static CloseWindow()
    foreign static WindowShouldClose()
    foreign static IsWindowReady()
    foreign static IsWindowFullscreen()
    foreign static IsWindowHidden()
    foreign static IsWindowMinimized()
    foreign static IsWindowMaximized()
    foreign static IsWindowFocused()
    foreign static IsWindowResized()
    foreign static IsWindowState(flags)
    foreign static SetWindowState(flags)
    foreign static ClearWindowState(flags)
    foreign static ToggleFullscreen()
    foreign static ToggleBorderlessWindowed()
    foreign static MaximizeWindow()
    foreign static MinimizeWindow()
    foreign static RestoreWindow()
    foreign static SetWindowIcon(img)
    foreign static SetWindowIcons(imgs, count)
    foreign static SetWindowTitle(title)
    foreign static SetWindowPosition(x, y)
    foreign static SetWindowMonitor(monitor)
    foreign static SetWindowMinSize(w,h)
    foreign static SetWindowMaxSize(w,h)
    foreign static SetWindowSize(w,h)
    foreign static SetWindowOpacity(opacity)
    foreign static SetWindowFocused()
    foreign static GetScreenWidth()
    foreign static GetScreenHeight()
    foreign static GetRenderWidth()
    foreign static GetRenderHeight()
    foreign static GetMonitorCount()
    foreign static GetCurrentMonitor()
    foreign static GetMonitorPosition(inpos, monitor)
    foreign static GetMonitorWidth(monitor)
    foreign static GetMonitorHeight(monitor)
    foreign static GetMonitorPhysicalWidth(monitor)
    foreign static GetMonitorPhysicalHeight(monitor)
    foreign static GetMonitorRefreshRate(monitor)
    foreign static GetWindowPosition(inpos)
    foreign static GetWindowScaleDPI(inscale)
    foreign static GetMonitorName(monitor)
    foreign static SetClipboardText(text)
    foreign static GetClipboardText()
    foreign static EnableEventWaiting()
    foreign static DisableEventWaiting()

    foreign static ShowCursor()
    foreign static HideCursor()
    foreign static IsCursorHidden()
    foreign static EnableCursor()
    foreign static DisableCursor()
    foreign static IsCursorOnScreen()

    foreign static ClearBackground(color)
    foreign static BeginDrawing()
    foreign static EndDrawing()
    foreign static BeginMode2D(camera)
    foreign static EndMode2D()
    foreign static BeginMode3D(camera)
    foreign static EndMode3D()
    foreign static BeginTextureMode(target)
    foreign static EndTextureMode()
    foreign static BeginShaderMode(shader)
    foreign static EndShaderMode()
    foreign static BeginBlendMode(mode)
    foreign static EndBlendMode()
    foreign static BeginScissorMode(x,y,width,height)
    foreign static EndScissorMode()
    foreign static BeginVrStereoMode(config)
    foreign static EndVrStereoMode()

    foreign static LoadVrStereoConfig(inconfig, device)
    foreign static UnloadVrStereoConfig(config)

    foreign static LoadShader(inshader, vsFileName, fsFileName)
    foreign static LoadShaderFromMemory(inshader, vsCode, fsCode)
    foreign static IsShaderReady(shader)
    foreign static GetShaderLocation(shader, uniformName)
    foreign static GetShaderLocationAttrib(shader, attribName)
    foreign static SetShaderValue(shader, locIndex, value, uniformType)
    foreign static SetShaderValueV(shader, locIndex, value, uniformType, count)
    foreign static SetShaderValueMatrix(shader, locIndex, mat)
    foreign static SetShaderValueTexture(shader, locIndex, texture)
    foreign static UnloadShader(shader)

    foreign static GetMouseRay(inray, mousePosition, camera)
    foreign static GetCameraMatrix(inmat, camera)
    foreign static GetCameraMatrix2D(inmat, camera)
    foreign static GetWorldToScreen(inpos, position, camera)
    foreign static GetScreenToWorld2D(inpos, position, camera)
    foreign static GetWorldToScreenEx(inpos, position, camera, width, height)
    foreign static GetWorldToScreen2D(inpos, position, camera)

    foreign static SetTargetFPS(fps)
    foreign static GetFrameTime()
    foreign static GetTime()
    foreign static GetFPS()
    
    foreign static SwapScreenBuffer()
    foreign static PollInputEvents()
    foreign static WaitTime(seconds)

    foreign static SetRandomSeed(seed)
    foreign static GetRandomValue(min, max)
    foreign static LoadRandomSequence(invlist, count, min, max)
    foreign static UnloadRandomSequence(vlist)

    foreign static TakeScreenshot(fileName)
    foreign static SetConfigFlags(flags)
    foreign static OpenURL(url)

    foreign static LoadFileData(fileName, dataSize)
    foreign static UnloadFileData(data)
    foreign static SaveFileData(fileName, data, dataSize)
    foreign static ExportDataAsCode(data, dataSize, fileName)
    foreign static LoadFileText(fileName)
    foreign static UnloadFileText(text)
    foreign static SaveFileText(fileName, text)

    foreign static FileExists(fileName)
    foreign static DirectoryExists(dirPath)
    foreign static IsFileExtension(fileName, ext)
    foreign static GetFileLength(fileName)
    foreign static GetFileExtension(fileName)
    foreign static GetFileName(filePath)
    foreign static GetFileNameWithoutExt(filePath)
    foreign static GetDirectoryPath(filePath)
    foreign static GetPrevDirectoryPath(dirPath)
    foreign static GetWorkingDirectory()
    foreign static GetApplicationDirectory()
    foreign static ChangeDirectory(dir)
    foreign static IsPathFile(path)
    foreign static LoadDirectoryFiles(inpathList, dirPath)
    foreign static LoadDirectoryFilesEx(inpathList, basePath, filter, scanSubdirs)
    foreign static UnloadDirectoryFiles(files)
    foreign static IsFileDropped()
    foreign static LoadDroppedFiles(infileList)
    foreign static UnloadDroppedFiles(files)
    foreign static GetFileModTime(fileName)

    foreign static CompressData(data, dataSize, compDataSize)
    foreign static DecompressData(compData, compDataSize, dataSize)
    foreign static EncodeDataBase64(data, dataSize, outputSize)
    foreign static DecodeDataBase64(data, outputSize)

    foreign static LoadAutomationEventList(ineventList, fileName)
    foreign static UnloadAutomationEventList(list)
    foreign static ExportAutomationEventList(list, fileName)
    foreign static SetAutomationEventList(list)
    foreign static SetAutomationEventBaseFrame(frame)
    foreign static StartAutomationEventRecording()
    foreign static StopAutomationEventRecording()
    foreign static PlayAutomationEvent(event)

    foreign static IsKeyPressed(key)
    foreign static IsKeyPressedRepeat(key)
    foreign static IsKeyDown(key)
    foreign static IsKeyReleased(key)
    foreign static IsKeyUp(key)
    foreign static GetKeyPressed()
    foreign static GetCharPressed()
    foreign static SetExitKey(key)

    foreign static IsGamepadAvailable(gamepad)
    foreign static GetGamepadName(gamepad)
    foreign static IsGamepadButtonPressed(gamepad, button)
    foreign static IsGamepadButtonDown(gamepad, button)
    foreign static IsGamepadButtonReleased(gamepad, button)
    foreign static IsGamepadButtonUp(gamepad, button)
    foreign static GetGamepadButtonPressed()
    foreign static GetGamepadAxisCount(gamepad)
    foreign static GetGamepadAxisMovement(gamepad, axis)
    foreign static SetGamepadMappings(gamepad)

    foreign static IsMouseButtonPressed(button)
    foreign static IsMouseButtonDown(button)
    foreign static IsMouseButtonReleased(button)
    foreign static IsMouseButtonUp(button)
    foreign static GetMouseX()
    foreign static GetMouseY()
    foreign static GetMousePosition(inpos)
    foreign static GetMouseDelta(indelta)
    foreign static SetMousePosition(x,y)
    foreign static SetMouseOffset(offsetX,offsetY)
    foreign static SetMouseScale(scaleX,scaleY)
    foreign static GetMouseWheelMove()
    foreign static GetMouseWheelMoveV(inv)
    foreign static SetMouseCursor(cursor)

    foreign static GetTouchX()
    foreign static GetTouchY()
    foreign static GetTouchPosition(inpos, index)
    foreign static GetTouchPointId(index)
    foreign static GetTouchPointCount()

    foreign static SetGesturesEnabled(flags)
    foreign static IsGestureDetected(gesture)
    foreign static GetGestureDetected()
    foreign static GetGestureHoldDuration()
    foreign static GetGestureDragVector(inv2)
    foreign static GetGestureDragAngle()
    foreign static GetGesturePinchVector(inv2)
    foreign static GetGesturePinchAngle()

    foreign static UpdateCamera(camera, mode)
    foreign static UpdateCameraPro(camera, movement, rotation, zoom)

    foreign static SetShapesTexture(texture, source)

    foreign static DrawPixel(posX, posY, color)
    foreign static DrawPixelV(position, color)
    foreign static DrawLine(startPosX, startPosY, endPosX, endPosY, color)
    foreign static DrawLineV(startPos, endPos, color)
    foreign static DrawLineEx(startPos, endPos, thick, color)
    foreign static DrawLineStrip(points, pointCount, color)
    foreign static DrawLineBezier(startPos, endPos, thick, color)
    foreign static DrawCircle(centerX, centerY, radius, color)
    foreign static DrawCircleSector(center, radius, startAngle, endAngle, segments, color)
    foreign static DrawCircleSectorLines(center, radius, startAngle, endAngle, segments, color)
    foreign static DrawCircleGradient(centerX, centerY, radius, color1, color2)
    foreign static DrawCircleV(center, radius, color)
    foreign static DrawCircleLines(centerX, centerY, radius, color)
    foreign static DrawCircleLinesV(center, radius, color)
    foreign static DrawEllipse(centerX, centerY, radiusH, radiusV, color)
    foreign static DrawEllipseLines(centerX, centerY, radiusH, radiusV, color)
    foreign static DrawRing(center, innerRadius, outerRadius, startAngle, endAngle, segments, color)
    foreign static DrawRectangle(posX, posY, width,height, color)
    foreign static DrawRectangleRec(rec, color)
    foreign static DrawRectanglePro(rec, origin, rotation, color)
    foreign static DrawRectangleGradientV(posX, posY, width, height, color1, color2)
    foreign static DrawRectangleGradientH(posX, posY, width, height, color1, color2)
    foreign static DrawRectangleGradientEx(rec, col1, col2, col3, col4)
    foreign static DrawRectangleLines(posX, posY,width, height, color)
    foreign static DrawRectangleLinesEx(rec, lineThick, color)
    foreign static DrawRectangleRounded(rec, roundness, segments, color)
    foreign static DrawRectangleRoundedLines(rec, roundness, segments, lineThick, color)
    foreign static DrawTriangle(v1, v2, v3, color)
    foreign static DrawTriangleLines(v1, v2, v3, color)
    foreign static DrawTriangleFan(points, pointCount, color)
    foreign static DrawTriangleStrip(points, pointCount, color)
    foreign static DrawPoly(center, sides, radius, rotation, color)
    foreign static DrawPolyLines(center, sides, radius, rotation, color)
    foreign static DrawPolyLinesEx(center, sides, radius, rotation, lineThick, color)

    foreign static DrawSplineLinear(points, pointCount, thick, color)
    foreign static DrawSplineBasis(points, pointCount, thick, color)
    foreign static DrawSplineCatmullRom(points, pointCount, thick, color)
    foreign static DrawSplineBezierQuadratic(points, pointCount, thick, color)
    foreign static DrawSplineBezierCubic(points, pointCount, thick, color)
    foreign static DrawSplineSegmentLinear(p1, p2, thick, color)
    foreign static DrawSplineSegmentBasis(p1, p2, p3, p4, thick, color)
    foreign static DrawSplineSegmentCatmullRom(p1, p2, p3, p4, thick, color)
    foreign static DrawSplineSegmentBezierQuadratic(p1, p2, p3, thick, color)
    foreign static DrawSplineSegmentBezierCubic(p1, c2, c3, p4, thick, color)

    foreign static GetSplinePointLinear(startPos, endPos, t)
    foreign static GetSplinePointBasis(p1, p2, p3, p4, t)
    foreign static GetSplinePointCatmullRom(p1, p2, p3, p4, t)
    foreign static GetSplinePointBezierQuad(p1, p2, p3, t)
    foreign static GetSplinePointBezierCubic(p1, c2, c3, p4, t)

    foreign static CheckCollisionRecs(rec1, rec2)
    foreign static CheckCollisionCircles(center1, radius1, center2, radius2)
    foreign static CheckCollisionCircleRec(center, radius, rec)
    foreign static CheckCollisionPointRec(point, rec)
    foreign static CheckCollisionPointCircle(point, center, radius)
    foreign static CheckCollisionPointTriangle(point, p1, p2, p3)
    foreign static CheckCollisionPointPoly(point, points, pointCount)
    foreign static CheckCollisionLines(startPos1, endPos1, startPos2, endPos2, collisionPoint)
    foreign static CheckCollisionPointLine(point, p1, p2, threshold)
    foreign static GetCollisionRec(inrect, rec1, rec2)

    foreign static LoadImage(inimg, fileName)
    foreign static LoadImageRaw(inimg, fileName, width, height, format, headerSize)
    foreign static LoadImageSvg(inimg, fileNameOrString, width, height)
    foreign static LoadImageAnim(inimg, fileName, frames)
    foreign static LoadImageFromMemory(inimg, fileType, fileData, dataSize)
    foreign static LoadImageFromTexture(inimg, texture)
    foreign static LoadImageFromScreen(inimg)
    foreign static IsImageReady(img)
    foreign static UnloadImage(img)
    foreign static ExportImage(img, fileName)
    foreign static ExportImageToMemory(img, fileType, fileSize)
    foreign static ExportImageAsCode(img, fileName)

    foreign static GenImageColor(inimg, width, height, color)
    foreign static GenImageGradientLinear(inimg, width, height, direction, start, end)
    foreign static GenImageGradientRadial(inimg, width, height, density, iner, outer)
    foreign static GenImageGradientSquare(inimg, width, height, density, iner, outer)
    foreign static GenImageChecked(inimg, width, height, checksX, checksY, col1, col2)
    foreign static GenImageWhiteNoise(inimg, width, height, factor)
    foreign static GenImagePerlinNoise(inimg, width, height, offsetX, offsetY, scale)
    foreign static GenImageCellular(inimg, width, height, tileSize)
    foreign static GenImageText(inimg, width, height, text)

    foreign static ImageCopy(inimg, img)
    foreign static ImageFromImage(inimg, img, rec)
    foreign static ImageText(inimg, text, fontSize, color)
    foreign static ImageTextEx(inimg, font, text, fontSize, spacing, tint)
    foreign static ImageFormat(img, newFormat)
    foreign static ImageToPOT(img, fill)
    foreign static ImageAlphaCrop(img, threshold)
    foreign static ImageAlphaClear(img, color, threshold)
    foreign static ImageAlphaMask(img, alphaMask)
    foreign static ImageAlphaPremultiply(img)
    foreign static ImageBlurGaussian(img, blurSize)
    foreign static ImageKernelConvolution(img, kernel, kernelSize)
    foreign static ImageResize(img, newWidth, newHeight)
    foreign static ImageResizeNN(img, newWidth, newHeight)
    foreign static ImageResizeCanvas(img, newWidth, newHeight, offsetX, offsetY, fill)
    foreign static ImageMipmaps(img)
    foreign static ImageDither(img, rBpp, gBpp, bBpp, aBpp)
    foreign static ImageFlipVertical(img)
    foreign static ImageFlipHorizontal(img)
    foreign static ImageRotate(img, degrees)
    foreign static ImageRotateCW(img)
    foreign static ImageRotateCCW(img)
    foreign static ImageColorTint(img, color)
    foreign static ImageColorInvert(img)
    foreign static ImageColorGrayscale(img)
    foreign static ImageColorContrast(img, contrast)
    foreign static ImageColorBrightness(img, brightness)
    foreign static ImageColorReplace(img, color, replace)
    foreign static LoadImageColors(incolor, img)
    foreign static LoadImagePalette(incolor, img, maxPaletteSize, colorCount)
    foreign static UnloadImageColors(colors)
    foreign static UnloadImagePalette(colors)
    foreign static GetImageAlphaBorder(inrect, img, threshold)
    foreign static GetImageColor(incolor, img, x, y)

    foreign static ImageClearBackground(dst, color)
    foreign static ImageDrawPixel(dst, posX, posY, color)
    foreign static ImageDrawPixelV(dst, position, color)
    foreign static ImageDrawLine(dst, startPosX, startPosY, endPosX, endPosY, color)
    foreign static ImageDrawLineV(dst, start, end, color)
    foreign static ImageDrawCircle(dst, centerX, centerY, radius, color)
    foreign static ImageDrawCircleV(dst, center, radius, color)
    foreign static ImageDrawCircleLines(dst, centerX, centerY, radius, color)
    foreign static ImageDrawCircleLinesV(dst, center, radius, color)
    foreign static ImageDrawRectangle(dst, posX, posY, width, height, color)
    foreign static ImageDrawRectangleV(dst, pos, size, color)
    foreign static ImageDrawRectangleRec(dst, rec, color)
    foreign static ImageDrawRectangleLines(dst, rec, thick, color)
    foreign static ImageDraw(dst, src, srcRec, dstRec, color)
    foreign static ImageDrawText(dst, text, posX, posY, fontSize, color)
    foreign static ImageDrawTextEx(dst, font, text, position, fontSize, spacing, color)

    foreign static LoadTexture(intex, fileName)
    foreign static LoadTextureFromImage(intex, img)
    foreign static LoadTextureCubemap(intex, img, layout)
    foreign static LoadRenderTexture(intex, width, height)
    foreign static IsTextureReady(texture)
    foreign static UnloadTexture(texture)
    foreign static IsRenderTextureReady(target)
    foreign static UnloadRenderTexture(target)
    foreign static UpdateTexture(texture, pixels)
    foreign static UpdateTextureRec(texture, rec, pixels)

    foreign static GenTextureMipmaps(texture)
    foreign static SetTextureFilter(texture, filter)
    foreign static SetTextureWrap(texture, wrap)

    foreign static DrawTexture(texture, posX, posY, tint)
    foreign static DrawTextureV(texture, position, tint)
    foreign static DrawTextureEx(texture, position, rotation, scale, tint)
    foreign static DrawTextureRec(texture, source, position, tint)
    foreign static DrawTexturePro(texture, source, dest, origin, rotation, tint)
    foreign static DrawTextureNPatch(texture, nPatchInfo, dest, origin, rotation, tint)

    foreign static Fade(incolor, color, alpha)
    foreign static ColorToInt(color)
    foreign static ColorNormalize(inv4, color)
    foreign static ColorFromNormalized(incolor, normalized)
    foreign static ColorToHSV(inv3, color)
    foreign static ColorFromHSV(incolor, hue, seturation, value)
    foreign static ColorTint(incolor, color, tint)
    foreign static ColorBrightness(incolor, color, factor)
    foreign static ColorContrast(incolor, color, contrast)
    foreign static ColorAlpha(incolor, color, alpha)
    foreign static ColorAlphaBlend(incolor, dist, src, tint)
    foreign static GetColor(incolor, hexValue)
    foreign static GetPixelColor(incolor, srcPtr, format)
    foreign static SetPixelColor(dstPtr, color, format)
    foreign static GetPixelDataSize(width, height, format)

    foreign static GetFontDefault(infont)
    foreign static LoadFont(infont, fileName)
    foreign static LoadFontEx(infont, fileName, fontSize, codepoints, codepointCount)
    foreign static LoadFontFromImage(infont, image, key, firstChar)
    foreign static LoadFontFromMemory(infont, fileType, fileData, dataSize, fontSize, codepoints, codepointCount)
    foreign static IsFontReady(font)
    foreign static LoadFontData(inglyphInfo, fileData, dataSize, fontSize, codepoints, codepointCount, type)
    foreign static GenImageFontAtlas(inimg, glyphs, glyphRecs, glyphCount, fontSize, padding, packMethod)
    foreign static UnloadFontData(glyphs, glyphCount)
    foreign static UnloadFont(font)
    foreign static ExportFontAsCode(font, fileName)

    foreign static DrawFPS(posX, posY)
    foreign static DrawText(text, posX, posY, fontSize, color)
    foreign static DrawTextEx(font, text, position, fontSize, spacing, tint)
    foreign static DrawTextPro(font, text, position, origin, rotation, fontSize, spacing, tint)
    foreign static DrawTextCodepoint(font, codepoint, position, fontSize, tint)
    foreign static DrawTextCodepoints(font, codepoints, codepointCount, position, fontSize, spacing, tint)

    foreign static SetTextLineSpacing(spacing)
    foreign static MeasureText(text, fontSize)
    foreign static MeasureTextEx(inv2, font, text, fontSize, spacing)
    foreign static GetGlyphIndex(font, codepoint)
    foreign static GetGlyphInfo(inglyphinfo, font, codepoint)
    foreign static GetGlyphAtlasRec(inglyphinfo, font, codepoint)

    foreign static LoadUTF8(codepoints, length)
    foreign static UnloadUTF8(text)
    foreign static LoadCodepoints(text, count)
    foreign static UnloadCodepoints(codepoints)
    foreign static GetCodepointCount(text)
    foreign static GetCodepoint(text, codepointSize)
    foreign static GetCodepointNext(text, codepointSize)
    foreign static GetCodepointPrevious(text, codepointSize)
    foreign static CodepointToUTF8(text, utf8Size)

    foreign static TextCopy(dst, src)
    foreign static TextIsEqual(text1, text2)
    foreign static TextLength(text)
    foreign static TextFormat(text)
    foreign static TextSubtext(text, position, length)
    foreign static TextReplace(text, replace, by)
    foreign static TextInsert(text, insert, position)
    foreign static TextJoin(textList, count, delimiter)
    foreign static TextSplit(text, delimiter, count)
    foreign static TextAppend(text, append, position)
    foreign static TextFindIndex(text, find)
    foreign static TextToUpper(text)
    foreign static TextToLower(text)
    foreign static TextToPascal(text)
    foreign static TextToInteger(text)

    foreign static DrawLine3D(startPos, endPos, color)
    foreign static DrawPoint3D(position, color)
    foreign static DrawCircle3D(center, radius, rotationAxis, rotationAngle, color)
    foreign static DrawTriangle3D(v1, v2, v3, color)
    foreign static DrawTriangleStrip3D(points, pointCount, color)
    foreign static DrawCube(position, width, height, length, color)
    foreign static DrawCubeV(position, size, color)
    foreign static DrawCubeWires(position, width, height, length, color)
    foreign static DrawCubeWiresV(position, size, color)
    foreign static DrawSphere(centerPos, radius, color)
    foreign static DrawSphereEx(centerPos, radius, rings, slices, color)
    foreign static DrawSphereWires(centerPos, radius, rings, slices, color)
    foreign static DrawCylinder(startPos, radiusTop, radiusBottom, height, slices, color)
    foreign static DrawCylinderEx(startPos, endPos, startRadius, endRadius, slices, color)
    foreign static DrawCylinderWires(position, radiusTop, radiusBottom, height, slices, color)
    foreign static DrawCylinderWiresEx(startPos, endPos, startRadius, endRadius, slices, color)
    foreign static DrawCapsule(startPos, endPos, radius, slices, rings, color)
    foreign static DrawCapsuleWires(startPos, endPos, radius, slices, rings, color)
    foreign static DrawPlane(centerPos, size, color)
    foreign static DrawRay(DrawRay, color)
    foreign static DrawGrid(slices, spacing)

    foreign static LoadModel(inmodel, fileName)
    foreign static LoadModelFromMesh(inmodel, mesh)
    foreign static IsModelReady(model)
    foreign static UnloadModel(model)
    foreign static GetModelBoundingBox(inbbox, model)

    foreign static DrawModel(model, epositionndPos, scale, tint)
    foreign static DrawModelEx(model, position, rotationAxis, rotationAngle, scale, tint)
    foreign static DrawModelWires(model, position, scale, tint)
    foreign static DrawModelWiresEx(model, position, rotationAxis, rotationAngle, scale, tint)
    foreign static DrawBoundingBox(box, color)
    foreign static DrawBillboard(camera, texture, position, size, tint)
    foreign static DrawBillboardRec(camera, texture, source, position, size, tint)
    foreign static DrawBillboardPro(camera, texture, source, position, up, size, origin, rotation, tint)

    foreign static UploadMesh(mesh, dynamic)
    foreign static UpdateMeshBuffer(mesh, indx, data, dataSize, offset)
    foreign static UnloadMesh(mesh)
    foreign static DrawMesh(mesh, material, transform)
    foreign static DrawMeshInstanced(mesh, material, transforms, instances)
    foreign static ExportMesh(mesh, fileName)
    foreign static GetMeshBoundingBox(inbbox, mesh)
    foreign static GenMeshTangents(mesh)

    foreign static GenMeshPoly(inmesh, sides, radius)
    foreign static GenMeshPlane(inmesh, width, length, reX, resZ)
    foreign static GenMeshCube(inmesh, width, height, length)
    foreign static GenMeshSphere(inmesh, radius, rings, slices)
    foreign static GenMeshHemiSphere(inmesh, radius, rings, sleics)
    foreign static GenMeshCylinder(inmesh, radius, height, slices)
    foreign static GenMeshCone(inmesh, radius, height, slices)
    foreign static GenMeshTorus(inmesh, radius, size, radSeg, sides)
    foreign static GenMeshKnot(inmesh, radius, size, radSeg, sides)
    foreign static GenMeshHeightmap(inmesh, heightmap, size)
    foreign static GenMeshCubicmap(inmesh, cubicmap, cubeSize)

    foreign static LoadMaterials(inmaterial, fileName, materialCount)
    foreign static LoadMaterialDefault(inmaterial)
    foreign static IsMaterialReady(material)
    foreign static UnloadMaterial(material)
    foreign static SetMaterialTexture(material, mapType, texture)
    foreign static SetModelMeshMaterial(material, meshId, materialId)

    foreign static LoadModelAnimations(inanim, fileName, animCount)
    foreign static UpdateModelAnimation(model, anim, frame)
    foreign static UnloadModelAnimation(anim)
    foreign static UnloadModelAnimations(animations, animCount)
    foreign static IsModelAnimationValid(model, anim)
    
    foreign static CheckCollisionSpheres(center1, radius1, center2, radius2)
    foreign static CheckCollisionBoxes(box1, box2)
    foreign static CheckCollisionBoxSphere(box, center, radius)
    foreign static GetRayCollisionSphere(incollision, ray, center, radius)
    foreign static GetRayCollisionBox(incollision, ray, box)
    foreign static GetRayCollisionMesh(incollision, ray, mesh, transform)    
    foreign static GetRayCollisionTriangle(incollision, ray, p1, p2, p3)
    foreign static GetRayCollisionQuad(incollision, ray, p1, p2, p3, p4)

    static PACK_RECT_MATH_DEFAULT{0}
    static PACK_RECT_MATH_BLH{0}
    static PACK_RECT_MATH_BFH{1}
    foreign static PackRectangles(in_rects, out_rects, max_width, max_height, method)
}

// raymath
foreign class Vector2 {
    construct new() {}
    construct new(x_, y_) {
        x = x_ 
        y = y_
    }
    +(val) {
        if(val is Num) { 
            return Vector2.new(this.x + val, this.y + val) 
        } else if(val is Vector2) {
            return Vector2.new(this.x + val.x, this.y + val.y)
        } else {
            return Vector2.new(this.x, this.y)
        }
    }
    -(val) {
        if(val is Num) { 
            return Vector2.new(this.x - val, this.y - val) 
        } else if(val is Vector2) {
            return Vector2.new(this.x - val.x, this.y - val.y)
        } else {
            System.print("[Error] Right operator must be Num or Vector2")
            return Vector2.new(this.x, this.y)
        }
    }
    *(val) {
        if(val is Num) { 
            return Vector2.new(this.x * val, this.y * val) 
        } else if(val is Vector2) {
            return Vector2.new(this.x * val.x, this.y * val.y)
        } else {
            System.print("[Error] Right operator must be Num or Vector2")
            return Vector2.new(this.x, this.y)
        }
    }
    /(val) {
        if(val is Num) { 
            return Vector2.new(this.x / val, this.y / val) 
        } else if(val is Vector2) {
            return Vector2.new(this.x / val.x, this.y / val.y)
        } else {
            System.print("[Error] Right operator must be Num or Vector2")
            return Vector2.new(this.x, this.y)
        }
    }
    foreign x
    foreign x=(val)
    foreign y
    foreign y=(val)
    length{Vector2.Vector2Length(this)}
    lengthSqr{Vector2.Vector2LengthSqr(this)}
    normalize{Vector2.Vector2Normalize(this)}
    dot(val) {
        if(val is Vector2) {
            return Vector2.Vector2DotProduct(val)
        } else {
            System.print("[Error] Right operator must be Num or Vector2")
            return Vector2.new(this.x, this.y)
        }
    }
    distance(val){
        if(val is Vector2) {
            return Vector2.Vector2Distance(this, val)
        } else {
            System.print("[Error] Right operator must be Num or Vector2")
            return 0
        }
    }
    distanceSqr(val) {
        if(val is Vector2) {
            return Vector2.Vector2DistanceSqr(this, val)
        } else {
            System.print("[Error] Right operator must be Num or Vector2")
            return 0
        }
    }

    foreign static Vector2Zero()
    foreign static Vector2One()
    foreign static Vector2Add(v1, v2)
    foreign static Vector2AddValue(v, add)
    foreign static Vector2Subtract(v1, v2)
    foreign static Vector2SubtractValue(v, sub)
    foreign static Vector2Length(v)
    foreign static Vector2LengthSqr(v)
    foreign static Vector2DotProduct(v1, v2)
    foreign static Vector2Distance(v1, v2)
    foreign static Vector2DistanceSqr(v1, v2)
    foreign static Vector2Angle(v1, v2)
    foreign static Vector2LineAngle(start, end)
    foreign static Vector2Scale(v, scale)
    foreign static Vector2Multiply(v1, v2)
    foreign static Vector2Negate(v)
    foreign static Vector2Divide(v1, v2)
    foreign static Vector2Normalize(v)
    foreign static Vector2Transform(v, mat)
    foreign static Vector2Lerp(v1, v2, amount)
    foreign static Vector2Reflect(v, normal)
    foreign static Vector2Rotate(v, angle)
    foreign static Vector2MoveTowards(v, target, maxDistance)
    foreign static Vector2Invert(v)
    foreign static Vector2Clamp(v, min, max)
    foreign static Vector2ClampValue(v, min, max)
    foreign static Vector2Equals(p, q)
}

foreign class Vector3 {
    construct new() {}
    construct new(x_, y_, z_) {
        x = x_ 
        y = y_ 
        z = z_
    }
    foreign x
    foreign x=(val)
    foreign y
    foreign y=(val)
    foreign z
    foreign z=(val)
    +(val) {
        return Vector3.new(this.x + val.x, this.y + val.y, this.z + val.z)
    }
    *(val) {
        if(val is Num) {
            return Vector3.new(this.x * val, this.y * val, this.z * val)
        } else if(val is Vector3) {
            return Vector3.new(this.x * val.x, this.y * val.y, this.z * val.z)
        } else {
            return Vector3.new(this.x, this.y, this.z)
        }
    }
    multiply(val) {
        if(val is Num) {
            this.x = this.x * val
            this.y = this.y * val
            this.z = this.z * val
        }
    }

    foreign static Vector3Zero()
    foreign static Vector3One()
    foreign static Vector3Add(v1, v2)
    foreign static Vector3AddValue(v, add)
    foreign static Vector3Subtract(v1, v2)
    foreign static Vector3SubtractValue(v, sub)
    foreign static Vector3Scale(v, scalar)
    foreign static Vector3Multiply(v1, v2)
    foreign static Vector3CrossProduct(v1, v2)
    foreign static Vector3Perpendicular(v)
    foreign static Vector3Length(v)
    foreign static Vector3LengthSqr(v)
    foreign static Vector3DotProduct(v1, v2)
    foreign static Vector3Distance(v1, v2)
    foreign static Vector3DistanceSqr(v1, v2)
    foreign static Vector3Angle(v1, v2)
    foreign static Vector3Negate(v)
    foreign static Vector3Divide(v1, v2)
    foreign static Vector3Normalize(v)
    foreign static Vector3Project(v1, v2)
    foreign static Vector3Reject(v1, v2)
    foreign static Vector3OrthoNormalize(v1, v2)
    foreign static Vector3Transform(v, mat)
    foreign static Vector3RotateByQuaternion(v, q)
    foreign static Vector3RotateByAxisAngle(v, axis, angle)
    foreign static Vector3Lerp(v1, v2, amount)
    foreign static Vector3Reflect(v, normal)
    foreign static Vector3Min(v1, v2)
    foreign static Vector3Max(v1, v2)
    foreign static Vector3Barycenter(p, a, b, c)
    foreign static Vector3Unproject(source, projection, view)
    foreign static Vector3ToFloatV(v)
    foreign static Vector3Invert(v)
    foreign static Vector3Clamp(v, min, max)
    foreign static Vector3ClampValue(v, min, max)
    foreign static Vector3Equals(p, q)
    foreign static Vector3Refract(v, n, r)
}

foreign class Vector4 {
    construct new() {}
    construct new(x_, y_, z_, w_) {
        x = x_ 
        y = y_ 
        z = z_ 
        w = w_
    }
    foreign x
    foreign x=(val)
    foreign y
    foreign y=(val)
    foreign z
    foreign z=(val)
    foreign w
    foreign w=(val)
}

foreign class Quaternion {
    construct new() {}
    construct new(x_, y_, z_, w_) {
        x = x_ 
        y = y_ 
        z = z_ 
        w = w_
    }
    foreign x
    foreign x=(val)
    foreign y
    foreign y=(val)
    foreign z
    foreign z=(val)
    foreign w
    foreign w=(val)
    foreign static QuaternionAdd(q1, q2)
    foreign static QuaternionAddValue(q, add)
    foreign static QuaternionSubtract(q1, q2)
    foreign static QuaternionSubtractValue(q, sub)
    foreign static QuaternionIdentity()
    foreign static QuaternionLength(q)
    foreign static QuaternionNormalize(q)
    foreign static QuaternionInvert(q)
    foreign static QuaternionMultiply(q1, q2)
    foreign static QuaternionScale(q, mul)
    foreign static QuaternionDivide(q1, q2)
    foreign static QuaternionLerp(q1, q2, amount)
    foreign static QuaternionNlerp(q1, q2, amount)
    foreign static QuaternionSlerp(q1, q2, amount)
    foreign static QuaternionFromVector3ToVector3(from, to)
    foreign static QuaternionFromMatrix(mat)
    foreign static QuaternionToMatrix(q)
    foreign static QuaternionFromAxisAngle(axis, angle)
    foreign static QuaternionToAxisAngle(q, outAxis, outAngle)
    foreign static QuaternionFromEuler(pitch, yaw, roll)
    foreign static QuaternionToEuler(q)
    foreign static QuaternionTransform(q, mat)
    foreign static QuaternionEquals(p, q)
}

foreign class Matrix {
    construct new() {}
    foreign [index]
    foreign [index]=(val)
    *(val) {
        if(val is Matrix) {
            return Matrix.MatrixMultiply(this, val)
        } else {
            return this
        }
    }
    -(val) {
        if(val is Matrix) {
            return Matrix.MatrixSubtract(this, val)
        } else {
            return this
        }
    }
    +(val) {
        if(val is Matrix) {
            return Matrix.MatrixAdd(this, val)
        } else {
            return this
        }
    }
    foreign static MatrixDeterminant(mat)
    foreign static MatrixTrace(mat)
    foreign static MatrixTranspose(mat)
    foreign static MatrixInvert(mat)
    foreign static MatrixIdentity()
    foreign static MatrixAdd(left, right)
    foreign static MatrixSubtract(left, right)
    foreign static MatrixMultiply(left, right)
    foreign static MatrixTranslate(x, y, z)
    foreign static MatrixRotate(axis, angle)
    foreign static MatrixRotateX(angle)
    foreign static MatrixRotateY(angle)
    foreign static MatrixRotateZ(angle)
    foreign static MatrixRotateXYZ(angle)
    foreign static MatrixRotateZYX(angle)
    foreign static MatrixScale(x, y, z)
    foreign static MatrixFrustum(left, right, bottom, top, near, far)
    foreign static MatrixPerspective(fovY, aspect, nearPlane, farPlane)
    foreign static MatrixOrtho(left, right, bottom, top, nearPlane, farPlane)
    foreign static MatrixLookAt(eye, target, up)
    foreign static MatrixToFloatV(mat)
}

foreign class float3 {
    construct new() {}
    foreign [index]
    foreign [index]=(val)
}

foreign class float16 {
    construct new() {}
    foreign [index]
    foreign [index]=(val)
}


class RayMath {
    foreign static Clamp(value, min, max)
    foreign static Lerp(start, end, amount)
    foreign static Normalize(value, start, end)
    foreign static Remap(value, inputStart, inputEnd, outputStart, outputEnd)
    foreign static Wrap(value, min, max)
    foreign static FloatEquals(x, y)
}