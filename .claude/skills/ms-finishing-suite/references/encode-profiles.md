# Encode Profiles

Codec, resolution, bitrate, container per aspect. Matches the platform spec table.

## 9:16

- width 1080, height 1920
- codec h264, profile main, level 4.2
- bitrate 8000-12000 kbps (default 10000)
- container mp4
- audio aac-lc 192 kbps 48kHz stereo
- loudness -14 LUFS, true peak -1 dBTP
- keyframe interval 2s
- faststart on

Platforms: Instagram Reels, TikTok, YouTube Shorts

## 1:1

- width 1080, height 1080
- codec h264, profile main, level 4.2
- bitrate 8000-10000 kbps (default 9000)
- container mp4
- audio aac-lc 192 kbps 48kHz stereo
- loudness -14 LUFS, true peak -1 dBTP
- keyframe interval 2s
- faststart on

Platforms: LinkedIn (feed), Instagram (feed when 1:1 is chosen), X (1:1 option)

## 4:5

- width 1080, height 1350
- codec h264, profile main, level 4.2
- bitrate 8000-10000 kbps (default 9000)
- container mp4
- audio aac-lc 192 kbps 48kHz stereo
- loudness -14 LUFS, true peak -1 dBTP
- keyframe interval 2s
- faststart on

Platforms: LinkedIn (feed), Instagram (feed)

## 16:9

- width 1920, height 1080
- codec h264, profile main, level 4.2
- bitrate 10000-16000 kbps (default 14000)
- container mp4
- audio aac-lc 192 kbps 48kHz stereo
- loudness -14 LUFS, true peak -1 dBTP
- keyframe interval 2s
- faststart on

Platforms: LinkedIn (native), X, YouTube (when 16:9 is used)

## Color metadata

- primaries: bt709
- transfer: bt709
- matrix: bt709
- range: tv (limited)
- pixel format: yuv420p

## Container metadata

- moov atom: at the front (faststart)
- no more than one video and one audio stream
- chapters: none
- subtitles: none in the mp4 (sidecar only)

## Encoder

Local: npx remotion render with the platform codec config
Lambda: npx remotion lambda render with the same config

Rules:

- No two-pass encoding games. Single pass at target bitrate.
- No CBR games. Use VBR with target bitrate and maxrate 1.5x.
- No HDR. SDR only unless the platform spec explicitly requires HDR (none of the target platforms do).
- No interlacing.
- No variable fps.

## Loudness pipeline

1. Encode the video with the mixed audio from the master composition.
2. Measure loudness on the encoded master.
3. If out of spec, apply a finishing loudnorm pass on the audio stream only.
4. Re-mux the audio into the video container without re-encoding the video.
5. Re-measure.

Rule: never re-encode the video to fix loudness. Only the audio is re-encoded.

## Determinism

- The same source with the same encoder config produces the same output.
- Remotion bundles the encoder, so version drift is controlled at the pipeline level.
- Re-encode and compare hashes as part of QA.

## Rejected patterns

- Upscaling below the platform's recommended resolution
- Delivering a resized master instead of a native aspect
- Bitrates above the platform's recommended max (slower upload, no quality gain)
- Bitrates below the platform's recommended min (visible compression)
- Container without faststart
- Audio bitrates below 128 kbps
- Sample rates other than 48kHz
- Mono delivery unless the platform requires it

## Verify

After encode, verify:

- ffprobe read of codec, resolution, fps, bitrate, audio codec, audio bitrate
- Loudness measurement
- Duration equals runtimeFrames / fps
- Keyframe interval within tolerance
- faststart confirmed (moov atom position)
