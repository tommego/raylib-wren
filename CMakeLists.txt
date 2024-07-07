set(CPACK_GENERATOR NSIS) # ZIP
set(CPACK_NSIS_MUI_ICON ${ROOT_DIR}/etc/Windows/mrv2.ico)

cmake_minimum_required(VERSION 3.16)
project(cico)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)

include(cico_config.cmake)

set(CPACK_GENERATOR NSIS) # ZIP

set(CPACK_NSIS_MUI_ICON ${ROOT_DIR}/etc/Windows/mrv2.ico)

add_subdirectory(src/third)
add_subdirectory(src/cico)
add_subdirectory(src/app)