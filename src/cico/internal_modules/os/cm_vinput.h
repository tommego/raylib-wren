#ifndef CM_VINPUT_H
#define CM_VINPUT_H
#include <cico_wren>
namespace cico
{
const char* cicoVinputSource();
WrenForeignMethodFn wrenVinputBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature);
WrenForeignClassMethods wrenVinputBinForeignClass(WrenVM* vm, const char* className);
} // namespace cico

#endif CM_VINPUT_H // CM_VINPUT_H   