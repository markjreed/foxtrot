#!/usr/bin/env bash
mapfile -t lines < <(expect -f - "${1%.*}.prg" <<'EOF' | petcat -nh -text | grep .
log_user 0
spawn bash -c "x16emu -prg [lindex $argv 0] -run -echo raw | LANG=C tr '\\r' '\\n'"
fconfigure $spawn_id -translation binary
fconfigure $user_spawn_id -translation binary -blocking 0
expect {READY.}
expect {READY.}
log_user 1
expect {READY.}
EOF
)
for (( l=0; l<${#lines[@]}-1; ++l )); do
  printf '%s\n' "${lines[l]}"
done
