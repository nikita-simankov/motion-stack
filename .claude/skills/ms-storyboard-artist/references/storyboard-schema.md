# Storyboard Schema

boards.json is the machine-readable board set. boards.md is the human render. Downstream stages read boards.json.

## boards.json

{
"projectId": "string",
"builtAt": "ISO8601",
"briefVersion": "v1",
"scriptVersion": "v1",
"conceptId": "A",
"fps": 30,
"runtimeFrames": 900,
"density": 3,
"boardCount": 10,
"boards": [
{
"boardId": "B01",
"beatId": "B1",
"frameStart": 0,
"frameEnd": 60,
"durationFrames": 60,
"framing": "full-frame | inset | split | stack | grid | overlay | reveal | isolated",
"subject": "string",
"action": "string",
"motionDirection": "push-in | pull-out | pan | tilt | parallax | morph | track | static",
"transitionIn": "hard-cut | cut-on-action | match-cut | wipe | mask | dissolve | glitch | scale | whip",
"transitionOut": "hard-cut | cut-on-action | match-cut | wipe | mask | dissolve | glitch | scale | whip",
"eyePath": ["string", "string"],
"voText": "string | null",
"onScreenText": "string | null",
"audioNote": "string",
"motionNotes": [
{
"element": "string",
"from": "string",
"to": "string",
"easing": "linear | ease-in | ease-out | ease-in-out | spring | bounce | null",
"frameAnchorStart": 0,
"frameAnchorEnd": 60,
"remotionPrimitive": "interpolate | spring | Sequence | AbsoluteFill | Series | custom"
}
],
"uiMockup": {
"device": "string | null",
"state": "default | hover | active | loading | success | error | null",
"frameDriven": true
},
"remotionSequence": {
"from": 0,
"durationInFrames": 60,
"transitionOut": "hard-cut",
"subSequences": [
{ "from": 0, "durationInFrames": 30, "name": "string" }
]
},
"renderHint": "2d-composition | three-canvas | lottie | remotion-rive-canvas",
"notes": "string"
}
],
"coverage": {
"claimedFrames": 0,
"uncoveredFrames": [],
"overlappingFrames": [],
"orphanBoards": []
},
"densityLog": [
{ "window": "0-10s", "boards": 3, "inRange": true, "reason": null }
]
}

## Rules

- frameStart of B01 is 0. frameEnd of the last board equals runtimeFrames.
- Board frame ranges are contiguous. B*n.frameEnd equals B*(n+1).frameStart.
- remotionSequence.from equals frameStart. remotionSequence.durationInFrames equals durationFrames.
- transitionOut of board N equals transitionIn of board N+1.
- Every motionNotes entry carries a Remotion primitive. No CSS, no Tailwind.
- uiMockup.frameDriven must be true when uiMockup is not null.
- coverage.uncoveredFrames and coverage.overlappingFrames must be empty for gate pass.
- coverage.orphanBoards must be empty.
- densityLog records boards per 10s window. Out-of-range windows require a reason.

## boards.md template

MOTION STUDIO — BOARDS
project-id: <project-id>
concept-id: <conceptId>
script-version: <v>
built-at: <ISO8601>
runtime: <seconds>s / <frames> frames @ <fps>fps
boards: <count>

COVERAGE
claimed: <frames>
uncovered: <none | list>
overlapping: <none | list>
orphans: <none | list>

DENSITY
0-10s 3 in range
10-20s 4 in range
...

BOARDS
B01 frames 0-60 beat B1 full-frame push-in
subject: <subject>
action: <action>
in/out: <in> / <out>
eye: <eyePath>
VO: <voText>
Text: <onScreenText>
Audio: <audioNote>
Motion: - <element>: <from> -> <to> (<easing>, frames <a>-<b>, via <primitive>)
Sequence: from <from>, <duration> frames
Sub: <name>, from <from>, <duration>
UI: <device> / <state>
Render: <renderHint>

B02 ...
