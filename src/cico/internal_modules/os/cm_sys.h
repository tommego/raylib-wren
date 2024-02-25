#ifndef CM_SYS_H
#define CM_SYS_H
#include <cico_wren>

namespace cico
{

const char* cicoSysSource();
WrenForeignMethodFn wrenSysBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature);
WrenForeignClassMethods wrenSysBinForeignClass(WrenVM* vm, const char* className);
} // namespace cico

#endif //CM_SYS_H