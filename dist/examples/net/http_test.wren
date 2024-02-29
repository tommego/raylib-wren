import "cico.net.mongoose" for MgMgr,MGHttpMessage,MGConnection,MGHttpServeOpts
import "cico/net/http" for HttpClient
import "cico/engine/signalslot" for SignalMgr
class cico {
    static init() {
        MgMgr.init()
        var http = HttpClient.new()
        http.replied.connect{|target, msg|
            System.print("message: %(msg.message)")
        }
        http.post("http://info.cern.ch/", "")
    }

    static eventLoop() {
        var result = MgMgr.tick()
        if(result) { result[0].call(result[1], result[2], result[3]) }
        SignalMgr.trigger()
        return 0
    }

    static exit() {
        MgMgr.quit()
    }
}