#!/bin/bash
base="${1%.a60}"
marst -o "${base}_a60.c" "$1"
gcc -o "$base" -I/usr/local/opt/marst/include -L/usr/local/opt/marst/lib "${base}_a60.c" -lalgol -lm 
