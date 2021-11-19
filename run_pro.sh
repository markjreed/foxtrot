#!/usr/bin/env bash
(cp ~/"Dropbox (Personal)/Commodore/Floppies/promal-2.1.d64" run-promal.d64
printf '%s\r' 'compile runme.s' 'runme >p' 'quit' >bootscript.j
tr $'\n' $'\r' <"$1" >runme.s
c1541 -attach run-promal.d64 -write runme.s runme.s,s
c1541 -attach run-promal.d64 -write bootscript.j bootscript.j,s
x64sc -ntsc -warp -autostart run-promal.d64 -basicload -iecdevice4 -prtxtdev1 promal.prt -pr4txtdev 0 -pr4drv ascii -pr4output text -device4 1) >/dev/null 2>&1
cat promal.prt
