#!/bin/bash
mkdir -p /tmp/4dos
bat="$1"
shift
cp "$bat" /tmp/4dos/runme.bat
cd /tmp/4dos
cmd=(dosbox -c 'mount d "'"$PWD"'"' -c 'mount c /tmp/4dos')
for d in [^CcDd]/; do
  cmd+=("-c" "mount ${d%/*} $PWD/$d")
done
if (( ! $# )); then
  cmd+=(-c c: -c d:4dos.com -c exit)
else
  cmd+=(-c "d:4dos.com $* >c:4dos.out" -c exit)
fi
"${cmd[@]}" >&/dev/null
cat /tmp/4dos/4dos.out
