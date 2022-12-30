cmake_minimum_required(VERSION 3.25)

add_library(lib lib.cc lib.h)
target_include_directories(lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(lib INTERFACE base)

target_runtime_requirements(lib
  subdirectory/lib-additional-data.txt .
  lib-data.txt lib-data
)
