import "cico.raylib" for Vector2,Vector3,Vector4,Color,Matrix,Quaternion,float3,float16,Rectangle
import "cico.json" for Json 

class Serializer {
    static Map2JsonString(map) {
        var ret = ""
        ret = ret + "{"
        var i = 0
        for(key in map.keys) {
            ret = ret + "\"%(key)\": "
            if(map[key] is Map) {
                ret = ret + Serializer.Map2JsonString(map[key])
            } else if(map[key] is String) {
                    ret = ret + "\"%(map[key])\""
            } else if(map[key] is Sequence) {
                ret = ret + Serializer.List2JsonString(map[key])
            }  else {
                ret = ret + "%(map[key])"
            }

            if(i < map.keys.count - 1) {
                ret = ret + ","
            }
            i = i + 1
        }

        ret = ret + "}"

        return ret
    }

    static List2JsonString(list) {
        var ret = ""
        ret = ret + "["
        var i = 0
        for(item in list) {
            if(item is Map) {
                ret = ret + Serializer.Map2JsonString(item)
            } else if(item is Sequence) {
                if(item is String) {
                    ret = ret + "\"%(item)\""
                } else {
                    ret = ret + Serializer.List2JsonString(item)
                }
            } else {
                ret = ret + "%(item)"
            }
            if(i < list.count - 1) {
                ret = ret + ","
            }
            i = i + 1
        }
        ret = ret + "]"
        return ret
    }

    static Stringify(val) {
        var ret = ""
        if(val is Map) {
            ret = Serializer.Map2JsonString(val)
        } else if(val is String) {
            ret = val 
        } else if(val is Sequence) {
            ret = Serializer.List2JsonString(val)
        }
        return ret 
    }

    static Json2Value(json) {
        var ret = null 
        if(json.isArray || json.isObject) {
            if(json.isObject) {
                ret = Serializer.wrapJsonObj_(json)
            } else if(json.isArray) {
                ret = Serializer.wrapJsonArr_(json)
            }
        } else {
            ret = json.value
        }
        return ret 
    }
    static wrapJsonObj_(json) {
        var ret = {}
        for(key in json.keys) {
            var v = json[key]
            if(v.isObject) {
                ret[key] = Serializer.wrapJsonObj_(v)
            } else if(v.isArray) {
                ret[key] = Serializer.wrapJsonArr_(v)
            } else {
                ret[key] = v.value
            }
        }
        return ret 
    }

    static wrapJsonArr_(json) {
        var ret = []
        for(i in 0..json.size - 1) {
            var v = json.at(i)
            if(v.isObject) {
                ret.add(Serializer.wrapJsonObj_(v))
            } else if(v.isArray) {
                ret = ret + Serializer.wrapJsonArr_(v)
            } else {
                ret.add(v.value)
            }
        }
        return ret 
    }

    static Value2Json(value) {
        var s = Serializer.Stringify(value)
        return Json.parse(s)
    }
}