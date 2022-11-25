find_program(GLSLANGVALIDATOR_EXE "glslangValidator")
mark_as_advanced(FORCE GLSLANGVALIDATOR_EXE)
if(GLSLANGVALIDATOR_EXE)
  message(STATUS "glslangValidator found: ${GLSLANGVALIDATOR_EXE}")
else()
  message(STATUS "glslangValidator not found!")
endif()

function(target_glsl_shaders TARGET_NAME)
  if(NOT GLSLANGVALIDATOR_EXE)
    message(
      FATAL_ERROR "Cannot compile GLSL to SPIR-V is glslangValidator not found!"
    )
  endif()

  set(OPTIONS)
  set(SINGLE_VALUE_KEYWORDS)
  set(MULTI_VALUE_KEYWORDS INTERFACE PUBLIC PRIVATE COMPILE_OPTIONS)
  cmake_parse_arguments(
    target_glsl_shaders "${OPTIONS}" "${SINGLE_VALUE_KEYWORDS}"
    "${MULTI_VALUE_KEYWORDS}" ${ARGN})

  foreach(GLSL_FILE IN LISTS target_glsl_shaders_INTERFACE)
    add_custom_command(
      OUTPUT ${GLSL_FILE}.spv
      COMMAND ${GLSLANGVALIDATOR_EXE} ${target_glsl_shaders_COMPILE_OPTIONS} -V
              "${GLSL_FILE}" -o "${GLSL_FILE}.spv"
      MAIN_DEPENDENCY ${GLSL_FILE})

    target_sources(${TARGET_NAME} INTERFACE ${GLSL_FILE}.spv)
  endforeach()

  foreach(GLSL_FILE IN LISTS target_glsl_shaders_PUBLIC)
    add_custom_command(
      OUTPUT ${GLSL_FILE}.spv
      COMMAND ${GLSLANGVALIDATOR_EXE} ${target_glsl_shaders_COMPILE_OPTIONS} -V
              "${GLSL_FILE}" -o "${GLSL_FILE}.spv"
      MAIN_DEPENDENCY ${GLSL_FILE})

    target_sources(${TARGET_NAME} PUBLIC ${GLSL_FILE}.spv)
  endforeach()

  foreach(GLSL_FILE IN LISTS target_glsl_shaders_PRIVATE)
    add_custom_command(
      OUTPUT ${GLSL_FILE}.spv
      COMMAND ${GLSLANGVALIDATOR_EXE} ${target_glsl_shaders_COMPILE_OPTIONS} -V
              "${GLSL_FILE}" -o "${GLSL_FILE}.spv"
      MAIN_DEPENDENCY ${GLSL_FILE})

    target_sources(${TARGET_NAME} PRIVATE ${GLSL_FILE}.spv)
  endforeach()
endfunction()
