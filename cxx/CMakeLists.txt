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
add_compile_definitions(
  # FMT_USE_LOCALE=0
  FMT_OPTIMIZE_SIZE=1
)

FetchContent_Declare(
  tomlplusplus
  URL https://github.com/marzer/tomlplusplus/archive/refs/tags/v3.4.0.tar.gz
  URL_HASH SHA256=8517f65938a4faae9ccf8ebb36631a38c1cadfb5efa85d9a72e15b9e97d25155
  DOWNLOAD_NO_PROGRESS TRUE
  EXCLUDE_FROM_ALL
  FIND_PACKAGE_ARGS 3.4.0
)

FetchContent_Declare(
  pcg_cpp
  URL https://github.com/imneme/pcg-cpp/archive/refs/heads/master.tar.gz
  URL_HASH SHA256=88fb53e10566426e66e1b3967746c23e46395d4e6cfd57303ebab1ed2bb15cc9
  DOWNLOAD_NO_PROGRESS TRUE
  EXCLUDE_FROM_ALL
)

FetchContent_MakeAvailable(tomlplusplus fmt pcg_cpp)

add_library(pcg INTERFACE EXCLUDE_FROM_ALL)
add_library(pcg::pcg ALIAS pcg)
target_include_directories(pcg INTERFACE "${pcg_cpp_SOURCE_DIR}/include")

find_package(wtl 0.11.2 COMPONENTS threads)
find_package(sfmt)
find_package(igraph 1.0.0)
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
