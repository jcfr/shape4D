#-----------------------------------------------------------------------------
# shape4D application
#-----------------------------------------------------------------------------

find_package (FFTW REQUIRED)
include_directories(${FFTW_INCLUDE_DIR})

# Include directories
include_directories(
  include/
  ./
  )
message(" — - — — in src")


FILE(GLOB_RECURSE ${PROJECT_NAME}_INCLUDE "include/*.h")

set(${PROJECT_NAME}_SOURCE
  array1d.txx
  array2d.txx
  array3d.txx
  adaptivegradientdescent.cpp
  algorithm.cpp
  shape4dstate.cpp
  grid.cpp
  gridoptimize.cpp
  helper.cpp
  landmarks.cpp
  optimizer.cpp
  regressionacceleration.cpp
  regression.cpp
  regressionparams.cpp
  regressionvelocity.cpp
  runexperiment.cpp
  saveshapesandvectors.cpp
  surfacecurrent.cpp
  targetdata.cpp
  shapeobject.cpp
  tmplandmark.cpp
  tmpsurfacecurrent.cpp
  multiobjectcomplex.cpp
  polydatareader.cpp
  polydatawriter.cpp
  tinystr.cpp
  tinyxml.cpp
  tinyxmlerror.cpp
  tinyxmlparser.cpp
  shape4D.cxx
  )
message(${${PROJECT_NAME}_SOURCE})


if(USE_SEM)
  # Build as a CLI
  message("Build as a CLI")

  add_definitions("-DUSE_SEM")
  SEMMacroBuildCLI(
    NAME ${PROJECT_NAME}
    ADDITIONAL_SRCS ${${PROJECT_NAME}_SOURCE}
    TARGET_LIBRARIES ${FFTW_LIBRARIES} ${VTK_LIBRARIES}
    INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}
    INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}
    RUNTIME_OUTPUT_DIRECTORY ${RUNTIME_OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    INSTALL_RUNTIME_DESTINATION ${INSTALL_RUNTIME_DEST}
    INSTALL_LIBRARY_DESTINATION ${SlicerExecutionModel_DEFAULT_CLI_RUNTIME_OUTPUT_DIRECTORY}
    INSTALL_ARCHIVE_DESTINATION ${SlicerExecutionModel_DEFAULT_CLI_RUNTIME_OUTPUT_DIRECTORY}
    )
else()
  # Build an independent executable
  message("Build an independent executable")
  add_executable(${PROJECT_NAME} ${${PROJECT_NAME}_SOURCE})
  target_link_libraries(${PROJECT_NAME} ${FFTW_LIBRARIES} ${VTK_LIBRARIES})
endif()

# Show header files in IDE
add_custom_target(include SOURCES ${${PROJECT_NAME}_INCLUDE})
