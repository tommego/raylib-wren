#ifndef CM_MATH_H
#define CM_MATH_H
#include <cico_wren>
#include "cico_def.h"

namespace cico {

const char* cicoMathSource();
WrenForeignMethodFn wrenEasingBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature);

} // namespace cico 

#endif //CM_MATH_H