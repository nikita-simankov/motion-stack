# Caption Variants

Caption adaptation, safe areas, aspect-specific sizing.

## Per aspect

### 9:16 (Instagram Reels, TikTok, YouTube Shorts)

- Safe area: 10% from bottom, 12% from top (platform UI overlaps)
- Text size: 48-56px at 1080p
- Line height: 1.15x
- Max 42 chars per line, 2 lines
- Position: bottom-center, offset from bottom = 10-12% of height

### 1:1 (LinkedIn feed, Instagram feed, X option)

- Safe area: 8% from bottom, 6% from top
- Text size: 44-52px at 1080p
- Line height: 1.15x
- Max 42 chars per line, 2 lines

### 4:5 (LinkedIn feed, Instagram feed)

- Safe area: 8% from bottom, 6% from top
- Text size: 44-52px at 1080p
- Line height: 1.15x
- Max 42 chars per line, 2 lines

### 16:9 (LinkedIn native, X, YouTube standard)

- Safe area: 6% from bottom, 6% from top
- Text size: 40-48px at 1080p
- Line height: 1.15x
- Max 42 chars per line, 2 lines

## Caption sources

- Text: verbatim from script.json
- Anchor: from script.json, re-mapped when the runtime changes
- Style: from style-tokens.type.roles.caption
- Scrim: from style-tokens (dark box with 60-80% opacity, or a shadow)

## Re-anchoring

When the platform cut's runtime differs from the master:

1. Read the original caption cue frame range.
2. Determine the shift from any cut beats before the cue.
3. Apply the shift.
4. Re-verify reading speed.
5. If reading speed > 20 cps, split the cue at a natural break.
6. If reading speed < 12 cps, leave as-is or merge with an adjacent cue.
7. Re-emit the SRT, VTT, and burned captions.

## Reading speed

- Target: 15-20 cps
- Max: 20 cps
- Min: 12 cps (below this, the caption lingers)

## Splitting rules

- Split at a comma, clause, or sentence boundary
- Never split mid-word
- Never split a number from its unit
- Never split a name from its title
- On split, each half keeps its own frame range; the sum equals the original

## Burned captions

- Rendered via the caption composition layer
- Same text as the SRT
- Same safe area as the aspect
- Fade in and out: 4 frames in, 4 frames out (from token)
- Never obscure the CTA
- Never obscure a UI element's critical area

## Sidecar captions

- SRT and VTT per platform
- One file per aspect per language
- UTF-8, no BOM
- Comma as decimal separator in SRT, period in VTT
- File naming: master.srt, master.vtt

## Multi-language

- SRT and VTT per language
- Burned captions in the primary language
- Storage: distribution/<platform>/captions/<lang>/

## Verification

- Text matches script.json verbatim
- cps <= 20
- Duration >= 12 frames
- Frame range within runtime
- SRT and VTT parse without error
- Burned captions visible in the burned master
- No caption obscures the CTA or a critical UI element

## Rejected

- Transcribed captions (use script.json verbatim)
- CSS text-shadow
- Captions longer than 2 lines
- Captions over 42 chars per line
- Captions over 20 cps
- Captions that obscure the CTA
- Captions using fonts not in the tokens
