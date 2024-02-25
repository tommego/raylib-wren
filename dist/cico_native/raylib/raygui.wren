// foreign class GuiStyleProp {
//     construct new(cid, pid, value) {
//         controlId = cid 
//         propertyId = pid 
//         propertyValue = value 
//     }
//     construct new() {}
//     foreign controlId
//     foreign controlId=(val)
//     foreign propertyId
//     foreign propertyId=(val)
//     foreign propertyValue
//     foreign propertyValue=(val)
// }

class RayGui {
    // Gui control state
    static STATE_NORMAL { 0 }
    static STATE_FOCUSED { 1 }
    static STATE_PRESSED { 2 }
    static STATE_DISABLED { 3 }

    // Gui control text alignment
    static TEXT_ALIGN_LEFT { 0 }
    static TEXT_ALIGN_CENTER { 1 }
    static TEXT_ALIGN_RIGHT { 2 }

    // Gui control text alignment vertical
    // NOTE: Text vertical position inside the text bounds
    static TEXT_ALIGN_TOP { 0 }
    static TEXT_ALIGN_MIDDLE { 1 }
    static TEXT_ALIGN_BOTTOM { 2 }

    // Gui control text wrap mode
    // NOTE: Useful for multiline text
    static TEXT_WRAP_NONE { 0 }
    static TEXT_WRAP_CHAR { 1 }
    static TEXT_WRAP_WORD { 2 }

    // Gui controls
    static DEFAULT { 0 }
    static LABEL { 1 }
    static BUTTON { 2 }
    static TOGGLE { 3 }
    static SLIDER { 4 }
    static PROGRESSBAR { 5 }
    static CHECKBOX { 6 }
    static COMBOBOX { 7 }
    static DROPDOWNBOX { 8 }
    static TEXTBOX { 9 }
    static VALUEBOX { 10 }
    static SPINNER { 11 }
    static LISTVIEW { 12 }
    static COLORPICKER { 13 }
    static SCROLLBAR { 14 }
    static STATUSBAR { 15 }

    // Gui base properties for every control
    // NOTE: RAYGUI_MAX_PROPS_BASE properties (by default 16 properties)
    static BORDER_COLOR_NORMAL { 0 }
    static BASE_COLOR_NORMAL { 1 }
    static TEXT_COLOR_NORMAL { 2 }
    static BORDER_COLOR_FOCUSED { 3 }
    static BASE_COLOR_FOCUSED { 4 }
    static TEXT_COLOR_FOCUSED { 5 }
    static BORDER_COLOR_PRESSED { 6 }
    static BASE_COLOR_PRESSED { 7 }
    static TEXT_COLOR_PRESSED { 8 }
    static BORDER_COLOR_DISABLED { 9 }
    static BASE_COLOR_DISABLED { 10 }
    static TEXT_COLOR_DISABLED { 11 }
    static BORDER_WIDTH { 12 }
    static TEXT_PADDING { 13 }
    static TEXT_ALIGNMENT { 14 }

    static TEXT_SIZE { 16 }
    static TEXT_SPACING { 17 }
    static LINE_COLOR { 18 }
    static BACKGROUND_COLOR { 19 }
    static TEXT_LINE_SPACING { 20 }
    static TEXT_ALIGNMENT_VERTICAL { 21 }
    static TEXT_WRAP_MODE { 22 }

    static GROUP_PADDING { 16 }

    static SLIDER_WIDTH { 16 }
    static SLIDER_PADDING { 17 }

    static PROGRESS_PADDING { 16 }

    static ARROWS_SIZE { 16 }
    static ARROWS_VISIBLE { 17 }
    static SCROLL_SLIDER_PADDING { 18 }
    static SCROLL_SLIDER_SIZE { 19 }
    static SCROLL_PADDING { 20 }
    static SCROLL_SPEED { 21 }

    static CHECK_PADDING { 16 }

    static COMBO_BUTTON_WIDTH { 16 }
    static COMBO_BUTTON_SPACING { 17 }

    static TEXT_READONLY { 16 }

    static SPIN_BUTTON_WIDTH { 16 } 
    static SPIN_BUTTON_SPACING { 17 } 

