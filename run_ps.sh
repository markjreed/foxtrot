#!/bin/bash
open -a Preview $(f ps cat "$1")
sleep 2
osascript >/dev/null 2>&1 <<'END_SCRIPT'
  tell application "Preview"
	activate
  end tell

  tell application "System Events" to tell process "Preview"
	tell menu 1 of menu bar item "Edit" of menu bar 1
      click menu item "Select All"
	  click menu item "Copy"
	end tell
    click menu item "Close Window" of menu 1 of menu bar item "File" of menu bar 1
  end tell
END_SCRIPT
sleep 2
pbpaste | tr $'\r' $'\n' | sed $'s/\./.\\\n/g' | sed -e 's/^ *//' | grep .
