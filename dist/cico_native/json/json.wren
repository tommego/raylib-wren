foreign class Json {
    static ValueTypeNum{0}
    static ValueTypeString{1}
    static ValueTypeBool{2}
    static ValueTypeObject{3}
    static ValueTypeArray{4}
    foreign static parse(source)
    foreign static parseFile(filepath)
    foreign static get(json, key)
    foreign static set(json, key, value)
    foreign static at(json, value)
    foreign static newValue(type, value)
    foreign dump()
    foreign size
    foreign isNumber
    foreign isObject
    foreign isArray
    foreign isBoolean 
    foreign value 
    foreign keys 
    at(index){ Json.at(this, index) }
    [key] {Json.get(this, key)}
    [key] = (val) {
        if(val is Num) {
            Json.set(this, key, Json.newValue(Json.ValueTypeNum, val))
        } else if(val is Bool) {
            Json.set(this, key, Json.newValue(Json.ValueTypeBool, val))
        } else if(val is String) {
            Json.set(this, key, Json.newValue(Json.ValueTypeString, val))
        } else if(val is Json) {
            Json.set(this, key, val)
        } else {
            System.print("cannot set key %(key) to value %(val)")
        }
    }
}