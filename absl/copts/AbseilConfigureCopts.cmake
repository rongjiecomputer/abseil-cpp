# See absl/copts/copts.py and absl/copts/generate_copts.py
include(GENERATED_AbseilCopts)

set(ABSL_LSAN_LINKOPTS "")
set(ABSL_HAVE_LSAN OFF)

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  set(ABSL_DEFAULT_COPTS "${ABSL_GCC_FLAGS}")
  set(ABSL_TEST_COPTS "${ABSL_GCC_FLAGS};${ABSL_GCC_TEST_FLAGS}")
  set(ABSL_EXCEPTIONS_FLAG "${ABSL_GCC_EXCEPTIONS_FLAGS}")
elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
  # MATCHES so we get both Clang and AppleClang
  if (MSVC)
    # clang-cl is half MSVC, half LLVM
    set(ABSL_DEFAULT_COPTS "${ABSL_CLANG_CL_FLAGS}")
    set(ABSL_TEST_COPTS "${ABSL_CLANG_CL_FLAGS};${ABSL_CLANG_CL_TEST_FLAGS}")
    set(ABSL_EXCEPTIONS_FLAG "${ABSL_CLANG_CL_EXCEPTIONS_FLAGS}")
  else()
    set(ABSL_DEFAULT_COPTS "${ABSL_LLVM_FLAGS}")
    set(ABSL_TEST_COPTS "${ABSL_LLVM_FLAGS};${ABSL_LLVM_TEST_FLAGS}")
    set(ABSL_EXCEPTIONS_FLAG "${ABSL_LLVM_EXCEPTIONS_FLAGS}")
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
      # AppleClang doesn't have lsan
      # https://developer.apple.com/documentation/code_diagnostics
      if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 3.5)
        set(ABSL_LSAN_LINKOPTS "-fsanitize=leak")
        set(ABSL_HAVE_LSAN ON)
      endif()
    endif()
  endif()
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
  set(ABSL_DEFAULT_COPTS "${ABSL_MSVC_FLAGS}")
  set(ABSL_TEST_COPTS "${ABSL_MSVC_FLAGS};${ABSL_MSVC_TEST_FLAGS}")
  set(ABSL_EXCEPTIONS_FLAG "${ABSL_MSVC_EXCEPTIONS_FLAGS}")
else()
  message(WARNING "Unknown compiler: ${CMAKE_CXX_COMPILER}.  Building with no default flags")
  set(ABSL_DEFAULT_COPTS "")
  set(ABSL_TEST_COPTS "")
  set(ABSL_EXCEPTIONS_FLAG "")
endif()

# This flag is used internally for Bazel builds and is kept here for consistency
set(ABSL_EXCEPTIONS_FLAG_LINKOPTS "")

if("${CMAKE_CXX_STANDARD}" EQUAL 98)
  message(FATAL_ERROR "Abseil requires at least C++11")
elseif(NOT "${CMAKE_CXX_STANDARD}")
  message(STATUS "No CMAKE_CXX_STANDARD set, assuming 11")
  set(ABSL_CXX_STANDARD 11)
else()
  set(ABSL_CXX_STANDARD "${CMAKE_CXX_STANDARD}")
endif()