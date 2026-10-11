# Master Schema

master.json is the machine-readable master manifest. master.md is the human render. Stage 15 (QA) and stage 16 (distribution) read master.json.

## master.json

{
"projectId": "string",
"builtAt": "ISO8601",
"deliveredAt": "ISO8601 | null",
"timelineVersion": "v1",
"gradeVersion": "v1",
"tokensVersion": "v1",
"fps": 30,
"runtimeFrames": 900,
"runtimeMs": 30000,
"masters": [
{
"masterId": "M-9x16",
"aspect": "9:16",
"width": 1080,
"height": 1920,
"codec": "h264",
"profile": "main",
"level": "4.2",
"bitrateKbps": 10000,
"container": "mp4",
"audioCodec": "aac-lc",
"audioBitrateKbps": 192,
"audioSampleRate": 48000,
"audioChannels": 2,
"integratedLUFS": -14.0,
"truePeakDBTP": -1.0,
"loudnessRangeLU": 0,
"durationFrames": 900,
"durationMs": 30000,
"path": "runs/<id>/deliverables/masters/9x16/master.mp4",
"hash": "sha256:...",
"burnedPath": "runs/<id>/deliverables/masters/9x16/master-burned.mp4",
"burnedHash": "sha256:...",
"srtPath": "runs/<id>/deliverables/masters/9x16/master.srt",
"srtHash": "sha256:...",
"vttPath": "runs/<id>/deliverables/masters/9x16/master.vtt",
"vttHash": "sha256:...",
"thumbnailPath": "runs/<id>/deliverables/masters/9x16/thumbnail.png",
"thumbnailHash": "sha256:...",
"platforms": ["linkedin", "instagram", "tiktok", "youtube"],
"qaCodes": []
}
],
"slate": {
"path": "runs/<id>/deliverables/slate.mp4",
"hash": "sha256:...",
"format": "mp4 | png"
},
"thumbnails": {
"autoExtracted": [
{ "frame": 45, "path": "runs/<id>/deliverables/thumbnails/frame-0045.png", "hash": "sha256:..." }
],
"designed": {
"path": "runs/<id>/deliverables/thumbnails/designed.png",
"hash": "sha256:...",
"sourcePath": "src/thumbnails/Designed.tsx"
},
"chosen": "runs/<id>/deliverables/masters/9x16/thumbnail.png"
},
"metadata": {
"path": "runs/<id>/deliverables/metadata.json",
"hash": "sha256:...",
"title": "string",
"description": "string",
"tags": ["string"],
"hashtags": ["string"],
"attribution": ["string"],
"disclosures": ["string"]
},
"cueSheetPath": "runs/<id>/deliverables/cue-sheet.csv",
"cueSheetHash": "sha256:...",
"licenseSummaryPath": "runs/<id>/deliverables/license-summary.json",
"licenseSummaryHash": "sha256:...",
"packagePath": "runs/<id>/deliverables/package.json",
"packageHash": "sha256:...",
"sha256SumsPath": "runs/<id>/deliverables/sha256sums.txt",
"sha256SumsHash": "sha256:...",
"determinismCheck": "pass | fail",
"qa": {
"passed": true,
"codes": [],
"notes": "string"
}
}

## Rules

- One master entry per aspect in the platform set.
- Every master matches its platform spec on codec, resolution, aspect, bitrate, and loudness.
- Every master has a burned-caption variant, an SRT, and a VTT.
- Every master's durationFrames equals runtimeFrames.
- Every master's hash matches the file on disk.
- Slate, thumbnails, metadata, cue sheet, license summary, and package are all present.
- sha256sums.txt lists every deliverable with its hash.
- determinismCheck must be pass for gate pass.
- qa.codes must be empty for gate pass.

## master.md template

MOTION STUDIO — MASTERS
project-id: <project-id>
built-at: <ISO8601>
delivered-at: <ISO8601 | not delivered>
runtime: <seconds>s / <frames> frames @ <fps>fps
masters: <count>

MASTERS
M-9x16 1080x1920 h264 main 4.2 10000 kbps -14 LUFS -1 dBTP sha256:...
M-1x1 1080x1080 h264 main 4.2 9000 kbps -14 LUFS -1 dBTP sha256:...
M-16x9 1920x1080 h264 main 4.2 14000 kbps -14 LUFS -1 dBTP sha256:...

CAPTIONS
9:16 burned + srt + vtt sha256:...
1:1 burned + srt + vtt sha256:...
16:9 burned + srt + vtt sha256:...

THUMBNAILS
auto: frame 45, 420, 780 sha256:...
designed: <path> sha256:...
chosen: 9x16 thumbnail

SLATE
<path> sha256:...

METADATA
title: <title>
description: <first 80 chars>
tags: <count>
hashtags: <count>
attribution: <count>
disclosures: <count>

PACKAGE
package.json sha256:...
sha256sums.txt sha256:...
cue-sheet.csv sha256:...
license-summary sha256:...

QA
passed: <true|false>
codes: <list>
notes: <string>

NEXT
<approve | revise <notes>>
