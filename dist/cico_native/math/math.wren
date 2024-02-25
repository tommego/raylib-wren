class Easing {
    static Linear(val) {
        return easing_(val, 0) 
    }

    static InQuad(val) { 
        return easing_(val, 2) 
    }

    static OutQuad(val) { 
        return easing_(val, 3) 
    }

    static InOutQuad(val) { 
        return easing_(val, 4) 
    }
    static InCubic(val) { 
        return easing_(val, 5) 
    }

    static OutCubic(val) { 
        return easing_(val, 6) 
    }

    static InOutCubic(val) { 
        return easing_(val, 7) 
    }

    static InQuart(val) { 
        return easing_(val, 8) 
    }

    static OutQuart(val) { 
        return easing_(val, 9) 
    }

    static InOutQuart(val) { 
        return easing_(val, 10) 
    }
    
    static InQuint(val) { 
        return easing_(val, 11) 
    }

    static OutQuint(val) { 
        return easing_(val, 12) 
    }

    static InOutQuint(val) { 
        return easing_(val, 13) 
    }

    static InSine(val) { 
        return easing_(val, 14) 
    }

    static OutSine(val) { 
        return easing_(val, 15) 
    }

    static InOutSine(val) { 
        return easing_(val, 16) 
    }

    static InExpo(val) { 
        return easing_(val, 17) 
    }

    static OutExpo(val) { 
        return easing_(val, 18) 
    }

    static InOutExpo(val) { 
        return easing_(val, 19) 
    }

    static InCirc(val) { 
        return easing_(val, 20) 
    }

    static OutCirc(val) { 
        return easing_(val, 21) 
    }

    static InOutCirc(val) { 
        return easing_(val, 22) 
    }

    static InBack(val) { 
        return easing_(val, 23) 
    }

    static OutBack(val) { 
        return easing_(val, 24) 
    }

    static InOutBack(val) { 
        return easing_(val, 25) 
    }

    static InElastic(val) { 
        return easing_(val, 26)
    }

    static OutElastic(val) { 
        return easing_(val, 27) 
    }

    static InOutElastic(val) { 
        return easing_(val, 28) 
    }

    static InBounce(val) { 
        return easing_(val, 29) 
    }

    static OutBounce(val) { 
        return easing_(val, 30) 
    }
    
    static InOutBounce(val) { 
        return easing_(val, 31) 
    }

    foreign static easing_(val, type)
}