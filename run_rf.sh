#!/bin/sh
ratfor ./punishment.rf >punishment_ratfor.f 2>/dev/null
gfortran punishment_ratfor.f >/dev/null  2>&1
./a.out
