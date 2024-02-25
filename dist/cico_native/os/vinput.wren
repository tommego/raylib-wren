class VInputMode {
    static Legacy{0}
    static Atom{1}
}

foreign class VKeyboard {
    construct new() { }
    foreign init(mode)
    foreign triggerKey(key)
    foreign triggerKeyEx(keyStr)

    static KEY_ESC{1}

    static KEY_1{2}
    static KEY_2{3}
    static KEY_3{4}
    static KEY_4{5}
    static KEY_5{6}
    static KEY_6{7}
    static KEY_7{8}
    static KEY_8{9}
    static KEY_9{10}
    static KEY_0{11}

    static KEY_MINUS{12}
    static KEY_EQUAL{13}
    static KEY_BACKSPACE{14}
    static KEY_TAP{15}

    static KEY_Q{16}
    static KEY_W{17}
    static KEY_E{18}
    static KEY_R{19}
    static KEY_T{20}
    static KEY_Y{21}
    static KEY_U{22}
    static KEY_I{23}
    static KEY_O{24}
    static KEY_P{25}

    static KEY_LEFTBRACE{26}
    static KEY_RIGHTBRACE{27}
    static KEY_ENTER{28}
    static KEY_LEFTCTRL{29}

    static KEY_A{30}
    static KEY_S{31}
    static KEY_D{32}
    static KEY_F{33}
    static KEY_G{34}
    static KEY_H{35}
    static KEY_J{36}
    static KEY_K{37}
    static KEY_L{38}

    static KEY_SEMICOLON{39}
    static KEY_APOSTROPHE{40}
    static KEY_GRAVE{41}
    static KEY_LEFTSHIFT{42}
    static KEY_BACKSLASH{43}

    static KEY_Z{44}
    static KEY_X{45}
    static KEY_C{46}
    static KEY_V{47}
    static KEY_B{48}
    static KEY_N{49}
    static KEY_M{50}
    
    static KEY_COMMA{51}
    static KEY_DOT{52}
    static KEY_SLASH{53}
    static KEY_RIGHTSHIFT{54}
    static KEY_KPASTERISK{55}
    static KEY_LEFTALT{56}
    static KEY_SPACE{57}
    static KEY_CAPSLOCK{58}

    static KEY_UP{103}
    static KEY_LEFT{105}
    static KEY_RIGHT{106}
    static KEY_DOWN{108}
}

foreign class VMouse {
    construct new() { }
}