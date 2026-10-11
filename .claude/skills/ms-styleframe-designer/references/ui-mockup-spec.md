# UI Mockup Spec

Required when brief Q8 is C (high-fidelity UI) or D (full product demo). Buildable as Remotion React components.

## Device frame

- widthPx, heightPx
- cornerRadiusPx
- bezelPx
- shadow — CSS box-shadow syntax as a spec string (used only inside Remotion components, not as a CSS transition)
- optional notch or dynamic island spec

Default: 1080x2340, radius 48, bezel 12, shadow 0 24px 60px rgba(0,0,0,0.45)

## Interaction states

Required states:

- default
- hover
- active
- loading
- success
- error
- disabled

Each state is a separate style frame board when Q8 is D. For Q8 C, states are variants within a family.

Each state carries:

- stateId
- frame anchor (when the state begins)
- visual spec (color roles, opacity, borders, shadows)
- transitionIn — from prior state, with bucket and easing
- transitionOut — to next state, with bucket and easing

## State transitions

- Frame-driven, implemented via useCurrentFrame comparison, not CSS
- Frame anchors are exact integers
- A transition is a motion note with a bucket and an easing
- No CSS transition properties anywhere in the mockup

## Cursor

- sizePx (default 24)
- shape arrow | dot | custom
- blendMode normal | difference
- easing ease-in-out (default, v1)
- v2: `curve` (default out-quart, the `cursor` role) and `path: smoothed`: each leg of the path eases with the curve, and a small overshoot comes from the curve choice, not from hand-tuned positions
- movement implemented via interpolate for position; click events via frame thresholds; click feedback is the `snappy` spring

## Smart zoom (v2)

`uiMockup.smartZoom`: `{ enabled, maxZoom (1.6), followLagFrames (10), transitionFrames (18) }`. The camera follows the cursor with lag and zooms into the control being used, then back out to the result. See `ms-motion-designer/references/camera-rig.md`.

## Typing (v2)

`uiMockup.typing`: `{ cadenceFrames: { min, max }, seed }`. Characters arrive at a seeded irregular cadence so typing reads as human. The seed is a constant; same seed, same cadence.

## Typography inside UI

- Inherits from type.roles
- UI-specific overrides allowed: uiLabel, uiValue
- No new font families inside the UI unless declared in type.families

## Spacing grid

- basePx 4 | 8 | 12 (default 8)
- all internal spacing is a multiple of basePx

## Imagery inside UI

- Screenshots are treated per imagery tokens (duotone, overlay, none)
- Avatars, icons, and illustrations follow iconography tokens
- Real product data is never used; use plausible placeholder copy approved by the client

## Buildability check

Before gate pass, verify every UI mockup board is buildable as:

- A React component in Remotion
- With a <Sequence> per state
- With useCurrentFrame driven state changes
- With no CSS transitions, no Tailwind animation classes
- With the exact tokens from this gate

If any board requires a capability outside this set, escalate. Do not paper over the gap with "we'll handle it at build time."

## Reference implementation

A UI mockup composition typically contains:

- DeviceFrame component (fixed dimensions, tokens applied)
- StatusBar component (static)
- Screen component (state-driven)
- Cursor component (position via interpolate, clicks via frame threshold)
- Optional FocusRing, HoverGlow, LoadingOverlay components

Each is a Remotion component. All timing is in frames.
