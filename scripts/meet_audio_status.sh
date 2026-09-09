#!/usr/bin/env bash
set -euo pipefail

# Emits waybar custom-module JSON reflecting whether the "system audio -> mic"
# PipeWire loopback (see meet_audio_toggle.sh) is currently active.

SINK_NAME="meet_mic_mix"

# Nerd Font (Material Design Icons) glyphs: plain mic when idle, a
# cast/broadcast icon once the desktop-audio loopback is mixed in.
IDLE_ICON=$'\U000f036c'   # nf-md-microphone
ACTIVE_ICON=$'\U000f040a' # nf-md-cast

if pactl list short modules 2>/dev/null | grep -q "sink_name=${SINK_NAME}"; then
  printf '{"text": " %s ", "class": "active", "tooltip": "System audio -> mic: ON (click to disable)"}\n' "$ACTIVE_ICON"
else
  printf '{"text": " %s ", "class": "idle", "tooltip": "System audio -> mic: OFF (click to enable)"}\n' "$IDLE_ICON"
fi
