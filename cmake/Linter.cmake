# Code linter for cpp using clang-tidy
# 
# usage: 
# 1. include this module in your CMakeLists.txt
# 2. call add_linter(<target>)

find_program (CPPLINT "clang-tidy")
mark_as_advanced(CPPLINT)
if (CPPLINT)
    message (STATUS "Found clang-tidy: ${CPPLINT}")
else ()
    message (STATUS "clang-tidy not found")
endif ()

option (ENABLE_CPPLINT "Enable clang-tidy autorun" OFF)
option (ENABLE_CPPLINT_FIX "Enable clang-tidy fix" OFF)

# global lint settings
set (CPPLINT_OPTIONS
# no lint google test headers 
-header-filter=.*gtest*
-checks=clan*,cert*,misc*,perf*,cppc*,read*,mode*,-cert-err58-cpp,-misc-noexcept-move-constructor
)

if (ENABLE_CPPLINT_FIX)
    set (CPPLINT_OPTIONS ${CPPLINT_OPTIONS} -fix-errors)
endif ()

function (lint_cpp LINT_TARGET)
    if (NOT CPPLINT)
        message (FATAL_ERROR "clang-tidy not found, skipping linting")
    endif ()

    if (NOT LINT_TARGET)
        message (FATAL_ERROR "lint_cpp() requires TARGET")
    endif ()

    if (NOT TARGET LintCode)
        add_custom_target (LintCode)
    endif ()
    
    add_custom_target (Lint_${LINT_TARGET}
        COMMENT "Linting ${LINT_TARGET}"
    )

    add_dependencies (LintCode Lint_${LINT_TARGET})

    get_target_property(SOURCES ${LINT_TARGET} SOURCES)

    foreach (SOURCE ${SOURCES})
        get_filename_component (EXT ${SOURCE} EXT)
    
        if (EXT MATCHES "([cC][cC]?)|([cC])")
            add_custom_command(
                TARGET Lint_${LINT_TARGET}
                POST_BUILD
                COMMAND ${CPPLINT} ${CPPLINT_OPTIONS} ${SOURCE}
                COMMENT "Linting ${SOURCE}"
            )
        endif ()
    endforeach ()

    if (ENABLE_CPPLINT)
        add_dependencies(${LINT_TARGET} Lint_${LINT_TARGET})
    endif ()
endfunction ()