foreign class File {
    construct new() {}
    foreign open(path, mode) 
    foreign close()
    foreign size
    foreign position 
    foreign atend
    foreign seek(pos)
    foreign read(len)
    foreign readline()
    foreign write(buff)
    foreign flush()
}