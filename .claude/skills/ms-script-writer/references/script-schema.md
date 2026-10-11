# Script Schema

script.json is the machine-readable script. script.md is the human render. Downstream stages read script.json.

## script.json

{
"projectId": "string",
"builtAt": "ISO8601",
"briefVersion": "v1",
"dossierVersion": "v1",
"conceptId": "A",
"fps": 30,
"runtimeSeconds": 30,
"runtimeFrames": 900,
"wpm": 155,
"hook": {
"visual": "string",
"text": "string",
"audio": "string",
"frameStart": 0,
"frameEnd": 60
},
"beats": [
{
"id": "B1",
"purpose": "hook | proof | objection | landing | cta | connective",
"frameStart": 0,
"frameEnd": 90,
"claimIds": ["C1"],
"vo": {
"text": "string",
"frameStart": 0,
"frameEnd": 90,
"durationFrames": 90,
"wordCount": 12,
"targetWPM": 155,
"estimatedSeconds": 4.6
},
"onScreenText": {
"text": "string",
"frameStart": 10,
"frameEnd": 90
},
"visualNote": "string",
"audioNote": "string"
}
],
"cta": {
"text": "string",
"vo": "string",
"frameStart": 780,
"frameEnd": 900
},
"totalVoLines": 0,
"totalVoWords": 0,
"estimatedVoSeconds": 0.0,
"claimTrace": [
{ "line": "string", "claimId": "C1", "source": "vo | onScreenText" }
],
"connectiveLines": [
{ "line": "string", "reason": "string" }
],
"brandVoiceCheck": {
"passed": true,
"notes": "string",
"checkedAt": "ISO8601"
},
"killLog": [
{ "line": "string", "reason": "time | redundancy | weak | brand" }
]
}

## Rules

- frameStart and frameEnd are integers. Ranges are contiguous across beats, from 0 to runtimeFrames.
- vo.durationFrames = frameEnd - frameStart.
- vo.estimatedSeconds = vo.wordCount / (vo.targetWPM / 60).
- vo.estimatedSeconds _ fps must be <= vo.durationFrames _ 1.10 or the line fails.
- hook.frameStart = 0 and hook.frameEnd <= 60 (or <= 90 for 90s runtime).
- Every beat.claimIds entry must exist in dossier.claims with used = true and confidence in {high, medium}.
- connectiveLines must include every VO line that has no claimIds and is not the CTA.
- brandVoiceCheck.passed must be true for the gate to pass.
- killLog is required, even if empty.

## script.md template

MOTION STUDIO — LOCKED SCRIPT
project-id: <project-id>
concept-id: <conceptId>
built-at: <ISO8601>
runtime: <seconds>s / <frames> frames @ <fps>fps
wpm: <wpm>

HOOK (frames <start>-<end>)
Visual: <visual>
Text: <text>
Audio: <audio>

BEATS
B1 frames <start>-<end> claims <C1,C3> purpose <hook|proof|...>
VO: <vo.text>
Text: <onScreenText.text>
Visual: <visualNote>
Audio: <audioNote>

B2 ...

CTA (frames <start>-<end>)
Text: <text>
VO: <vo>

TRACE
<line> -> <claimId>
...

CONNECTIVE
<line> -> <reason>
...

BRAND VOICE
passed: <true|false>
notes: <notes>

KILLED
<line> -> <reason>
...
