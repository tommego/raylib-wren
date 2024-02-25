#include "cm_file.h"
#include "cico_def.h"
#include <string.h>

namespace cico
{

static void FileMalloc(WrenVM* vm) {
    File* f = (File*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(File));
    memset(f, 0, sizeof(File));
}

void File::open(WrenVM* vm)
{
    auto path = wrenGetSlotString(vm, 1);
    auto mode = wrenGetSlotString(vm, 2);
    if(m_file) {
        fclose(m_file);
        m_file = nullptr;
    }
    m_file = fopen(path, mode);
    wrenSetSlotBool(vm, 0, m_file ? true : false);
}

void File::close(WrenVM* vm)
{
    if(m_file) { fclose(m_file); m_file = nullptr; }
}

void File::size(WrenVM* vm)
{
    int64_t fsize = -1;
    if(m_file) { 
        fpos_t curPos;
        fgetpos(m_file, &curPos);
        fseek(m_file, 0, SEEK_END);
        fsize = ftell(m_file);
        fsetpos(m_file, &curPos);
    }
    wrenSetSlotDouble(vm, 0, double(fsize));
}

void File::position(WrenVM* vm)
{
    int64_t pos = -1;
    if(m_file) { pos = fgetpos(m_file, nullptr); }
    wrenSetSlotDouble(vm, 0, double(pos));
}

void File::atend(WrenVM* vm)
{
    bool isend = true;
    if(m_file) {
        isend = feof(m_file);
        wrenSetSlotBool(vm, 0, isend);
    }
}

void File::seek(WrenVM* vm)
{
    int64_t ret = -1;
    int64_t pos = int64_t(wrenGetSlotDouble(vm, 1));
    if(m_file) { ret = fseek(m_file, pos, 0); }
}

void File::read(WrenVM* vm)
{
    int64_t len = int64_t(wrenGetSlotDouble(vm, 1));
    int64_t readlen = -1;
    char* buff = nullptr;
    std::string out;
    if(m_file && len > 0) {
        buff = (char*)malloc(len+1);
        buff[len] = '\0';
        readlen = fread(buff, len, 1, m_file);
    }
    out.append(buff);
    wrenSetSlotString(vm, 0, out.c_str());
    // if(buff) { free(buff); }
}

void File::readline(WrenVM* vm)
{
    std::string out;
    char buf;
    if(m_file) {
        int64_t len = 0;
        for(;;) {
            len = fread(&buf, 1, 1, m_file);
            out.push_back(buf);
            if(buf == '\n' || len <= 0)
            {
                out.push_back('\0');
                break;
            }
        }
    }
    wrenSetSlotString(vm, 0, out.c_str());
}

void File::write(WrenVM* vm)
{
    auto buff = wrenGetSlotString(vm, 1);
    auto buffsize = strlen(buff);
    int64_t len = -1;
    if(m_file){
        len = fwrite(buff, buffsize, 1, m_file);
    }
    wrenSetSlotDouble(vm, 0, double(len));
}

void File::flush(WrenVM* vm) 
{
    if(m_file) { fflush(m_file); }
}
static char* g_fileModuleSource = nullptr;
const char* cicoFileSource()
{
    if(!g_fileModuleSource) {g_fileModuleSource = loadModuleSource("cico_native/os/file.wren"); }
    return g_fileModuleSource;
}

CICO_CLS_METHOD(File, cico_file_open, open)
CICO_CLS_METHOD(File, cico_file_close, close)
CICO_CLS_METHOD(File, cico_file_size, size)
CICO_CLS_METHOD(File, cico_file_position, position)
CICO_CLS_METHOD(File, cico_file_atend, atend)
CICO_CLS_METHOD(File, cico_file_seek, seek)
CICO_CLS_METHOD(File, cico_file_read, read)
CICO_CLS_METHOD(File, cico_file_readline, readline)
CICO_CLS_METHOD(File, cico_file_write, write)
CICO_CLS_METHOD(File, cico_file_flush, flush)

WrenForeignMethodFn wrenFileBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature)
{
    WrenForeignMethodFn fn = nullptr;
    if(strcmp(className, "File") == 0)
    {
        do 
        {
            if(strcmp(signature, "open(_,_)") == 0) { fn = cico_file_open; break; }
            if(strcmp(signature, "close()") == 0) { fn = cico_file_close; break; } 
            if(strcmp(signature, "size") == 0) { fn = cico_file_size; break; } 
            if(strcmp(signature, "position") == 0) { fn = cico_file_position; break; } 
            if(strcmp(signature, "atend") == 0) { fn = cico_file_atend; break; } 
            if(strcmp(signature, "seek(_)") == 0) { fn = cico_file_seek; break; } 
            if(strcmp(signature, "read(_)") == 0) { fn = cico_file_read; break; } 
            if(strcmp(signature, "readline()") == 0) { fn = cico_file_readline; break; } 
            if(strcmp(signature, "write(_)") == 0) { fn = cico_file_write; break; }
            if(strcmp(signature, "flush()") == 0) { fn = cico_file_flush; break; }
        } while(false);
    }
    return fn;
}

WrenForeignClassMethods wrenFileBindClass(WrenVM* vm,const char* className)
{
    WrenForeignClassMethods fn;
    fn.allocate = FileMalloc;
    fn.finalize = nullptr;
    return fn;
}
    
} // namespace cico
