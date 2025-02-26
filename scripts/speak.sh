#!/usr/bin/env bash
# Script to synthesize speech and play it with VLC in the background

# Ensure a message is provided
if [ -z "$1" ]; then
  echo "Usage: speak <text>"
  exit 1
fi

# Temporary file for the speech
TEMP_FILE="/tmp/speech.wav"

# check model and config files
if [ ! -f ~/en_US-joe-medium.onnx ]; then
  echo "Model file not found. Please download the model file and try again."
  echo "https://github.com/rhasspy/piper/blob/master/VOICES.md"
  exit 1
fi

# Synthesize the speech
echo "$1" | \
  piper --model ~/en_US-joe-medium.onnx \
        --config ~/en_en_US_joe_medium_en_US-joe-medium.onnx.json \
        --output_file "$TEMP_FILE"

# Check if VLC is installed
if command -v vlc &> /dev/null; then
  # Play the audio in the background
  vlc --intf dummy --play-and-exit "$TEMP_FILE" >/dev/null 2>&1 &
else
  echo "VLC is not installed. Please install VLC and try again."
  exit 1
fi

# Wait for VLC to finish before deleting the file
wait

# Remove the temporary audio file
# rm -f "$TEMP_FILE"
