# Music Schema

music.json is the machine-readable music manifest. music.md is the human render. The editor (stage 12) and the finishing suite (stage 14) read music.json and the music stem. The cue sheet is the legal artifact.

## music.json

{
"projectId": "string",
"builtAt": "ISO8601",
"briefVersion": "v1",
"boardsVersion": "v1",
"tokensVersion": "v1",
"voVersion": "v1",
"sfxVersion": "v1",
"fps": 30,
"runtimeFrames": 900,
"musicalBrief": {
"mood": "string",
"tempoRange": { "min": 90, "max": 120 },
"keyPreference": "string | null",
"energyArc": "string",
"budgetTier": "lean | standard | premium"
},
"posture": "licensed-track | original-score | no-music | client-provided",
"musicStem": {
"path": "runs/<id>/audio/music-stem.wav",
"hash": "sha256:...",
"durationMs": 0,
"integratedLUFS": -18.0,
"truePeakDBTP": -1.0,
"sampleRate": 48000,
"bitDepth": 24
},
"cues": [
{
"cueId": "M001",
"cueType": "main | intro | transition | drop | hit | out | stinger | silence",
"frameStart": 0,
"frameEnd": 900,
"durationFrames": 900,
"durationMs": 30000,
"source": "library | composed | client-supplied | silence",
"library": "string | null",
"trackTitle": "string",
"trackArtist": "string",
"trackComposer": "string | null",
"trackPublisher": "string | null",
"trackDurationMs": 30000,
"isrc": "string | null",
"usage": "background | feature | stinger",
"offsetMs": 0,
"gainDb": -18,
"duck": {
"ducked": true,
"duckAmountDb": -18,
"sidechainSource": "runs/<id>/audio/vo-stem.wav",
"attackFrames": 8,
"releaseFrames": 24
},
"license": {
"licenseId": "string",
"library": "string",
"territory": "worldwide | string",
"platformScope": ["linkedin", "instagram", "tiktok", "youtube", "x"],
"monetizationAllowed": true,
"contentIdCleared": true,
"expiry": null,
"clearedBy": "string",
"clearedAt": "ISO8601"
},
"notes": "string"
}
],
"cueSheetPath": "runs/<id>/cue-sheet.csv",
"coverage": {
"runtimeCovered": 900,
"runtimeUncovered": 0,
"uncoveredRanges": []
},
"qa": {
"passed": true,
"codes": [],
"notes": "string"
}
}

## Rules

- runtimeCovered + runtimeUncovered = runtimeFrames
- uncoveredRanges must be empty for gate pass unless the run posture is "no-music"
- Every cue has an integer frameStart and frameEnd
- Every cue's durationFrames = frameEnd - frameStart, >= 15
- Every cue's license is valid for every platform in brief.Q4
- Every cue's license expiry is after the video's publication window
- Every cue with monetizationAllowed false fails if the video is monetized
- Every cue without contentIdCleared true fails on YouTube
- duck.duckAmountDb defaults to style-tokens.audio.musicDuckLUFS
- duck.attackFrames and duck.releaseFrames default to 8 and 24
- qa.codes must be empty for gate pass

## music.md template

MOTION STUDIO — MUSIC
project-id: <project-id>
built-at: <ISO8601>
boards-version: <v>
posture: <posture>
cues: <count>

MUSICAL BRIEF
mood: <mood>
tempo: <min>-<max> bpm
key: <key | none>
energy arc: <arc>
budget tier: <tier>

STEM
path: runs/<id>/audio/music-stem.wav
hash: sha256:...
duration: <ms>
integrated: <LUFS>
true peak: <dBTP>

CUES
M001 main frames 0-900 library Epidemic <title> -18 LUFS ducked -18dB
M002 hit frames 660-676 composed in-house <title> -14 LUFS no duck
...

LICENSES
M001 <licenseId> worldwide all platforms monetization: yes ContentID: cleared
M002 original worldwide all platforms monetization: yes ContentID: n/a
...

COVERAGE
covered: <frames>
uncovered: <frames>
ranges: <list>

QA
passed: <true|false>
codes: <list>
notes: <string>

CUE SHEET
<path to cue-sheet.csv>

NEXT
<approve | revise <notes>>
