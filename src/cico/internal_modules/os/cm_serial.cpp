#include "cm_serial.h"
#include "cico_def.h"
#include "serial/serial.h"


namespace cico
{
typedef serial::PortInfo PortInfo;
typedef serial::Timeout Timeout;
typedef serial::Serial Serial;
typedef serial::bytesize_t bytesize_t;
typedef serial::stopbits_t stopbits_t;
typedef serial::flowcontrol_t flowcontrol_t;
typedef serial::parity_t parity_t;

CICO_CLS_ALLOCATOR(PortInfo)
CICO_CLS_ALLOCATOR(Timeout)
// CICO_CLS_ALLOCATOR(Serial)

struct SerialWraper {
    Serial* serial = nullptr;
    Serial* running = nullptr;
};

static void SerialMalloc(WrenVM* vm) {
    SerialWraper* f = (SerialWraper*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(SerialWraper)); 
    f->serial = new Serial();
}

#define WRENCLSMETHOD0(cls, fn, retType) \
static void wren##cls##fn(WrenVM* vm) { \
    wrenSetSlot##retType(vm, 0, WSCls(0, cls)->serial->fn()); \
}

#define WRENCLSMETHOD1(cls, fn, retType, ptype1) \
static void wren##cls##fn(WrenVM* vm) { wrenSetSlot##retType(vm, 0, WSCls(0, cls)->serial->fn(WS##ptype1(1))); }

#define WRENCLSMETHOD_VOID0(cls, fn) \
static void wren##cls##fn(WrenVM* vm) { WSCls(0, cls)->serial->fn(); }
#define WRENCLSMETHOD_VOID1(cls, fn, ptype1) \
static void wren##cls##fn(WrenVM* vm) { WSCls(0, cls)->serial->fn(WS##ptype1(1)); }

#define WRENCLSPROPERTY_RW(cls, prop, type) \
void wren##cls##Get##prop(WrenVM* vm) { wrenSetSlot##type(vm, 0, WSCls(0, cls)->serial->get##prop()); } \
void wren##cls##Set##prop(WrenVM* vm) { \
    WSCls(0, cls)->serial->set##prop(WS##type(1)); \
}

#define WRENCLSPROPERTY_CVT_RW(cls, prop, type, cvt) \
void wren##cls##Get##prop(WrenVM* vm) { wrenSetSlot##type(vm, 0, WSCls(0, cls)->serial->get##prop()##cvt); } \
void wren##cls##Set##prop(WrenVM* vm) { WSCls(0, cls)->serial->set##prop(WS##type(1)); }

#define WRENCLSPROPERTY_SCVT_RW(cls, prop, type, cvt) \
void wren##cls##Get##prop(WrenVM* vm) { wrenSetSlot##type(vm, 0, WSCls(0, cls)->serial->get##prop()); } \
void wren##cls##Set##prop(WrenVM* vm) { WSCls(0, cls)->serial->set##prop(cvt(wrenGetSlot##type(vm, 1))); }

#define WRENCLS_FOREIGN_PROPERTY_RW(cls, prop, fcls) \
void wren##cls##Get##prop(WrenVM* vm) { *WSCls(1, fcls) = (WSCls(0, cls)->serial->get##prop()); } \
void wren##cls##Set##prop(WrenVM* vm) { WSCls(0, cls)->serial->set##prop(*WSCls(1, fcls)); }

WRENPROPERTY_CVT_RW(PortInfo, port, String, .c_str())
WRENPROPERTY_CVT_RW(PortInfo, description, String, .c_str())
WRENPROPERTY_CVT_RW(PortInfo, hardware_id, String, .c_str())
static void wrenPortInfolist_ports(WrenVM* vm) {
    auto ports = serial::list_ports();
    LOG_F(INFO, "[Serial] enumerate_ports: %d ", ports.size());
    wrenEnsureSlots(vm, ports.size() + 1);
    for(int i = 0; i < ports.size(); i++) {
        auto port = (PortInfo*)wrenSetSlotNewForeign(vm, i + 1, 0, sizeof(PortInfo));
        port->port = ports[i].port;
        port->description = ports[i].description;
        port->hardware_id = ports[i].hardware_id;
        LOG_F(INFO, "[Serial] got port: %s, desc: %s, id: %s", ports[i].port.c_str(), ports[i].description.c_str(), port->hardware_id.c_str());
    }
    wrenSetSlotNewList(vm, 0);
    for(int i = 0; i < ports.size(); i++) { wrenInsertInList(vm, 0, i, i + 1); }
}

