#ifndef CM_MONGOOSE_H
#define CM_MONGOOSE_H
#include <cico_wren>
namespace cico
{
const char* cicoMongosseSource();
WrenForeignMethodFn wrenMongooseBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature);
WrenForeignClassMethods wrenMongooseBindClass(WrenVM* vm, const char* className);
}

#endif CM_MONGOOSE_H