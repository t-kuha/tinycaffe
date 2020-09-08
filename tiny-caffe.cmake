# mini-caffe.cmake

# select BLAS
set(BLAS "openblas" CACHE STRING "Selected BLAS library")

# turn on C++11
if(CMAKE_COMPILER_IS_GNUCXX OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()

# include and library
if(MSVC)
  include_directories(${CMAKE_CURRENT_LIST_DIR}/3rdparty/include
                      ${CMAKE_CURRENT_LIST_DIR}/3rdparty/include/opencv/include)
  link_directories(${CMAKE_CURRENT_LIST_DIR}/3rdparty/libs/release)
  list(APPEND Caffe_LINKER_LIBS  libprotobuf glog gflags
                                libopenblas opencv_world310)
elseif(ANDROID)
  # TODO https://github.com/android-ndk/ndk/issues/105
  set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} -nodefaultlibs -lgcc -lc -lm -ldl")
  if(ANDROID_EXTRA_LIBRARY_PATH)
    include_directories(${CMAKE_CURRENT_LIST_DIR}/include
                        ${ANDROID_EXTRA_LIBRARY_PATH}/include)
    link_directories(${ANDROID_EXTRA_LIBRARY_PATH}/lib)
    list(APPEND Caffe_LINKER_LIBS openblas protobuf log)
  else(ANDROID_EXTRA_LIBRARY_PATH)
    message(FATAL_ERROR "ANDROID_EXTRA_LIBRARY_PATH must be set.")
  endif(ANDROID_EXTRA_LIBRARY_PATH)
else(MSVC)
  if(APPLE)
    include_directories(/usr/local/opt/openblas/include)
    link_directories(/usr/local/opt/openblas/lib)
  endif(APPLE)
  include_directories(${CMAKE_CURRENT_LIST_DIR}/include)
  list(APPEND Caffe_LINKER_LIBS protobuf)
  if(BLAS STREQUAL "openblas")
    list(APPEND Caffe_LINKER_LIBS openblas)
    message(STATUS "Use OpenBLAS for blas library")
  else()
    list(APPEND Caffe_LINKER_LIBS blas)
    message(STATUS "Use BLAS for blas library")
  endif()
endif(MSVC)

# source file structure
file(GLOB CAFFE_SRC ${CMAKE_CURRENT_LIST_DIR}/src/*.hpp
	${CMAKE_CURRENT_LIST_DIR}/src/*.cpp
	${CMAKE_CURRENT_LIST_DIR}/src/caffe.pb.h
	${CMAKE_CURRENT_LIST_DIR}/src/caffe.pb.cc)

# cpp code
set(CAFFE_COMPILE_CODE ${CAFFE_SRC})

# file structure
source_group(src FILES ${CAFFE_SRC})

add_definitions(-DCAFFE_EXPORTS)
add_definitions(-DUSE_OPENCV)
add_library(caffe SHARED ${CAFFE_COMPILE_CODE})
target_link_libraries(caffe ${Caffe_LINKER_LIBS})
