foreign class MGConnection {
    construct new() {}
    // foreign next
    // foreign id 
    // foreign is_listening
    // foreign is_client 
    // foreign is_accepted 
    // foreign is_resolving
    // foreign is_arplooking
    // foreign is_connecting 
    // foreign is_tls
    // foreign is_tls_hs
    // foreign is_udp 
    // foreign is_websocket
    // foreign is_mqtt5
    // foreign is_hexdumping
    // foreign is_draining
    // foreign is_closing
    // foreign is_full
    // foreign is_resp
    // foreign is_readable
    // foreign is_writable 
}

foreign class MGDNS {
    construct new() {}
    // foreign url
    // foreign url=(val)
}

foreign class MGAddr {
    construct new() {}
    // foreign ip 
    // foreign ip=(val)
    // foreign port 
    // foreign port=(val)
    // foreign scope_id 
    // foreign scope_id=(val)
    // foreign is_ip6 
    // foreign is_ip6=(val)
}

foreign class MGHttpHeader {
    construct new() {}
    // foreign name 
    // foreign name=(val)
    // foreign value 
    // foreign value=(val)
}

foreign class MGHttpMessage {
    construct new() {}
    // foreign method
    // foreign method=(val)
    // foreign uri 
    // foreign uri=(val)
    // foreign query
    // foreign query=(val)
    // foreign proto 
    // foreign proto=(val)
    // foreign body 
    // foreign body=(val)
    // foreign head 
    // foreign head=(val)
    // foreign message 
    // foreign message=(val)
    // foreign headerAt(inHeader, index) // max header count of MG_MAX_HTTP_HEADERS
}

foreign class MGHttpServeOpts {
    construct new() {}
    foreign root_dir
    foreign root_dir=(val)
    foreign ssi_pattern
    foreign ssi_pattern=(val)
    foreign extra_headers 
    foreign extra_headers=(val)
    foreign mime_types
    foreign mime_types=(val)
}

foreign class MGHtttpPart {
    construct new() {}
    // foreign name 
    // foreign name=(val)
    // foreign filename 
    // foreign fielname=(val)
    // foreign body 
    // foreign body=(val)
}

foreign class MGTlsOpts{
    construct new() {}
    // foreign ca 
    // foreign ca=(val)
    // foreign cert 
    // foreign cert=(val)
    // foreign key
    // foreign key=(val)
    // foreign name 
    // foreign name=(val)
}

class MgMgr {
    // foreign static  init()
    // foreign static  free()
    // foreign static  poll()
    
    foreign static  listen(url, cb)
    foreign static  connect(url, cb)
    foreign static  wrapfd(fd, cb)
    foreign static  send(conn, buff)
    foreign static  closeConn(conn)

    foreign static  httpParse(text, msg)
    foreign static  httpWriteChunk(conn, text)
    foreign static  HttpDeleteChunk(conn, hm)
    foreign static  httpListen(connin, url, msg, cb)
    foreign static  httpConnect(connin, url, cb)
    foreign static  httpServeDir(conn, hm, opts)
    foreign static  httpServeFile(conn, hm, path, opts)
    foreign static  httpReply(conn, code, header, body)
    foreign static  httpMatchUri(hm, glob)
    foreign static  httpUpload(conn, hm, fs, dir, maxSize)
    foreign static  httpBauth(conn, user, pass)
    foreign static  httpStatus(hm)

    foreign static  tlsInit(conn, opts)
    foreign static  tlsFree(conn)
    foreign static  tlsSend(conn, text)
    foreign static  tlsRecv(conn, maxLen)
    foreign static  tlsPending(conn)
    foreign static  tlsHandShake(conn)

    foreign static  tlsCtxInit()
    foreign static  tlsCtxFree()

    foreign static  ioSend(conn, text)
    foreign static  ioRecv(conn, maxLen)

    foreign static tick()

    foreign static  arch 

    foreign static init()
    foreign static quit()

    static onEvent(cb, conn, ev, msg) {
        System.print("================ on Event: %(cb) %(conn) %(msg)")
    }

    static MG_LL_NONE{0}
    static MG_LL_ERROR{1}
    static MG_LL_INFO{2}
    static MG_LL_DEBUG{3}
    static MG_LL_VERBOSE{4}

    static MG_FS_READ{1}
    static MG_FS_WRITE{2}
    static MG_FS_DIR{4}

    static MG_EV_ERROR{0}
    static MG_EV_OPEN{1}
    static MG_EV_POLL{2}
    static MG_EV_RESOLVE{3}
    static MG_EV_CONNECT{4}
    static MG_EV_ACCEPT{5}
    static MG_EV_TLS_HS{6}
    static MG_EV_READ{7}
    static MG_EV_WRITE{8}
    static MG_EV_CLOSE{9}
    static MG_EV_HTTP_MSG{10}
    static MG_EV_WS_OPEN{11}
    static MG_EV_WS_MSG{12}
    static MG_EV_WS_CTL{13}
    static MG_EV_MQTT_CMD{14}
    static MG_EV_MQTT_MSG{15}
    static MG_EV_MQTT_OPEN{16}
    static MG_EV_SNTP_TIME{17}
    static MG_EV_WAKEUP{18}
    static MG_EV_USER{19}

    static MG_IO_ERR{-1}
    static MG_IO_WAIT{-2}
    static MG_IO_RESET{-3}

    static MQTT_PROP_TYPE_BYTE{0}
    static MQTT_PROP_TYPE_STRING{1}
    static MQTT_PROP_TYPE_STRING_PAIR{2}
    static MQTT_PROP_TYPE_BINARY_DATA{3}
    static MQTT_PROP_TYPE_VARIABLE_INT{4}
    static MQTT_PROP_TYPE_INT{5}
    static MQTT_PROP_TYPE_SHORT{6}

    static MQTT_OK{0}
    static MQTT_INCOMPLETE{1}
    static MQTT_MALFORMED{2}

    static MG_JSON_TOO_DEEP{-1}
    static MG_JSON_INVALID{-2}
    static MG_JSON_NOT_FOUND{-3}

    static MG_OTA_UNAVAILABLE{0}
    static MG_OTA_FIRST_BOOT{1}
    static MG_OTA_UNCOMMITTED{2}
    static MG_OTA_COMMITTED{3}

    static MG_FIRMWARE_CURRENT{0}
    static MG_FIRMWARE_PREVIOUS{1}

    static MG_ARCH_CUSTOM{0}
    static MG_ARCH_UNIX{1}
    static MG_ARCH_WIN32{2}
    static MG_ARCH_ESP32{3}
    static MG_ARCH_ESP8266{4}
    static MG_ARCH_FREERTOS{5}
    static MG_ARCH_AZURERTOS{6}
    static MG_ARCH_ZEPHYR{7}
    static MG_ARCH_NEWLIB{8}
    static MG_ARCH_CMSIS_ROTS1{9}
    static MG_ARCH_TIRTOS{10}
    static MG_ARCH_RP2040{11}
    static MG_ARCH_ARMCC{12}
    static MG_ARCH_CMSIS_RTOS2{13}
    static MG_ARCH_RTTHREAD{14}


    // static MAX_HTTP_HEADERS{30}
    // static HTTP_INDEX{"index.html"}
}

// expect: onEvent 1 2 3