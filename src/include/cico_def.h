#ifndef CICO_DEF_H
#define CICO_DEF_H

#include "loguru/loguru.hpp"
#include <stdio.h>
#include <string.h>
#include <vector>

#define CICO_CLS_METHOD(cls, method, fn) \
static void method(WrenVM* vm) { \
    auto inst = (cls*)wrenGetSlotForeign(vm, 0); \
    inst->fn(vm); \
} 

#define CICO_CLS_ALLOCATOR(cls) \
static void cls##Malloc(WrenVM* vm) { \
    cls* f = (cls*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(cls)); \
    memset(f, 0, sizeof(cls)); \
}

#define CICO_CLS_FREE(cls) \
static void cls##Free(WrenVM* vm) { \
    cls* f = (cls*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(cls)); \
    cls::~cls() \
}


#define WRENGETTERFN(cls,prop) wren##cls##Get##prop 
#define WRENSETTERFN(cls,prop) wren##cls##Set##prop

#define WSDouble(slot) wrenGetSlotDouble(vm, slot)
#define WSBool(slot) wrenGetSlotBool(vm, slot)
#define WSString(slot) wrenGetSlotString(vm, slot)
#define WSCls(slot, cls) ((cls*)wrenGetSlotForeign(vm, slot))

#define WRENPROPERTY_RW(cls, prop, type) \
void wren##cls##Get##prop(WrenVM* vm) { wrenSetSlot##type(vm, 0, WSCls(0, cls)->prop); } \
void wren##cls##Set##prop(WrenVM* vm) { WSCls(0, cls)->prop = wrenGetSlot##type(vm, 1); }

#define WRENPROPERTY_CVT_RW(cls, prop, type, cvt) \
void wren##cls##Get##prop(WrenVM* vm) { wrenSetSlot##type(vm, 0, WSCls(0, cls)->prop##cvt); } \
void wren##cls##Set##prop(WrenVM* vm) { WSCls(0, cls)->prop = wrenGetSlot##type(vm, 1); }

#define WRENPROPERTY_CVT_RO(cls, prop, type, cvt) \
void wren##cls##Get##prop(WrenVM* vm) { wrenSetSlot##type(vm, 0, WSCls(0, cls)->prop##cvt); }

#define WRENFOREIGNPROPERTY_RO(cls, prop, type) void wren##cls##Get##prop(WrenVM* vm) { wrenSetSlot##type(vm, 0, WSCls(0, cls)->prop); } 
#define WRENFOREIGNPROPERTY_WO(cls, prop, type) void wren##cls##Set##prop(WrenVM* vm) { WSCls(0, cls)->prop = *WSCls(1, type); }

#define RAYMATHFN(fn) raymath##fn
#define RAYLIBFN(fn) raylib##fn
#define RAYGUIFN(fn) raygui##fn

#define CICO_NMODULE(module) std::string("cico_native/" + module + ".wren").constData()

struct ValueList {
    int valueType;
    int count;
    void *data;
};

struct Value {
    int valueType;
    void* data;
};

static char* loadModuleSource(const char* path) {
    LOG_F(INFO, "Loading module source: %s", path);
    FILE* file = fopen(path, "rb");
    char* source = nullptr;
    do {
        // Find out how big the file is.
        fseek(file, 0L, SEEK_END);
        size_t fileSize = ftell(file);
        rewind(file);

        // Allocate a buffer for it.
        char* source = (char*)malloc(fileSize + 1);
        if (source == NULL)
        {
            fprintf(stderr, "Could not read file \"%s\".\n", path);
            break;
        }

        // Read the entire file.
        size_t bytesRead = fread(source, 1, fileSize, file);
        if (bytesRead < fileSize)
        {
            fprintf(stderr, "Could not read file \"%s\".\n", path);
            break;
        }

        // Terminate the string.
        source[bytesRead] = '\0';

        fclose(file);
        return source;
    } while(false);
    return source;
}

#endif // CICO_DEF_H