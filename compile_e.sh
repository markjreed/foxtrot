#!/bin/bash
if type -p se >/dev/null; then
  se c "$@"
else
  exit 2
fi
