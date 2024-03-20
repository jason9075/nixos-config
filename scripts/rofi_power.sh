#!/usr/bin/env bash

chosen=$(echo -e " Lock\n Logout\n Reboot\n Shutdown" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
  " Lock") swaylock ;;
  " Logout") loginctl terminate-user $USER ;;
  " Reboot") systemctl reboot ;;
  " Shutdown") systemctl poweroff ;;
esac
