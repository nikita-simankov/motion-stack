# Caption Pipeline

Caption generation, burned, SRT, VTT.

## Source

Captions come from script.json VO lines, not from transcription. The lines are already aligned to frames by stage 4 and confirmed by stage 9.

Per caption cue:

- text — verbatim from script.json
- frameStart, frameEnd — from script.json
- durationFrames
- characterCount
- cps (characters per second) = characterCount / (durationFrames / fps)

## Splitting rules

- Target: 15-20 cps
- Max: 20 cps
- Max 42 characters per line, 2 lines per cue
- If a line exceeds either, split at a natural break (comma, clause, sentence)
- On split, each half keeps its own frame range; the sum of halves equals the original line's frame range
- No split mid-word
- No split that separates a number from its unit

## Positioning

- Bottom-center default
- Token-defined offset from bottom (default 10% of height)
- Safe area per style-tokens.layout.aspectOverrides
- If a UI element occupies the caption zone, the caption shifts up per the safe area rule
- No caption overlaps a burned-in caption from a UI element

## Styling

- Type role: caption (defined in style-tokens.type)
- Size: 40-56px at 1080p (from token)
- Line height: 1.15x
- Scrim: token-defined (dark box with 60-80% opacity or a drop shadow)
- No text-shadow via CSS; the scrim is a Remotion element
- Fade in and fade out: 4 frames in, 4 frames out (from token)

## SRT output

Format:
1
00:00:00,000 --> 00:00:02,000
Line one
Line two

Rules:

- One index per cue, starting at 1
- Timecodes HH:MM:SS,mmm
- Comma as the decimal separator
- Text verbatim from script.json
- No styling tags unless the platform requires
- UTF-8 encoding, no BOM
- File extension .srt

## VTT output

Format:
WEBVTT

00:00:00.000 --> 00:00:02.000
Line one
Line two

Rules:

- Header WEBVTT on the first line
- Timecodes HH:MM:SS.mmm
- Period as the decimal separator
- Optional STYLE block per the token's caption style
- UTF-8 encoding, no BOM
- File extension .vtt

## Burned-in output

The burned-in master is a separate encode:

1. Enable the caption composition layer in the master.
2. Encode at the same profile as the clean master.
3. Save to master-burned.mp4.
4. Hash and record.

Rules:

- Burned captions never replace the sidecar SRT and VTT. Both are delivered.
- Burned captions use the same text as the sidecar.
- Burned captions respect the safe area.
- Burned captions never obscure the CTA.

## Multi-language

When brief.Q19 is C or D:

- Generate captions in each target language
- SRT and VTT per language
- Burned captions only in the primary language
- Store under deliverables/masters/<aspect>/captions/<lang>/

Rules:

- Multi-language captions use the dubbed audio's alignment when a dubbed stem exists.
- Otherwise, they align to the source VO.

## Verification

Before gate pass:

- Every cue's text matches script.json
- Every cue's cps is <= 20
- Every cue's duration is >= 12 frames
- Every cue's frame range is within runtimeFrames
- SRT and VTT parse without error
- Burned captions visible in the burned master
- No caption overlaps a UI element

## Rejected patterns

- Transcribed captions (transcription introduces errors; use script.json)
- Captions with CSS text-shadow
- Captions longer than 2 lines
- Captions with more than 42 characters per line
- Captions with cps above 20
- Captions that obscure the CTA
- Captions that use fonts not declared in style-tokens.type