    static LIST_ITEMS_HEIGHT { 16 }
    static LIST_ITEMS_SPACING { 17 }
    static SCROLLBAR_WIDTH { 18 }
    static SCROLLBAR_SIDE { 19 }

    static COLOR_SELECTOR_SIZE { 16 }
    static HUEBAR_WIDTH { 17 }
    static HUEBAR_PADDING { 18 }
    static HUEBAR_SELECTOR_HEIGHT { 19 }
    static HUEBAR_SELECTOR_OVERFLOW { 20 }

    // Global gui state control functions
    foreign static GuiEnable()
    foreign static GuiDisable()
    foreign static GuiLock()
    foreign static GuiUnlock()
    foreign static GuiIsLocked()
    foreign static GuiSetAlpha(alpha)
    foreign static GuiSetState(state)
    foreign static GuiGetState()

    // Font set/get functions
    foreign static GuiSetFont(font)
    foreign static GuiGetFont(infont)

    // Style set/get functions
    foreign static GuiSetStyle(control, property, value)
    foreign static GuiGetStyle(control, property)
    foreign static GuiGetStyleColor(incolor, control, property)

    // Styles loading functions
    foreign static GuiLoadStyle(fileName)
    foreign static GuiLoadStyleDefault()

    // Tooltips management functions
    foreign static GuiEnableTooltip()
    foreign static GuiDisableTooltip()
    foreign static GuiSetTooltip(tooltip)

    // Icons functionality
    foreign static GuiIconText(iconId, text)
    foreign static GuiSetIconScale(scale)
    foreign static GuiGetIcons(inicons)
    foreign static GuiLoadIcons(fileName, loadIconsName)
    foreign static GuiDrawIcon(iconId, posX, posY, pixelSize, color)

    // Controls
    //----------------------------------------------------------------------------------------------------------
    // Container/separator controls, useful for controls organization
    foreign static GuiWindowBox(bounds, title)
    foreign static GuiGroupBox(bounds, text)
    foreign static GuiLine(bounds, text)
    foreign static GuiPanel(bounds, text)
    foreign static GuiTabBar(bounds, text, count, active)
    foreign static GuiScrollPanel(bounds, text, content, scroll, view)

    // Basic controls set
    foreign static GuiLabel(bounds, text)
    foreign static GuiButton(bounds, text)
    foreign static GuiLabelButton(bounds, text)
    foreign static GuiToggle(bounds, text, active)
    foreign static GuiToggleGroup(bounds, text, active)
    foreign static GuiToggleSlider(bounds, text, active)
    foreign static GuiCheckBox(bounds, text, checked)
    foreign static GuiComboBox(bounds, text, active)

    foreign static GuiDropdownBox(bounds, text, active, editMode)
    foreign static GuiSpinner(bounds, text, value, minValue, maxValue, editMode)
    foreign static GuiValueBox(bounds, text, value, minValue, maxValue, editMode)
    foreign static GuiTextBox(bounds, text, textSize, editMode)

    foreign static GuiSlider(bounds, textLeft, textRight, value, minValue, maxValue)
    foreign static GuiSliderBar(bounds, textLeft, textRight, value, minValue, maxValue)
    foreign static GuiProgressBar(bounds, textLeft, textRight, value, minValue, maxValue)
    foreign static GuiStatusBar(bounds, text)
    foreign static GuiDummyRec(bounds, text)
    foreign static GuiGrid(bounds, text, spacing, subdivs, mouseCell)

    // Advance controls set
    foreign static GuiListView(bounds, text, scrollIndex, active)
    foreign static GuiListViewEx(bounds, text, count, scrollIndex, active, focus)
    foreign static GuiMessageBox(bounds, title, message, buttons)
    foreign static GuiTextInputBox(bounds, title, message, buttons, text, textMaxSize, secretViewActive)
    foreign static GuiColorPicker(bounds, text, color)
    foreign static GuiColorPanel(bounds, text, color)
    foreign static GuiColorBarAlpha(bounds, text, alpha)
    foreign static GuiColorBarHue(bounds, text, value)
    foreign static GuiColorPickerHSV(bounds, text, colorHsv)
    foreign static GuiColorPanelHSV(bounds, text, colorHsv)
}