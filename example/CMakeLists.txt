# Copyright (c) 2022 Drahomir Dlabaja

cmake_minimum_required(VERSION 3.25)

project(runtime-requirements-example)

list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_SOURCE_DIR}/..)

find_package(runtime-requirements)

add_subdirectory(base)
add_subdirectory(lib)
add_subdirectory(app)
