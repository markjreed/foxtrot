#!/bin/bash
elm package install elm-lang/core -y
elm package install elm-lang/html -y
exec elm make "$@" --output=punishment_elm.html
