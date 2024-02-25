#ifndef CM_JSON_H
#define CM_JSON_H
#include <cico_wren>

namespace cico
{

const char* cicoJsonSource();
WrenForeignMethodFn wrenJsonBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature);
WrenForeignClassMethods wrenJsonBindClass(WrenVM* vm, const char* className);

} // namespace cico
#endif //CM_JSON_H