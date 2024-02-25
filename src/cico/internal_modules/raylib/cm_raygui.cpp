#include "cm_raygui.h"
#include "cico_def.h"

#define RAYGUI_IMPLEMENTATION
extern "C" {
    #include "raygui.h"
}

namespace cico 
{

void RAYGUIFN(GuiEnable)(WrenVM* vm) { GuiEnable(); }
void RAYGUIFN(GuiDisable)(WrenVM* vm) { GuiDisable(); }
void RAYGUIFN(GuiLock)(WrenVM* vm) { GuiLock(); }
void RAYGUIFN(GuiUnlock)(WrenVM* vm) { GuiUnlock(); }
void RAYGUIFN(GuiIsLocked)(WrenVM* vm) { wrenSetSlotBool(vm, 0, GuiIsLocked()); }
void RAYGUIFN(GuiSetAlpha)(WrenVM* vm) { GuiSetAlpha(WSDouble(1)); }
void RAYGUIFN(GuiSetState)(WrenVM* vm) { GuiSetState(WSDouble(1)); }
void RAYGUIFN(GuiGetState)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiGetState()); }

void RAYGUIFN(GuiSetFont)(WrenVM* vm) { GuiSetFont(*WSCls(1, Font)); }
void RAYGUIFN(GuiGetFont)(WrenVM* vm) { *WSCls(1, Font) = GuiGetFont(); }

void RAYGUIFN(GuiSetStyle)(WrenVM* vm) { GuiSetStyle(WSDouble(1), WSDouble(2), WSDouble(3)); }
void RAYGUIFN(GuiGetStyle)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiGetStyle(WSDouble(1), WSDouble(2))); }
void RAYGUIFN(GuiGetStyleColor)(WrenVM* vm) { 
    auto hexValue = GuiGetStyle(WSDouble(2), WSDouble(3)); 
    WSCls(1, Color)->r = (unsigned char)(hexValue >> 24) & 0xFF;
    WSCls(1, Color)->g = (unsigned char)(hexValue >> 16) & 0xFF;
    WSCls(1, Color)->b = (unsigned char)(hexValue >> 8) & 0xFF;
    WSCls(1, Color)->a = (unsigned char)(hexValue) & 0xFF;
}

void RAYGUIFN(GuiLoadStyle)(WrenVM* vm) { GuiLoadStyle(WSString(1)); }
void RAYGUIFN(GuiLoadStyleDefault)(WrenVM* vm) { GuiLoadStyleDefault(); }

void RAYGUIFN(GuiEnableTooltip)(WrenVM* vm) { GuiEnableTooltip(); }
void RAYGUIFN(GuiDisableTooltip)(WrenVM* vm) { GuiDisableTooltip(); }
void RAYGUIFN(GuiSetTooltip)(WrenVM* vm) { GuiSetTooltip(WSString(1)); }

void RAYGUIFN(GuiIconText)(WrenVM* vm) { wrenSetSlotString(vm, 0, GuiIconText(WSDouble(1), WSString(2))); }
void RAYGUIFN(GuiSetIconScale)(WrenVM* vm) { GuiSetIconScale(WSDouble(1)); }
void RAYGUIFN(GuiGetIcons)(WrenVM* vm) { }
void RAYGUIFN(GuiLoadIcons)(WrenVM* vm) { wrenSetSlotString(vm, 0, (const char*)GuiLoadIcons(WSString(1), WSBool(2))); }
void RAYGUIFN(GuiDrawIcon)(WrenVM* vm) { 
    wrenSetSlotDouble(vm, 0, 0); 
    GuiDrawIcon(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color));
}

void RAYGUIFN(GuiWindowBox)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiWindowBox(*WSCls(1, Rectangle), WSString(2))); }
void RAYGUIFN(GuiGroupBox)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiGroupBox(*WSCls(1, Rectangle), WSString(2))); }
void RAYGUIFN(GuiLine)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiLine(*WSCls(1, Rectangle), WSString(2))); }
void RAYGUIFN(GuiPanel)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiPanel(*WSCls(1, Rectangle), WSString(2))); }
void RAYGUIFN(GuiTabBar)(WrenVM* vm) {  
    auto bounds = *WSCls(1, Rectangle);
    auto vlist = WSCls(2, ValueList);
    auto text = (const char**)vlist->data;
    auto cnt = WSDouble(3);
    auto value = (int*)WSCls(4, Value)->data;
    wrenSetSlotDouble(vm, 0, GuiTabBar(bounds, text, cnt, value));
}
void RAYGUIFN(GuiScrollPanel)(WrenVM* vm) { 
    wrenSetSlotDouble(vm, 0, GuiScrollPanel(*WSCls(1, Rectangle), WSString(2), *WSCls(3, Rectangle), WSCls(4, Vector2), WSCls(5, Rectangle))); 
}

