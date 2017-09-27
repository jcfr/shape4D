cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
message(" — - — — in shape4d.cmake ")

#-----------------------------------------------------------------------------
# Slicer extension
#-----------------------------------------------------------------------------
if(EXTENSION_SUPERBUILD_BINARY_DIR)
  find_package(Slicer REQUIRED)
  include(${Slicer_USE_FILE})
endif()

#-----------------------------------------------------------------------------
# External dependencies
#-----------------------------------------------------------------------------
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake" ${CMAKE_MODULE_PATH} )



# If we build a Slicer CLI module
# This needs to be before `find_package(VTK REQUIRED)`
if(USE_SEM)
  add_definitions("-DUSE_SEM")
  find_package(SlicerExecutionModel REQUIRED)
  include(${SlicerExecutionModel_USE_FILE})
endif()

# If we use VTK file reader instead of custom file reader
# This needs to be before `SEMMacroBuildCLI(...)` to include
# ${VTK_LIBRARIES}
if(USE_VTK)
    add_definitions("-DUSE_VTK")
    find_package(VTK REQUIRED)
    include(${VTK_USE_FILE})
endif()


#-----------------------------------------------------------------------------
# Tests
#-----------------------------------------------------------------------------
if(BUILD_TESTING)
  include(CTest)
  add_subdirectory(testing)
endif()



