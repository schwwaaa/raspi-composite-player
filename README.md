# raspi-composite-player

A simple media player image for the **Raspberry Pi 3 Model B+**

You know — the one with the **3.5 mm, 4-pole composite output**.  
https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus/

Oh no:

- it’s getting harder to find  
- composite A/V support past **Bullseye** is basically gone  
- Bullseye isn’t available in Raspberry Pi Imager  
- manual headless setup bad  

So… **we did it so you don’t have to**.

---

## Usage (Quick Start)

### Prerequisites

- Raspberry Pi **3 Model B+**
- Composite A/V cable (TRRS → RCA)
- SD card (8 GB+ recommended)
- Optional:
  - Ethernet
  - Wi-Fi
  - USB keyboard or numpad

### Steps

1. Download image
   https://drive.google.com/file/d/1Y6pwTen5M_y9hYgS8aJSBdjM-uiVRS7-/view?usp=sharing
3. Uncompress image file
4. Write the image to an SD card  
5. Insert the SD card into the Pi  
6. Power it on  

That’s it.

The pi will boot, and the demo video should play automatically, and will loop until power is removed.

---

## File Management
MP4 files in the following directory will be looped, in ascending alphanumeric order:

```
/home/mediaplayer/media
```

SFTP and SCP protocols are ideal to transfer files, but require a network connection.

Or, using a linux host, you can just plop files in the media dir via rootfs

### Ethernet

Plug it in.  
The Pi will request an IP via DHCP automatically.

You should be able to SSH in immediately.

### Wi‑Fi (Headless)

1. Remove the SD card from the Pi after powering it down safely
2. Insert it into another computer  
3. On the **boot** partition, create a file called `wpa_supplicant.conf`:

```ini
country=US

network={
    ssid="MYSSID"
    psk="password123"
}
```

4. Savem, reinsert the SD card and boot the Pi

It should connect automatically. Should. 

---

## SSH Access

SSH is enabled by default.

If needed, you can also enable it by placing a **blank file named `ssh`** in the boot partition before first boot.

```bash
ssh mediaplayer@<pi-ip-address>
```

---

## Video Preparation (Important)

This project was designed specifically for **composite CRT playback**.

Performance depends heavily on how the video is prepared.

Videos should be **pre-encoded** to avoid runtime scaling and stutter.

Example FFmpeg command for displaying videos on an old 12 " CRT with clapped out speakers:

```bash
ffmpeg -i input.mp4 \
  -vf "scale=720:480:force_original_aspect_ratio=decrease,\
pad=720:480:(ow-iw)/2:(oh-ih)/2" \
  -r 30000/1001 \
  -pix_fmt yuv420p \
  -c:v libx264 -profile:v baseline -level 3.0 \
  -b:v 1500k \
  -c:a aac -ar 44100 -ac 2 -b:a 128k \
  output_pi_crt.mp4
```


---

## Keyboard / Numpad Controls (Optional)

A USB keyboard or numpad can be connected at any time.
Controls are optional — video will autoplay even if nothing is plugged in.

### Default Controls

| Key | Action |
|---|---|
| Space / KP5 | Pause / Resume |
| Right / KP6 | Seek forward |
| Left / KP4 | Seek backward |
| N / KP9 | Next video |
| P / KP7 | Previous video |
| Q / Esc | Quit playback |

The control service:
- starts automatically after boot  
- waits for devices to appear  
- works with **any USB keyboard**  
- recovers if devices are unplugged  

---

## Troubleshooting

### Video plays but stutters

Your video is likely not pre-encoded for composite output.  
Re-encode to **720×480**, **H.264 Baseline**, ~**1–1.5 Mbps**.

### Black screen, audio only

Composite output may not be forced.

This image already handles that — but if rolling your own, check `config.txt` and ensure you are not using KMS (`vc4-kms-v3d`).


### No network

- Ethernet should be plug-and-play
- Double-check `wpa_supplicant.conf`
- Ensure Wi-Fi country is set

---


## Notes

The goal of this project is **not modern quality** — it’s **reliable composite playback**.

It is intentionally simple and boring, so you don't have to.
