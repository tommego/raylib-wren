#ifndef CICO_FILE_MODULE_H
#define CICO_FILE_MODULE_H

#include "wren.hpp"

namespace cico
{
WrenLoadModuleResult readModule(WrenVM* vm, const char* module);
const char* cicoResolveFileModule(WrenVM* vm, const char* importer, const char* module);
} // namespace cico


#endif //CICO_FILE_MODULE_H