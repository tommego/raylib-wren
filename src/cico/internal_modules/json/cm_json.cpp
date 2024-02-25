#include "cm_json.h"

#include "cico_def.h"
#include "json_fwd.hpp"
#include "json.hpp"
#include <stdio.h>
#include <string>
#include <fstream>
using json = nlohmann::json;
namespace cico  
{

CICO_CLS_ALLOCATOR(json)

static char* g_jsonModuleSource = nullptr;

const char* cicoJsonSource() {
    if(!g_jsonModuleSource) { g_jsonModuleSource = loadModuleSource("cico_native/json/json.wren"); }
    return g_jsonModuleSource;
}

void wrenJsonParse(WrenVM* vm) {
    auto str = WSString(1);
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(json));
    (*WSCls(0, json)) = json::parse(str);
}

void wrenJsonParseFile(WrenVM* vm) {
    auto path = WSString(1);
    auto js = (json*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(json));
    std::ifstream f(path);
    *js = json::parse(f);
}

void wrenJsonDump(WrenVM* vm) {
    auto path = WSString(1);
    auto strDump = WSCls(0, json)->dump();
    wrenSetSlotString(vm, 0, strDump.c_str());
}

void wrenJsonGet(WrenVM* vm) {
    auto o = WSCls(1, json);
    auto js = (json*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(json));
    *js = (*o)[std::string(WSString(2))];
}

void wrenJsonSet(WrenVM* vm) { (*WSCls(1, json))[WSString(2)] = *WSCls(3, json); }

void wrenJsonAt(WrenVM* vm) {
    auto o = WSCls(1, json);
    auto js = (json*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(json));
    *js = (*o).at(int(WSDouble(2)));
}

void wrenJsonSize(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, json)->size()); }
void wrenJsonIsNumber(WrenVM* vm) { wrenSetSlotBool(vm, 0, WSCls(0, json)->is_number()); }
void wrenJsonIsObject(WrenVM* vm) { wrenSetSlotBool(vm, 0, WSCls(0, json)->is_object()); }
void wrenJsonIsArray(WrenVM* vm) { wrenSetSlotBool(vm, 0, WSCls(0, json)->is_array()); }
void wrenJsonIsBoolean(WrenVM* vm) { wrenSetSlotBool(vm, 0, WSCls(0, json)->is_boolean()); }
void wrenJsonIsString(WrenVM* vm) { wrenSetSlotBool(vm, 0, WSCls(0, json)->is_string()); }
void wrenJsonValue(WrenVM* vm) {
    auto o = WSCls(0, json);
    if(o->is_object() || o->is_array()) {
        auto v = (json*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(json));
        *v = *o;
    } else if(o->is_number()) {
        wrenSetSlotDouble(vm, 0, float(*o));
    } else if(o->is_boolean()) {
        wrenSetSlotBool(vm, 0, bool(*o));
    } else if(o->is_string()) {
        wrenSetSlotString(vm, 0, std::string(*o).c_str());
    } 
}
void wrenJsonKeys(WrenVM* vm) {
    auto o = WSCls(0, json);
    wrenSetSlotNewList(vm, 0);
    wrenEnsureSlots(vm, 2);
    if(o->is_object()) {
        int idx = 0;
        for(auto it = o->begin(); it != o->end(); ++it) {
            const auto& k = it.key().c_str();
            wrenSetSlotString(vm, 1, k);
            wrenInsertInList(vm, 0, 0, 1);
        }
    }
}

void wrenJsonNewValue(WrenVM* vm) {
    auto type = int(WSDouble(1));
    auto v = (json*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(json));
    switch(type) {
        case 0: {
            *v = WSDouble(2);
            break;
        }
        case 1: {
            *v = WSString(2);
            break;
        }
        case 2: {
            *v = WSBool(2);
            break;
        }
        case 3: {
            *v = {};
            break;
        }
        case 4: {
            *v = json::parse("[]");
            break;
        }
        default: {
            *v = *WSCls(2, json);
            break;
        }
    }
}

WrenForeignMethodFn wrenJsonBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature)
{   
    WrenForeignMethodFn fn = nullptr;
    if(strcmp(className, "Json") == 0)
    {
        do 
        {
            if(strcmp(signature, "parse(_)") == 0) { fn = wrenJsonParse; break; }
            if(strcmp(signature, "parseFile(_)") == 0) { fn = wrenJsonParseFile; break; }
            if(strcmp(signature, "dump()") == 0) { fn = wrenJsonDump; break; }
            if(strcmp(signature, "get(_,_)") == 0) { fn = wrenJsonGet; break; }
            if(strcmp(signature, "set(_,_,_)") == 0) { fn = wrenJsonSet; break; }
            if(strcmp(signature, "at(_,_)") == 0) { fn = wrenJsonAt; break; }
            if(strcmp(signature, "newValue(_,_)") == 0) { fn = wrenJsonNewValue; break; }
            if(strcmp(signature, "size") == 0) { fn = wrenJsonSize; break; }
            if(strcmp(signature, "isNumber") == 0) { fn = wrenJsonIsNumber; break; }
            if(strcmp(signature, "isObject") == 0) { fn = wrenJsonIsObject; break; }
            if(strcmp(signature, "isArray") == 0) { fn = wrenJsonIsArray; break; }
            if(strcmp(signature, "isBoolean") == 0) { fn = wrenJsonIsBoolean; break; }
            if(strcmp(signature, "isString") == 0) { fn = wrenJsonIsString; break; }
            if(strcmp(signature, "value") == 0) { fn = wrenJsonValue; break; }
            if(strcmp(signature, "keys") == 0) { fn = wrenJsonKeys; break; }
        } while(false);
    }
    return fn;
}

WrenForeignClassMethods wrenJsonBindClass(WrenVM* vm, const char* className)
{
    WrenForeignClassMethods ret;


    ret.allocate = nullptr;
    ret.finalize = nullptr;
    do 
    {
        if(strcmp(className, "Json") == 0) { ret.allocate = jsonMalloc;  break; } 
    } while(false);
    return ret;
}
} // namespace cico     
