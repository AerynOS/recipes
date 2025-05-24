## This is a list of packages that should be removed from the repo once moss supports package removal

### Moved into other gcc packages
- gcc-devel
- gcc-32bit-devel

### Replaced by sdl2-compat
- sdl2
- sdl2-devel
- sdl2-dbginfo

### Replaced by mesa-clc
- intel-clc
- intel-clc-dbginfo

### Merged into llvm package
- libcxx-dbginfo
- llvm-bolt-dbginfo

### GDB didn't actually have any devel files
- gdb-devel

### Don't need
- libfuse2-32bit
- libfuse2-32bit-dbginfo
- libfuse2-32bit-devel

### Split into gtk3/gtk4 specific packages
- vte
- vte-devel

### Nodejs is now a meta-package that doesn't need headers
- nodejs-devel
