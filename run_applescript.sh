#!/bin/sh
case `uname -s` in
  Darwin) exec osascript "$1" 2>&1;;
  *) exit 123;;
esac
