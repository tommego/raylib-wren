#include "cm_sqlite3.h"
#include "cico_def.h"
extern "C" {
    #include "sqlite3/sqlite3.h"
}

namespace cico {

struct Sqlite3Wrap {
    sqlite3* db;
};

struct Sqlite3StmtWrap {
    sqlite3_stmt* stmt;
};

CICO_CLS_ALLOCATOR(Sqlite3Wrap)
CICO_CLS_ALLOCATOR(Sqlite3StmtWrap)

void wrenSqlite3Open(WrenVM* vm) {
    Sqlite3Wrap* cls = WSCls(0, Sqlite3Wrap);
    sqlite3_open(WSString(1), &cls->db);
    wrenSetSlotBool(vm, 0, cls->db != nullptr);
}

void wrenSqlite3PrepareV2(WrenVM* vm) {
    Sqlite3Wrap* cls = WSCls(0, Sqlite3Wrap);
    sqlite3* db = cls->db;
    const char* query = WSString(1);
    Sqlite3StmtWrap* stmtWrap = WSCls(2, Sqlite3StmtWrap);
    sqlite3_prepare_v2(db, query, -1, &stmtWrap->stmt, nullptr);
    wrenSetSlotBool(vm, 0, stmtWrap->stmt != nullptr);
}

void wrenSqlite3Step(WrenVM* vm) {
    sqlite3* db = WSCls(0, Sqlite3Wrap)->db;
    sqlite3_stmt* stmt = WSCls(1, Sqlite3StmtWrap)->stmt;
    int code = -1;
    if(!stmt) {
        wrenSetSlotDouble(vm, 0, -1);
    } else {
        code = sqlite3_step(stmt);
        wrenSetSlotDouble(vm, 0, code);
    }
}

void wrenSqlite3ColValue(WrenVM* vm) {
    sqlite3_stmt* stmt = WSCls(1, Sqlite3StmtWrap)->stmt;
    int col = WSDouble(2);
    int bytes = sqlite3_column_type(stmt, col);
    switch(bytes) {
    case SQLITE3_TEXT: {
        wrenSetSlotString(vm, 0, (const char*)sqlite3_column_text(stmt, col));
        break;
    }
    case SQLITE_INTEGER: {
        wrenSetSlotDouble(vm, 0, sqlite3_column_int(stmt, col));
        break;
    }
    case SQLITE_FLOAT: {
        wrenSetSlotDouble(vm, 0, sqlite3_column_double(stmt, col));
        break;
    }
    default: {
        wrenSetSlotNull(vm, 0);
        break;
    }
    }
}

void wrenSqlite3ColName(WrenVM* vm) {
    sqlite3_stmt* stmt = WSCls(1, Sqlite3StmtWrap)->stmt;
    int col = WSDouble(2);
    wrenSetSlotString(vm, 0, sqlite3_column_name(stmt, col));
}

void wrenSqlite3Finalize(WrenVM* vm) {
    sqlite3_stmt* stmt = WSCls(1, Sqlite3StmtWrap)->stmt;
    sqlite3_finalize(stmt);
}

void wrenSqlite3Close(WrenVM* vm) {
    sqlite3* db = WSCls(0, Sqlite3Wrap)->db;
    sqlite3_close(db);
}

void wrenSqlite3ColCount(WrenVM* vm) {
    Sqlite3StmtWrap* stmtWrap = WSCls(1, Sqlite3StmtWrap);
    if(stmtWrap->stmt) {
        wrenSetSlotDouble(vm, 0, sqlite3_column_count(stmtWrap->stmt));
    } else {
        wrenSetSlotDouble(vm, 0, 0);
    }
}

static char* g_Sqlite3ModuleSource = nullptr;
const char* cicoSqlite3Source() {
    if(!g_Sqlite3ModuleSource) {g_Sqlite3ModuleSource = loadModuleSource("cico_native/os/sqlite3.wren"); }
    return g_Sqlite3ModuleSource;
}

WrenForeignMethodFn wrenSqlite3BindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature) {
    WrenForeignMethodFn fn = nullptr;
    if(strcmp(className, "Sqlite3") == 0) {
        do {
            if(strcmp(signature, "open(_)") == 0) { fn = wrenSqlite3Open; break; }
            if(strcmp(signature, "prepareV2(_,_)") == 0) { fn = wrenSqlite3PrepareV2; break; }
            if(strcmp(signature, "step(_)") == 0) { fn = wrenSqlite3Step; break; }
            if(strcmp(signature, "colValue(_,_)") == 0) { fn = wrenSqlite3ColValue; break; }
            if(strcmp(signature, "colName(_,_)") == 0) { fn = wrenSqlite3ColName; break; }
            if(strcmp(signature, "colCount(_)") == 0) { fn = wrenSqlite3ColCount; break; }
            if(strcmp(signature, "finalize()") == 0) { fn = wrenSqlite3Finalize; break; }
            if(strcmp(signature, "close()") == 0) { fn = wrenSqlite3Close; break; }

        } while(false);
    } 
    return fn;
}

WrenForeignClassMethods wrenSqlite3BinForeignClass(WrenVM* vm, const char* className) {
    WrenForeignClassMethods cls;
    cls.allocate = nullptr;
    cls.finalize = nullptr;
    do {
        if(strcmp(className, "Sqlite3") == 0) { cls.allocate = Sqlite3WrapMalloc; break; }
        if(strcmp(className, "Stmt") == 0) { cls.allocate = Sqlite3StmtWrapMalloc; break; }
    } while(false);
    return cls;
}

}