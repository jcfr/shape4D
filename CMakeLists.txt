cmake_minimum_required(VERSION 3.1)

project(shape4D)
message("=——Cmakelist")
#-----------------------------------------------------------------------------
# Slicer extension
#-----------------------------------------------------------------------------

# Superbuild is automatically set to ON in the outer-build if shape4D is built
# as a Slicer extension.

option(${PROJECT_NAME}_SUPERBUILD "Build ${PROJECT_NAME} and the projects it depends on." OFF)


if(${PROJECT_NAME}_BUILD_SLICER_EXTENSION AND NOT EXTENSION_SUPERBUILD_BINARY_DIR)
  set(${PROJECT_NAME}_SUPERBUILD ON)  
  option(USE_VTK "Use VTK instead of built-in vtk polydata reader/writer" ON)
  option(USE_SEM "Use SlicerExecutionModel to build shape4D as CLI" ON)
endif()

if(${PROJECT_NAME}_SUPERBUILD)
  option(USE_VTK "Use VTK instead of built-in vtk polydata reader/writer" ON)
  option(USE_SEM "Use SlicerExecutionModel to build shape4D as CLI" ON)
else()
  option(USE_VTK "Use VTK instead of built-in vtk polydata reader/writer" OFF)
  option(USE_SEM "Use SlicerExecutionModel to build shape4D as CLI" OFF)
endif()


if(${PROJECT_NAME}_BUILD_SLICER_EXTENSION)
  #-----------------------------------------------------------------------------
  # Extension meta-information
  set(EXTENSION_HOMEPAGE "http://slicer.org/slicerWiki/index.php/Documentation/Nightly/Extensions/shape4D")
  set(EXTENSION_CATEGORY "Shape Analysis")
  set(EXTENSION_CONTRIBUTORS "Francois Budin (Kitware Inc.), James Fishbaugh (NYU)")
  set(EXTENSION_DESCRIPTION "shape4D is an extension for estimating continuous evolution from a discrete collection of shapes, designed to produce realistic anatomical trajectories.")
  set(EXTENSION_ICONURL "http://www.example.com/Slicer/Extensions/shape4D.png")
  set(EXTENSION_SCREENSHOTURLS "http://www.example.com/Slicer/Extensions/shape4D/Screenshots/1.png")
  # Required in Superbuild.cmake
  set(EXTENSION_DEPENDS "NA") # Specified as a space separated string, a list or 'NA' if any
  set(SUPERBUILD_TOPLEVEL_PROJECT ${PROJECT_NAME})
  set(EXTENSION_BUILD_SUBDIRECTORY ${PROJECT_NAME}-build) # Required for packaging purposes

  find_package(Slicer REQUIRED)
  include(${Slicer_USE_FILE})
  mark_as_superbuild(Slicer_DIR)

endif()

#-----------------------------------------------------------------------------
# Superbuild
#-----------------------------------------------------------------------------

# Set to OFF by default, to avoid changing behavior (backward compatibility).
mark_as_advanced(${PROJECT_NAME}_SUPERBUILD)
if(${PROJECT_NAME}_SUPERBUILD)
  include("${CMAKE_CURRENT_SOURCE_DIR}/SuperBuild.cmake")
  return()
else()
  include("${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}.cmake")
endif()

#-----------------------------------------------------------------------------
# Source code
#-----------------------------------------------------------------------------

add_subdirectory(src)

#-----------------------------------------------------------------------------
# Install
#-----------------------------------------------------------------------------

#install(TARGETS shape4D RUNTIME DESTINATION ${INSTALL_RUNTIME_DEST} COMPONENT Executables)
# Slicer extension packaging
if(${PROJECT_NAME}_BUILD_SLICER_EXTENSION)
  install(FILES ${FFTW_INSTALL_LIBRARIES} DESTINATION ${Slicer_INSTALL_LIB_DIR})
  set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${CMAKE_BINARY_DIR};${EXTENSION_NAME};ALL;/")
  include(${Slicer_EXTENSION_CPACK})
endif()