# CMake

- [CMake](#cmake)
  - [General](#general)
  - [CMakeLists.txt](#cmakeliststxt)
    - [Target](#target)
    - [CXX Standard](#cxx-standard)
    - [Catch2](#catch2)
  - [Reference](#reference)

## General
Cmake generates build file. (e.g. make, ninja)

## CMakeLists.txt
- `CMakeLists.txt` file at the project root dir should contain two info.
  - cmake_minimum_required
  - project
    ```
    cmake_minimum_required(VERSION 3.11)

    project(
    <name>
    VERSION 0.1
    DESCRIPTION "<desc>"
    LANGUAGES CXX)
    ```

### Target
- If a target is header-only, one should write as below
    ```
    add_library(<target_name> INTERFACE)
    target_include_directories(<target_name> INTERFACE <header_files...>)
    ```

### CXX Standard
- To set cpp standard for all targets, use below
    ```
    set(CMAKE_CXX_STANDARD 11)
    set(CMAKE_CXX_STANDARD_REQUIRED On)
    ```

### Catch2
- One should install Catch2 on the system first. Preferably with a package manager. e.g. `brew install catch2`
- One should include Catch2 with CMake, and link test executable with catch 2. If one does not need custom main for test, use below; [^1]

    ```
    find_package(Catch2 3 REQUIRED)

    add_executable(test test.cpp)
    target_link_libraries(test
        PRIVATE
        Catch2::Catch2WithMain
        <library_target_under_test>)

    include(CTest)
    include(Catch)

    catch_discover_tests(test)
    ```

## Reference
[^1] https://github.com/catchorg/Catch2/blob/devel/docs/tutorial.md