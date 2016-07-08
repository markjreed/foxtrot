#!/bin/bash
if type -p ratfor >/dev/null 2>&1 && type -p gfortran >/dev/null 2>&1; then
  ratfor "$1" >"${1%.rf}-rf.f" 2>/dev/null
  exec gfortran -o "${1%.rf}" "${1%.rf}-rf.f"  >/dev/null  2>&1
else
  exit 2
fi
