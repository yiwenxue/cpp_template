# desc:
# This cmake module exports a simple function to perform clang-formt on the
# source code of a target.
# 
# udage
# 1. include this file in your project
# 2. call format_cpp(<target>)

option (ENABLE_CODE_FORMAT "Enable code format autorun" OFF)

# formater for cpp
find_program(CLANG_FORMAT_EXE "clang-format")
mark_as_advanced(FORCE CLANG_FORMAT_EXE)
if(CLANG_FORMAT_EXE)
    message(STATUS "clang-format found: ${CLANG_FORMAT_EXE}")
else()
    message(STATUS "clang-format not found!")
endif()

# global clang-format options
set(CLANG_FORMAT_OPTIONS
    -style=file
    -i
    -fallback-style=llvm
)

# command format diff
function (format_cpp FORMAT_CPP_TARGET)
    if(NOT CLANG_FORMAT_EXE)
        message (FATAL_ERROR "clang-format not found!")
    endif()

    if (NOT FORMAT_CPP_TARGET)
        message (FATAL_ERROR "No target specified for format-cpp")
    endif ()

    # get all source files
    get_target_property (SOURCES ${FORMAT_CPP_TARGET} SOURCES)

    # filter out all cpp files
    foreach (SOURCE ${SOURCES})
        get_filename_component (EXT ${SOURCE} EXT)
        if (EXT MATCHES "([hH][pP][pP]?)|([cC][cC]?)|([hH][hH]?)|([cC])")
            list (APPEND CPP_SOURCES ${SOURCE})
        endif ()
    endforeach ()

    # add format target, only if the file changed
    add_custom_target (${FORMAT_CPP_TARGET}_format
        COMMAND ${CLANG_FORMAT_EXE} ${CLANG_FORMAT_OPTIONS} ${CPP_SOURCES}
        COMMENT "Formatting ${FORMAT_CPP_TARGET}..."
        DEPENDS ${CPP_SOURCES}
        VERBATIM
    )

    if (NOT TARGET FormatCode)
        add_custom_target (FormatCode)
    endif ()

    add_dependencies(FormatCode ${FORMAT_CPP_TARGET}_format)

    if (ENABLE_CODE_FORMAT)        
        # add dependency to format command, build depend on format
        add_dependencies (${FORMAT_CPP_TARGET} ${FORMAT_CPP_TARGET}_format)
    endif ()
endfunction()