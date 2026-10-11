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

## Styles (token contract v2)

`style-tokens.captions.style` selects one of three styles. The text is always the script text.

- cue — the whole cue appears at once. Authoritative and measured tone, and the sidecar files in every case.
- word-highlight — words appear grouped in pages of at most `captions.maxWordsPerPage` (4 by default). Spoken words are full strength, the current word takes the `captionActive` role (the accent colour), upcoming words are dimmed.
- word-pop — as word-highlight, and each word scales 0.9 to 1.0 over 5 frames as it is spoken. Playful tone.

Word-level styles read `vo.json` `lines[].words` (integer frames; see `ms-voiceover-producer/references/line-generation.md`). Pages break when a word ends a sentence, when the page is full, or when the gap to the next word is at least `captions.breakOnGapFrames` (9). Implementation: `WordCaptions` and `pageWords` in `src/motion/WordCaptions.tsx`; paging is computed in frames so cues land exactly on the VO.

SRT and VTT sidecars stay cue-level whatever the burned style is.

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
- Bottom edge at least `platformInsetsPx.bottom` above the canvas edge (380px for 9:16 by default); left and right insets from the same token. See `ms-command/references/platform-specs.md`.
- Token-defined offset from bottom for other aspects (default 10% of height)
- Safe area per style-tokens.layout.aspectOverrides
- If a UI element occupies the caption zone, the caption shifts up per the safe area rule
- No caption overlaps a burned-in caption from a UI element

## Styling

- Type roles: caption, and captionActive for the current word (defined in style-tokens.type)
- Size: 40-56px at 1080p (from token)
- Line height: 1.15x
- Scrim: token-defined (dark box with 60-80% opacity or a drop shadow)
- No text-shadow via CSS; the scrim is a Remotion element
- Fade in and fade out: `captions.fadeFrames` (4) in, the same out
- Scrim colour and opacity from `captions.scrim` (a palette role plus opacity)

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
- Word-level styles: every word frame equals the `vo.json` word frame (CAP-01), every page has at most `maxWordsPerPage` words (CAP-04), the burned style equals `captions.style` (CAP-03)
- Every caption sits inside the platform insets (CAP-02)

## Rejected patterns

- Transcribed captions (transcription introduces errors; use script.json for the text and the VO alignment for word timing)
- Word timing guessed by splitting a cue evenly
- Captions with CSS text-shadow
- Captions longer than 2 lines
- Captions with more than 42 characters per line
- Captions with cps above 20
- Captions that obscure the CTA
- Captions that use fonts not declared in style-tokens.type