void RAYGUIFN(GuiLabel)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiLabel(*WSCls(1, Rectangle), WSString(2))); }
void RAYGUIFN(GuiButton)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiButton(*WSCls(1, Rectangle), WSString(2))); }
void RAYGUIFN(GuiLabelButton)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiLabelButton(*WSCls(1, Rectangle), WSString(2))); }
void RAYGUIFN(GuiToggle)(WrenVM* vm) {  
    wrenSetSlotDouble(vm, 0, GuiToggle(*WSCls(1, Rectangle), WSString(2), (bool*)WSCls(3, Value)->data));
}
void RAYGUIFN(GuiToggleGroup)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiToggleGroup(*WSCls(1, Rectangle), WSString(2), (int*)WSCls(3, Value)->data));
}
void RAYGUIFN(GuiToggleSlider)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiToggleSlider(*WSCls(1, Rectangle), WSString(2), (int*)WSCls(3, Value)->data));
}
void RAYGUIFN(GuiCheckBox)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiCheckBox(*WSCls(1, Rectangle), WSString(2), (bool*)WSCls(3, Value)->data));
}
void RAYGUIFN(GuiComboBox)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiComboBox(*WSCls(1, Rectangle), WSString(2), (int*)WSCls(3, Value)->data));
}

void RAYGUIFN(GuiDropdownBox)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiDropdownBox(*WSCls(1, Rectangle), WSString(2), (int*)WSCls(3, Value)->data, WSBool(4)));
}
void RAYGUIFN(GuiSpinner)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiSpinner(*WSCls(1, Rectangle), WSString(2), (int*)WSCls(3, Value)->data, WSDouble(4), WSDouble(5), WSBool(6)));
}
void RAYGUIFN(GuiValueBox)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiValueBox(*WSCls(1, Rectangle), WSString(2), (int*)WSCls(3, Value)->data, WSDouble(4), WSDouble(5), WSBool(6)));
}
void RAYGUIFN(GuiTextBox)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiTextBox(*WSCls(1, Rectangle), (char*)WSString(2), WSDouble(3), WSBool(4)));
}

void RAYGUIFN(GuiSlider)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiSlider(*WSCls(1, Rectangle), WSString(2), WSString(3), (float*)WSCls(4, Value)->data, WSDouble(5), WSDouble(6)));
}
void RAYGUIFN(GuiSliderBar)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiSliderBar(*WSCls(1, Rectangle), WSString(2), WSString(3), (float*)WSCls(4, Value)->data, WSDouble(5), WSDouble(6)));
}
void RAYGUIFN(GuiProgressBar)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiProgressBar(*WSCls(1, Rectangle), WSString(2), WSString(3), (float*)WSCls(4, Value)->data, WSDouble(5), WSDouble(6)));
}
void RAYGUIFN(GuiStatusBar)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiStatusBar(*WSCls(1, Rectangle), WSString(2))); }
void RAYGUIFN(GuiDummyRec)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiDummyRec(*WSCls(1, Rectangle), WSString(2))); }
void RAYGUIFN(GuiGrid)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiGrid(*WSCls(1, Rectangle), WSString(2), WSDouble(3), WSDouble(4), WSCls(5, Vector2)));
}
void RAYGUIFN(GuiListView)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiListView(*WSCls(1, Rectangle), WSString(2), (int*)WSCls(3, Value)->data, (int*)WSCls(4, Value)->data));
}
void RAYGUIFN(GuiListViewEx)(WrenVM* vm) {
    auto text = WSCls(2, ValueList);
    auto cnt = int(WSDouble(3));
    auto idx = WSCls(4, Value);
    auto active = WSCls(5, Value);
    auto focus = WSCls(6, Value);
    wrenSetSlotDouble(vm, 0, GuiListViewEx(*WSCls(1, Rectangle), (const char**)text->data, cnt, (int*)idx->data, (int*)active->data, (int*)focus->data));
}
void RAYGUIFN(GuiMessageBox)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiMessageBox(*WSCls(1, Rectangle), WSString(2), WSString(3), WSString(4)));
}
void RAYGUIFN(GuiTextInputBox)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiTextInputBox(*WSCls(1, Rectangle), WSString(2), WSString(3), WSString(4), (char*)WSCls(5, Value)->data, WSDouble(6), (bool*)WSCls(7, Value)->data));
}
void RAYGUIFN(GuiColorPicker)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiColorPicker(*WSCls(1, Rectangle), WSString(2), WSCls(3, Color))); }
void RAYGUIFN(GuiColorPanel)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiColorPanel(*WSCls(1, Rectangle), WSString(2), WSCls(3, Color))); }
void RAYGUIFN(GuiColorBarAlpha)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiColorBarAlpha(*WSCls(1, Rectangle), WSString(2), (float*)WSCls(3,Value)->data));
}
void RAYGUIFN(GuiColorBarHue)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GuiColorBarHue(*WSCls(1, Rectangle), WSString(2), (float*)WSCls(3,Value)->data));
}
void RAYGUIFN(GuiColorPickerHSV)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiColorPickerHSV(*WSCls(1, Rectangle), WSString(2), WSCls(3, Vector3))); }
void RAYGUIFN(GuiColorPanelHSV)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GuiColorPanelHSV(*WSCls(1, Rectangle), WSString(2), WSCls(3, Vector3))); }

