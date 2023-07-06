#!/bin/bash
if type -p dogescript >/dev/null; then
  dogescript "$1" >"${1%.*}-doge.js"
else
  exit 2
fi
