#ifndef CM_SERIAL_H
#define CM_SERIAL_H
#include <cico_wren>

namespace cico
{

const char* cicoSerialSource();
WrenForeignMethodFn wrenSerialBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature);
WrenForeignClassMethods wrenSerialBinForeignClass(WrenVM* vm, const char* className);
} // namespace cico

#endif //CM_SERIAL_H