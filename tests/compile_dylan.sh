#!/bin/bash -e
name="$(sed -ne $'s/^Module:[\t ]*//p' "$1")"
name="${name:-runme}"
unset dir
rm -rf "${dir:=./dylan-build}"
mkdir "$dir"
(cd "$dir" && make-dylan-app "$name") >/dev/null 2>&1
cp "$dir/$name/$name.lid" "$dir/$name/$name.hdp"
rsync -a "$HOME/lib/dylan/prebuilt/_build" "$dir/$name"
cp "$1" "$dir/$name/$name.dylan"
(cd "$dir/$name" && dylan-compiler -build "$name".lid) >/dev/null 2>&1
