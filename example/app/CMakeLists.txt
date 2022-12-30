cmake_minimum_required(VERSION 3.25)

add_executable(app app.cc)
target_link_libraries(app PUBLIC lib)
target_runtime_requirements(app "app-data.txt")

copy_runtime_requirements(app ${CMAKE_CURRENT_BINARY_DIR})
