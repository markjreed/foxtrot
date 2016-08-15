#!/bin/bash
base="${1%.a60}"
marst -o "${base}_a60.c" "$1"
gcc -o "$base" "${base}_a60.c" -lalgol -lm 
