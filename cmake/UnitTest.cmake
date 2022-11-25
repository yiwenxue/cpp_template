find_package (GTest REQUIRED)

set (UNIT_TEST_INVOKER ${CMAKE_SOURCE_DIR}/tests/main.cpp)

if (GTEST_FOUND)
    message(STATUS "GTest found in ${GTEST_INCLUDE_DIRS}")
    include_directories(${GTEST_INCLUDE_DIRS})
else()
    # message(FATAL_ERROR "GTest not found")
    message(STATUS "GTest not found")
endif()

# function to add test to the source list
function (add_test_unit)
    set (options)
    set (oneValueArgs NAME)
    set (multiValueArgs INCLUDES SOURCES LIBS)

    cmake_parse_arguments (ADD_TEST_UNIT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT ADD_TEST_UNIT_NAME)
        message (FATAL_ERROR "add_test_unit() requires NAME")
    endif ()

    if (NOT ADD_TEST_UNIT_SOURCES)
        message (FATAL_ERROR "add_test_unit() requires SOURCES")
    endif ()

    # SOURCES is a list of source files or directories
    foreach (source ${ADD_TEST_UNIT_SOURCES})
        if (IS_DIRECTORY ${source})
            # obtain all files and dirs under this directory
            file (GLOB_RECURSE source_files ${source}/*)
            list (APPEND ADD_TEST_UNIT_SOURCES ${source_files})
            list (REMOVE_ITEM ADD_TEST_UNIT_SOURCES ${source})
        endif ()
    endforeach ()

    # add test invoker 
    list (APPEND ADD_TEST_UNIT_SOURCES ${UNIT_TEST_INVOKER})

    # remove duplicates
    list (REMOVE_DUPLICATES ADD_TEST_UNIT_SOURCES)

    # add test executable
    add_executable(${ADD_TEST_UNIT_NAME} ${ADD_TEST_UNIT_SOURCES})

    # add include directories
    if (ADD_TEST_UNIT_INCLUDES)
        target_include_directories(${ADD_TEST_UNIT_NAME} PRIVATE ${ADD_TEST_UNIT_INCLUDES})
    endif ()

    # link test executable against gtest & gtest_main
    target_link_libraries(${ADD_TEST_UNIT_NAME} ${GTEST_BOTH_LIBRARIES} ${ADD_TEST_UNIT_LIBS})

    # add test to ctest
    add_test(NAME ${ADD_TEST_UNIT_NAME} COMMAND ${ADD_TEST_UNIT_NAME})
endfunction()