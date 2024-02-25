#ifndef CM_RAYGUI_H
#define CM_RAYGUI_H
#include <cico_wren>
namespace cico
{
const char* cicoRayGuiSource();
WrenForeignMethodFn wrenRayGuiBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature);

} // namespace cico


#endif // CM_RAYGUI_H