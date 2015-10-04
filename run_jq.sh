#!/bin/bash
jq -r -s -f "$@" </dev/null
