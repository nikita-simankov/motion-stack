# Styleframe Schema

Two artifacts: styleframes.json (the frame set) and style-tokens.json (the frozen contract). styleframes.md is the human render. style-tokens.json is read by every downstream stage.

## styleframes.json

{
"projectId": "string",
"builtAt": "ISO8601",
"briefVersion": "v1",
"boardsVersion": "v1",
"conceptId": "A",
"families": [
{
"familyId": "F1",
"name": "hook",
"framing": "full-frame | inset | split | stack | grid | overlay | reveal | isolated",
"subjectType": "type-led | ui-led | data-led | image-led | hybrid",
"motionPosture": "static | push-in | parallax | kinetic | cursor-driven | morph",
"boardIds": ["B01"],
"variants": [
{
"variantId": "F1-v1",
"axis": "palette-intensity | type-weight | motion-energy | texture",
"axisValue": "string",
"previewPath": "string",
"notes": "string"
}
],
"selectedVariantId": "F1-v1",
"tokenRefs": ["palette.primary", "type.hook"]
}
],
"coverage": {
"boardsCovered": 0,
"boardsUncovered": [],
"orphanFamilies": []
},
"driftCheck": {
"passed": true,
"deviations": []
}
}

## style-tokens.json

Current contract: `tokenVersion: 2`. The block below is the v1 base shape, which every v2 file still contains. The v2 additions follow it. Files without `tokenVersion` are v1 (see `token-migration-v1-to-v2.md`).

{
"projectId": "string",
"frozenAt": "ISO8601",
"frozenBy": "string",
"frozen": true,
"palette": {
"background": "#0A0A0A",
"surface": "#141414",
"textPrimary": "#F5F5F5",
"textSecondary": "#A3A3A3",
"textInverse": "#0A0A0A",
"accentPrimary": "#3B82F6",
"accentSecondary": "#F59E0B",
"stateSuccess": "#10B981",
"stateWarning": "#F59E0B",
"stateError": "#EF4444",
"stateInfo": "#3B82F6",
"gradientStops": [
{ "position": 0.0, "hex": "#0A0A0A" },
{ "position": 1.0, "hex": "#1E1E1E" }
]
},
"type": {
"families": [
{ "id": "display", "family": "Inter", "source": "@remotion/google-fonts", "fallback": "system-ui" },
{ "id": "mono", "family": "JetBrains Mono", "source": "@remotion/google-fonts", "fallback": "ui-monospace" }
],
"roles": [
{
"role": "hook",
"familyId": "display",
"weight": 700,
"sizePx": 96,
"lineHeightPx": 100,
"trackingEm": -0.02,
"casing": "sentence",
"numerals": "tabular"
},
{
"role": "onScreenText",
"familyId": "display",
"weight": 600,
"sizePx": 48,
"lineHeightPx": 56,
"trackingEm": -0.01,
"casing": "sentence",
"numerals": "tabular"
}
]
},
"motion": {
"buckets": [
{ "name": "micro", "minFrames": 6, "maxFrames": 12 },
{ "name": "short", "minFrames": 12, "maxFrames": 24 },
{ "name": "medium", "minFrames": 24, "maxFrames": 45 },
{ "name": "long", "minFrames": 45, "maxFrames": 90 }
],
"easings": ["linear", "ease-out", "ease-in", "ease-in-out", "spring", "bounce"],
"transitionSet": ["hard-cut", "cut-on-action", "match-cut", "wipe", "mask", "dissolve", "glitch", "scale", "whip"]
},
"texture": {
"grain": { "intensity": 0.08, "animated": true, "blendMode": "overlay" },
"halation": { "threshold": 200, "radiusPx": 4, "intensity": 0.25 },
"chromaticAberration": { "offsetPx": 1, "mode": "radial" },
"vignette": { "intensity": 0.15, "radiusPct": 70 }
},
"grade": {
"targetGamma": "sRGB",
"targetGamut": "Rec.709",
"lutId": "string | null",
"contrastCurve": [
{ "in": 0.0, "out": 0.0 },
{ "in": 0.25, "out": 0.22 },
{ "in": 0.75, "out": 0.78 },
{ "in": 1.0, "out": 1.0 }
],
"blackPoint": 0,
"whitePoint": 255,
"highlightRolloff": "soft | hard"
},
"audio": {
"integratedLUFS": -14,
"truePeakDBTP": -1,
"voLUFS": -16,
"musicDuckLUFS": -18,
"sfxLUFS": -20,
"fadeInFrames": 6,
"fadeOutFrames": 12
},
"uiMockup": {
"device": {
"widthPx": 1080,
"heightPx": 2340,
"cornerRadiusPx": 48,
"bezelPx": 12,
"shadow": "0 24px 60px rgba(0,0,0,0.45)"
},
"states": ["default", "hover", "active", "loading", "success", "error", "disabled"],
"cursor": {
"sizePx": 24,
"shape": "arrow | dot | custom",
"blendMode": "normal | difference",
"easing": "ease-in-out"
},
"spacingBasePx": 8
},
"layout": {
"grid": "12-column",
"marginPx": 64,
"safeAreaPct": 8,
"aspectOverrides": [
{ "aspect": "9:16", "marginPx": 48, "safeAreaPct": 10 },
{ "aspect": "1:1", "marginPx": 56, "safeAreaPct": 9 }
]
},
"iconography": {
"strokePx": 2,
"cornerRadiusPx": 4,
"fillRule": "outline | fill | mixed",
"sizeScalePx": [16, 24, 32, 48]
},
"imagery": {
"treatment": "duotone | overlay | none",
"overlayHex": "#0A0A0A",
"overlayOpacity": 0.4,
"cropRule": "center | rule-of-thirds | subject-locked"
},
"frozen": true
}

