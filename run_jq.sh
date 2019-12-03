#!/bin/bash
if type -p jq >/dev/null 2>&1; then
  jq -nrsf "$@"
else
  exit 2
fi
