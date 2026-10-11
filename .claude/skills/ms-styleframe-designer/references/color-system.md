# Color System

Palette is locked as a spec. Every color used anywhere in the run exists in the palette.

## Roles

- background — default canvas
- surface — cards, panels, insets
- textPrimary — primary reading color
- textSecondary — secondary reading color
- textInverse — text on accent or on a light surface
- accentPrimary — primary brand or concept accent
- accentSecondary — secondary accent, used sparingly
- stateSuccess — positive confirmations
- stateWarning — non-blocking alerts
- stateError — blocking failures
- stateInfo — neutral informational
- gradientStops — ordered array with positions

## Contrast minimums

- textPrimary on background: >= 4.5:1
- textPrimary on surface: >= 4.5:1
- textSecondary on background: >= 3:1
- textInverse on accentPrimary: >= 4.5:1
- stateSuccess/Warning/Error/Info on background when used as text: >= 4.5:1
- stateSuccess/Warning/Error/Info on background when used as fills: >= 3:1

Compute with the WCAG relative luminance formula. Reject any palette that fails.

## Palette size

- Minimum: background, surface, textPrimary, textSecondary, accentPrimary
- Maximum: 12 named colors plus 3 gradient stops per gradient, up to 3 gradients
- Beyond 12, the palette is a design system, not a video palette

## Gradients

- Every gradient is enumerated with stops and positions
- No freeform gradients
- No gradient is defined by two colors without positions
- Radials are specified with center, radius, and stops

### Mesh gradients (v2)

- `type: "mesh"` in `palette.gradients[]`: a base colour plus 3 to 5 points, each `{ color, x, y, radiusPct }`.
- Every colour is a palette colour. No freeform colours.
- Points drift on seeded noise: `seed` (string), `amplitudePct`, `framesPerCycle`. Same seed, same result.
- Enumerated like every other gradient: the base and every point colour are listed.
- Contrast is measured against the base colour and each point colour, never "somewhere in the gradient".
- Implementation: `MeshGradient` in `src/motion/`. See `looks.md`.

## Dark and light

- Pick one baseline: dark or light
- The baseline defines background and textPrimary
- The inverse is defined for callouts, not for a mode switch
- No mid-video mode switches unless the concept requires and the boards authorize

## State colors

- Use standard hues when possible: green, amber, red, blue
- Do not use accentPrimary as stateSuccess or stateError
- Do not use textPrimary as a fill color

## Accessibility

- Never signal state by color alone. Pair with an icon or a label.
- Never place textPrimary on accentPrimary without checking contrast.
- Never rely on a gradient for contrast. Contrast is measured against the endpoint colors.

## Drift detection

On any style frame, verify every color used exists in the palette. Any color outside the palette is a GRD-xx defect at stage 15 QA, and it also fails this gate if found in a style frame.

## Output

- Palette table with role, hex, and usage note
- Contrast table with foreground, background, ratio, and pass/fail
- Gradient list with stops and positions
