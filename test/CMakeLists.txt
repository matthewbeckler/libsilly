cmake_minimum_required(VERSION 3.0)
set(CMAKE_CXX_STANDARD 11)

project(silly_tests)

# Tell cmake where to find the files that tell it where to find files. The
# cmake subdirectory should contain .cmake files that define custom
# functions and Find*.cmake files that tell cmake where to look for
# libraries. This must be done before the find_package commands.
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/)


set(BUILD_GTEST ON)

add_subdirectory(lib/googletest-release-1.8.0)

include_directories(${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})

add_executable(runSillyTests
        test_silly.cpp
        ../silly.c
        )


# Add flags for debugging and for code coverage tests.
SET(NEW_FLAGS "-g -O0 -Wall -Wextra --coverage")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${NEW_FLAGS}")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${NEW_FLAGS}")
set_target_properties(runSillyTests PROPERTIES LINKER_FLAGS "--coverage -lgcov")

target_link_libraries(runSillyTests gtest gtest_main)

set(LCOV_REMOVE_EXTRA "'*/gtest/*'")
include(CodeCoverage)
setup_target_for_coverage(coverage runSillyTests "silly_tests" "--gtest_output='xml:testresults.xml'" )

