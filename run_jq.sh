#!/bin/bash
if type -p jq >/dev/null 2>&1; then
  jq -r -s -f "$@" </dev/null
else
  exit 2
fi
