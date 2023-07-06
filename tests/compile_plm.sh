#!/usr/bin/env bash
plm2c "$1"
gcc "${1%.*}.c"
