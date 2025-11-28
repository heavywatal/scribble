cmake_minimum_required(VERSION 3.30)
project(scribble
  VERSION 0.1.0
  LANGUAGES CXX)

include(CMakePrintHelpers)
include(GNUInstallDirs)
set(CMAKE_VERBOSE_MAKEFILE ON)

set(CMAKE_CXX_EXTENSIONS OFF)
add_library(common INTERFACE)
target_compile_features(common INTERFACE cxx_std_17)
add_compile_options(
  -Wall -Wextra -Wpedantic
  -Wconversion -Wsign-conversion -Wshadow
  $<IF:$<BOOL:$<CONFIG>>,,-Werror>
  $<IF:$<BOOL:$<CONFIG>>,,-O2>
  $<IF:$<BOOL:$<CONFIG>>,,-g>
  $<$<STREQUAL:${CMAKE_SYSTEM_PROCESSOR},x86_64>:-march=native>
  $<$<STREQUAL:${CMAKE_SYSTEM_PROCESSOR},arm64>:-march=armv8.4-a>
)

set(CMAKE_MODULE_PATH "$ENV{HOME}/.cmake/packages")
include(WarningFlagsCXX OPTIONAL)

find_package(Boost COMPONENTS context)
cmake_print_variables(Boost_FOUND Boost_INCLUDE_DIRS)

include(FetchContent)
FetchContent_Declare(fmt
  GIT_REPOSITORY https://github.com/fmtlib/fmt.git
  GIT_TAG 407c905e45ad75fc29bf0f9bb7c5c2fd3475976f
  EXCLUDE_FROM_ALL
  FIND_PACKAGE_ARGS 12.1.0
)

FetchContent_Declare(
  tomlplusplus
  GIT_REPOSITORY https://github.com/marzer/tomlplusplus.git
  GIT_TAG 30172438cee64926dc41fdd9c11fb3ba5b2ba9de
  EXCLUDE_FROM_ALL
  FIND_PACKAGE_ARGS 3.4.0
)

FetchContent_MakeAvailable(tomlplusplus fmt)
find_package(wtl 0.11.2 COMPONENTS threads)
find_package(sfmt)
find_package(igraph 1.0.0)
find_package(pcg)
find_package(pcglite 0.2.2)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} source_files)
if(Boost_FOUND)
  aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/boost boost_src)
  list(APPEND source_files ${boost_src})
endif()

target_link_libraries(common INTERFACE fmt::fmt wtl::wtl)

foreach(src IN LISTS source_files)
  cmake_path(GET src STEM name_we)
  add_executable(${name_we} ${src})
  target_link_libraries(${name_we} PRIVATE common)
endforeach()

target_link_libraries(benchmark PRIVATE wtl::sfmt pcg::pcg pcglite::pcglite)
target_link_libraries(concurrent PRIVATE wtl::threads)
target_link_libraries(igraph PRIVATE igraph::igraph)
target_link_libraries(toml PRIVATE tomlplusplus::tomlplusplus)
if(Boost_FOUND)
  target_link_libraries(boost_coroutine2 PRIVATE Boost::context)
  target_link_libraries(boost_graph PRIVATE Boost::boost)
  target_link_libraries(boost_math PRIVATE Boost::boost)
  target_compile_options(boost_graph PRIVATE -Wno-sign-conversion)
endif()
target_compile_options(bitwise PRIVATE -Wno-sign-conversion)
target_compile_options(union PRIVATE -Wno-sign-conversion)

cmake_print_variables(CMAKE_CXX_FLAGS_DEBUG)
cmake_print_variables(CMAKE_CXX_FLAGS_RELWITHDEBINFO)
cmake_print_variables(CMAKE_CXX_FLAGS_MINSIZEREL)
cmake_print_variables(CMAKE_CXX_FLAGS_RELEASE)
cmake_print_variables(CMAKE_CXX_FLAGS_DEV)

install(TARGETS sizeof)
