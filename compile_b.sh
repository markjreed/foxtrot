#!/bin/bash
ybc/ybc -c "$PWD/$1"
gcc -m32 "$1.o" ybc/b-lib.o
