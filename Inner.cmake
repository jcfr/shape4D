cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(shape4D)

if(EXTENSION_SUPERBUILD_BINARY_DIR)
  find_package(Slicer REQUIRED)
  include(${Slicer_USE_FILE})
endif()

# External dependencies
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake" ${CMAKE_MODULE_PATH} )

option(USE_VTK "Use VTK instead of built-in vtk polydata reader/writer" OFF)
option(USE_SEM "Use SlicerExecutionModel as CLI" OFF)

find_package (FFTW REQUIRED)
include_directories(${FFTW_INCLUDE_DIR})

# Include directories
include_directories(
  include/
  src/
)

FILE(GLOB_RECURSE shape4D_INCLUDE "include/*.h")

set(shape4D_SOURCE
   src/array1d.txx
   src/array2d.txx
   src/array3d.txx
   src/adaptivegradientdescent.cpp
   src/algorithm.cpp
   src/shape4dstate.cpp
   src/grid.cpp
   src/gridoptimize.cpp
   src/helper.cpp
   src/landmarks.cpp
   src/optimizer.cpp
   src/regressionacceleration.cpp
   src/regression.cpp
   src/regressionparams.cpp
   src/regressionvelocity.cpp
   src/runexperiment.cpp
   src/saveshapesandvectors.cpp
   src/surfacecurrent.cpp
   src/targetdata.cpp
   src/shapeobject.cpp
   src/tmplandmark.cpp
   src/tmpsurfacecurrent.cpp
   src/multiobjectcomplex.cpp
   src/polydatareader.cpp
   src/polydatawriter.cpp
   src/tinystr.cpp
   src/tinyxml.cpp
   src/tinyxmlerror.cpp
   src/tinyxmlparser.cpp
   src/main.cpp
)

if(USE_SEM)
  add_definitions("-DUSE_SEM")
  # Build a Slicer CLI for Slicer
  find_package(SlicerExecutionModel REQUIRED)
  include(${SlicerExecutionModel_USE_FILE})
endif()

if(USE_VTK)
    add_definitions("-DUSE_VTK")
    find_package(VTK REQUIRED)
    include(${VTK_USE_FILE})
endif()

if(USE_SEM)
  add_definitions("-DUSE_SEM")
  SEMMacroBuildCLI(
    NAME ${PROJECT_NAME}
    ADDITIONAL_SRCS ${shape4D_SOURCE}
    TARGET_LIBRARIES ${FFTW_LIBRARIES} ${VTK_LIBRARIES}
    INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}
  )
else()
  # Build an independent executable without any dependency if outside of Slicer
  add_executable(shape4D ${shape4D_SOURCE})
  target_link_libraries(shape4D ${FFTW_LIBRARIES} ${VTK_LIBRARIES})
endif()

add_custom_target(include SOURCES ${shape4D_INCLUDE})

# If install subdirectory is not set, set it to default value
if(NOT INSTALL_RUNTIME_DEST)
  set(INSTALL_RUNTIME_DEST bin)
endif()

install(TARGETS shape4D RUNTIME DESTINATION ${INSTALL_RUNTIME_DEST} COMPONENT Executables)
