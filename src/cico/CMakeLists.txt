cmake_minimum_required(VERSION 3.16)
project(cico_engine)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(${WIN32})
    add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
    add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
endif()

include_directories(../third)
include_directories(../third/eigen3)
include_directories(../third/SINS/Core)
include_directories(../third/wren/src/include)
include_directories(../third/serial/include)
include_directories(../third/raylib/src)
include_directories(../include)
include_directories(./internal_modules)
include_directories(./)

set(cico_sources
    cico_core.cpp 
    cico_math.cpp
    cico_module.cpp
    cico_file_module.cpp
    internal_modules/math/cm_math.cpp 
    internal_modules/os/cm_file.cpp 
    internal_modules/os/cm_sys.cpp 
    internal_modules/os/cm_serial.cpp
    internal_modules/net/cm_mongoose.cpp 
)

if(${CICO_MODULE_VINPUT} MATCHES ON)
    message("[CICO] build cico vinput module")
    add_definitions(-DCICO_MODULE_VINPUT)
    list(APPEND cico_sources internal_modules/os/cm_vinput.cpp)
endif()

if(${CICO_MODULE_JSON} MATCHES ON) 
    message("[CICO] building cico json module")
    add_definitions(-DCICO_MODULE_JSON)
    list(APPEND cico_sources internal_modules/json/cm_json.cpp)
endif()

if(${CICO_MODULE_RAYLIB} MATCHES ON)
    message("[CICO] building cico raylib module")
    add_definitions(-DCICO_MODULE_RAYLIB)
    list( APPEND cico_sources 
        internal_modules/raylib/cm_raylib.cpp 
        internal_modules/raylib/cm_raygui.cpp 
    )
endif()

list(APPEND CICO_LIBS wren mongoose serial)

add_library(cico STATIC)
target_sources(cico PRIVATE ${cico_sources})
target_link_libraries(cico PRIVATE ${CICO_LIBS})