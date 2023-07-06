#!/usr/bin/env osascript
on doLogo(codeString)
  tell application "UCBLogo" to activate
  tell application "System Events" to keystroke (codeString & return)
end doLogo

on run(argv)
  tell application "UCBLogo" to launch
  tell application "System Events"
    repeat until visible of process "UCBLogo" is true
      delay 0.1
    end
  end tell
  set cwd to (do shell script "pwd")
  set logoCode to text of (read POSIX file (cwd & "/" & (item 1 of argv)))
  doLogo("setprefix \"" & cwd)
  doLogo("openwrite \"logo-result.txt")
  doLogo("setwrite \"logo-result.txt")
  doLogo(logoCode)
  doLogo("close \"logo-result.txt")
  delay 2
  doLogo("bye")
  delay 2
  tell application "UCBLogo" to quit
  delay 2
  return text 1 through -2 of (read POSIX file (cwd & "/logo-result.txt"))
end run

