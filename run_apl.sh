#!/bin/bash
exec apl --script -f "$@" | grep '^[^ ]'
