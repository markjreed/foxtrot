#!/bin/bash
cintsys64 -c "${1%.*}" | sed -n -e '1,2d' -e 's/^\r*[0-9.]*> //' -e '$ !{;s/^\r//;p;}'
