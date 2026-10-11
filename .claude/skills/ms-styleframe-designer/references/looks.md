# Looks, Layout and Surfaces (token contract v2)

A look is a bundle of token values chosen together, so palette, type, motion, texture, layout and captions agree. A bundle is a starting point for gate 6. It is written into `style-tokens.json` as concrete values, and `look.bundleId` records where they came from.

v1 locked individual tokens and left coherence to the designer. v2 adds the bundles, a layout system, and a surface vocabulary.

## Bundles

Bundles map to intake Q7. Pick one, then adjust at gate 6; adjusted values are marked `source: "override"`.

| bundleId | Q7 | palette archetype | type | motion | texture | layout | captions |
|---|---|---|---|---|---|---|---|
| editorial-clean | A | light baseline, one accent, generous space | high-contrast display plus a quiet text family | measured: out-quart, in-cubic, no blur | none, grain 0 | 12 columns, 64px margin, thirds | cue |
| brand-native | B | client tokens as imported | client families | per tone | per client | per client | per tone |
| cinematic-grain | C | dark baseline, one warm and one cool accent | one display family, light weights | measured to punchy; in-out-expo camera, blur on | grain 0.10, halation 0.25, vignette 0.2, optional light leak | camera rig, 2 to 3 parallax layers | word-highlight |
| kinetic-graphic | D | dark or saturated baseline, high contrast, 3 to 4 colours | heavy display family, tight tracking | punchy: out-expo, in-expo, snappy springs, blur on | grain 0.05 | big type, tight grid, hard cuts | word-pop or word-highlight |
| dark-product-ui | B or C with Q8 C/D | near-black baseline, one brand accent, soft glow | neutral grotesque plus mono for data | punchy: out-expo, snappy | grain 0.04 | device frame, smart zoom, glass panels | word-highlight |
| tactile-analog | C or D | warm paper baseline, ink and one spot colour | serif display plus a grotesque | measured: out-quart, soft springs | paper 0.10, halftone 0.20, grain 0.08 | 8 columns, 48px margin, offset-aligned | cue |

Bundle values are concrete when applied. They are token defaults, not taste statements. Brand-native does not override client tokens.

Bundle selection rules:

- Authoritative tone: editorial-clean, brand-native, or dark-product-ui.
- Measured tone: editorial-clean, cinematic-grain, tactile-analog.
- Punchy tone: kinetic-graphic, dark-product-ui, brand-native.
- Kinetic tone: kinetic-graphic.
- A bundle that fights the tone is flagged at the gate, not silently accepted.

## Layout system

```
layout.grid                 { columns, gutterPx, baselinePx }   e.g. { 12, 24, 8 }
layout.marginPx             outer margin
layout.safeAreaPct          percentage safe area (v1)
layout.focalPoint           rule-of-thirds | center | golden
layout.aspectOverrides[]    { aspect, marginPx, safeAreaPct, platformInsetsPx }
```

- Everything snaps to the baseline: spacing is a multiple of `baselinePx`.
- Each beat has one focal element placed on a focal point (a thirds intersection by default). Secondary elements align to grid columns, not to the canvas centre by accident.
- `platformInsetsPx` carries the per-platform UI overlay insets for that aspect (see `ms-command/references/platform-specs.md`). For 9:16 the universal default is top 260, bottom 380, left 60, right 120. Captions, CTAs and any text a viewer must read stay inside the inset box. Decorative layers may bleed.

## Surfaces

Optional token groups. Each is `enabled: false` until a bundle or the designer turns it on.

### Mesh gradient

A palette-only gradient whose control points drift on seeded noise. Added to `palette.gradients[]`:

```
{ "id": "bg-mesh", "type": "mesh", "base": "<palette hex>",
  "points": [{ "color": "<palette hex>", "x": 20, "y": 25, "radiusPct": 55 }, ...],
  "seed": "bg-mesh-1", "amplitudePct": 12, "framesPerCycle": 90 }
```

- Every colour is a palette colour. 3 to 5 points. `seed` makes it deterministic.
- Implementation: `MeshGradient.tsx`, built on `noise2D(seed, x, y)` from `@remotion/noise`.
- Contrast is measured against the base and the point colours, never "somewhere in the gradient".

### Glass and blur panels

```
surface.glass { enabled, blurPx, tintOpacity, borderOpacity }   e.g. { true, 24, 0.12, 0.18 }
```

Used for UI panels over a mesh or image. Text on glass meets the 4.5:1 minimum against the worst-case backdrop colour.

### Texture additions

```
texture.halftone   { enabled, cellPx, intensity }
texture.paper      { enabled, intensity }
texture.lightLeak  { enabled, intensity }
```

- Light leaks come from Remotion's `lightLeak()` in `@remotion/effects`. The older `@remotion/light-leaks` package is deprecated; do not add it. Verify the import path against the pinned Remotion version at scaffold.
- Texture still applies at stage 13 in the fixed order (texture, grade, rolloff, output). New textures slot into the texture step.

## What not to do

- Mixing two bundles in one piece
- A mesh gradient with colours outside the palette
- Glass over a busy photo with no scrim
- Decorative texture on UI mockup content (the product must read as clean)
- A look that depends on a CSS filter in the scene (grade filters are applied at stage 13 only)
