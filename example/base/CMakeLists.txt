cmake_minimum_required(VERSION 3.25)

add_library(base base.cc base.h)
target_include_directories(base PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_runtime_requirements(base ${CMAKE_CURRENT_SOURCE_DIR}/base-data.txt base-data)
