cmake_minimum_required(VERSION 3.30)
project(scribble
  VERSION 0.1.0
  LANGUAGES CXX)

include(CMakePrintHelpers)
include(GNUInstallDirs)
set(CMAKE_VERBOSE_MAKEFILE ON)

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
cmake_print_variables(CMAKE_BUILD_TYPE)
set(CMAKE_CXX_FLAGS_DEV "-O2 -g")
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(common INTERFACE)
target_compile_features(common INTERFACE cxx_std_17)
target_compile_options(common INTERFACE
  -Wall -Wextra -pedantic -Werror -march=native
)
target_link_libraries(common INTERFACE wtl::wtl)

set(CMAKE_MODULE_PATH "$ENV{HOME}/.cmake/packages")
include(WarningFlagsCXX OPTIONAL)

find_package(Boost COMPONENTS context)
cmake_print_variables(Boost_FOUND Boost_INCLUDE_DIRS)

include(FetchContent)
FetchContent_Declare(
  tomlplusplus
  GIT_REPOSITORY https://github.com/marzer/tomlplusplus.git
  GIT_TAG        v3.4.0
)

FetchContent_MakeAvailable(tomlplusplus)
find_package(Threads)
find_package(wtl 0.10.0)
find_package(sfmt)
find_package(igraph 0.10.16)
find_package(pcg)
find_package(pcglite 0.2.1)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} source_files)
if(Boost_FOUND)
  aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/boost boost_src)
  list(APPEND source_files ${boost_src})
endif()

foreach(src IN LISTS source_files)
  cmake_path(GET src STEM name_we)
  add_executable(${name_we} ${src})
  target_link_libraries(${name_we} PRIVATE common)
endforeach()

target_link_libraries(benchmark PRIVATE wtl::sfmt pcg::pcg pcglite::pcglite)
target_link_libraries(concurrent PRIVATE Threads::Threads)
target_link_libraries(igraph PRIVATE igraph::igraph)
target_link_libraries(toml PRIVATE tomlplusplus::tomlplusplus)
if(Boost_FOUND)
  target_link_libraries(boost_coroutine2 PRIVATE Boost::context)
  target_link_libraries(boost_graph PRIVATE Boost::boost)
  target_link_libraries(boost_math PRIVATE Boost::boost)
endif()

cmake_print_variables(CMAKE_CXX_FLAGS_DEBUG)
cmake_print_variables(CMAKE_CXX_FLAGS_RELWITHDEBINFO)
cmake_print_variables(CMAKE_CXX_FLAGS_MINSIZEREL)
cmake_print_variables(CMAKE_CXX_FLAGS_RELEASE)
cmake_print_variables(CMAKE_CXX_FLAGS_DEV)

install(TARGETS sizeof)
