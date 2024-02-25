cmake_minimum_required(VERSION 3.16)
project(cico_engine_app)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(${WIN32})
    add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
    add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
endif()

include_directories(../third)
include_directories(../include)

set(cico_app_sources
    main.cpp 
)

add_executable(cico_app)
target_sources(cico_app PRIVATE ${cico_app_sources})
list(APPEND app_libs cico)
if(${CICO_MODULE_RAYLIB} MATCHES ON) 
    list(APPEND app_libs raylib)
endif()
if(${CICO_MODULE_SPINE} MATCHES ON) 
list(APPEND app_libs)
endif()
target_link_libraries(cico_app PRIVATE ${app_libs})