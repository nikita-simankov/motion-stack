# Sound Schema

sfx.json is the machine-readable SFX manifest. sfx.md is the human render. The editor (stage 12) and the finishing suite (stage 14) read sfx.json and the SFX stem.

## sfx.json

{
"projectId": "string",
"builtAt": "ISO8601",
"briefVersion": "v1",
"boardsVersion": "v1",
"tokensVersion": "v1",
"voVersion": "v1",
"fps": 30,
"sfxStem": {
"path": "runs/<id>/audio/sfx-stem.wav",
"hash": "sha256:...",
"durationMs": 0,
"integratedLUFS": -20.0,
"truePeakDBTP": -1.0,
"sampleRate": 48000,
"bitDepth": 24
},
"placements": [
{
"sfxId": "S001",
"boardId": "B01",
"sceneId": "S-B01",
"frameAnchor": 30,
"frameStart": 24,
"frameEnd": 60,
"category": "impact | transition | ui | ambient | accent | riser | stinger | silence",
"function": "landing | bridging | interaction | bed | punctuation | tension | signature | none",
"source": "library | synthesized | client-supplied | silence",
"filePath": "runs/_sfx/impacts/impact-sub-01.wav",
"license": {
"licenseId": "string | null",
"source": "library | client-supplied | synthesized",
"attributionRequired": false,
"attributionText": null,
"clearedBy": "string",
"clearedAt": "ISO8601"
},
"synthesisSpec": {
"type": "sub-drop | riser | tick | sweep | custom",
"params": {},
"generator": "string"
} ,
"loudnessTarget": -14,
"fadeInFrames": 8,
"fadeOutFrames": 12,
"ducked": false,
"duckAmountDb": 0,
"notes": "string"
}
],
"silenceRecords": [
{ "boardId": "B05", "reason": "VO lands the beat; no SFX needed" }
],
"coverage": {
"boardsWithSfx": 0,
"boardsWithSilence": 0,
"boardsUnresolved": []
},
"qa": {
"passed": true,
"codes": [],
"notes": "string"
}
}

## Rules

- Every placement has a boardId in boards.json and a sceneId in scenes.json.
- Every placement has an integer frameAnchor, frameStart, frameEnd.
- Every placement's duration = frameEnd - frameStart, in the range 6 to 300 frames.
- Every placement's category determines its loudness target band.
- Silence is a first-class placement with source: "silence" and function: "none".
- Silence records are separate from placements for reporting.
- Every sourced placement carries a license record.
- Every synthesized placement carries a synthesisSpec.
- ducked and duckAmountDb record whether the placement was ducked against the VO stem.
- coverage.boardsUnresolved must be empty for gate pass.
- qa.codes must be empty for gate pass.

## sfx.md template

MOTION STUDIO — SFX
project-id: <project-id>
built-at: <ISO8601>
boards-version: <v>
tokens-version: <v>
vo-version: <v>
placements: <count>
silences: <count>

STEM
path: runs/<id>/audio/sfx-stem.wav
hash: sha256:...
duration: <ms>
integrated: <LUFS>
true peak: <dBTP>

PLACEMENTS
S001 B01 frame 30 impact landing library -14 LUFS ok
S002 B02 frame 120 transition bridging synthesized -22 LUFS ok
S003 B03 frame 240-268 ui interaction library -22 LUFS ok
...

SILENCE
B05 VO lands the beat; no SFX needed
...

LICENSE
library: <n> placements
synthesized: <n> placements
client: <n> placements

QA
passed: <true|false>
codes: <list>
notes: <string>

NEXT
<approve | revise <notes>>
