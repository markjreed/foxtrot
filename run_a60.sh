#!/bin/sh
if type -p racket >/dev/null 2>&1; then
  racket -e '(require algol60/algol60) (eval (list '\''include-algol (vector-ref (current-command-line-arguments) 0)))' -- "$1"
else
  exit 2
fi
