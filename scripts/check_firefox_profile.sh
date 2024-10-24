#!/usr/bin/env bash

# Check if the correct number of arguments are passed
if [ $# -ne 2 ]; then
    echo "Usage: $0 <profile_name>"
    exit 1
fi

# Assign variables from input arguments
PROFILE_NAME="$1"

# Profile directory path
PROFILE_DIR="$HOME/.mozilla/firefox"

# Check if the profile exists
PROFILE_EXISTS=$(grep -c "\[$PROFILE_NAME\]" "$PROFILE_DIR/profiles.ini")

if [ "$PROFILE_EXISTS" -eq 0 ]; then
    # Create the new profile
    firefox --no-remote --CreateProfile "$PROFILE_NAME"
fi

