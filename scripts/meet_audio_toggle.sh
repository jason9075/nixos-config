#!/usr/bin/env bash
set -euo pipefail

# Toggle a PipeWire virtual mic ("meet_mic_mix") that mixes the desktop
# audio monitor together with the real microphone into one source, then
# points the system default input at it. Lets Google Meet (or any app that
# just uses the default mic) share desktop audio without per-app setup.
#
# ON:  null-sink meet_mic_mix <- loopback(real mic) + loopback(default sink
#      monitor); default source switched to meet_mic_mix.monitor.
# OFF: all modules we loaded are unloaded and the original default source
#      is restored from STATE_FILE.

SINK_NAME="meet_mic_mix"
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/meet-audio-toggle.state"
WAYBAR_SIGNAL="RTMIN+9"

if ! command -v pactl >/dev/null 2>&1; then
  notify-send "Meet Audio" "pactl not found (PipeWire pulse compat missing?)"
  exit 1
fi

# Module ids in load order (null-sink first, then the two loopbacks).
mapfile -t MODULE_IDS < <(pactl list short modules | awk -v name="$SINK_NAME" '$0 ~ name {print $1}')

if [[ ${#MODULE_IDS[@]} -gt 0 ]]; then
  # --- currently ON: restore the mic, then tear the routing down ---
  if [[ -f "$STATE_FILE" ]]; then
    pactl set-default-source "$(cat "$STATE_FILE")" || true
    rm -f "$STATE_FILE"
  fi

  # Unload newest-first (loopbacks) so the sink they feed isn't yanked out
  # from under them mid-teardown.
  for ((i = ${#MODULE_IDS[@]} - 1; i >= 0; i--)); do
    pactl unload-module "${MODULE_IDS[$i]}" || true
  done
  notify-send "Meet Audio" "Disabled - mic is back to normal"
else
  # --- currently OFF: build the mix and switch the default mic to it ---
  DEFAULT_SOURCE=$(pactl get-default-source)
  DEFAULT_SINK=$(pactl get-default-sink)
  echo "$DEFAULT_SOURCE" >"$STATE_FILE"

  pactl load-module module-null-sink \
    sink_name="$SINK_NAME" sink_properties=device.description=Meet-Mic-Mix >/dev/null
  pactl load-module module-loopback \
    source="$DEFAULT_SOURCE" sink="$SINK_NAME" latency_msec=20 >/dev/null
  pactl load-module module-loopback \
    source="${DEFAULT_SINK}.monitor" sink="$SINK_NAME" latency_msec=20 >/dev/null

  pactl set-default-source "${SINK_NAME}.monitor"
  notify-send "Meet Audio" "Enabled - mic now includes desktop audio"
fi

pkill -"${WAYBAR_SIGNAL}" waybar || true

# AGS uses a request instead of a Unix signal (see gsr_toggle.sh for the same
# pattern). Best-effort so this still works on machines using Waybar only.
if command -v ags >/dev/null 2>&1; then
  ags request refresh-meet-audio >/dev/null 2>&1 || true
fi
