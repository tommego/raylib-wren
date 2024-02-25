set(CICO_MODULE_JSON ON)
set(CICO_MODULE_RAYLIB ON)
if(CMAKE_HOST_UNIX) # currently only support for linux system
    set(CICO_MODULE_VINPUT ON)
else()
    set(CICO_MODULE_VINPUT OFF)
endif()

set(CICO_MODULE_SPINE ON)

set(CICO_MODULE_MPV ON)