import "cico.raylib" for Raylib,Rectangle,Value,ValueList,Color, Vector2, Vector3, Font
import "cico.raygui" for RayGui 

class DrawType {
    static None {0}
    static Icon {1}
    static Window {2}
    static Group {3}
    static Line {4}
    static Panel {5}
    static TabBar {6}
    static ScrollPanel {7}
    static Label {8}
    static Button {9}
    static LabelButton {10}
    static Toggle {11}
    static ToggleGroup {12}
    static ToggleSlider {13}
    static CheckBox {14}
    static ComboBox {15}
    static DropdownBox {16}
    static Spinner {17}
    static ValueBox {18}
    static TextBox {19}
    static Slider {20}
    static SliderBar {21}
    static ProgressBar {22}
    static StatusBar {23}
    static DummyRec {24}
    static Grid {25}
    static ListView {26}
    static ListViewEx {27}
    static MessageBox {28}
    static TextInputBox {29}
    static ColorPicker {30}
    static ColorPanel {31}
    static ColorBarAlpha {32}
    static ColorBarHue {33}
    static ColorPickerHSV {34}
    static ColorPanelHSV {35}
}

class GuiControl {
    static DEFAULT{0}
    static LABEL{1}
    static BUTTON{2}
    static TOGGLE{3}
    static SLIDER{4}
    static PROGRESSBAR{5}
    static CHECKBOX{6}
    static COMBOBOX{7}
    static DROPDOWNBOX{8}
    static TEXTBOX{9}
    static VALUEBOX{10}
    static SPINNER{11}
    static LISTVIEW{12}
    static COLORPICKER{13}
    static SCROLLBAR{14}
    static STATUSBAR{15}
}

class GuiStyle {
    static Ashes {"styles/style_ashes.rgs"}
    static Bluish {"styles/style_bluish.rgs"}
    static Candy {"styles/style_candy.rgs"}
    static Cherry {"styles/style_cherry.rgs"}
    static Cyber {"styles/style_cyber.rgs"}
    static Dark {"styles/style_dark.rgs"}
    static Enefete {"styles/style_enefete.rgs"}
    static Jungle {"styles/style_jungle.rgs"}
    static Lavanda {"styles/style_lavanda.rgs"}
    static Sunny {"styles/style_sunny.rgs"}
    static Terminal {"styles/style_terminal.rgs"}
}

class GuiProperty {
    static BORDER_COLOR_NORMAL {0}
    static BASE_COLOR_NORMAL {1}
    static TEXT_COLOR_NORMAL {2}
    static BORDER_COLOR_FOCUSED {3}
    static BASE_COLOR_FOCUSED {4}
    static TEXT_COLOR_FOCUSED {5}
    static BORDER_COLOR_PRESSED {6}
    static BASE_COLOR_PRESSED {7}
    static TEXT_COLOR_PRESSED {8}
    static BORDER_COLOR_DISABLED {9}
    static BASE_COLOR_DISABLED {10}
    static TEXT_COLOR_DISABLED {11}

    static BORDER_WIDTH {12}
    static TEXT_PADDING {13}
    static TEXT_ALIGNMENT {14}

    // extend properties
    static TEXT_SIZE {16}
    static TEXT_SPACING {17}
    static LINE_COLOR {18}
    static BACKGROUND_COLOR {19}
    static TEXT_LINE_SPACING {20}
    static TEXT_ALIGNMENT_VERTICAL {21}
    static TEXT_WRAP_MODE {22}
}

class ControlResult {
    construct new(type_, code_, values_) { 
        _code = code_ 
        _type = type_ 
        _values = values_
    } 
    code {_code}
    type {_type}
    values {_values}
}

class CUI {
    construct new() {
        _code = 0
        _valueInt = Value.new()
        _valueInt.create(Raylib.VALUE_TYPE_INT, 0)
        _valueInt1 = Value.new()
        _valueInt1.create(Raylib.VALUE_TYPE_INT, 0)
        _valueInt2 = Value.new()
        _valueInt2.create(Raylib.VALUE_TYPE_INT, 0)
        _valueBool = Value.new()
        _valueBool.create(Raylib.VALUE_TYPE_BOOLEAN, false)
        _valueString = Value.new()
        _valueString.create(Raylib.VALUE_TYPE_STRING, "")
        _valueFloat = Value.new()
        _valueFloat.create(Raylib.VALUE_TYPE_FLOAT, 0)
        _font = Font.new()
        Raylib.LoadFont(_font, "fonts/default.ttf")
    }

    font{_font}

