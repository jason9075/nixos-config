#!/usr/bin/env bash

COLOR=$(hyprpicker)

echo "${COLOR}" | wl-copy -n 
notify-send "Color Picker" "<span color='${COLOR}'>███</span> ${COLOR}"
