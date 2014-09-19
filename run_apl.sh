#!/bin/bash
apl --script -f "$@" | grep '^[^ ]'
