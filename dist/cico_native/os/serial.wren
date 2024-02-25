foreign class PortInfo {
    construct new() {}
    foreign port
    foreign port=(val)
    foreign description
    foreign description=(val)
    foreign hardware_id
    foreign hardware_id=(val)
    foreign static list_ports
}

foreign class Timeout {
    construct new() { 
        this.inter_byte_timeout = 0
        this.read_timeout_constant = 0
        this.read_timeout_multiplier = 0
        this.write_timeout_constant = 0
        this.write_timeout_multiplier = 0
    }
    construct new(a, b, c, d, e) {
        this.inter_byte_timeout = a 
        this.read_timeout_constant = b
        this.read_timeout_multiplier = c 
        this.write_timeout_constant = d 
        this.write_timeout_multiplier = e
    }
    foreign static max 
    // foreign static simpleTimeout(timeout) 
    foreign inter_byte_timeout
    foreign inter_byte_timeout=(val)
    foreign read_timeout_constant
    foreign read_timeout_constant=(val)
    foreign read_timeout_multiplier
    foreign read_timeout_multiplier=(val)
    foreign write_timeout_constant
    foreign write_timeout_constant=(val)
    foreign write_timeout_multiplier
    foreign write_timeout_multiplier=(val)
    static simpleTimeout(timeout) { Timeout.new(Timeout.max, timeout, 0, timeout, 0) }
}

foreign class Serial {
    construct new() {
        this.baudRate = 9600
        this.timeout = Timeout.simpleTimeout(1000)
        this.byteSize = Serial.eightbits
        this.stopBits = Serial.stopbits_one
        this.flowControl = Serial.flowcontrol_none
        this.port = ""
    }
    construct new(port, baud) {
        this.baudRate = baud
        this.timeout = Timeout.new() 
        this.byteSize = Serial.eightbits
        this.stopBits = Serial.stopbits_one
        this.flowControl = Serial.flowcontrol_none
        this.port = port
    }
    foreign open()
    foreign isOpen
    foreign close()
    foreign available 
    foreign waitReadable()
    foreign waitByteTimes(count)
    foreign read(size)
    foreign readline()
    // foreign readlines() 
    foreign write(data)
    foreign port 
    foreign port=(val)
    foreign timeout=(val)
    // foreign timeout=(inter_byte_timeout, read_timeout_constant, read_timeout_multiplier, write_timeout_constant, write_timeout_multiplier)
    // foreign getTimeout(inTimeout)
    foreign baudRate
    foreign baudRate=(val)
    foreign byteSize
    foreign byteSize=(val)
    foreign parity
    foreign parity=(val)
    foreign stopBits
    foreign stopBits=(val)
    foreign flowControl
    foreign flowControl=(val)
    foreign flush()
    foreign flushInput()
    foreign flushOutput()
    foreign sendBreak(val)
    foreign breakLevel=(val)
    foreign rtsLevel=(val)
    foreign dtrLevel=(val)
    foreign waitForChange()
    foreign cts                         /*! Returns the current status of the CTS line. */
    foreign dsr                         /*! Returns the current status of the DSR line. */
    foreign ri                          /*! Returns the current status of the RI line. */
    foreign cd                          /*! Returns the current status of the CD line. */

    // stop bits
    static stopbits_one{1}
    static stopbits_two{2}
    static stopbits_one_point_five{3}

    // flow control
    static flowcontrol_none{1}
    static flowcontrol_software{2}
    static flowcontrol_hardware{3}

    // byte size
    static fivebits{5}
    static sixbits{6}
    static sevenbits{7}
    static eightbits{8}
}