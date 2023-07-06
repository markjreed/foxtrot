#!/bin/bash
if type -p cintsys64 >/dev/null 2>&1; then
  cintsys64 -c "${1%.*}" | sed -n -e '1,2d' -e 's/^\r*[0-9.]*> //' -e '$ !{;s/^\r//;p;}'
else
  exit 2
fi
