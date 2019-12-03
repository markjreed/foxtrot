#!/bin/bash
if type -p elm >/dev/null 2>&1; then
  elm init <<<y >&/dev/null
  exec elm make "$@" --output=punishment_elm.html
else
  exit 2
fi
