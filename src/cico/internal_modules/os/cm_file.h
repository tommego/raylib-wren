#ifndef CM_FILE_H
#define CM_FILE_H
#include <string>
#include <cico_wren>
#include <stdio.h>

namespace cico
{

class File {
public:
    void open(WrenVM* vm);
    void close(WrenVM* vm);
    void size(WrenVM* vm);
    void position(WrenVM* vm);
    void atend(WrenVM* vm);
    void seek(WrenVM* vm);
    void read(WrenVM* vm);
    void readline(WrenVM* vm);
    void write(WrenVM* vm);
    void flush(WrenVM* vm);

private:
    FILE* m_file;
};

const char* cicoFileSource();
WrenForeignMethodFn wrenFileBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature);
WrenForeignClassMethods wrenFileBindClass(WrenVM* vm, const char* className);
} // namespace cico


#endif //CM_FILE_H