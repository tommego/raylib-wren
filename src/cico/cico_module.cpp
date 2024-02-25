#include "cico_module.h"
#include <map>
#include <stdio.h>

namespace cico 
{

static std::map<std::string, ModuleContext> g_moduleInsp;
    
void registerModule(std::string name, std::string source, void* classFn, void* methodFn)
{
    do 
    {
        if(g_moduleInsp.find(name) != g_moduleInsp.end())
        {
            printf("module %s has been registered.\n", name.c_str());
            break;
        }
        ModuleContext ctx;
        ctx.source = source;
        ctx.foreignClassFn = classFn;
        ctx.foreignMethodFn = methodFn;
        g_moduleInsp.insert({name, ctx});
        printf("[registerModule] module registered, current size: %d\n", g_moduleInsp.size());
    } while(false);
}

ModuleContext* findModule(std::string name)
{
    ModuleContext* ret = nullptr;
    do 
    {
        if(g_moduleInsp.find(name) == g_moduleInsp.end()) { break; }
        ret = &g_moduleInsp[name];
    } while(false);
    return ret;
}

} // namespace cico 
