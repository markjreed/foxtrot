#!/bin/bash
if type -p mono >/dev/null 2>&1; then
  mono "${1%.*}.exe"
else
  exit 2
fi
