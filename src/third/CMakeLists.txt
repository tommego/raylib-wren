cmake_minimum_required(VERSION 3.16)
project(wren)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(${WIN32})
    add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
    add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
endif()

include_directories(wren/src)
include_directories(wren/src/include)
include_directories(wren/src/optional)
include_directories(wren/src/vm)

add_definitions(-DWREN_OPT_RANDOM=1)
add_definitions(-DWREN_OPT_META=1)

set(wren_sources
    wren/src/optional/wren_opt_meta.c 
    wren/src/optional/wren_opt_random.c
    wren/src/vm/wren_compiler.c
    wren/src/vm/wren_core.c
    wren/src/vm/wren_debug.c
    wren/src/vm/wren_primitive.c
    wren/src/vm/wren_utils.c
    wren/src/vm/wren_value.c
    wren/src/vm/wren_vm.c
)
# wren libs
add_library(wren STATIC)
target_sources( wren PRIVATE ${wren_sources} )

if(${CICO_MODULE_RAYLIB} MATCHES ON)

    if(CMAKE_HOST_UNIX)
        message("[CICO] building drm graphic for rockchip platform")
        set(PLATFORM DRM)
        include_directories(${CMAKE_SYSROOT}/usr/include/libdrm)
    endif()
    message("[CICO] building raylib")
    add_subdirectory(raylib)
endif()

if(${CICO_MODULE_SPINE} MATCHES ON) 
endif()

add_subdirectory(mongoose)
add_subdirectory(serial)
add_subdirectory(dynalo)
add_subdirectory(sqlite3)
# build examples
# add_executable(example_embedding)
# target_sources(example_embedding PRIVATE wren/example/embedding/main.c)
# target_link_libraries(example_embedding PRIVATE wren)
