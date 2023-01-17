#!/usr/bin/env bash
tmp=$(mktemp -d)
pkg=${1%%.*}
(cd "$tmp" && bal new "$pkg")
cp "$1" "$tmp/$pkg/main.bal"
(cd "$tmp/$pkg" && bal run)
rm -rf "$tmp"
