class Platform {
    foreign static argv
    foreign static platform
    foreign static separator
    // foreign pwd 
    // foreign cwd 
    // foreign version 
    // foreign ls(path)
    // foreign mkdir(path)
    // foreign exists(path)
    // foreign rmfile(path)
    // foreign rmdir(path)
    // foreign isfile(path)
    // foreign isdir(path)
    // foreign copy(from, to)
    // foreign mv(from, to)
    // foreign link(dst, src)
    // foreign unlink(dst)
    // foreign touch(file)
    // foreign getenv(key)
    // foreign putenv(key)
    // foreign system(cmd)

    static ICON_INFO{0}
    static ICON_WARNING{1}
    static ICON_ERROR{2}
    static ICON_QUESTION{3}
    static CHOICE_OK{0}
    static CHOICE_OK_CANCEL{1}
    static CHOICE_YES_NO{2}
    static CHOICE_YES_NO_CANCEL{3}
    static CHOICE_RETRY_CANCEL{4}
    static CHOICE_ABORT_RETRY_IGNORE{5}
    foreign static selectFolder()
    foreign static openFile(title, filters, isMultipleFiles)
    foreign static openSaveFile(title, filters)
    foreign static notify(title, msg, iconType)
    static notify(title, msg) { Platform. notify(title, msg, Platform.ICON_INFO) }
    foreign static message(title, msg, choice, iconType)
}   