cmake_minimum_required(VERSION 3.1)
project(sketchbook CXX)

include(GNUInstallDirs)
set(CMAKE_VERBOSE_MAKEFILE TRUE)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_EXTENSIONS FALSE)

if(CMAKE_BUILD_TYPE MATCHES Debug)
  add_compile_options(-g)
else()
  add_definitions(-DNDEBUG)
endif()
add_compile_options(-O3 -march=native -Wall -Wextra -Wpedantic)

set(CMAKE_PREFIX_PATH ${HOME}/local:${HOME}/.linuxbrew)
find_package(wtl REQUIRED)
link_libraries(wtl)
find_package(sfmt REQUIRED)
link_libraries(sfmt)

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  link_libraries(pthread)
endif()

macro(add_executable_named src)
  get_filename_component(name_we ${src} NAME_WE)
  add_executable(${name_we} ${src})
endmacro()

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} source_files)
foreach(src IN LISTS source_files)
  add_executable_named(${src})
endforeach()
