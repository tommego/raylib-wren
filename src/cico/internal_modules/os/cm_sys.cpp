#include "cm_sys.h"
#include <vector>
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

void wrenSysSelectFolder(WrenVM* vm) {       
    auto dir = pfd::select_folder("Select any directory", pfd::path::home()).result();
    wrenSetSlotString(vm, 0, dir.c_str());
}

void wrenSysOpenFile(WrenVM* vm) {
    const auto title = WSString(1);
    int filterCount = wrenGetListCount(vm, 2);
    std::vector<std::string> filters;
    bool isMultiFiles = WSBool(3);
    LOG_F(INFO, "open file, filter count: %d, is multi files: %d", filterCount, isMultiFiles);
    wrenEnsureSlots(vm, 5);
    for(int i = 0; i < filterCount; i++) {
        wrenGetListElement(vm, 2, i, 4);
        filters.push_back(WSString(4));
    }

    auto f = pfd::open_file(title, pfd::path::home(),
                            filters,
                            isMultiFiles ? pfd::opt::multiselect : pfd::opt::none);

    int i = 0;
    auto files = f.result();
    wrenEnsureSlots(vm, 2);
    wrenSetSlotNewList(vm, 0);

    for (auto const &name : files) {
        wrenSetSlotString(vm, 1, name.c_str());
        wrenInsertInList(vm, 0, i, 1);
        i++;
    }
}

void wrenSysOpenSaveFile(WrenVM* vm) {
    auto title = WSString(1);
    int filterCount = wrenGetListCount(vm, 2);
    std::vector<std::string> filters;
    wrenEnsureSlots(vm, 4);
    for(int i = 0; i < filterCount; i++) {
        wrenGetListElement(vm, 2, i, 3);
        filters.push_back(WSString(3));
    }
    auto f = pfd::save_file(title, pfd::path::home() + pfd::path::separator() + "New File", filters, pfd::opt::none).result();
    wrenSetSlotString(vm, 0, f.c_str());
}

void wrenSysPlatform(WrenVM* vm) {
    #if defined(_WIN32) || defined(_WINDOWS)
    wrenSetSlotString(vm, 0, "windows");
    #else 
    wrenSetSlotString(vm, 0, "Unknown");
    #endif
}

void wrenSysSeparator(WrenVM* vm) {
#if defined(_WIN32) 
    wrenSetSlotString(vm, 0, "\\");
#else 
    wrenSetSlotString(vm, 0, "/");
#endif
}

void wrenSysNotify(WrenVM* vm) {
    const char* title = WSString(1);
    const char* msg = WSString(2);
    int icontype = int(WSDouble(3));
    pfd::notify(title, msg, pfd::icon(icontype));
}

void wrenSysMessage(WrenVM* vm) {
    const char* title = WSString(1);
    const char* msg = WSString(2);
    int choice = int(WSDouble(3));
    int icontype = int(WSDouble(4));
    auto m = pfd::message(title, msg, pfd::choice(choice), pfd::icon(icontype));
    for (int i = 0; i < 10 && !m.ready(1000); ++i)
        std::cout << "Waited 1 second for user input...\n";
    wrenSetSlotDouble(vm, 0, double(m.result()));
}

WrenForeignMethodFn wrenSysBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature) {
    WrenForeignMethodFn fn = nullptr;

    if(strcmp(className, "Platform") == 0) {
        do {
            if(strcmp(signature, "argv") == 0) { fn = wrenSysArgv; break;}
            if(strcmp(signature, "platform") == 0) { fn = wrenSysPlatform; break;}
            if(strcmp(signature, "separator") == 0) { fn = wrenSysSeparator; break;}
            if(strcmp(signature, "selectFolder()") == 0) { fn = wrenSysSelectFolder; break;}
            if(strcmp(signature, "notify(_,_,_)") == 0) { fn = wrenSysNotify; break;}
            if(strcmp(signature, "message(_,_,_,_)") == 0) { fn = wrenSysNotify; break;}
            if(strcmp(signature, "openFile(_,_,_)") == 0) { fn = wrenSysOpenFile; break;}
            if(strcmp(signature, "openSaveFile(_,_)") == 0) { fn = wrenSysOpenSaveFile; break;}

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
