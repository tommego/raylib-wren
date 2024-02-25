#include "../include/cico.h"
#include "cico_module.h"
#include <fstream>
#include <iostream>
#include <stdio.h>
#include "wren.hpp"

#include "loguru/loguru.cpp"

#include "internal_modules/math/cm_math.h"
#include "internal_modules/os/cm_file.h"
#include "internal_modules/os/cm_sys.h"
#include "cico_file_module.h"

#if defined(CICO_MODULE_VINPUT)
#include "internal_modules/os/cm_vinput.h"
#endif

#if defined(CICO_MODULE_JSON)
#include "internal_modules/json/cm_json.h"
#endif

#if defined(CICO_MODULE_RAYLIB)
#include "internal_modules/raylib/cm_raylib.h"
#include "internal_modules/raylib/cm_raygui.h"
#endif

#include "internal_modules/net/cm_mongoose.h"
#include "internal_modules/os/cm_serial.h"
typedef WrenForeignMethodFn (*CicoRegisterMethodFn)(WrenVM* vm, const char* className, bool isStatic, const char* signature);
typedef WrenForeignClassMethods (*CicoRegisterClassFn)(WrenVM* vm, const char* className);
extern std::vector<const char*> cico_argv;
namespace cico
{

typedef struct VmCtx {
    WrenInterpretResult wren_result;
    WrenVM* wren_vm = nullptr;
    WrenConfiguration wren_config;
} VmCtx;

void writeFn(WrenVM* vm, const char* text)
{
  LOG_F(INFO, "[wren] %s", text);
}

void errorFn(WrenVM* vm, WrenErrorType errorType,
             const char* module, const int line,
             const char* msg)
{
  switch (errorType)
  {
    case WREN_ERROR_COMPILE:
    {
      LOG_F(ERROR, "[wren][%s line %d] [Error] %s\n", module, line, msg);
    } break;
    case WREN_ERROR_STACK_TRACE:
    {
      LOG_F(ERROR, "[wren][%s line %d] in %s\n", module, line, msg);
    } break;
    case WREN_ERROR_RUNTIME:
    {
      LOG_F(ERROR, "[wren][Runtime Error] %s\n", msg);
    } break;
  }
}

WrenLoadModuleResult wrenLoadModule(WrenVM* vm, const char* name)
{
  LOG_F(INFO, "[wrenLoadModule] module: %s.\n", name);
  WrenLoadModuleResult result;
  result.source = nullptr;
  result.userData = nullptr;
  result.onComplete = nullptr;
  auto moduleCtx = findModule(name);
  do 
  {
    if(!moduleCtx) { break; }
    result.source = moduleCtx->source.c_str();
  } while(false);

  if(result.source == nullptr)
  {
    result = readModule(vm, name);
  }
  return result;
}

WrenForeignMethodFn wrenBindModuleFn(WrenVM* vm, const char* module, const char* className, bool isStatic, const char* signature)
{
  WrenForeignMethodFn result = nullptr;
  auto moduleCtx = findModule(module);
  do 
  {
    if(!moduleCtx) { break; }
    result = ((CicoRegisterMethodFn)moduleCtx->foreignMethodFn)(vm, className, isStatic, signature);
  } while(false);
  return result;
}

WrenForeignClassMethods wrenBindModuleClass(WrenVM* vm, const char* module, const char* className)
{
  WrenForeignClassMethods result;
  result.allocate = nullptr;
  result.finalize = nullptr;
  auto moduleCtx = findModule(module);
  do 
  {
    if(!moduleCtx) { break; }
    result = ((CicoRegisterClassFn)moduleCtx->foreignClassFn)(vm, className);
  } while(false);
  return result;
}

