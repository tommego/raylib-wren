#include "cico.h"

int main(int argc, const char* argv[])
{
    if(argc >= 2)
    { 
        cico::cico_init_app(argc, argv);
        auto engine = cico::cico_create();
        cico::cico_start(engine, argv[1]); 
        cico::cico_stop(engine);
        cico::cico_destroy(engine);
        engine = nullptr;
    } else {
        printf("Usage: ./cico_app path/to/script.wren \n");
    }
    return 0;
}