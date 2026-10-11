# Type System

Type is locked per role with exact values. No role is left to the motion designer's judgment.

## Font loading

- Prefer @remotion/google-fonts for standard families
  Example: import { loadFont } from "@remotion/google-fonts/Inter"
- Self-host webfonts when the client requires a licensed family
- System fallbacks are recorded but never relied on for rendering
- Fallback font stack must be named in the token even when unused

## Roles and required fields

Every role carries:

- familyId (references type.families)
- weight (integer, from the family's available weights)
- sizePx at 1080p (scaled for other resolutions at render time)
- lineHeightPx
- trackingEm
- casing (upper | lower | sentence | title)
- numerals (lining | old-style | tabular)

## Standard role set

### hook

- Heaviest weight available in the display family
- Size dominates the canvas: 84-120px at 1080p for 9:16, 72-96px for 16:9
- Tracking tight: -0.02 to -0.03 em
- Casing: sentence or title, never upper unless the concept is authoritative and plain
- Numerals: tabular

### bodyVO

- Weight 400-500
- Size 28-36px at 1080p
- Line height 1.4-1.5x size
- Tracking 0
- Casing: sentence
- Numerals: tabular (numbers align in stacks)

### onScreenText

- Weight 600-700
- Size 40-56px at 1080p
- Line height 1.15-1.25x
- Tracking -0.01 to -0.02 em
- Casing: sentence
- Numerals: tabular

### uiLabel

- Weight 500
- Size 20-24px at 1080p
- Tracking 0
- Casing: sentence
- Numerals: tabular

### uiValue

- Weight 600
- Size 32-40px at 1080p
- Tabular numerals required
- Casing: sentence

### statNumber

- Display family, heaviest weight
- Size 120-200px at 1080p
- Tracking -0.03 em
- Tabular numerals
- Casing: not applicable

### quote

- Serif family when available, otherwise display family at weight 400-500
- Size 48-64px
- Line height 1.3x
- Tracking 0
- Casing: sentence

### cta

- Same family as hook
- Weight 600-700
- Size 44-56px
- Tracking -0.01 em
- Casing: sentence or title

### lowerThird

- Weight 500-600
- Size 28-36px
- Tracking 0
- Casing: title
- Numerals: tabular

## Rendering rules

- All type is rendered via Remotion components, not CSS text in HTML
- No CSS transitions on type
- No Tailwind animation classes on type
- Per-character or per-word animation uses useCurrentFrame and interpolate, not CSS keyframes
- Text wrapping is intentional: set a max-width in px, never rely on browser auto-wrap

## Accessibility

- Minimum contrast 4.5:1 for bodyVO, onScreenText, uiLabel, uiValue, cta
- Minimum contrast 3:1 for hook and statNumber when used as a hero
- Minimum size 20px at 1080p for anything intended to be read
- No text over busy imagery without a scrim or overlay from the imagery tokens

## Cross-aspect scaling

Base size is defined at 1080p. For other aspects:

- 9:16 at 1080x1920 — size at 1080p width basis, scale 1.0
- 1:1 at 1080x1080 — size at 1080p width basis, scale 1.0
- 16:9 at 1920x1080 — size at 1080p height basis, scale 1.0 for hook and stat, 0.85 for body and ui
- 4:5 at 1080x1350 — size at 1080p width basis, scale 1.0

Record the scale rules in the token set so the finishing stage does not have to guess.
