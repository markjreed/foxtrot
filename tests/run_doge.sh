#!/bin/bash
if type -p node >/dev/null 2>&1; then
  exec node "${1%.*}-doge.js"
else
  exit 2
fi
