#!/usr/bin/env bash -e
if (( ! $#  )); then
  echo >&2 "Usage: $0 Algol-M file"
  exit 1
fi
dir=/tmp/runcpm$$
mkdir "$dir" && cp "$1" "$dir/RUNME.ALG" && cd "$dir"
disksrc=$(brew --prefix yaze-ag)/lib/yaze/disks
for disk in BOOT_UTILS CPM3_SYS; do
  gzcat "$disksrc/$disk.ydsk" >"$disk.ydsk"
done
cat >.yazerc <<EOF
mount a BOOT_UTILS.ydsk
mount b CPM3_SYS.ydsk
mount m /Users/mjreed/lib/retro/cpm/ALGOL-M
go
EOF
cat >PROFILE.SUB <<EOF
B:SETDEF [NOPAGE]
M:ALGOLM RUNME
M:RUNALG RUNME
EOF
cdm BOOT_UTILS.ydsk >&/dev/null  <<'EOF'
era profile.sub
cp t:profile.sub
cp t:runme.alg
quit
EOF
expect <<'EOF'
log_user 0
spawn yaze
expect "ALGOL-M INTERPRETER-VERS 1.0\r\n\r\n\r\n"
set accum {}
expect {
  "A>" { send "E\r" }
  -regexp {..*} {
    set accum "${accum}$expect_out(0,string)"
    exp_continue
  }
}
puts [regsub "\[\r\n \]*$" $accum {}]
EOF
cd - >/dev/null 2>&1
rm -rf "$dir"
