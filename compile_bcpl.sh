#!/bin/bash
if type -p cintsys64 >/dev/null 2>&1; then
  cintsys64 -c "bcpl $1 to ${1%.*} t64"
else
  exit 2
fi
