# CMake

- [CMake](#cmake)
  - [General](#general)
  - [CMakeLists.txt](#cmakeliststxt)
    - [Target](#target)

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

