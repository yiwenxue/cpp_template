# sub project for unit test

set (UNIT_TEST_PROJECT_NAME ${PROJECT_NAME}_test)

project (${UNIT_TEST_PROJECT_NAME})

include (${CMAKE_SOURCE_DIR}/cmake/UnitTest.cmake)
include (${CMAKE_SOURCE_DIR}/cmake/CodeFormat.cmake)
include (${CMAKE_SOURCE_DIR}/cmake/Linter.cmake)
include (${CMAKE_SOURCE_DIR}/cmake/CodeCoverage.cmake)

enable_testing()

add_test_unit(
    NAME UnitTest
    SOURCES ${CMAKE_SOURCE_DIR}/tests
)

# ENABLE LINT AND FIX
format_cpp(UnitTest)
lint_cpp(UnitTest)
target_code_coverage(UnitTest)