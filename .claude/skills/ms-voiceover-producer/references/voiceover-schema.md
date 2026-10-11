# Voiceover Schema

vo.json is the machine-readable VO manifest. vo.md is the human render. The sound stage reads vo.json and the VO stem.

## vo.json

{
"projectId": "string",
"builtAt": "ISO8601",
"briefVersion": "v1",
"scriptVersion": "v1",
"fps": 30,
"modelId": "eleven_multilingual_v2",
"voiceId": "string",
"voiceSettings": {
"stability": 0.5,
"similarity_boost": 0.75,
"style": 0.0,
"use_speaker_boost": true
},
"outputFormat": "mp3_44100_128",
"voStem": {
"path": "runs/<id>/audio/vo-stem.wav",
"hash": "sha256:...",
"durationMs": 0,
"integratedLUFS": -16.0,
"truePeakDBTP": -1.0,
"sampleRate": 48000,
"bitDepth": 24
},
"lines": [
{
"lineId": "L1",
"beatId": "B1",
"text": "string",
"frameStart": 0,
"frameEnd": 90,
"targetMs": 3000,
"silence": false,
"wordSource": "elevenlabs-alignment | forced-alignment | none",
"words": [
{ "text": "Stop", "startFrame": 90, "endFrame": 105 }
],
"audio": {
"path": "runs/<id>/audio/lines/L1.wav",
"hash": "sha256:...",
"durationMs": 2960,
"deltaMs": -40
},
"regenerationCount": 0,
"qaCodes": []
}
],
"generationLog": [
{
"lineId": "L1",
"modelId": "eleven_multilingual_v2",
"voiceId": "string",
"generatedAt": "ISO8601",
"characters": 42,
"attempt": 1,
"status": "ok | regen | failed"
}
],
"characterCount": 0,
"costEstimate": { "currency": "USD", "amount": 0.0 },
"licenseOrConsent": {
"type": "pre-made | clone | ai-disclosed",
"consentPath": "string | null",
"disclosureText": "string | null"
},
"dubbed": [
{
"lang": "es",
"stemPath": "runs/<id>/audio/dubbed/es/stem.wav",
"hash": "sha256:...",
"integratedLUFS": -16.0,
"truePeakDBTP": -1.0,
"qaCodes": []
}
],
"qa": {
"passed": true,
"codes": [],
"notes": "string"
}
}

## Rules

- modelId and voiceId are frozen for the run. Changing either invalidates all generated lines.
- Every line's audio.deltaMs = audio.durationMs - targetMs. Overrun if deltaMs > targetMs _ 0.10. Underrun if deltaMs < -targetMs _ 0.40.
- Silence lines have silence: true and no audio entry.
- words (v2): integer frames on the master timeline, ordered, non-overlapping, each inside the line's frameStart to frameEnd, each at least 1 frame. Required when captions.style is word-highlight or word-pop, or when word-lockup is used. wordSource records where the timing came from; none is valid only when no word-level feature is used.
- generationLog records every attempt. Failed attempts are kept.
- qa.codes collects every VO-xx code raised during QA.
- qa.passed is true only when qa.codes is empty.
- licenseOrConsent.type is required. When clone, consentPath is required. When ai-disclosed, disclosureText is required.

## vo.md template

MOTION STUDIO — VOICEOVER
project-id: <project-id>
script-version: <v>
model: <modelId>
voice_id: <voiceId>
settings: stability <s> similarity <sb> style <st> boost <b>
output format: <format>
characters: <count>
cost estimate: <amount> <currency>

STEM
path: runs/<id>/audio/vo-stem.wav
hash: sha256:...
duration: <ms>
integrated: <LUFS>
true peak: <dBTP>

LINES
L1 frames 0-90 target 3000ms actual 2960ms delta -40ms ok
L2 frames 90-210 target 4000ms actual 4380ms delta +380ms OVER
...

DUBBED
es stem.wav hash sha256:... -16 LUFS -1 dBTP ok
...

LICENSE / CONSENT
type: <pre-made | clone | ai-disclosed>
consent: <path | null>
disclosure: <text | null>

QA
passed: <true|false>
codes: <list>
notes: <string>

NEXT
<approve | revise <notes>>
