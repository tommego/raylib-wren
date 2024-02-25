#ifndef CICO_MODULE_H
#define CICO_MODULE_H

#include <string>
namespace cico 
{
    typedef struct ModuleContext {
        std::string source;
        void* foreignClassFn;
        void* foreignMethodFn;
    } ModuleContext;

    void registerModule(std::string name, std::string source, void* classFn, void* methodFn);

    ModuleContext* findModule(std::string name);

} // namespace cico 

#endif // CICO_MODULE_H