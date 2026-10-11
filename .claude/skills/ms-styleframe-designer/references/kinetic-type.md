# Kinetic Type (token contract v2)

Type that moves is a library of named presets, not per-project improvisation. Implementation: `ms-motion-designer/templates/motion/KineticText.tsx` (copied to `src/motion/` by scaffold). Every preset is frame-driven, takes its curve from `motion.roles`, its stagger from `motion.choreography`, and its type from a `type.roles` entry.

v1 shipped one pattern: every word fades in and rises 20px. It is the generic template look. v2 replaces it.

## Presets

| preset | what moves | when | cost |
|---|---|---|---|
| mask-line | each line rises from 100% to 0% inside an overflow mask, lines stagger | hooks, statements, editorial and authoritative tone | low |
| word-rise | words stagger in with a short rise and opacity | punchy copy, lists of short phrases | low |
| word-lockup | one word lands per VO word, on the VO word's frame, with a slight scale settle | the hook, a claim read aloud; needs `vo.json` word timings | low |
| weight-swell | variable-font weight animates from the role weight up (default +300) | emphasis, brand-forward tone; needs a variable family | low |
| outline-fill | outlined glyphs fill left to right | section titles, stats intro | low |
| number-roll | a number counts to its value, tabular figures | stats, metrics, prices | low |

Presets compose. A hook is typically `word-lockup` for the claim and `number-roll` for the figure.

## Rules

- One preset per text block. A block never mixes two entrance styles.
- `entranceFrames` sits inside a motion bucket (usually short, 12 to 24).
- Lines never reflow. Each line is a string; `maxWidthPx` is explicit. `fit: true` shrinks the size with `fitText()` from `@remotion/layout-utils` so the longest line fits; the font must be loaded first.
- Hold after the entrance settles is at least `max(minHoldFrames, words x readHoldFramesPerWord)`.
- Exit uses the exit role at `exitRatio` of the entrance length. A text block that cuts out on a scene boundary needs no exit.
- Numbers use tabular figures. `number-roll` sets `font-variant-numeric: tabular-nums` itself.
- Do not wrap counting numbers or glyph reveals in `<MotionBlur>`; blur ghosts the digits.
- Per-glyph animation is not in the library. If a concept needs it, the board asks for it at stage 5 and it ships as a new preset, not a one-off.

## Variable fonts

- A family is variable when `type.families[].axes` lists its axes, for example `[{ "tag": "wght", "min": 100, "max": 900 }]`.
- Load with `@remotion/google-fonts` (variable families expose their axes) or self-host a WOFF2 with the axes preserved.
- `weight-swell` writes `font-variation-settings: "wght" N`, with N interpolated per frame. Weights outside the declared axis range are rejected at validation.
- Static families can use every other preset.

## Hierarchy

- Maximum two families per piece (enforced by `validate-tokens.sh`).
- One focal text element per beat. If two text blocks enter together, one must be at least 1.5x the size of the other.
- The expressive `display` role (optional) is oversized, may crop or bleed past the safe area on purpose, and is never used for reading text.

## Token additions

```
type.families[].axes        optional, variable-font axes
type.roles[].role           adds: caption, captionActive, display (optional)
```

Caption roles are specified in `ms-finishing-suite/references/caption-pipeline.md`.

## Anti-patterns

- Fading every word in at the same speed with the same rise
- A different entrance for each of three lines in one block
- A hook that holds for fewer frames than it takes to read
- `font-weight` jumps instead of an axis tween
- Text set in a third family "just for this word"
