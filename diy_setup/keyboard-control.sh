#!/bin/bash

FIFO="/run/mplayerctl/control"
# place this file in /usr/local/bin/

# Wait for FIFO (created by tmpfiles + used by mplayer)
while [ ! -p "$FIFO" ]; do
  sleep 0.2
done

# Pick ANY keyboard-like input device.
# Prefer by-id (stable), fall back to event devices.
pick_device() {
  # by-id is best when it exists
  for d in /dev/input/by-id/*event-kbd; do
    [ -e "$d" ] && echo "$d" && return 0
  done

  # fallback: any event device that looks like a keyboard (rough but works)
  for d in /dev/input/event*; do
    [ -e "$d" ] && echo "$d" && return 0
  done

  return 1
}

while true; do
  DEVICE="$(pick_device || true)"

  # If no keyboard attached yet, keep waiting quietly
  if [ -z "$DEVICE" ]; then
    sleep 2
    continue
  fi

  # Run evtest and translate key presses -> mplayer slave commands
  /usr/bin/evtest "$DEVICE" 2>/dev/null | while read -r line; do
    case "$line" in
      *"type 1 (EV_KEY)"*"value 1"*)
        case "$line" in
          *"(KEY_SPACE)"*|*"(KEY_KP5)"*) echo pause > "$FIFO" ;;
          *"(KEY_RIGHT)"*|*"(KEY_KP6)"*) echo seek 10 > "$FIFO" ;;
          *"(KEY_LEFT)"*|*"(KEY_KP4)"*)  echo seek -10 > "$FIFO" ;;
          *"(KEY_N)"*|*"(KEY_KP9)"*)     echo pt_step 1 > "$FIFO" ;;
          *"(KEY_P)"*|*"(KEY_KP7)"*)     echo pt_step -1 > "$FIFO" ;;
          *"(KEY_ESC)"*|*"(KEY_Q)"*)     echo quit > "$FIFO" ;;
        esac
      ;;
    esac
  done

  # If evtest exits (device unplugged, etc.), loop and re-detect
  sleep 1
done
