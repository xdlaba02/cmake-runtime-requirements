# Copyright (c) 2022 Drahomir Dlabaja

function(target_runtime_requirements TARGET)
  while(ARGN)
    list(POP_FRONT ARGN SRC DST)
    get_filename_component(ABSOLUTE_PATH ${SRC} ABSOLUTE)
    set_property(TARGET ${TARGET} PROPERTY RUNTIME_REQUIREMENTS "${ABSOLUTE_PATH}:${DST}" APPEND)
  endwhile()
endfunction()

function(get_runtime_requirements TARGET OUTPUT)
  if (TARGET ${TARGET})
    get_target_property(RUNTIME_REQUIREMENTS ${TARGET} RUNTIME_REQUIREMENTS)

    if (RUNTIME_REQUIREMENTS)
      list(APPEND TARGET_RUNTIME_REQUIREMENTS ${RUNTIME_REQUIREMENTS})
    endif()

    get_target_property(PRIVATE_LINK_LIBRARIES   ${TARGET} LINK_LIBRARIES)
    get_target_property(INTERFACE_LINK_LIBRARIES ${TARGET} INTERFACE_LINK_LIBRARIES)

    set(LINK_LIBRARIES "")

    if (PRIVATE_LINK_LIBRARIES)
      list(APPEND LINK_LIBRARIES ${PRIVATE_LINK_LIBRARIES})
    endif()

    if (INTERFACE_LINK_LIBRARIES)
      list(APPEND LINK_LIBRARIES ${INTERFACE_LINK_LIBRARIES})
    endif()

    if (LINK_LIBRARIES)
      list(REMOVE_DUPLICATES LINK_LIBRARIES)

      foreach(LINK_LIBRARY ${LINK_LIBRARIES})
        get_runtime_requirements(${LINK_LIBRARY} TARGET_RUNTIME_REQUIREMENTS)
      endforeach()
    endif()

    list(REMOVE_DUPLICATES TARGET_RUNTIME_REQUIREMENTS)
    set(${OUTPUT} ${TARGET_RUNTIME_REQUIREMENTS} PARENT_SCOPE)
  endif()
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
