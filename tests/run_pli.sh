#!/usr/bin/env bash 
if (( ! $#  )); then
  echo >&2 "Usage: $0 pli-source-file"
  exit 1
fi
dir=/tmp/runcpm$$
mkdir "$dir" && cp "$1" "$dir/RUNME.PLI" && cd "$dir"
disksrc=$(echo ~/cpm)
for disk in BOOT_UTILS CPM3_SYS pli-b; do
  cp "$disksrc/$disk.ydsk" .
done
cat >.yazerc <<EOF
mount a BOOT_UTILS.ydsk
mount b CPM3_SYS.ydsk
mount c pli-b.ydsk
go
EOF
cat >PROFILE.SUB <<EOF
3SETDEF A,B,* [TEMPORARY=A:,ISO,ORDER=(SUB,COM)]
SETDEF [NOPAGE]
C:
PLI RUNME
LINK RUNME,PLILIB.IRL
RUNME
EOF
cdm pli-b.ydsk >&/dev/null  <<'EOF'
cp t:runme.pli
quit
EOF

cdm BOOT_UTILS.ydsk >&/dev/null  <<'EOF'
era profile.sub
cp t:profile.sub
quit
EOF
expect <<'EOF'
log_user 0
spawn yaze
expect "C>RUNME\r\r\n"
set accum {}
expect {
  "End of Execution" { exp_continue }
  "C>" { send "E\r" }
  -regexp {..*\n} {
    puts [regsub -all {[\n\r]} $expect_out(0,string) {}]
    exp_continue
  }
}
EOF
cd - >/dev/null 2>&1
rm -rf "$dir"
