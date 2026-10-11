# Cut Schema

distribution.json is the machine-readable distribution manifest. distribution.md is the human render. Stage 17 (ms-social-calendar) reads distribution.json and the distribution pack.

## distribution.json

{
"projectId": "string",
"builtAt": "ISO8601",
"masterVersion": "v1",
"qaVersion": "v1",
"tokensVersion": "v1",
"platforms": [
{
"platform": "linkedin",
"aspect": "16:9",
"width": 1920,
"height": 1080,
"codec": "h264",
"bitrateKbps": 14000,
"durationFrames": 900,
"durationMs": 30000,
"native": true,
"reCutReason": null,
"hook": {
"type": "master | re-cut",
"firstLine": "string",
"frameOneText": "string",
"audioCue": "string"
},
"copy": {
"firstLine": "string",
"captionBody": "string",
"cta": "string",
"hashtags": ["string"]
},
"artifacts": {
"videoPath": "runs/<id>/distribution/linkedin/master.mp4",
"videoHash": "sha256:...",
"burnedPath": "runs/<id>/distribution/linkedin/master-burned.mp4",
"burnedHash": "sha256:...",
"srtPath": "runs/<id>/distribution/linkedin/master.srt",
"srtHash": "sha256:...",
"vttPath": "runs/<id>/distribution/linkedin/master.vtt | null",
"vttHash": "sha256:... | null",
"thumbnailPath": "runs/<id>/distribution/linkedin/thumbnail.png",
"thumbnailHash": "sha256:...",
"metadataPath": "runs/<id>/distribution/linkedin/metadata.json",
"metadataHash": "sha256:..."
},
"integratedLUFS": -14.0,
"truePeakDBTP": -1.0,
"qaCodes": []
}
],
"pack": {
"path": "runs/<id>/distribution/pack.json",
"hash": "sha256:...",
"sha256SumsPath": "runs/<id>/distribution/sha256sums.txt",
"sha256SumsHash": "sha256:..."
},
"determinismCheck": "pass | fail",
"qa": {
"passed": true,
"codes": [],
"notes": "string"
}
}

## Rules

- Every platform in brief.Q4 is represented.
- Every platform's aspect, width, height, codec, and duration match the platform rules.
- native is always true for the cut. A false value is a defect.
- reCutReason is required when the cut's duration differs from the master's.
- hook.type is "master" when the master hook is reused, "re-cut" when adapted.
- copy.firstLine differs across platforms.
- copy.hashtags differ across platforms.
- artifacts includes every required file per platform.
- integratedLUFS and truePeakDBTP match the platform rules.
- qa.codes must be empty for gate pass.
- determinismCheck must be pass for gate pass.

## distribution.md

See references/distribution-report-template.md.
