cmake_minimum_required(VERSION 3.1)
project(scribble CXX)

include(GNUInstallDirs)
set(CMAKE_VERBOSE_MAKEFILE ON)

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
set(CMAKE_CXX_FLAGS_DEV "-O2 -g")
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
add_compile_options(-march=native -Wall -Wextra -pedantic)

set(CMAKE_MODULE_PATH "$ENV{HOME}/.cmake/packages")
include(WarningFlagsCXX OPTIONAL)

set(Boost_NO_BOOST_CMAKE ON)
find_package(Boost COMPONENTS context)
message("Boost_INCLUDE_DIRS: ${Boost_INCLUDE_DIRS}")

find_package(Threads)
find_package(wtl)
find_package(sfmt)
find_package(cpptoml)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} source_files)
if(NOT cpptoml_FOUND)
  list(REMOVE_ITEM source_files ${CMAKE_CURRENT_SOURCE_DIR}/toml.cpp)
endif()

foreach(src IN LISTS source_files)
  get_filename_component(name_we ${src} NAME_WE)
  add_executable(${name_we} ${src})
endforeach()

target_link_libraries(benchmark PRIVATE wtl::wtl wtl::sfmt)
target_link_libraries(boost_coroutine2 PRIVATE Boost::context)
target_link_libraries(boost_graph PRIVATE Boost::boost)
target_link_libraries(boost_math PRIVATE Boost::boost)
target_link_libraries(concurrent PRIVATE wtl::wtl Threads::Threads)
target_link_libraries(genetic PRIVATE wtl::wtl)
if(cpptoml_FOUND)
  target_link_libraries(toml PRIVATE cpptoml)
endif()

message(STATUS "CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message(STATUS "CMAKE_CXX_FLAGS_DEBUG: ${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "CMAKE_CXX_FLAGS_RELWITHDEBINFO: ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
message(STATUS "CMAKE_CXX_FLAGS_MINSIZEREL: ${CMAKE_CXX_FLAGS_MINSIZEREL}")
message(STATUS "CMAKE_CXX_FLAGS_RELEASE: ${CMAKE_CXX_FLAGS_RELEASE}")
message(STATUS "CMAKE_CXX_FLAGS_DEV: ${CMAKE_CXX_FLAGS_DEV}")

install(TARGETS sizeof
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