## style-tokens.json: v2 additions (tokenVersion 2)

Add to the base shape above. Values shown are the defaults in `ms-setup/tokens-v2-defaults.json` (punchy tone).

{
"tokenVersion": 2,
"migratedFrom": null,
"reapprovalRequired": false,
"look": { "bundleId": "dark-product-ui", "source": "bundle | override | migrated" },
"palette": {
"gradients": [
{ "id": "bg-mesh", "type": "mesh", "base": "#0A0A0A",
"points": [{ "color": "#3B82F6", "x": 20, "y": 25, "radiusPct": 55 }],
"seed": "bg-mesh-1", "amplitudePct": 12, "framesPerCycle": 90 }
]
},
"type": {
"families": [{ "id": "display", "family": "Inter", "source": "@remotion/google-fonts", "fallback": "system-ui",
"axes": [{ "tag": "wght", "min": 100, "max": 900 }] }],
"roles": [
{ "role": "caption", "familyId": "display", "weight": 700, "sizePx": 44, "lineHeightPx": 52, "trackingEm": -0.01, "casing": "sentence", "numerals": "tabular" },
{ "role": "captionActive", "familyId": "display", "weight": 700, "sizePx": 44, "lineHeightPx": 52, "trackingEm": -0.01, "casing": "sentence", "numerals": "tabular" }
]
},
"motion": {
"tone": "authoritative | punchy | measured | kinetic | playful",
"aliases": { "ease-out": "out-cubic", "ease-in": "in-cubic", "ease-in-out": "in-out-cubic" },
"curves": { "out-expo": [0.16, 1, 0.3, 1], "in-expo": [0.7, 0, 0.84, 0], "in-out-quart": [0.76, 0, 0.24, 1] },
"springs": { "land": { "damping": 12, "stiffness": 180, "mass": 0.6 }, "snappy": { "damping": 20, "stiffness": 200, "mass": 0.6 } },
"roles": { "entrance": "out-expo", "exit": "in-expo", "state": "in-out-quart", "camera": "in-out-quart", "cursor": "out-quart" },
"choreography": {
"exitRatio": 0.65,
"staggerStepFrames": { "min": 2, "max": 6 },
"staggerCapFrames": 20,
"overlapPct": 65,
"readHoldFramesPerWord": 10,
"minHoldFrames": 24,
"settleFrames": { "min": 8, "max": 24 },
"overshootMaxPct": 12
},
"motionBlur": { "enabled": true, "component": "CameraMotionBlur", "shutterAngle": 180, "samples": 6, "appliesTo": ["whip", "scale", "push-in"] }
},
"captions": {
"style": "cue | word-highlight | word-pop",
"maxWordsPerPage": 4,
"breakOnGapFrames": 9,
"fadeFrames": 4,
"activeColorRole": "accentPrimary",
"scrim": { "colorRole": "background", "opacity": 0.7 },
"safeZoneRef": "platform-specs.md#vertical-9-16",
"wordTimingSource": "vo.json:lines[].words"
},
"camera": { "rig": true, "maxZoom": 1.25, "parallaxDepths": [-0.5, 0, 1, 2], "depthBlur": { "enabled": false, "blurPerDepthPx": 2, "maxBlurPx": 10 } },
"rhythm": { "beatGrid": { "snapFrames": 2, "required": false }, "audioReactive": { "enabled": false, "smoothingFrames": 3 }, "maxStaticFrames": 45 },
"surface": { "glass": { "enabled": false, "blurPx": 24, "tintOpacity": 0.12, "borderOpacity": 0.18 } },
"texture": {
"halftone": { "enabled": false, "cellPx": 6, "intensity": 0.2 },
"paper": { "enabled": false, "intensity": 0.1 },
"lightLeak": { "enabled": false, "intensity": 0.35 }
},
"layout": {
"grid": { "columns": 12, "gutterPx": 24, "baselinePx": 8 },
"focalPoint": "rule-of-thirds | center | golden",
"aspectOverrides": [{ "aspect": "9:16", "marginPx": 48, "safeAreaPct": 10,
"platformInsetsPx": { "top": 260, "bottom": 380, "left": 60, "right": 120 } }]
},
"uiMockup": {
"cursor": { "curve": "out-quart", "path": "smoothed" },
"smartZoom": { "enabled": true, "maxZoom": 1.6, "followLagFrames": 10, "transitionFrames": 18 },
"typing": { "cadenceFrames": { "min": 2, "max": 4 }, "seed": "typing" }
},
"loop": { "enabled": false, "matchFrames": 6 }
}

