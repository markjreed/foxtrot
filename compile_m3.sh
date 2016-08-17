#!/usr/bin/env bash
dir="${1%.*}"
mkdir "$dir" && cp "$1" "$dir"/Main.m3 && cd "$dir" && cm3 -build 
