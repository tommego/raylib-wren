#ifndef CICO_H
#define CICO_H
#include <string>
#include "cico_math.h"

namespace cico {
class CicoEngine {
public:
    CicoEngine();
    ~CicoEngine();
    void* vm_ctx = nullptr;
};

extern CicoEngine* cico_create();
extern void cico_start(CicoEngine* engine, std::string program);
extern void cico_stop(CicoEngine* engine);
extern void cico_destroy(CicoEngine* engine);
extern void cico_init_app(int argc, const char* argv[]);

} //namespace cico

#endif //CICO_H