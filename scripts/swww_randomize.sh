#!/usr/bin/env bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals

TRANSITION_FPS=30
TRANSITION_DUR=2

DIR=$HOME/Pictures/wallpapers
if [ ! -d "$DIR" ]; then
    echo "Wallpaper directory not found. Exiting."
    exit 1
fi

PICS=($(find "$DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' \)))
if [ ${#PICS[@]} -eq 0 ]; then
    echo "No wallpapers found in the directory. Exiting."
    exit 1
fi

RANDOME_PIC=${PICS[ $RANDOM % ${#PICS[@]} ]}

swww query || swww init

swww img ${RANDOME_PIC} --transition-fps ${TRANSITION_FPS} --transition-type any --transition-duration ${TRANSITION_DUR}

cp ${RANDOME_PIC} $HOME/Pictures/current-wallpaper.jpg