## Rules

- style-tokens.json.frozen flips to true only on gate pass.
- Every token carries a concrete value. No token says "like" or "feels".
- Every color used in styleframes.json exists in palette.
- Every type role used in boards exists in type.roles.
- Every motion note in boards.json maps to a bucket and an easing in motion.
- Every transition in boards.json exists in motion.transitionSet.
- audio targets must match the platform spec table for the primary platform. If they differ, the platform spec wins.
- uiMockup section is required when brief Q8 is C or D. It can be null when Q8 is A or B.
- layout.aspectOverrides covers every aspect in the brief's platform set.
- v2: every curve is `[x1, y1, x2, y2]` with x1 and x2 in 0..1; every motion role, alias target and listed easing resolves to a declared curve, `linear`, or `spring`.
- v2: every spring has damping, stiffness and mass above zero, and overshoots no more than `choreography.overshootMaxPct`.
- v2: `out-back`, the `bouncy` spring and the `bounce` easing exist only when `motion.tone` is playful.
- v2: at most two type families; a `caption` role exists; `captions.style` is one of cue, word-highlight, word-pop.
- v2: `layout.grid` is an object, and every aspect override carries `platformInsetsPx`.
- v2: a file with `reapprovalRequired: true` is never `frozen: true`.
- `ms-setup/validate-tokens.sh` enforces every v2 rule above before the gate is presented.

## styleframes.md template

MOTION STUDIO — STYLE FRAMES
project-id: <project-id>
built-at: <ISO8601>
boards-version: <v>
families: <count>
variants: <count>

COVERAGE
boards covered: <n>/<total>
boards uncovered: <none | list>
orphan families: <none | list>

DRIFT CHECK
passed: <true|false>
deviations: <none | list>

FAMILIES
F1 hook full-frame type-led push-in
boards: B01
variants:
F1-v1 palette-intensity high <preview path> selected
F1-v2 palette-intensity low <preview path>
tokens: palette.primary, type.hook, motion.medium, motion.roles.entrance

F2 ...

STYLE TOKENS

  <summary of frozen token sections>

NEXT
<approve | revise <notes>>
