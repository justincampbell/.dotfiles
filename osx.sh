#!/bin/bash -e

echo "Setting Energy Saver preferences"
sudo pmset -b displaysleep 10
sudo pmset -b sleep 60
sudo pmset -c displaysleep 15
sudo pmset -c sleep 0

echo "Configuring dock"
osascript -e '
tell application "System Events"
  tell dock preferences
    set dock size to 0.75
    set magnification size to 1

    set autohide to true
    set magnification to true
  end tell
end tell
'

# Mouse Settings
echo "Opening Trackpad preferences"
osascript -e '
tell application "System Preferences"
  activate
  reveal (pane id "com.apple.preference.trackpad")
end tell
'
read -p "Turn on tap to click"
read -p "Turn on 3 finger drag"
