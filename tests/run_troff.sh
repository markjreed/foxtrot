#!/usr/bin/env bash
gs -q -sOutputFile=- -sDEVICE=pdfwrite -dBATCH -dNOPAUSE <(groff "$@") | pdftotext - - | tr -d '\f' | grep .
