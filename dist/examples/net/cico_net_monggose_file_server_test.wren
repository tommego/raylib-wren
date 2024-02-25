import "cico.net.mongoose" for MgMgr,MGHttpMessage,MGConnection,MGHttpServeOpts

class cico {
    static init() {
        MgMgr.init()
        var conn = MGConnection.new() 
        var connMsg = MGHttpMessage.new()
        MgMgr.httpListen(conn, "http://0.0.0.0:8000", connMsg, Fn.new{|cnn, ev, msg|
            System.print("================ onNetworkEvent: %(cnn) %(ev) %(msg)")
            var opt = MGHttpServeOpts.new()
            opt.root_dir = "."
            opt.ssi_pattern = "#.html"
            MgMgr.httpServeDir(cnn, msg, opt)
        })
    }

    static eventLoop() {
        var result = MgMgr.tick()
        if(result) { result[0].call(result[1], result[2], result[3]) }
        return 0
    }

    static exit() {
        MgMgr.quit()
    }
}