# cmake-runtime-requirements
CMake module for explicit tracking and copying runtime requirements.

## Integration
If you want to use the module in your project, simply include the `runtime-requirements-config.cmake` into your CMake scripts.
Alternatively, you can declare a dependency to the script via `find_package(runtime-requirements)` and resolve the dependency however you like.

## Usage
The `runtime-requirements-config.cmake` exposes the following CMake functions:
-- `target_runtime_requirements(<target> [items...])` declares that `<target>` expects `[items...]` in current working directory at runtime.
-- `get_runtime_requirements(<target> <VAR>)` recursively extracts all runtime requirements from a `<target>` into a `<VAR>`.
-- `copy_runtime_requirements(<target> <directory>)` recursively extracts all runtime requirements from a `<target>` and copies them into the `<directory>`.

You can see an example usage in the `example` subfolder. Note that the example is rather simplistic, yet the module is intended to be used in much more complicated situations.

## License
See [LICENSE](LICENSE) for license and copyright information.
