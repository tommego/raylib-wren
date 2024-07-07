#include "cm_sys.h"
#include "cico_def.h"
#include "portable-file-dialogs/portable-file-dialogs.h"

std::vector<const char*> cico_argv;
namespace cico
{
static char* g_sysModuleSource = nullptr;
const char* cicoSysSource() {
    if(!g_sysModuleSource) {g_sysModuleSource = loadModuleSource("cico_native/os/sys.wren"); }
    return g_sysModuleSource;
}

void wrenSysArgv(WrenVM* vm) {
    wrenSetSlotNewList(vm, 0);
    wrenEnsureSlots(vm, 2);
    for(int i = 0; i < cico_argv.size(); i++) {
        wrenSetSlotString(vm, 1, cico_argv[i]);
        wrenInsertInList(vm, 0, i, 1);
    }
}

void wrenSysSelectDir(WrenVM* vm) {
    auto dir = pfd::select_folder("Select any directory", pfd::path::home()).result();
    wrenSetSlotString(vm, 0, dir.c_str());
}

void wrenSysPlatform(WrenVM* vm) {
    #if defined(_WIN32) || defined(_WINDOWS)
    wrenSetSlotString(vm, 0, "windows");
    #else 
    wrenSetSlotString(vm, 0, "Unknown");
    #endif
}

WrenForeignMethodFn wrenSysBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature) {
    WrenForeignMethodFn fn = nullptr;

    if(strcmp(className, "Platform") == 0) {
        do {
            if(strcmp(signature, "argv") == 0) { fn = wrenSysArgv; break;}
            if(strcmp(signature, "selectDir()") == 0) { fn = wrenSysSelectDir; break;}
            if(strcmp(signature, "platform") == 0) { fn = wrenSysPlatform; break;}
        } while(false);
    }

    return fn;
}

WrenForeignClassMethods wrenSysBinForeignClass(WrenVM* vm, const char* className) {
    WrenForeignClassMethods cm;
    cm.allocate = nullptr;
    cm.finalize = nullptr;
    return cm;
}

} // namespace cico
