#include "cm_math.h"
#include <string.h>
#include "cico_math.h"
#include <stdio.h>

namespace cico
{

static void easing_(WrenVM* vm) {
    const auto& val = wrenGetSlotDouble(vm, 1);
    const auto& type = int(wrenGetSlotDouble(vm, 2));
    wrenSetSlotDouble(vm, 0, (double)cico::easing(val, (cico::EasingType)type));
}

static char* g_mathModuleSource = nullptr;
const char* cicoMathSource()
{
    if(!g_mathModuleSource) {g_mathModuleSource = loadModuleSource("cico_native/math/math.wren");}
    return g_mathModuleSource;
}
    
WrenForeignMethodFn wrenEasingBindForeignMethod(WrenVM* vmconst, const char* className, bool isStatic, const char* signature)
{
    WrenForeignMethodFn fn = nullptr;
    if(strcmp(className, "Easing") == 0) { 
        do 
        {
            if (strcmp(signature, "easing_(_,_)") == 0) { fn = easing_; break; }
        } while(false);
    }
    return fn;
}

} // namespace cico