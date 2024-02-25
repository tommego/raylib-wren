#include "cm_mongoose.h"
#include "mongoose/mongoose.h"
#include "cico_def.h"
#include <stdio.h>
#include <string>
#include <fstream>
#include <thread>
#include <vector>
#include <mutex>

namespace cico  
{
CICO_CLS_ALLOCATOR(mg_timer)
CICO_CLS_ALLOCATOR(mg_iobuf)
CICO_CLS_ALLOCATOR(mg_md5_ctx)
CICO_CLS_ALLOCATOR(mg_sha256_ctx)
CICO_CLS_ALLOCATOR(mg_dns)
CICO_CLS_ALLOCATOR(mg_addr)
CICO_CLS_ALLOCATOR(mg_mgr)
CICO_CLS_ALLOCATOR(mg_connection)
CICO_CLS_ALLOCATOR(mg_http_header)
CICO_CLS_ALLOCATOR(mg_http_message)
CICO_CLS_ALLOCATOR(mg_http_serve_opts)
CICO_CLS_ALLOCATOR(mg_http_part)
CICO_CLS_ALLOCATOR(mg_tls_opts)
CICO_CLS_ALLOCATOR(mg_mqtt_prop)
CICO_CLS_ALLOCATOR(mg_mqtt_opts)
CICO_CLS_ALLOCATOR(mg_mqtt_message)
CICO_CLS_ALLOCATOR(mg_dns_message)
CICO_CLS_ALLOCATOR(mg_dns_header)
CICO_CLS_ALLOCATOR(mg_dns_rr)
CICO_CLS_ALLOCATOR(mg_rpc_req)
CICO_CLS_ALLOCATOR(mg_rpc)
struct mg_connection_wrapper {
    mg_connection* connection = nullptr;
    mg_connection* pandingConnection = nullptr;
};
CICO_CLS_ALLOCATOR(mg_connection_wrapper)

struct WrenMgEvent {
    WrenHandle* cb_handle;
    WrenHandle* conn_handle;
    WrenHandle* msg_handle;
    mg_http_message* http_msg;
    mg_connection_wrapper* conn_rapper;
    int ev;
    WrenVM* vm;
};
static std::vector<WrenMgEvent*> g_mgEvents;
static std::mutex g_mgEventMutx;

static mg_mgr* g_mg_mgr_ctx = nullptr; 
static std::thread g_mg_thread;
static bool g_mg_exit = false;

static const char *s_root_dir = ".";
static const char *s_listening_address = "http://0.0.0.0:8000";
static const char *s_enable_hexdump = "no";
static const char *s_ssi_pattern = "#.html";

void mg_str_cpy(mg_str* dst, mg_str* src) {
    dst->len = src->len;
    if(src->ptr && strlen(src->ptr) > 0) {
        dst->ptr = (const char*)malloc(strlen(src->ptr)* sizeof(const char));
        memset(const_cast<char*>(dst->ptr), 0, strlen(src->ptr) * sizeof(const char));
        memcpy(const_cast<char*>(dst->ptr), src->ptr, strlen(src->ptr) * sizeof(const char));
    }
}
void mg_http_message_cpy(mg_http_message* dst, mg_http_message* src) {
    mg_str_cpy(&(dst->method), &src->method);
    mg_str_cpy(&(dst->uri), &(src->uri));
    mg_str_cpy(&(dst->query), &(src->query));
    mg_str_cpy(&(dst->proto), &(src->proto));
    for(int i = 0; i < MG_MAX_HTTP_HEADERS; i++) {
        mg_str_cpy(&(dst->headers[i].name), &(src->headers[i].name));
        mg_str_cpy(&(dst->headers[i].value), &(src->headers[i].value));
    }
    mg_str_cpy(&(dst->body), &(src->body));
    mg_str_cpy(&(dst->head), &(src->head));
    mg_str_cpy(&(dst->message), &(src->message));

}

void mg_poll_event() {
    while(!g_mg_exit) { mg_mgr_poll(g_mg_mgr_ctx, 50); }
    mg_mgr_free(g_mg_mgr_ctx);
    g_mg_mgr_ctx = nullptr;
}

void init_mg_mgr() {
    LOG_F(INFO, "============= Init mongoose ============= ");
    g_mg_mgr_ctx = new mg_mgr;
    mg_mgr_init(g_mg_mgr_ctx);
    g_mg_thread = std::thread(mg_poll_event);
}

void cb_http_client(mg_connection* c, int ev, void* ev_data) {
    if(ev == MG_EV_OPEN) {

    }
}

void cb_http_server(mg_connection* c, int ev, void* ev_data) {
  if (ev == MG_EV_HTTP_MSG) {
    struct mg_http_message *hm = (mg_http_message*)ev_data, tmp = {0};
    struct mg_str unknown = mg_str_n("?", 1), *cl;
    struct mg_http_serve_opts opts = {0};
    opts.root_dir = s_root_dir;
    opts.ssi_pattern = s_ssi_pattern;
    auto info = (WrenMgEvent*)c->fn_data;
    g_mgEventMutx.lock();
    WrenMgEvent* mev = new WrenMgEvent;
    mev->cb_handle = info->cb_handle;
    mev->conn_handle = info->conn_handle;
    mev->msg_handle = info->msg_handle;
    mev->http_msg = info->http_msg;
    mev->vm = info->vm;
    mev->ev = ev;
    mev->conn_rapper = info->conn_rapper;
    mev->conn_rapper->pandingConnection = c;
    mg_http_message_cpy(mev->http_msg, hm);
    g_mgEvents.push_back(mev);
    g_mgEventMutx.unlock();
    mg_http_parse((char *) c->send.buf, c->send.len, &tmp);
    cl = mg_http_get_header(&tmp, "Content-Length");
    LOG_F(INFO, "[Mongosse] http server event, connection: %p", c);
    if (cl == NULL) cl = &unknown;
  }
}

void cb_mg_io(mg_connection* c, int ev, void* ev_data) {

}

#define CICO_MG_METHOD(name) cico_mg_##name

void cico_mg_listen(WrenVM* vm) { 
    // WrenMgEvent* info = new WrenMgEvent;
    // info->conn_handle = wrenGetSlotHandle(vm, 1);
    // info->msg_handle = wrenGetSlotHandle(vm, 3);
    // info->cb_handle = wrenGetSlotHandle(vm, 4);
    // info->vm = vm; 
    // mg_http_listen(g_mg_mgr_ctx, WSString(2), cb_http_server, info);
}
void cico_mg_connect(WrenVM* vm) { }
void cico_mg_wrapfd(WrenVM* vm) { }
void cico_mg_send(WrenVM* vm) { }
void cico_mg_closeConn(WrenVM* vm) { }
void cico_mg_httpParse(WrenVM* vm) { }
void cico_mg_httpWriteChunk(WrenVM* vm) { }
void cico_mg_HttpDeleteChunk(WrenVM* vm) { }
void cico_mg_httpListen(WrenVM* vm) { 
    WrenMgEvent* info = new WrenMgEvent;
    info->conn_handle = wrenGetSlotHandle(vm, 1);
    info->msg_handle = wrenGetSlotHandle(vm, 3);
    info->cb_handle = wrenGetSlotHandle(vm, 4);
    info->conn_rapper = WSCls(1, mg_connection_wrapper);
    info->http_msg = WSCls(3, mg_http_message);
    info->vm = vm; 
    auto conn = mg_http_listen(g_mg_mgr_ctx, WSString(2), cb_http_server, info);
    info->conn_rapper->connection = conn;
    (WSCls(1, mg_connection_wrapper))->connection = conn;
    LOG_F(INFO, "[Mongoose] listening %p %p %p, connection: %p", info->conn_handle, info->msg_handle, info->cb_handle, conn);
}
void cico_mg_httpConnect(WrenVM* vm) { }
void cico_mg_httpServeDir(WrenVM* vm) { 
    auto c = WSCls(1, mg_connection_wrapper)->pandingConnection;
    auto hm = WSCls(2, mg_http_message);
    auto opts = WSCls(3, mg_http_serve_opts);
    LOG_F(INFO, "[Mongoose] http serving dir: %s, pattern: %s, uri: %s, connection: %p", opts->root_dir, opts->ssi_pattern, hm->uri.ptr, c);
    mg_http_serve_dir(c, hm, opts);
}
void cico_mg_httpServeFile(WrenVM* vm) { }
void cico_mg_httpReply(WrenVM* vm) { }
void cico_mg_httpMatchUri(WrenVM* vm) { }
void cico_mg_httpUpload(WrenVM* vm) { }
void cico_mg_httpBauth(WrenVM* vm) { }
void cico_mg_httpStatus(WrenVM* vm) { }
void cico_mg_tlsInit(WrenVM* vm) { }
void cico_mg_tlsFree(WrenVM* vm) { }
void cico_mg_tlsSend(WrenVM* vm) { }
void cico_mg_tlsRecv(WrenVM* vm) { }
void cico_mg_tlsPending(WrenVM* vm) { }
void cico_mg_tlsHandShake(WrenVM* vm) { }
void cico_mg_tlsCtxInit(WrenVM* vm) { }
void cico_mg_tlsCtxFree(WrenVM* vm) { }
void cico_mg_ioSend(WrenVM* vm) { }
void cico_mg_ioRecv(WrenVM* vm) { }
void cico_mg_arch(WrenVM* vm) { wrenSetSlotDouble(vm, 0, MG_ARCH); }
void cico_mg_init(WrenVM* vm) { g_mg_exit = false; if(!g_mg_mgr_ctx) { init_mg_mgr(); } }
void cico_mg_quit(WrenVM* vm) { g_mg_exit = true; }
void cico_mg_tick(WrenVM* vm) {
    wrenSetSlotNull(vm, 0);
    g_mgEventMutx.lock();
    while(g_mgEvents.size()) {
        WrenMgEvent* info = g_mgEvents[0];
        wrenEnsureSlots(vm, 5);
        wrenSetSlotNewList(vm, 0);
        wrenSetSlotHandle(vm, 1, info->cb_handle);
        wrenSetSlotHandle(vm, 2, info->conn_handle);
        wrenSetSlotDouble(vm, 3, info->ev);
        wrenSetSlotHandle(vm, 4, info->msg_handle);
        wrenInsertInList(vm, 0, 0, 1);
        wrenInsertInList(vm, 0, 1, 2);
        wrenInsertInList(vm, 0, 2, 3);
        wrenInsertInList(vm, 0, 3, 4);
        free(info);
        g_mgEvents.erase(g_mgEvents.begin());
        break;
    }
    g_mgEventMutx.unlock();
}

WRENPROPERTY_RW(mg_http_serve_opts, root_dir, String)
WRENPROPERTY_RW(mg_http_serve_opts, ssi_pattern, String)
WRENPROPERTY_RW(mg_http_serve_opts, extra_headers, String)
WRENPROPERTY_RW(mg_http_serve_opts, mime_types, String)

static char* g_mongooseModuleSource = nullptr;
const char* cicoMongosseSource() {
    if(!g_mongooseModuleSource) {g_mongooseModuleSource = loadModuleSource("cico_native/net/mongoose.wren");}
    return g_mongooseModuleSource;
}


WrenForeignMethodFn wrenMongooseBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature) {
    WrenForeignMethodFn fn = nullptr; 
    if(strcmp(className, "MgMgr") == 0) {
        do {
            if(strcmp(signature, "listen(_,_)") == 0) { fn = CICO_MG_METHOD(listen); break; }
            if(strcmp(signature, "connect(_,_)") == 0) { fn = CICO_MG_METHOD(connect); break; }
            if(strcmp(signature, "wrapfd(_,_)") == 0) { fn = CICO_MG_METHOD(wrapfd); break; }
            if(strcmp(signature, "send(_,_)") == 0) { fn = CICO_MG_METHOD(send); break; }
            if(strcmp(signature, "closeConn(_)") == 0) { fn = CICO_MG_METHOD(closeConn); break; }
            if(strcmp(signature, "httpParse(_,_)") == 0) { fn = CICO_MG_METHOD(httpParse); break; }
            if(strcmp(signature, "httpWriteChunk(_,_)") == 0) { fn = CICO_MG_METHOD(httpWriteChunk); break; }
            if(strcmp(signature, "HttpDeleteChunk(_,_)") == 0) { fn = CICO_MG_METHOD(HttpDeleteChunk); break; }
            if(strcmp(signature, "httpListen(_,_,_,_)") == 0) { fn = CICO_MG_METHOD(httpListen); break; }
            if(strcmp(signature, "httpConnect(_,_,_)") == 0) { fn = CICO_MG_METHOD(httpConnect); break; }
            if(strcmp(signature, "httpServeDir(_,_,_)") == 0) { fn = CICO_MG_METHOD(httpServeDir); break; }
            if(strcmp(signature, "httpServeFile(_,_,_,_)") == 0) { fn = CICO_MG_METHOD(httpServeFile); break; }
            if(strcmp(signature, "httpReply(_,_,_,_)") == 0) { fn = CICO_MG_METHOD(httpReply); break; }
            if(strcmp(signature, "httpMatchUri(_,_)") == 0) { fn = CICO_MG_METHOD(httpMatchUri); break; }
            if(strcmp(signature, "httpUpload(_,_,_,_,_)") == 0) { fn = CICO_MG_METHOD(httpUpload); break; }
            if(strcmp(signature, "httpBauth(_,_,_)") == 0) { fn = CICO_MG_METHOD(httpBauth); break; }
            if(strcmp(signature, "httpStatus(_)") == 0) { fn = CICO_MG_METHOD(httpStatus); break; }
            if(strcmp(signature, "tlsInit(_,_)") == 0) { fn = CICO_MG_METHOD(tlsInit); break; }
            if(strcmp(signature, "tlsFree(_)") == 0) { fn = CICO_MG_METHOD(tlsFree); break; }
            if(strcmp(signature, "tlsSend(_,_)") == 0) { fn = CICO_MG_METHOD(tlsSend); break; }
            if(strcmp(signature, "tlsRecv(_,_)") == 0) { fn = CICO_MG_METHOD(tlsRecv); break; }
            if(strcmp(signature, "tlsPending(_)") == 0) { fn = CICO_MG_METHOD(tlsPending); break; }
            if(strcmp(signature, "tlsHandShake(_)") == 0) { fn = CICO_MG_METHOD(tlsHandShake); break; }
            if(strcmp(signature, "tlsCtxInit()") == 0) { fn = CICO_MG_METHOD(tlsCtxInit); break; }
            if(strcmp(signature, "tlsCtxFree()") == 0) { fn = CICO_MG_METHOD(tlsCtxFree); break; }
            if(strcmp(signature, "ioSend(_,_)") == 0) { fn = CICO_MG_METHOD(ioSend); break; }
            if(strcmp(signature, "ioRecv(_,_)") == 0) { fn = CICO_MG_METHOD(ioRecv); break; }
            if(strcmp(signature, "arch") == 0) { fn = CICO_MG_METHOD(arch); break; }
            if(strcmp(signature, "init()") == 0) { fn = CICO_MG_METHOD(init); break; }
            if(strcmp(signature, "quit()") == 0) { fn = CICO_MG_METHOD(quit); break; }
            if(strcmp(signature, "tick()") == 0) { fn = CICO_MG_METHOD(tick); break; }
        } while(false);
    } else if(strcmp(className, "MGHttpServeOpts") == 0) {
        do {
            if(strcmp(signature, "root_dir") == 0) { fn = WRENGETTERFN(mg_http_serve_opts, root_dir); break; }
            if(strcmp(signature, "root_dir=(_)") == 0) { fn = WRENSETTERFN(mg_http_serve_opts, root_dir); break; }
            if(strcmp(signature, "ssi_pattern") == 0) { fn = WRENGETTERFN(mg_http_serve_opts, ssi_pattern); break; }
            if(strcmp(signature, "ssi_pattern=(_)") == 0) { fn = WRENSETTERFN(mg_http_serve_opts, ssi_pattern); break; }
            if(strcmp(signature, "extra_headers") == 0) { fn = WRENGETTERFN(mg_http_serve_opts, extra_headers); break; }
            if(strcmp(signature, "extra_headers=(_)") == 0) { fn = WRENSETTERFN(mg_http_serve_opts, extra_headers); break; }
            if(strcmp(signature, "mime_types") == 0) { fn = WRENGETTERFN(mg_http_serve_opts, mime_types); break; }
            if(strcmp(signature, "mime_types=(_)") == 0) { fn = WRENSETTERFN(mg_http_serve_opts, mime_types); break; }
        } while(false);
    }
    return fn;
}

WrenForeignClassMethods wrenMongooseBindClass(WrenVM* vm, const char* className) {
    WrenForeignClassMethods cls; 
    cls.allocate = nullptr;
    cls.finalize = nullptr;

    do {
        if(strcmp(className, "MGConnection") == 0) { cls.allocate = mg_connection_wrapperMalloc; break; }
        if(strcmp(className, "MGDNS") == 0) { cls.allocate = mg_dnsMalloc; break; }
        if(strcmp(className, "MGAddr") == 0) { cls.allocate = mg_addrMalloc; break; }
        if(strcmp(className, "MGHttpHeader") == 0) { cls.allocate = mg_http_headerMalloc; break; }
        if(strcmp(className, "MGHttpMessage") == 0) { cls.allocate = mg_http_messageMalloc; break; }
        if(strcmp(className, "MGHttpServeOpts") == 0) { cls.allocate = mg_http_serve_optsMalloc; break; }
        if(strcmp(className, "MGHtttpPart") == 0) { cls.allocate = mg_http_partMalloc; break; }
        if(strcmp(className, "MGTlsOpts") == 0) { cls.allocate = mg_tls_optsMalloc; break; }
    } while(false);
    return cls;
}

}