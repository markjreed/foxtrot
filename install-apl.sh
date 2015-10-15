#!/bin/bash -e
curl -sSLO ftp://ftp.gnu.org/pub/gnu/apl/apl-1.5.tar.gz
tar xzf apl-1.5.tar.gz
cd apl-1.5
sh ./configure 
make
make install
