#!/bin/bash
ybc -c "$PWD/$1"
gcc -m32 "$1.o" /usr/local/lib/b-lib.o
