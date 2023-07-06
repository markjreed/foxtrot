#!/bin/sh
if type -p osascript >/dev/null 2>&1; then
  exec osascript "$1" 2>&1
else
  exit 2
fi
