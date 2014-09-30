#!/bin/sh
racket -e '(require algol60/algol60) (eval (list '\''include-algol (vector-ref (current-command-line-arguments) 0)))' -- "$1"
