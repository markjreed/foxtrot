#!/bin/bash
ratfor "$1" >"${1%.rf}-rf.f" 2>/dev/null
exec gfortran -o "${1%.rf}" "${1%.rf}-rf.f"  >/dev/null  2>&1
