# Copyright (c) 2022 Drahomir Dlabaja

# TODO consider subdirectories and relative paths while copying dependencies

function(target_runtime_requirements TARGET)
  foreach(RUTNIME_DEPENDENCY ${ARGN})
    get_filename_component(ABSOLUTE_PATH ${RUTNIME_DEPENDENCY} ABSOLUTE)
    set_property(TARGET ${TARGET} PROPERTY RUNTIME_REQUIREMENTS ${ABSOLUTE_PATH} APPEND)
  endforeach()
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
  foreach(TARGET_RUNTIME_REQUIREMENT ${TARGET_RUNTIME_REQUIREMENTS})
    configure_file(${TARGET_RUNTIME_REQUIREMENT} ${DIRECTORY} COPYONLY)
  endforeach()
endfunction()
