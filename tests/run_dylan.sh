#!/bin/bash -e
name="$(sed -ne $'s/^Module:[\t ]*//p' "$1")"
name="${name:-runme}"
"./dylan-build/$name/_build/bin/$name" "$@"
