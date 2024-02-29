import "cico.net.mongoose" for MgMgr,MGHttpMessage,MGConnection,MGHttpServeOpts
import "cico/engine/signalslot" for Signal 

class HttpClient {
    construct new() {
        _conn = null 
        _msg = MGHttpMessage.new()
        _dataToPost = ""
        _replied = Signal.new(this)
        _method = "GET"
        _url = ""
        _onHttpEvent = Fn.new{|c, ev, msg| 
            if(ev == MgMgr.MG_EV_CONNECT) {
                var uri = MgMgr.UrlToUri(_url)
                var t = ""
                if(_method.contains("GET")) {
                    t = "%(_method) %(uri.uri) HTTP/1.0\r\nHost: %(uri.host)\r\nContent-Type: octet-stream\r\nContent-Length: 0\r\n\r\n"
                } else if(_method.contains("POST")) {
                    t = "%(_method) %(uri.uri) HTTP/1.0\r\nHost: %(uri.host)\r\nContent-Type: octet-stream\r\nContent-Length: %(_dataToPost.count)\r\n\r\n%(_dataToPost)"
                }
                MgMgr.send(c, t)
            } else if(ev == MgMgr.MG_EV_HTTP_MSG) { 
                this.onReplied(msg) 
            }
        }
    }

    replied{_replied}
    get(url) {
        _method = "GET"
        _url = url
        _conn = MGConnection.new()
        MgMgr.httpConnect(_conn, url, _msg, _onHttpEvent)
    }
    post(url, data) {
        _method = "POST"
        _url = url
        _dataToPost = data 
        _conn = MGConnection.new()
        MgMgr.httpConnect(_conn, url, _msg, _onHttpEvent)
    }

    onReplied(msg) {  
        _replied.emit(msg) 
    }
}

class HttpServer {
    construct new() {

    }
}