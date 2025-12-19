# save this file to /usr/local/bin/

#!/bin/bash
set -e

MEDIA_DIR="/home/mediaplayer/media"
FIFO="/run/mplayerctl/control"

# Wait for framebuffer
while [ ! -e /dev/fb0 ]; do
  sleep 0.5
done

cd "$MEDIA_DIR"

shopt -s nullglob
files=( *.mp4 )

if [ ${#files[@]} -eq 0 ]; then
  sleep 5
  exit 0
fi

exec /usr/bin/mplayer \
  -slave \
  -input file="$FIFO" \
  -vo fbdev:/dev/fb0 \
  -ao alsa:device=hw=0.0 \
  -fs \
  -quiet \
  -loop 0 \
  "${files[@]}"