    static SetFont(font) { RayGui.GuiSetFont(font) }
    static GetFont() {
        var f = Font.new()
        RayGui.GuiGetFont(f)
        return f
    }
    static LoadInternalStyle(fileName) { RayGui.GuiLoadStyle(fileName) }

    static LoadStyle(fileName) {}

    static GetStyle(control, property) { 
        return RayGui.GuiGetStyle(control, property) 
    }
    static SetStyle(control, property, value) { RayGui.GuiSetStyle(control, property, value) }

    Icon(iconId, x, y, pxSize, color) {
        _code = RayGui.GuiDrawIcon(iconId, x, y, pxSize, color)
        return ControlResult.new(DrawType.Icon, _code, [])
    }

    Window(bounds, title) {
        _code = RayGui.GuiWindowBox(bounds, title)
        return ControlResult.new(DrawType.Window, _code, [])
    }
    Group(bounds, text) {
        _code = RayGui.GuiGroupBox(bounds, text)
        return ControlResult.new(DrawType.Group, _code, [])
    }
    Line(bounds, text) {
        _code = RayGui.GuiLine(bounds, text)
        return ControlResult.new(DrawType.Line, _code, [])
    }
    Panel(bounds, text) {
        _code = RayGui.GuiPanel(bounds, text)
        return ControlResult.new(DrawType.Panel, _code, [])
    }
    TabBar(bounds, vlist, currentIndex) {
        if(vlist.count > 0) {
            _valueInt.set(currentIndex)
            _code = RayGui.GuiTabBar(bounds, vlist, vlist.count, _valueInt)
            return ControlResult.new(DrawType.Panel, _code, [_valueInt.get(null)])
        }
    }
    ScrollPanel(bounds, text, content, scroll, view) {
        _code = RayGui.GuiScrollPanel(bounds, text, content, scroll, view)
        return ControlResult.new(DrawType.ScrollPanel, _code, [scroll, view]) 
    }

    Label(bounds, text) {
        _code = RayGui.GuiLabel(bounds, text)
        return ControlResult.new(DrawType.Label, _code, [])
    }

    Button(bounds, text) {
        _code = RayGui.GuiButton(bounds, text)
        return ControlResult.new(DrawType.Button, _code, [])
    }

    LabelButton(bounds, text) {
        _code = RayGui.GuiLabelButton(bounds, text)
        return ControlResult.new(DrawType.LabelButton, _code, [])
    }

    Toggle(bounds, text, active) {
        _valueBool.set(active)
        _code = RayGui.GuiToggle(bounds, text, _valueBool)
        return ControlResult.new(DrawType.Toggle, _code, [_valueBool.get(null)])
    }

    ToggleGroup(bounds, text, active) {
        _valueInt.set(active)
        _code = RayGui.GuiToggleGroup(bounds, text, _valueInt)
        return ControlResult.new(DrawType.ToggleGroup, _code, [_valueInt.get(null)])
    }

    ToggleSlider(bounds, text, active) {
        _valueInt.set(active)
        _code = RayGui.GuiToggleSlider(bounds, text, _valueInt)
        return ControlResult.new(DrawType.ToggleSlider, _code, [_valueInt.get(null)])
    }

    CheckBox(bounds, text, checked) {
        _valueBool.set(checked)
        _code = RayGui.GuiCheckBox(bounds, text, _valueBool)
        return ControlResult.new(DrawType.CheckBox, _code, [_valueBool.get(null)])
    }

    ComboBox(bounds, text, active) {
        _valueInt.set(active)
        _code = RayGui.GuiComboBox(bounds, text, _valueInt)
        return ControlResult.new(DrawType.ComboBox, _code, [_valueInt.get(null)])
    }

    DropdownBox(bounds, text, active, editMode) {
        _valueInt.set(active)
        _code = RayGui.GuiDropdownBox(bounds, text, _valueInt, editMode)
        return ControlResult.new(DrawType.DropdownBox, _code, [_valueInt.get(null)])
    }

    Spinner(bounds, text, value, min, max, editMode) {
        _valueInt.set(value)
        _code = RayGui.GuiSpinner(bounds, text, _valueInt, min, max, editMode)
        return ControlResult.new(DrawType.Spinner, _code, [_valueInt.get(null)])
    }

    ValueBox(bounds, text, value, min, max, editMode) {
        _valueInt.set(value)
        _code = RayGui.GuiValueBox(bounds, text, _valueInt, min, max, editMode)
        return ControlResult.new(DrawType.ValueBox, _code, [_valueInt.get(null)])
    }

