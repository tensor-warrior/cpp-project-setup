This is the initial project setup for all my C++ projects. Package manager used is Conan with GNU Make as build utility. To get started, start by installing Conan and GNU Make. Once both are installed, initialize Conan profile by running:

```ps
conan profile detect --force
```

To check profile configurations, run:

```ps
conan profile show
```

Once conan has been set up, list the required dependencies in the `conanfile.txt` and then run:

```ps
conan install . --output-folder=build --build=missing
```

This installs all the dependencies and writes `build/conandeps.mk` with Make variables for headers (`-I`), library paths (`-L`), and library names (`-l`). Build and run the program with:

```sh
make
make run
```

The executable is written to `bin/`, and object files are written to `build/obj/`. Remove the executable and object files with `make clean`; this keeps Conan's generated files in `build/` intact.

The Makefile builds all `.cpp` files directly inside `src/` and adds `include/` to the header search path. Source files can include project headers with quoted includes, such as `#include "my_header.hpp"`.