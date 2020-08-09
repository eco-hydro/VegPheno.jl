#! /bin/bash

gcc  -DNDEBUG -O2 -Wall -std=gnu99 -mfpmath=sse -msse2 -mstackrealign -pedantic -g -O0 -fdiagnostics-color=always -c smooth_whit.c -o smooth_whit.o
gcc -shared -s -static-libgcc -o smooth_whit.so smooth_whit.o
