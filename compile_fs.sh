#!/bin/bash
if type -p fsharpc >&/dev/null; then
  fsharpc "$@"
else
  exit 2
fi
