#ifndef CM_SQLITE3_H
#define CM_SQLITE3_H
#include <cico_wren>

namespace cico
{

const char* cicoSqlite3Source();
WrenForeignMethodFn wrenSqlite3BindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature);
WrenForeignClassMethods wrenSqlite3BinForeignClass(WrenVM* vm, const char* className);
} // namespace cico

#endif // CM_SQLITE3_H