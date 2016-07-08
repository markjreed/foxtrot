#!/bin/bash
if type -p apl >/dev/null 2>&1; then
  exec apl --script -f "$@" | grep '^[^ ]'
else
  exit 2
fi
