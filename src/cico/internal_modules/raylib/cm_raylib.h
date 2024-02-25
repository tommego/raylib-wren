#ifndef CM_RAYLIB_H
#define CM_RAYLIB_H
#include <cico_wren>
namespace cico
{

const char* cicoRaylibSource();
WrenForeignMethodFn wrenRaylibBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature);
WrenForeignClassMethods wrenRaylibBindClass(WrenVM* vm, const char* className);
} // namespace cico

#endif //CM_RAYLIB_H