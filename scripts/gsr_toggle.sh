#!/usr/bin/env bash
set -euo pipefail

# Toggle gpu-screen-recorder: starts a recording of the focused monitor if
# none is running, otherwise stops the running one gracefully.

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/gpu-screen-recorder.pid"
OUTDIR="$HOME/Videos/recordings"
WAYBAR_SIGNAL="RTMIN+8"
# Mix desktop audio and mic into a single track (gpu-screen-recorder merges
# sources separated by "|" instead of adding a second audio stream).
AUDIO_SOURCE="default_output|default_input"

if ! command -v gpu-screen-recorder >/dev/null 2>&1; then
  notify-send "Screen Recording" "gpu-screen-recorder is not installed"
  exit 1
fi

# "-w focused" needs an explicit "-s WxH" (it means focused *window*, not
# monitor) and otherwise exits immediately, so pick a real monitor name.
pick_monitor() {
  if command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name' | head -n1
  fi
}

if [[ -f "$PIDFILE" ]]; then
  PID=$(sed -n '1p' "$PIDFILE")
  OUTFILE=$(sed -n '2p' "$PIDFILE")
else
  PID=""
  OUTFILE=""
fi

if [[ -n "$PID" ]] && kill -0 "$PID" 2>/dev/null; then
  kill -INT "$PID"
  rm -f "$PIDFILE"
  notify-send "Screen Recording" "Stopped. Saved to ${OUTFILE:-$OUTDIR}"
else
  rm -f "$PIDFILE"
  MONITOR=$(pick_monitor)
  if [[ -z "$MONITOR" ]]; then
    MONITOR=$(gpu-screen-recorder --list-monitors 2>/dev/null | head -n1 | cut -d'|' -f1)
  fi
  if [[ -z "$MONITOR" ]]; then
    notify-send "Screen Recording" "No monitor found to record"
    exit 1
  fi

  mkdir -p "$OUTDIR"
  OUTFILE="${OUTDIR}/$(date +%Y-%m-%d_%H-%M-%S).mp4"
  gpu-screen-recorder -w "$MONITOR" -f 60 -a "$AUDIO_SOURCE" -o "$OUTFILE" &>/tmp/gpu-screen-recorder.log &
  NEWPID=$!
  printf '%s\n%s\n' "$NEWPID" "$OUTFILE" > "$PIDFILE"
  notify-send "Screen Recording" "Started -> ${OUTFILE}"
fi

pkill -"${WAYBAR_SIGNAL}" waybar || true