WRENPROPERTY_RW(Timeout, inter_byte_timeout, Double)
WRENPROPERTY_RW(Timeout, read_timeout_constant, Double)
WRENPROPERTY_RW(Timeout, read_timeout_multiplier, Double)
WRENPROPERTY_RW(Timeout, write_timeout_constant, Double)
WRENPROPERTY_RW(Timeout, write_timeout_multiplier, Double)
static void wrenTimeoutmax(WrenVM* vm) { wrenSetSlotDouble(vm, 0, Timeout::max()); }

// WRENCLSMETHOD_VOID0(SerialWraper, open)
static void wrenSerialWraperopen(WrenVM* vm) {
    auto wrap = WSCls(0, SerialWraper);
    auto old = wrap->serial;
    wrap->serial = new Serial(
        old->getPort(),
        old->getBaudrate(),
        old->getTimeout(),
        old->getBytesize(),
        old->getParity(),
        old->getStopbits(),
        old->getFlowcontrol()
    );
    if(old->isOpen()) { old->flush(); old->close(); }
    free(old);
}
WRENCLSMETHOD0(SerialWraper, isOpen, Bool)
WRENCLSMETHOD_VOID0(SerialWraper, close)
WRENCLSMETHOD0(SerialWraper, available, Double)
WRENCLSMETHOD0(SerialWraper, waitReadable, Bool)
WRENCLSMETHOD_VOID1(SerialWraper, waitByteTimes, Double)
static void wrenSerialWraperread(WrenVM* vm) {
    size_t bsize = (size_t) WSDouble(1);
    uint8_t* buff = (uint8_t*)malloc(bsize * sizeof(uint8_t));
    memset(buff, 0, bsize * sizeof(uint8_t));
    auto readSize = WSCls(0, SerialWraper)->serial->read(buff, bsize);
    if(readSize > 0 && readSize != bsize) { buff = (uint8_t*)realloc(buff, readSize * sizeof(uint8_t)); }
    wrenSetSlotString(vm, 0, (const char*)buff);
}
static void wrenSerialWraperreadline(WrenVM* vm) {
    std::string buff;
    WSCls(0, SerialWraper)->serial->readline(buff);
    wrenSetSlotString(vm, 0, buff.c_str());
}
WRENCLSMETHOD1(SerialWraper, write, Double, String);
WRENCLSPROPERTY_CVT_RW(SerialWraper, Port, String, .c_str());
WRENCLS_FOREIGN_PROPERTY_RW(SerialWraper, Timeout, Timeout)
WRENCLSPROPERTY_RW(SerialWraper, Baudrate, Double)
WRENCLSPROPERTY_SCVT_RW(SerialWraper, Bytesize, Double, bytesize_t)
WRENCLSPROPERTY_SCVT_RW(SerialWraper, Parity, Double, parity_t)
WRENCLSPROPERTY_SCVT_RW(SerialWraper, Stopbits, Double, stopbits_t)
WRENCLSPROPERTY_SCVT_RW(SerialWraper, Flowcontrol, Double, flowcontrol_t)
WRENCLSMETHOD_VOID0(SerialWraper, flush)
WRENCLSMETHOD_VOID0(SerialWraper, flushInput)
WRENCLSMETHOD_VOID0(SerialWraper, flushOutput)
WRENCLSMETHOD_VOID1(SerialWraper, sendBreak, Double);
WRENCLSMETHOD_VOID1(SerialWraper, setBreak, Bool);
WRENCLSMETHOD_VOID1(SerialWraper, setRTS, Bool);
WRENCLSMETHOD_VOID1(SerialWraper, setDTR, Bool);
WRENCLSMETHOD0(SerialWraper, waitForChange, Bool)
WRENCLSMETHOD0(SerialWraper, getCTS, Bool)
WRENCLSMETHOD0(SerialWraper, getDSR, Bool)
WRENCLSMETHOD0(SerialWraper, getRI, Bool)
WRENCLSMETHOD0(SerialWraper, getCD, Bool)

