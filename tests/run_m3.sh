#!/usr/bin/env bash
dir="${1%.*}_dir"
cd "$dir" && DYLD_FALLBACK_LIBRARY_PATH=/usr/local/cm3/lib ./*/prog