static char* g_rayguiModuleSource = nullptr;
const char* cicoRayGuiSource()
{
    if(!g_rayguiModuleSource) { g_rayguiModuleSource = loadModuleSource("cico_native/raylib/raygui.wren"); }
    return g_rayguiModuleSource;
}

WrenForeignMethodFn wrenRayGuiBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature)
{
    WrenForeignMethodFn fn = nullptr;
    if(strcmp(className, "RayGui") == 0) {
        do
        {
            if(strcmp(signature, "GuiEnable()") == 0 ) { fn = RAYGUIFN(GuiEnable); break; }
            if(strcmp(signature, "GuiDisable()") == 0 ) { fn = RAYGUIFN(GuiDisable); break; }
            if(strcmp(signature, "GuiLock()") == 0 ) { fn = RAYGUIFN(GuiLock); break; }
            if(strcmp(signature, "GuiUnlock()") == 0 ) { fn = RAYGUIFN(GuiUnlock); break; }
            if(strcmp(signature, "GuiIsLocked()") == 0 ) { fn = RAYGUIFN(GuiIsLocked); break; }
            if(strcmp(signature, "GuiSetAlpha(_)") == 0 ) { fn = RAYGUIFN(GuiSetAlpha); break; }
            if(strcmp(signature, "GuiSetState(_)") == 0 ) { fn = RAYGUIFN(GuiSetState); break; }
            if(strcmp(signature, "GuiGetState()") == 0 ) { fn = RAYGUIFN(GuiGetState); break; }

            if(strcmp(signature, "GuiSetFont(_)") == 0 ) { fn = RAYGUIFN(GuiSetFont); break; }
            if(strcmp(signature, "GuiGetFont(_)") == 0 ) { fn = RAYGUIFN(GuiGetFont); break; }

            if(strcmp(signature, "GuiSetStyle(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiSetStyle); break; }
            if(strcmp(signature, "GuiGetStyle(_,_)") == 0 ) { fn = RAYGUIFN(GuiGetStyle); break; }
            if(strcmp(signature, "GuiGetStyleColor(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiGetStyleColor); break; }
            

            if(strcmp(signature, "GuiLoadStyle(_)") == 0 ) { fn = RAYGUIFN(GuiLoadStyle); break; }
            if(strcmp(signature, "GuiLoadStyleDefault()") == 0 ) { fn = RAYGUIFN(GuiLoadStyleDefault); break; }

            if(strcmp(signature, "GuiEnableTooltip()") == 0 ) { fn = RAYGUIFN(GuiEnableTooltip); break; }
            if(strcmp(signature, "GuiDisableTooltip()") == 0 ) { fn = RAYGUIFN(GuiDisableTooltip); break; }
            if(strcmp(signature, "GuiSetTooltip(_)") == 0 ) { fn = RAYGUIFN(GuiSetTooltip); break; }

            if(strcmp(signature, "GuiIconText(_,_)") == 0 ) { fn = RAYGUIFN(GuiIconText); break; }
            if(strcmp(signature, "GuiSetIconScale(_)") == 0 ) { fn = RAYGUIFN(GuiSetIconScale); break; }
            if(strcmp(signature, "GuiGetIcons(_)") == 0 ) { fn = RAYGUIFN(GuiGetIcons); break; }
            if(strcmp(signature, "GuiLoadIcons(_,_)") == 0 ) { fn = RAYGUIFN(GuiLoadIcons); break; }
            if(strcmp(signature, "GuiDrawIcon(_,_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiDrawIcon); break; }

            if(strcmp(signature, "GuiWindowBox(_,_)") == 0 ) { fn = RAYGUIFN(GuiWindowBox); break; }
            if(strcmp(signature, "GuiGroupBox(_,_)") == 0 ) { fn = RAYGUIFN(GuiGroupBox); break; }
            if(strcmp(signature, "GuiLine(_,_)") == 0 ) { fn = RAYGUIFN(GuiLine); break; }
            if(strcmp(signature, "GuiPanel(_,_)") == 0 ) { fn = RAYGUIFN(GuiPanel); break; }
            if(strcmp(signature, "GuiTabBar(_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiTabBar); break; }
            if(strcmp(signature, "GuiScrollPanel(_,_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiScrollPanel); break; }

            if(strcmp(signature, "GuiLabel(_,_)") == 0 ) { fn = RAYGUIFN(GuiLabel); break; }
            if(strcmp(signature, "GuiButton(_,_)") == 0 ) { fn = RAYGUIFN(GuiButton); break; }
            if(strcmp(signature, "GuiLabelButton(_,_)") == 0 ) { fn = RAYGUIFN(GuiLabelButton); break; }
            if(strcmp(signature, "GuiToggle(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiToggle); break; }
            if(strcmp(signature, "GuiToggleGroup(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiToggleGroup); break; }
            if(strcmp(signature, "GuiToggleSlider(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiToggleSlider); break; }
            if(strcmp(signature, "GuiCheckBox(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiCheckBox); break; }
            if(strcmp(signature, "GuiComboBox(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiComboBox); break; }

            if(strcmp(signature, "GuiDropdownBox(_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiDropdownBox); break; }
            if(strcmp(signature, "GuiSpinner(_,_,_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiSpinner); break; }
            if(strcmp(signature, "GuiValueBox(_,_,_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiValueBox); break; }
            if(strcmp(signature, "GuiTextBox(_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiTextBox); break; }

            if(strcmp(signature, "GuiSlider(_,_,_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiSlider); break; }
            if(strcmp(signature, "GuiSliderBar(_,_,_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiSliderBar); break; }
            if(strcmp(signature, "GuiProgressBar(_,_,_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiProgressBar); break; }
            if(strcmp(signature, "GuiStatusBar(_,_)") == 0 ) { fn = RAYGUIFN(GuiStatusBar); break; }
            if(strcmp(signature, "GuiDummyRec(_,_)") == 0 ) { fn = RAYGUIFN(GuiDummyRec); break; }
            if(strcmp(signature, "GuiGrid(_,_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiGrid); break; }

            if(strcmp(signature, "GuiListView(_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiListView); break; }
            if(strcmp(signature, "GuiListViewEx(_,_,_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiListViewEx); break; }
            if(strcmp(signature, "GuiMessageBox(_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiMessageBox); break; }
            if(strcmp(signature, "GuiTextInputBox(_,_,_,_,_,_,_)") == 0 ) { fn = RAYGUIFN(GuiTextInputBox); break; }
            if(strcmp(signature, "GuiColorPicker(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiColorPicker); break; }
            if(strcmp(signature, "GuiColorPanel(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiColorPanel); break; }
            if(strcmp(signature, "GuiColorBarAlpha(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiColorBarAlpha); break; }
            if(strcmp(signature, "GuiColorBarHue(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiColorBarHue); break; }
            if(strcmp(signature, "GuiColorPickerHSV(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiColorPickerHSV); break; }
            if(strcmp(signature, "GuiColorPanelHSV(_,_,_)") == 0 ) { fn = RAYGUIFN(GuiColorPanelHSV); break; }

        } while(false);
    }
    return fn;
}

} // namespace cico 
