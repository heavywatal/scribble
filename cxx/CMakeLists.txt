cmake_minimum_required(VERSION 3.15)
project(scribble CXX)

include(CMakePrintHelpers)
include(GNUInstallDirs)
set(CMAKE_VERBOSE_MAKEFILE ON)

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
cmake_print_variables(CMAKE_BUILD_TYPE)
set(CMAKE_CXX_FLAGS_DEV "-O2 -g")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
add_compile_options(-march=native -Wall -Wextra -pedantic)

set(CMAKE_MODULE_PATH "$ENV{HOME}/.cmake/packages")
include(WarningFlagsCXX OPTIONAL)

set(Boost_NO_BOOST_CMAKE ON)
find_package(Boost COMPONENTS context)
cmake_print_variables(Boost_INCLUDE_DIRS)

find_package(Threads)
find_package(wtl)
find_package(sfmt)
find_package(igraph 0.10.2)
find_package(toml11)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} source_files)
if(NOT toml11_FOUND)
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
target_link_libraries(igraph PRIVATE igraph::igraph)
if(toml11_FOUND)
  target_link_libraries(toml PRIVATE toml11::toml11)
endif()

cmake_print_variables(CMAKE_CXX_FLAGS)
cmake_print_variables(CMAKE_CXX_FLAGS_DEBUG)
cmake_print_variables(CMAKE_CXX_FLAGS_RELWITHDEBINFO)
cmake_print_variables(CMAKE_CXX_FLAGS_MINSIZEREL)
cmake_print_variables(CMAKE_CXX_FLAGS_RELEASE)
cmake_print_variables(CMAKE_CXX_FLAGS_DEV)

install(TARGETS sizeof
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
