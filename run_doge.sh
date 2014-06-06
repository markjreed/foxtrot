#!/bin/bash
dogescript "$@" >/tmp/doge.js
node /tmp/doge.js
