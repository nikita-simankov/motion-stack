# Style Token Authoring

A token is a spec, not a reference.

## The spec rule

Every token carries a concrete value. Concrete means one of:

- A hex code (#0A0A0A)
- A number with a unit (24px, -0.02em, -14 LUFS)
- A named enum from a fixed list
- An ordered array with a defined length
- A formula with all inputs defined

A token that fails any of these is a reference, and references are rejected.

## Accepted vs rejected tokens

Accepted:

- "accentPrimary": "#3B82F6"
- "trackingEm": -0.02
- "sizePx": 96
- "easings": ["linear", "ease-out", "ease-in", "ease-in-out", "spring", "bounce"]
- "bucket.short": { "minFrames": 12, "maxFrames": 24 }
- "gradientStops": [{ "position": 0.0, "hex": "#0A0A0A" }, { "position": 1.0, "hex": "#1E1E1E" }]

Rejected:

- "accentPrimary": "a nice blue"
- "trackingEm": "tight"
- "sizePx": "large"
- "easings": "smooth"
- "bucket.short": "quick"
- "gradientStops": ["dark", "darker"]
- "vibe": "premium"
- "feel": "cinematic"

## Enumerated ranges

A range is allowed only when both endpoints are defined and the intermediate values are enumerable. "Opacity 0 to 1" is allowed. "Opacity somewhere between 0 and 1" is not.

## Inherited tokens

When --client or --preset supplies tokens:

- Imported tokens are marked with source: "client" or "preset"
- Imported tokens cannot be edited at this gate without an explicit override flag
- Imported tokens that conflict with the platform spec table are flagged and the platform spec wins

## Frozen contract

On gate pass, style-tokens.json.frozen flips to true. From that point:

- No stage may edit a token
- Any downstream deviation triggers GRD-xx or ANIM-xx
- Rollback to stage 6 is required to change a token

## Compatibility checks

Before freeze:

- Every token must be expressible in Remotion. No CSS-only primitives.
- Every type family must load via @remotion/google-fonts or a self-hosted webfont.
- Every easing must map to a Remotion primitive: interpolate (with easing), spring, or custom.
- Every transition must map to a Remotion <TransitionSeries> entry or a Sequence boundary.
- Every audio target must be achievable by the finishing stack.

## Authoring order

1. Palette first — everything else references it
2. Type next — needs the palette for contrast checks
3. Motion language third — needs the transitions from boards
4. Texture and grade fourth — needs the palette and type for reference points
5. UI mockup fifth — needs type, palette, and motion
6. Layout sixth — needs margin and safe area relative to platform aspects
7. Iconography and imagery seventh — depend on palette and type
8. Audio tokens last — depend on brief Q13 and the platform spec

Do not author out of order. Token cross-references break when authored out of sequence.
