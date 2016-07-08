#!/bin/bash
if type -p elm >/dev/null 2>&1; then
  elm package install elm-lang/core -y
  elm package install elm-lang/html -y
  exec elm make "$@" --output=punishment_elm.html
else
  exit 2
fi
