# Timeline Schema

timeline.json is the machine-readable timeline manifest. timeline.md is the human render. The grade stage (13) and the finishing stage (14) read timeline.json and the master composition.

## timeline.json

{
"projectId": "string",
"builtAt": "ISO8601",
"lockedAt": "ISO8601 | null",
"briefVersion": "v1",
"boardsVersion": "v1",
"scenesVersion": "v1",
"tokensVersion": "v1",
"fps": 30,
"width": 1080,
"height": 1920,
"runtimeFrames": 900,
"runtimeMs": 30000,
"masterCompositionId": "<slug>-master",
"masterSourcePath": "src/Master.tsx",
"masterSourceHash": "sha256:...",
"timeline": [
{
"orderIndex": 1,
"sceneId": "S-B01",
"boardId": "B01",
"compositionId": "<slug>-B01",
"frameStart": 0,
"frameEnd": 60,
"durationFrames": 60,
"transitionIn": "hard-cut",
"transitionOut": "cut-on-action",
"transitionDurationInFrames": 8
}
],
"audioMap": [
{
"stemId": "vo",
"stemPath": "runs/<id>/audio/vo-stem.wav",
"stemHash": "sha256:...",
"startFrom": 0,
"durationMs": 30000,
"notes": "placed at frame 0; anchors inside the stem"
},
{
"stemId": "sfx",
"stemPath": "runs/<id>/audio/sfx-stem.wav",
"stemHash": "sha256:...",
"startFrom": 0,
"durationMs": 30000,
"notes": "placed at frame 0; anchors inside the stem"
},
{
"stemId": "music",
"stemPath": "runs/<id>/audio/music-stem.wav",
"stemHash": "sha256:...",
"startFrom": 0,
"durationMs": 30000,
"notes": "placed at frame 0; anchors inside the stem"
}
],
"mix": {
"voGainDb": 0,
"sfxGainDb": 0,
"musicGainDb": 0,
"masterGainDb": 0
},
"cutList": [
{ "cutIndex": 1, "frame": 60, "fromSceneId": "S-B01", "toSceneId": "S-B02", "transition": "cut-on-action", "durationInFrames": 8 }
],
"coverage": {
"claimedFrames": 0,
"uncoveredFrames": [],
"overlappingFrames": [],
"orphanScenes": []
},
"previewPath": "runs/<id>/previews/master.mp4",
"previewHash": "sha256:...",
"determinismCheck": "pass | fail",
"blockedItems": [],
"locked": false
}

## Rules

- runtimeFrames equals brief.runtime.frames exactly.
- runtimeMs = runtimeFrames / fps \* 1000.
- Every entry in timeline has contiguous frameStart and frameEnd ranges from 0 to runtimeFrames.
- Every transitionOut equals the next entry's transitionIn.
- Every transitionDurationInFrames is within the frozen motion bucket and 6-90.
- Every audioMap entry has startFrom: 0 unless the manifest specifies an offset.
- Every stem's hash matches its source manifest.
- mix.voGainDb, mix.sfxGainDb, and mix.musicGainDb default to 0.
- coverage.uncoveredFrames, overlappingFrames, orphanScenes must be empty for gate pass.
- determinismCheck must be pass for gate pass.
- blockedItems must be empty for gate pass.
- locked flips to true on gate pass.
- masterSourceHash is recorded at lock and cannot change until rollback.

## timeline.md template

MOTION STUDIO — TIMELINE
project-id: <project-id>
built-at: <ISO8601>
locked-at: <ISO8601 | not locked>
boards-version: <v>
scenes-version: <v>
runtime: <seconds>s / <frames> frames @ <fps>fps
master: <masterCompositionId>

TIMELINE

# scene board frames duration in out trans dur

1 S-B01 B01 0-60 60 hard-cut cut-on-action 8
2 S-B02 B02 60-300 240 cut-on-action dissolve 12
3 S-B03 B03 300-450 150 dissolve hard-cut -
...

AUDIO
vo runs/<id>/audio/vo-stem.wav startFrom 0 sha256:...
sfx runs/<id>/audio/sfx-stem.wav startFrom 0 sha256:...
music runs/<id>/audio/music-stem.wav startFrom 0 sha256:...

MIX
vo 0 dB sfx 0 dB music 0 dB master 0 dB

CUTS
1 frame 60 S-B01 -> S-B02 cut-on-action 8 frames
2 frame 300 S-B02 -> S-B03 dissolve 12 frames
...

COVERAGE
claimed: <frames>
uncovered: <none | list>
overlapping: <none | list>
orphans: <none | list>

DETERMINISM
pass | fail

PREVIEW
<path> sha256:...

NEXT
<approve | revise <notes>>
