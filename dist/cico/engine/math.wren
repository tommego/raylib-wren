class Math {
    static mod(a, b) { a - (a / b).floor * b }
    static ringIdx(i, size) {
        var d = Math.mod(i.abs, size)
        if(i >= 0) {
            return d 
        } else {
            return size - d
        }
    }
}