  const char* resolveModule(WrenVM* vm, const char* importer, const char* module)
  {
    // LOG_F(INFO, "[resolveModule] %s %s \n", importer, module);
    return cicoResolveFileModule(vm, importer, module);
  }

CicoEngine::CicoEngine()
{

}

CicoEngine::~CicoEngine()
{

}

CicoEngine* cico_create()
{
    auto engine = new CicoEngine();
    engine->vm_ctx = new VmCtx();
    return engine;
}

void cico_start(CicoEngine* engine, std::string program)
{
  LOG_F(INFO, "[cico] starting cico %s \n", program.c_str());
  std::ifstream input {program, std::ios::binary | std::ios::ate};
  auto psize = input.tellg();
  std::string program_raw(psize, '\0');
  input.seekg(0);
  if(input.read(&program_raw[0], psize)) 
  {
      LOG_F(INFO, "[cico] script sizes: %d\n", int(psize));
  }

  // register modules
  registerModule("cico.math", cicoMathSource(), nullptr, (void*)wrenEasingBindForeignMethod);
  // registerModule("cico.core", cicoCoreSource(), nullptr, (void*)wrenCoreBindForeignMethod);
  registerModule("cico.os.file", cicoFileSource(), (void*)wrenFileBindClass, (void*)wrenFileBindForeignMethod);
  registerModule("cico.os.sys", cicoSysSource(), nullptr, (void*)wrenSysBindForeignMethod);
  registerModule("cico.os.serial", cicoSerialSource(), (void*)wrenSerialBinForeignClass, (void*)wrenSerialBindForeignMethod);
  registerModule("cico.net.mongoose", cicoMongosseSource(), (void*)wrenMongooseBindClass, (void*)wrenMongooseBindForeignMethod);
#if defined(CICO_MODULE_VINPUT)
  registerModule("cico.os.vinput", cicoVinputSource(), (void*)wrenVinputBinForeignClass, (void*)wrenVinputBindForeignMethod);
#endif
#if defined(CICO_MODULE_JSON)
  registerModule("cico.json", cicoJsonSource(), (void*)wrenJsonBindClass, (void*)wrenJsonBindForeignMethod);
#endif
#if defined(CICO_MODULE_RAYLIB)
  registerModule("cico.raylib", cicoRaylibSource(), (void*)wrenRaylibBindClass, (void*)wrenRaylibBindForeignMethod);
  registerModule("cico.raygui", cicoRayGuiSource(), nullptr, (void*)wrenRayGuiBindForeignMethod);
#endif

  wrenInitConfiguration(&((VmCtx*)engine->vm_ctx)->wren_config);
  ((VmCtx*)engine->vm_ctx)->wren_config.writeFn = &writeFn;
  ((VmCtx*)engine->vm_ctx)->wren_config.errorFn = &errorFn;
  ((VmCtx*)engine->vm_ctx)->wren_config.loadModuleFn = (WrenLoadModuleFn)wrenLoadModule;
  ((VmCtx*)engine->vm_ctx)->wren_config.bindForeignMethodFn = (WrenBindForeignMethodFn)wrenBindModuleFn;
  ((VmCtx*)engine->vm_ctx)->wren_config.bindForeignClassFn = (WrenBindForeignClassFn)wrenBindModuleClass;
  ((VmCtx*)engine->vm_ctx)->wren_config.resolveModuleFn = resolveModule;
  ((VmCtx*)engine->vm_ctx)->wren_vm = wrenNewVM(&((VmCtx*)engine->vm_ctx)->wren_config);

  const char* module = program.c_str();
  // ((VmCtx*)engine->vm_ctx)->wren_result = wrenInterpret(((VmCtx*)engine->vm_ctx)->wren_vm, module, program_raw.c_str());

  auto vm = ((VmCtx*)engine->vm_ctx)->wren_vm;
  // wrenInterpret(vm, module, app_program_raw.c_str());
  ((VmCtx*)engine->vm_ctx)->wren_result = wrenInterpret(vm, module, program_raw.c_str());
  wrenEnsureSlots(vm, 1);
  wrenGetVariable(vm, module, "cico", 0);
  auto app_handle = wrenGetSlotHandle(vm, 0);
  auto mapp_init = wrenMakeCallHandle(vm, "init()");
  auto mapp_eventLoop = wrenMakeCallHandle(vm, "eventLoop()");
  auto mapp_exit = wrenMakeCallHandle(vm, "exit()");

  wrenEnsureSlots(vm, 1);
  wrenSetSlotHandle(vm, 0, app_handle);
  WrenInterpretResult result = wrenCall(vm, mapp_init);

  while(1) {
    wrenEnsureSlots(vm, 1);
    wrenSetSlotHandle(vm, 0, app_handle);
    result = wrenCall(vm, mapp_eventLoop);
    auto ret = wrenGetSlotDouble(vm, 0);
    // LOG_F(INFO, "[CICO]event loop %f", ret);
    if(ret != 0) { break; }
  };
  
  wrenEnsureSlots(vm, 1);
  wrenSetSlotHandle(vm, 0, app_handle);
  result = wrenCall(vm, mapp_exit);
}

void cico_stop(CicoEngine* engine)
{
  switch (((VmCtx*)engine->vm_ctx)->wren_result)
  {
    case WREN_RESULT_COMPILE_ERROR:
      { LOG_F(ERROR, "Compile Error!\n"); } break;
    case WREN_RESULT_RUNTIME_ERROR:
      { LOG_F(ERROR, "Runtime Error!\n"); } break;
    case WREN_RESULT_SUCCESS:
      { LOG_F(INFO, "Success!\n"); } break;
  }
  wrenFreeVM(((VmCtx*)engine->vm_ctx)->wren_vm);
}

void cico_destroy(CicoEngine* engine)
{
    free(engine);
}

void cico_init_app(int argc, const char* argv[])
{
  for(int i = 0; i < argc; i++) {
    if(i == 1) continue;
    cico_argv.push_back(argv[i]);
  }
  loguru::init(argc, const_cast<char**>(argv), {});
  char log_path[1024];
  loguru::suggest_log_path("./logs", log_path, 1024);
  loguru::add_file(log_path, loguru::Append, loguru::Verbosity_MAX);
  loguru::g_preamble_thread = false;
  loguru::g_preamble_file = false;
  loguru::g_preamble_uptime = false;
  loguru::g_preamble_date = false;
}

} // namespace cico