    TextBox(bounds, text, textSize, editMode) {
        _code = RayGui.GuiTextBox(bounds, text, textSize, editMode)
        return ControlResult.new(DrawType.ValueBox, _code, [])
    }

    Slider(bounds, labelLeft, labelRight, value, min, max) {
        _valueInt.set(value)
        _code = RayGui.GuiSlider(bounds, labelLeft, labelRight, _valueInt, min, max)
        return ControlResult.new(DrawType.Slider, _code, [_valueInt.get(null)])
    }

    SliderBar(bounds, labelLeft, labelRight, value, min, max) {
        _valueInt.set(value)
        _code = RayGui.GuiSliderBar(bounds, labelLeft, labelRight, _valueInt, min, max)
        return ControlResult.new(DrawType.SliderBar, _code, [_valueInt.get(null)])
    }

    ProgressBar(bounds, labelLeft, labelRight, value, min, max) {
        _valueInt.set(value)
        _code = RayGui.GuiProgressBar(bounds, labelLeft, labelRight, _valueInt, min, max)
        return ControlResult.new(DrawType.ProgressBar, _code, [_valueInt.get(null)])
    }

    StatusBar(bounds, text) {
        _code = RayGui.GuiStatusBar(bounds, text)
        return ControlResult.new(DrawType.StatusBar, _code, [])
    }

    DummyRec(bounds, text) {
        _code = RayGui.GuiDummyRec(bounds, text)
        return ControlResult.new(DrawType.DummyRec, _code, [])
    }

    Grid(bounds, text, spacing, subdivs, mouseCell) {
        _code = RayGui.GuiGrid(bounds, text, spacing, subdivs, mouseCell)
        return ControlResult.new(DrawType.Grid, _code, [mouseCell])
    }

    ListView(bounds, text, scrollIndex, active) {
        _valueInt.set(active)
        _code = RayGui.GuiListView(bounds, text, _valueInt)
        return ControlResult.new(DrawType.ListView, _code, [_valueInt.get(null)])
    }

    ListViewEx(bounds, vlist, scrollIndex, active, focus) {
        _valueInt.set(active)
        _valueInt1.set(active)
        _valueInt2.set(focus)
        _code = RayGui.GuiListViewEx(bounds, vlist, vlist.count, _valueInt, _valueInt1, _valueInt2)
        return ControlResult.new(DrawType.ListViewEx, _code, [_valueInt.get(null), _valueInt1.get(null), _valueInt2.get(null)])
    }

    MessageBox(bounds, title, message, buttons) {
        _code = RayGui.GuiMessageBox(bounds, title, message, buttons)
        return ControlResult.new(DrawType.MessageBox, _code, [])
    }

    TextInputBox(bounds, title, message, buttons, text, textMaxSize, secret) {
        _valueString.set(text)
        _valueBool.set(secret)
        _code = RayGui.GuiTextInputBox(bounds, title, message, buttons, _valueString, textMaxSize, _valueBool)
        return ControlResult.new(DrawType.TextInputBox, _code, [_valueString.get(null), _valueBool.get(null)])
    }

    ColorPicker(bounds, text, color) {
        _code = RayGui.GuiColorPicker(bounds, text, color)
        return ControlResult.new(DrawType.ColorPicker, _code, [color])
    }

    ColorPanel(bounds, text, color) {
        _code = RayGui.GuiColorPanel(bounds, text, color)
        return ControlResult.new(DrawType.ColorPanel, _code, [color])
    }

    ColorBarAlpha(bounds, text, alpha) {
        _valueFloat.set(alpha)
        _code = RayGui.GuiColorBarAlpha(bounds, text, _valueFloat)
        return ControlResult.new(DrawType.ColorBarAlpha, _code, [_valueFloat.get(null)])
    }

    ColorBarHue(bounds, text, value) {
        _valueFloat.set(value)
        _code = RayGui.GuiColorBarHue(bounds, text, _valueFloat)
        return ControlResult.new(DrawType.ColorBarHue, _code, [_valueFloat.get(null)])
    }

    ColorPickerHSV(bounds, text, colorHsv) {
        _code = RayGui.GuiColorPickerHSV(bounds, text, colorHsv)
        return ControlResult.new(DrawType.ColorPickerHSV, _code, [colorHsv])
    }

    ColorPanelHSV(bounds, text, colorHsv) {
        _code = RayGui.GuiColorPanelHSV(bounds, text, colorHsv)
        return ControlResult.new(DrawType.ColorPanelHSV, _code, [colorHsv])
    }
}