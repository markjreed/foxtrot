#!/usr/bin/env bash
prog8c -target virtual -emu "$1" | sed -e '1,13d' | ghead -n -2
