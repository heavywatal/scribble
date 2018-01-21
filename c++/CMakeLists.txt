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

find_package(wtl)
find_package(sfmt)
link_libraries(wtl)
link_libraries(sfmt)

set(Boost_NO_BOOST_CMAKE TRUE)
find_package(Boost REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})
link_directories(${Boost_LIBRARY_DIRS})
message("Boost_INCLUDE_DIRS: ${Boost_INCLUDE_DIRS}")
message("Boost_LIBRARY_DIRS: ${Boost_LIBRARY_DIRS}")

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
