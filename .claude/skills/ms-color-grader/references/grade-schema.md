# Grade Schema

grade.json is the machine-readable grade manifest. grade.md is the human render. Stage 14 reads grade.json.

## grade.json

{
"projectId": "string",
"builtAt": "ISO8601",
"timelineVersion": "v1",
"tokensVersion": "v1",
"masterSourceHash": "sha256:...",
"inputColorspace": "sRGB",
"outputGamma": "sRGB",
"outputGamut": "Rec.709",
"lutId": "string | null",
"lutHash": "sha256:... | null",
"operations": [
{
"operationId": "OP01",
"type": "grain",
"order": 1,
"params": { "intensity": 0.08, "animated": true, "blendMode": "overlay" },
"tolerance": { "intensity": 0.02 },
"measured": { "intensity": 0.081 }
},
{
"operationId": "OP02",
"type": "halation",
"order": 2,
"params": { "threshold": 200, "radiusPx": 4, "intensity": 0.25 },
"tolerance": { "intensity": 0.0125, "radiusPx": 1 },
"measured": { "intensity": 0.248, "radiusPx": 4 }
},
{
"operationId": "OP03",
"type": "chromaticAberration",
"order": 3,
"params": { "offsetPx": 1, "mode": "radial" },
"tolerance": { "offsetPx": 0.1 },
"measured": { "offsetPx": 1.0 }
},
{
"operationId": "OP04",
"type": "vignette",
"order": 4,
"params": { "intensity": 0.15, "radiusPct": 70 },
"tolerance": { "intensity": 0.01, "radiusPct": 2 },
"measured": { "intensity": 0.152, "radiusPct": 70 }
},
{
"operationId": "OP05",
"type": "contrastCurve",
"order": 5,
"params": {
"anchors": [
{ "in": 0.00, "out": 0.00 },
{ "in": 0.25, "out": 0.22 },
{ "in": 0.75, "out": 0.78 },
{ "in": 1.00, "out": 1.00 }
]
},
"tolerance": { "anchorDelta": 0.005 },
"measured": { "anchorDeltaMax": 0.003 }
},
{
"operationId": "OP06",
"type": "lut",
"order": 6,
"params": { "lutId": "string", "strength": 1.0 },
"tolerance": { "strength": 0.0 },
"measured": { "strength": 1.0 }
},
{
"operationId": "OP07",
"type": "blackClamp",
"order": 7,
"params": { "blackPoint": 0 },
"tolerance": { "value": 1 },
"measured": { "value": 0 }
},
{
"operationId": "OP08",
"type": "whiteClamp",
"order": 8,
"params": { "whitePoint": 255 },
"tolerance": { "value": 1 },
"measured": { "value": 255 }
},
{
"operationId": "OP09",
"type": "rolloff",
"order": 9,
"params": { "mode": "soft" },
"tolerance": {},
"measured": {}
},
{
"operationId": "OP10",
"type": "outputTransform",
"order": 10,
"params": { "targetGamma": "sRGB", "targetGamut": "Rec.709" },
"tolerance": {},
"measured": {}
}
],
"paletteContrast": [
{
"role": "textPrimary",
"fgHex": "#F5F5F5",
"bgRole": "background",
"bgHex": "#0A0A0A",
"ratio": 18.2,
"minimum": 4.5,
"pass": true
}
],
"blackPointMeasured": 0,
"whitePointMeasured": 255,
"previewPath": "runs/<id>/previews/grade.mp4",
"previewHash": "sha256:...",
"determinismCheck": "pass | fail",
"qa": {
"passed": true,
"codes": [],
"notes": "string"
}
}

## Rules

- operations are ordered 1..N and match the fixed pipeline order.
- Every operation's measured value is within its tolerance.
- paletteContrast lists every palette color used in the picture; all must pass.
- blackPointMeasured within 1 of token blackPoint.
- whitePointMeasured within 1 of token whitePoint.
- lutHash is required when lutId is set.
- determinismCheck must be pass for gate pass.
- qa.codes must be empty for gate pass.

## grade.md template

MOTION STUDIO — GRADE
project-id: <project-id>
built-at: <ISO8601>
timeline-version: <v>
tokens-version: <v>
master-hash: sha256:...
input colorspace: <sRGB | Rec.709 | ...>
output gamma: <target>
output gamut: <target>
lut: <lutId | none>

OPERATIONS

# type params measured status

1 grain intensity 0.08, animated, overlay 0.081 ok
2 halation threshold 200, radius 4, intensity 0.25 0.248, 4 ok
3 chromaticAberration offset 1, radial 1.0 ok
4 vignette intensity 0.15, radius 70 0.152, 70 ok
5 contrastCurve 4 anchors 0.003 max ok
6 lut <lutId> strength 1.0 1.0 ok
7 blackClamp 0 0 ok
8 whiteClamp 255 255 ok
9 rolloff soft - ok
10 outputTransform sRGB / Rec.709 - ok

PALETTE CONTRAST
textPrimary #F5F5F5 on #0A0A0A ratio 18.2 min 4.5 pass
textSecondary #A3A3A3 on #0A0A0A ratio 7.2 min 3.0 pass
...

BLACK / WHITE
black measured: 0 token: 0 delta 0
white measured: 255 token: 255 delta 0

DETERMINISM
pass | fail

PREVIEW
<path> sha256:...

QA
passed: <true|false>
codes: <list>
notes: <string>

NEXT
<approve | revise <notes>>
