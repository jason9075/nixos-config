#!/usr/bin/env bash

TARGET_DIR="$HOME/.openclaw/workspace"
SOURCE_DIR="$HOME/nixos-config/home/services/openclaw/docs"

mkdir -p "$TARGET_DIR"

echo "Copying OpenClaw markdown files from $SOURCE_DIR to $TARGET_DIR..."
for file in "$SOURCE_DIR"/*.md; do
    filename=$(basename "$file")
    # Remove existing file or symlink to avoid "Read-only file system" when it's a Nix symlink
    rm -f "$TARGET_DIR/$filename"
    cp "$file" "$TARGET_DIR/"
done
