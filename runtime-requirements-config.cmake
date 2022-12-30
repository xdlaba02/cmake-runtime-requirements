# Copyright (c) 2022 Drahomir Dlabaja

function(target_runtime_requirements TARGET)
  while(ARGN)
    list(POP_FRONT ARGN SRC DST)
    get_filename_component(ABSOLUTE_PATH ${SRC} ABSOLUTE)
    set_property(TARGET ${TARGET} PROPERTY RUNTIME_REQUIREMENTS "${ABSOLUTE_PATH}:${DST}" APPEND)
  endwhile()
endfunction()

function(get_runtime_requirements TARGET OUTPUT)
  # quality of life error for bad calls
  if (NOT TARGET ${TARGET})
    message(FATAL_ERROR "${TARGET} is not a CMake target!")
  endif()

  # infinite recursion guard
  get_target_property(RUNTIME_REQUIREMENTS_VISITING ${TARGET} RUNTIME_REQUIREMENTS_VISITING)
  if (RUNTIME_REQUIREMENTS_VISITING)
    return()
  endif()

  # enable infinite recursion guard
  set_target_property(${TARGET} RUNTIME_REQUIREMENTS_VISITING TRUE)

  # handle requrements of a current target
  get_target_property(RUNTIME_REQUIREMENTS ${TARGET} RUNTIME_REQUIREMENTS)

  if (RUNTIME_REQUIREMENTS)
    list(APPEND TARGET_RUNTIME_REQUIREMENTS ${RUNTIME_REQUIREMENTS})
  endif()

  # gather all dependencies of the current target
  get_target_property(LINK_LIBRARIES              ${TARGET} LINK_LIBRARIES)
  get_target_property(INTERFACE_LINK_LIBRARIES    ${TARGET} INTERFACE_LINK_LIBRARIES)
  get_target_property(MANUALLY_ADDED_DEPENDENCIES ${TARGET} MANUALLY_ADDED_DEPENDENCIES)

  set(TARGET_DEPENDENCIES "")

  if (LINK_LIBRARIES)
    list(APPEND TARGET_DEPENDENCIES ${LINK_LIBRARIES})
  endif()

  if (INTERFACE_LINK_LIBRARIES)
    list(APPEND TARGET_DEPENDENCIES ${INTERFACE_LINK_LIBRARIES})
  endif()

  if (MANUALLY_ADDED_DEPENDENCIES)
    list(APPEND TARGET_DEPENDENCIES ${MANUALLY_ADDED_DEPENDENCIES})
  endif()

  # handle recursive call to all dependencies
  if (TARGET_DEPENDENCIES)
    list(REMOVE_DUPLICATES TARGET_DEPENDENCIES)

    foreach(TARGET_DEPENDENCY ${TARGET_DEPENDENCIES})
      if (TARGET ${TARGET_DEPENDENCY})
        get_runtime_requirements(${TARGET_DEPENDENCY} TARGET_RUNTIME_REQUIREMENTS)
      endif()
    endforeach()
  endif()

  # reset infinite recursion guard
  set_target_property(${TARGET} RUNTIME_REQUIREMENTS_VISITING "")

  # set output variable
  list(REMOVE_DUPLICATES TARGET_RUNTIME_REQUIREMENTS)
  set(${OUTPUT} ${TARGET_RUNTIME_REQUIREMENTS} PARENT_SCOPE)
endfunction()

function(copy_runtime_requirements TARGET DIRECTORY)
  get_runtime_requirements(${TARGET} TARGET_RUNTIME_REQUIREMENTS)

  foreach(REQUIREMENT_PAIR ${TARGET_RUNTIME_REQUIREMENTS})
    string(REPLACE ":" ";" REQUIREMENT_PAIR ${REQUIREMENT_PAIR})
    list(GET REQUIREMENT_PAIR 0 SRC)
    list(GET REQUIREMENT_PAIR 1 DST)
    file(MAKE_DIRECTORY ${DIRECTORY}/${DST})
    configure_file("${SRC}" "${DIRECTORY}/${DST}/" COPYONLY)
  endforeach()
endfunction()
