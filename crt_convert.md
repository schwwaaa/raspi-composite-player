Converts a video for optimal display on an old CRT. 

    ffmpeg -i input.mp4 \
      -vf "scale=720:480:force_original_aspect_ratio=decrease,\
    pad=720:480:(ow-iw)/2:(oh-ih)/2,setsar=1" \
      -r 30000/1001 \
      -pix_fmt yuv420p \
      -c:v libx264 -profile:v baseline -level 3.0 \
      -preset slow \
      -b:v 1500k -maxrate 1500k -bufsize 3000k \
      -movflags +faststart \
      -c:a aac -ar 44100 -ac 2 -b:a 128k \
      output.mp4

**Video Processing (Video Filters)**:
   ```-vf "scale=720:480:force_original_aspect_ratio=decrease,\pad=720:480:(ow-iw)/2:(oh-ih)/2,setsar=1"``` 
   - `scale=720:480:force_original_aspect_ratio=decrease`: Resizes the video to 720x480 pixels while maintaining the original aspect ratio.
   - `\pad=720:480:(ow-iw)/2:(oh-ih)/2`: Adds padding to the video to ensure it fits within the specified dimensions without cropping. The padding is added symmetrically around the edges.
   - `setsar=1`: Sets the sample aspect ratio to 1:1, which helps in ensuring the correct display of the video without distortion.

**Frame Rate and Pixel Format**:
   ```-r 30000/1001 \ -pix_fmt yuv420p```
   - `-r 30000/1001`: Adjusts the frame rate to NTSC standard (30 FPS) by resampling the frames to fit the required frame rate.
   - `-pix_fmt yuv420p`: Specifies the pixel format as YUV 4:2:0 planar, which is more efficient and widely supported.

**Video Codec and Settings**:
   ```-c:v libx264 -profile:v baseline -level 3.0 \ -preset slow \ -b:v 1500k -maxrate 1500k -bufsize 3000k```
   - `-c:v libx264`: Uses the x264 codec for encoding the video.
   - `-profile:v baseline`: Selects the baseline profile, suitable for most content.
   - `-level 3.0`: Sets the encoding level to 3.0, which continues to provide a balance between quality and compression.
   - `-preset slow`: Uses the slow preset, which optimizes for quality at the expense of speed.
   - `-b:v 1500k`: Sets the constant bitrate for the video to 1500 kbps.
   - `-maxrate 1500k`: Limits the maximum bitrate to 1500 kbps.
   - `-bufsize 3000k`: Sets the buffer size to 3000 kbps, which helps manage memory usage during encoding.  

**Container Header and Metadata**:
   ```-movflags +faststart```
   - `-movflags +faststart`: Encodes the header of the video file early in the file, which helps improve streaming performance.

**Audio Processing**:
   ```-c:a aac -ar 44100 -ac 2 -b:a 128k```
   - `-c:a aac`: Uses the AAC audio codec.
   - `-ar 44100`: Sets the audio sample rate to 44100 Hz.
   - `-ac 2`: Specifies stereo audio.
   - `-b:a 128k`: Sets the bitrate for the audio to 128 kbps.
