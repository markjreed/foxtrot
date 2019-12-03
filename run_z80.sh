#!/bin/sh -e
if (( ! $#  )); then 
  echo >&2 "Usage: $0 z80-assembly-file"
  exit 1
fi
dir=/tmp/runcpm$$
mkdir "$dir" && cp "$1" "$dir/RUNME.Z80" && cd "$dir"
disksrc=$(echo /usr/local/Cellar/yaze-ag/*/lib/yaze/disks)
for disk in BOOT_UTILS CPM3_SYS; do
  gzcat "$disksrc/$disk.ydsk" >"$disk.ydsk"
done
cat >.yazerc <<EOF
mount a BOOT_UTILS.ydsk
mount b CPM3_SYS.ydsk
go
EOF
cat >PROFILE.SUB <<EOF
B:SETDEF [NOPAGE]
Z80ASM RUNME/AK
RUNME
EOF
cdm BOOT_UTILS.ydsk >&/dev/null  <<'EOF' 
era profile.sub
cp t:profile.sub
cp t:runme.z80
quit
EOF
expect <<'EOF'
log_user 0
spawn yaze
expect "A>RUNME\r\r\n"
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
