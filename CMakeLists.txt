cmake_minimum_required(VERSION 3.22)

project (
    "MyProject"
    VERSION 1.0.0
    DESCRIPTION "My Project"
    LANGUAGES CXX
)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(
    FATAL_ERROR
      "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
  )
endif()

# add cmake modules path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include (${CMAKE_SOURCE_DIR}/cmake/tools.cmake)

set (CODE_COVERAGE ON)

# add unit test
add_subdirectory(tests)
