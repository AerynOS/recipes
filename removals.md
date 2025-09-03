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

### Not used
- python-32bit
- python-32bit-devel
- python-32bit-dbginfo

### Now part of linux-tools
- perf-dbginfo

### man3 is used by perl
- perl-parse-yapp-devel
- perl-xml-parser-devel
- perl-uri-devel

### Never used
- libxcomposite-32bit
- libxcomposite-32bit-dbginfo
- libxcomposite-32bit-devel
- libxdamage-32bit
- libxdamage-32bit-dbginfo
- libxdamage-32bit-devel
- libxdmcp-32bit
- libxdmcp-32bit-dbginfo
- libxdmcp-32bit-devel
- libxinerama-32bit
- libxinerama-32bit-dbginfo
- libxinerama-32bit-devel
- libxtst-32bit
- libxtst-32bit-dbginfo
- libxtst-32bit-devel

### Actually checked for by cmake
- sdl2-compat-staticlib

### Renamed and split
- linux-firmware-amd
- linux-firmware-intel
- linux-firmware-nvidia

### Split
- mesa-devel

### Split
- pulseaudio

### Double packaged
- pycairo
- pycairo-devel

### Split
- gnome-desktop
- gnome-desktop-devel

### No longer used apparently
- vulkan-volk

### freerdp was the last revdep of this and it uses sdl3-ttf now
- sdl2-ttf
- sdl2-ttf-devel
- sdl2-ttf-dbginfo

### Upstream split to new qgpgme package
- gpgme-qt6
- gpgme-qt6-devel

### No longer generated
- vscode-bin-dbginfo

### Replaced by libdbusmenu-docs
- libdbusmenu-gtk3-docs

### Split to subpackages
- glycin
- glycin-devel

### Renamed to jpegxl-dbginfo
- libjxl-dbginfo