#define WRENCLSGETTERFN(cls, prop) wren##cls##Get##prop
#define WRENCLSSETTERFN(cls, prop) wren##cls##Set##prop
#define WRENCLSFN(cls, fn) wren##cls##fn

static char* g_SerialModuleSource = nullptr;
const char* cicoSerialSource() {
    if(!g_SerialModuleSource) {g_SerialModuleSource = loadModuleSource("cico_native/os/serial.wren"); }
    return g_SerialModuleSource;
}

WrenForeignMethodFn wrenSerialBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature) {
    WrenForeignMethodFn fn = nullptr;
    if(strcmp(className, "Timeout") == 0) {
        do {
            if(strcmp(signature, "max") == 0) { fn = wrenTimeoutmax; break; }
            if(strcmp(signature, "inter_byte_timeout") == 0) { fn = WRENGETTERFN(Timeout, inter_byte_timeout); break; }
            if(strcmp(signature, "inter_byte_timeout=(_)") == 0) { fn = WRENSETTERFN(Timeout, inter_byte_timeout); break; }
            if(strcmp(signature, "read_timeout_constant") == 0) { fn = WRENGETTERFN(Timeout, read_timeout_constant); break; }
            if(strcmp(signature, "read_timeout_constant=(_)") == 0) { fn = WRENSETTERFN(Timeout, read_timeout_constant); break; }
            if(strcmp(signature, "read_timeout_multiplier") == 0) { fn = WRENGETTERFN(Timeout, read_timeout_multiplier); break; }
            if(strcmp(signature, "read_timeout_multiplier=(_)") == 0) { fn = WRENSETTERFN(Timeout, read_timeout_multiplier); break; }
            if(strcmp(signature, "write_timeout_constant") == 0) { fn = WRENGETTERFN(Timeout, write_timeout_constant); break; }
            if(strcmp(signature, "write_timeout_constant=(_)") == 0) { fn = WRENSETTERFN(Timeout, write_timeout_constant); break; }
            if(strcmp(signature, "write_timeout_multiplier") == 0) { fn = WRENGETTERFN(Timeout, write_timeout_multiplier); break; }
            if(strcmp(signature, "write_timeout_multiplier=(_)") == 0) { fn = WRENSETTERFN(Timeout, write_timeout_multiplier); break; }
        } while(false);
    } else if(strcmp(className, "Serial") == 0) {
        do {
            if(strcmp(signature, "open()") == 0) { 
                LOG_F(INFO, "[Serial] invoke open %s", signature);
                fn = WRENCLSFN(SerialWraper, open); break; 
            }
            if(strcmp(signature, "isOpen") == 0) { fn = WRENCLSFN(SerialWraper, isOpen); break; }
            if(strcmp(signature, "close()") == 0) { fn = WRENCLSFN(SerialWraper, close); break; }
            if(strcmp(signature, "available") == 0) { fn = WRENCLSFN(SerialWraper, available); break; }
            if(strcmp(signature, "waitReadable()") == 0) { fn = WRENCLSFN(SerialWraper, waitReadable); break; }
            if(strcmp(signature, "waitByteTimes(_)") == 0) { fn = WRENCLSFN(SerialWraper, waitByteTimes); break; }
            if(strcmp(signature, "read(_)") == 0) { fn = WRENCLSFN(SerialWraper, read); break; }
            if(strcmp(signature, "readline()") == 0) { fn = WRENCLSFN(SerialWraper, readline); break; }
            if(strcmp(signature, "write(_)") == 0) { fn = WRENCLSFN(SerialWraper, write); break; }
            if(strcmp(signature, "port") == 0) { fn = WRENCLSGETTERFN(SerialWraper, Port); break; }
            if(strcmp(signature, "port=(_)") == 0) { fn = WRENCLSSETTERFN(SerialWraper, Port); break; }
            if(strcmp(signature, "timeout") == 0) { fn = WRENCLSGETTERFN(SerialWraper, Timeout); break; }
            if(strcmp(signature, "timeout=(_)") == 0) { fn = WRENCLSSETTERFN(SerialWraper, Timeout); break; }
            if(strcmp(signature, "baudRate") == 0) { fn = WRENCLSGETTERFN(SerialWraper, Baudrate); break; }
            if(strcmp(signature, "baudRate=(_)") == 0) { fn = WRENCLSSETTERFN(SerialWraper, Baudrate); break; }
            if(strcmp(signature, "byteSize") == 0) { fn = WRENCLSGETTERFN(SerialWraper, Bytesize); break; }
            if(strcmp(signature, "byteSize=(_)") == 0) { fn = WRENCLSSETTERFN(SerialWraper, Bytesize); break; }
            if(strcmp(signature, "parity") == 0) { fn = WRENCLSGETTERFN(SerialWraper, Parity); break; }
            if(strcmp(signature, "parity=(_)") == 0) { fn = WRENCLSSETTERFN(SerialWraper, Parity); break; }
            if(strcmp(signature, "stopBits") == 0) { fn = WRENCLSGETTERFN(SerialWraper, Stopbits); break; }
            if(strcmp(signature, "stopBits=(_)") == 0) { fn = WRENCLSSETTERFN(SerialWraper, Stopbits); break; }
            if(strcmp(signature, "flowControl") == 0) { fn = WRENCLSGETTERFN(SerialWraper, Flowcontrol); break; }
            if(strcmp(signature, "flowControl=(_)") == 0) { fn = WRENCLSSETTERFN(SerialWraper, Flowcontrol); break; }
            if(strcmp(signature, "flush()") == 0) { fn = WRENCLSFN(SerialWraper, flush); break; }
            if(strcmp(signature, "flushInput()") == 0) { fn = WRENCLSFN(SerialWraper, flushInput); break; }
            if(strcmp(signature, "flushOutput()") == 0) { fn = WRENCLSFN(SerialWraper, flushOutput); break; }
            if(strcmp(signature, "sendBreak(_)") == 0) { fn = WRENCLSFN(SerialWraper, sendBreak); break; }
            if(strcmp(signature, "breakLevel=(_)") == 0) { fn = WRENCLSFN(SerialWraper, setBreak); break; }
            if(strcmp(signature, "rtsLevel=(_)") == 0) { fn = WRENCLSFN(SerialWraper, setRTS); break; }
            if(strcmp(signature, "dtrLevel=(_)") == 0) { fn = WRENCLSFN(SerialWraper, setDTR); break; }
            if(strcmp(signature, "waitForChange()") == 0) { fn = WRENCLSFN(SerialWraper, waitForChange); break; }
            if(strcmp(signature, "cts") == 0) { fn = WRENCLSFN(SerialWraper, getCTS); break; }
            if(strcmp(signature, "dsr") == 0) { fn = WRENCLSFN(SerialWraper, getDSR); break; }
            if(strcmp(signature, "ri") == 0) { fn = WRENCLSFN(SerialWraper, getRI); break; }
            if(strcmp(signature, "cd") == 0) { fn = WRENCLSFN(SerialWraper, getCD); break; }
        } while(false);
    } else if(strcmp(className, "PortInfo") == 0) {
        do {
            if(strcmp(signature, "port") == 0) { fn = WRENGETTERFN(PortInfo, port); break; }
            if(strcmp(signature, "port=(_)") == 0) { fn = WRENSETTERFN(PortInfo, port); break; }
            if(strcmp(signature, "description") == 0) { fn = WRENGETTERFN(PortInfo, description); break; }
            if(strcmp(signature, "description=(_)") == 0) { fn = WRENSETTERFN(PortInfo, description); break; }
            if(strcmp(signature, "hardware_id") == 0) { fn = WRENGETTERFN(PortInfo, hardware_id); break; }
            if(strcmp(signature, "hardware_id=(_)") == 0) { fn = WRENSETTERFN(PortInfo, hardware_id); break; }
            if(strcmp(signature, "list_ports") == 0) { fn = wrenPortInfolist_ports; break; }
        } while(false);
    }

    return fn;
}

WrenForeignClassMethods wrenSerialBinForeignClass(WrenVM* vm, const char* className) {
    WrenForeignClassMethods cls;
    cls.allocate = nullptr;
    cls.finalize = nullptr;
    do {
        if(strcmp(className, "Serial") == 0) { cls.allocate = SerialMalloc; break; }
        if(strcmp(className, "PortInfo") == 0) { cls.allocate = PortInfoMalloc; break; }
        if(strcmp(className, "Timeout") == 0) { cls.allocate = TimeoutMalloc; break; }
    } while(false);
    return cls;
}

} // namespace cico
