#!/bin/bash
if type -p ybc >/dev/null; then
  ybc -c "$PWD/$1"
  gcc -m32 "$1.o" /usr/local/lib/b-lib.o || exit 2
else
  exit 2
fi
