#include <bits/wordsize.h>

#if __WORDSIZE == 32
#include "llvm-config32.h"
#elif __WORDSIZE == 64
#include "llvm-config64.h"
#else
#error "Unknown word size"
#endif
