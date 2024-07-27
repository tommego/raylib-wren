foreign class Stmt {
    construct new() {}
}

foreign class Sqlite3 {
    construct new() {}
    foreign open(filePath)
    foreign prepareV2(query, stmt)
    foreign step(stmt) 
    foreign colValue(stmt, col)
    foreign colName(stmt, col)
    foreign colCount(stmt)
    foreign finalize()
    foreign close()

    // status
    static SQLITE_OK { 0 }
    static SQLITE_ERROR { 1 }
    static SQLITE_INTERNAL { 2 }
    static SQLITE_PERM { 3 }
    static SQLITE_ABORT { 4 }
    static SQLITE_BUSY { 5 }
    static SQLITE_LOCKED { 6 }
    static SQLITE_NOMEM { 7 }
    static SQLITE_READONLY { 8 }
    static SQLITE_INTERRUPT { 9 }
    static SQLITE_IOERR { 10 }
    static SQLITE_CORRUPT { 11 }
    static SQLITE_NOTFOUND { 12 }
    static SQLITE_FULL { 13 }
    static SQLITE_CANTOPEN { 14 }
    static SQLITE_PROTOCOL { 15 }
    static SQLITE_EMPTY { 16 }
    static SQLITE_SCHEMA { 17 }
    static SQLITE_TOOBIG { 18 }
    static SQLITE_CONSTRAINT { 19}
    static SQLITE_MISMATCH { 20 }
    static SQLITE_MISUSE { 21 }
    static SQLITE_NOLFS { 22 }
    static SQLITE_AUTH { 23 }
    static SQLITE_FORMAT { 24 }
    static SQLITE_RANGE { 25 }
    static SQLITE_NOTADB { 26 }
    static SQLITE_NOTICE { 27 }
    static SQLITE_WARNING { 28 }
    static SQLITE_ROW { 100 }
    static SQLITE_DONE { 101 }

    // colume byte
    static SQLITE_INTEGER{1}
    static SQLITE_FLOAT{2}
    static SQLITE_BLOB{4}
    static SQLITE_NULL{5}
    static SQLITE_TEXT{3}
}