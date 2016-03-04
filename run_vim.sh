#!/bin/bash
vim -S "$1" +x /tmp/runvim$$ >&/dev/null
cat /tmp/runvim$$
rm -f /tmp/runvim$$
