# cmake-runtime-requirements
CMake module for explicit tracking and copying runtime requirements.
The module allows for assigning files to a runtime filesystem and transitively copying a filesystem of a target to a destination directory.

## Integration
If you want to use the module in your project, simply include the `runtime-requirements-config.cmake` into your CMake scripts.
Alternatively, you can declare a dependency to the module via `find_package(runtime-requirements)` and resolve the dependency however you like.

## Usage
The `runtime-requirements-config.cmake` module exposes the following CMake functions:
-- `target_runtime_requirements(<target> [<src> <dst>]...)` declares that `<target>` requires `<src>` files in `<dst>` subfolders in a runtime filesystem.
-- `get_runtime_requirements(<target> <VAR>)` recursively extracts all runtime requirements from a `<target>` into a `<VAR>`. The `<VAR>` contains lists of `<src>:<dst>` pairs.
-- `copy_runtime_requirements(<target> <directory>)` recursively extracts all runtime requirements from a `<target>` and copies them into the runtime filesystem with root in `<directory>`.

You can see an example usage in the `example` subfolder. Note that the example is rather simplistic, yet the module is intended to be used in much more complicated situations.

## License
See [LICENSE](LICENSE) for license and copyright information.
