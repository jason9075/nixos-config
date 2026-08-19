#!/usr/bin/env bash
set -euo pipefail

# Emits waybar custom-module JSON reflecting whether gpu-screen-recorder is
# currently running.

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/gpu-screen-recorder.pid"

# Plain FontAwesome dot glyphs (circle-o / circle) so idle blends in with the
# other custom modules and recording is just a quiet color change, no
# blinking text. Built via ANSI-C quoting instead of a literal glyph so the
# codepoint survives regardless of editor/terminal font.
IDLE_ICON=$''
RECORDING_ICON=$''

if [[ -f "$PIDFILE" ]] && kill -0 "$(sed -n '1p' "$PIDFILE")" 2>/dev/null; then
  printf '{"text": " %s ", "class": "recording", "tooltip": "Recording... click to stop"}\n' "$RECORDING_ICON"
else
  printf '{"text": " %s ", "class": "idle", "tooltip": "Click to start screen recording"}\n' "$IDLE_ICON"
fi
