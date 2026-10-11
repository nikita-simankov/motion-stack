# UI Mockup Components

Catalogue of Remotion React components for UI mockups. Used when brief Q8 is C or D.

## DeviceFrame

Props:

- width, height (from style-tokens.uiMockup.device)
- cornerRadiusPx
- bezelPx
- shadow
- children

Renders a device shell with a screen region as children.

Dimensions come from tokens, not from props at call time unless the scene has multiple devices.

## StatusBar

Static component. Time, signal, battery. Values from tokens or props. No animation.

## Screen

Props:

- state — default | hover | active | loading | success | error | disabled
- stateChangeFrame — the frame at which state flips
- children (or state-specific children map)

Rules:

- Reads useCurrentFrame() to compare against stateChangeFrame
- Never uses CSS transitions
- State change is a hard swap or a frame-interpolated crossfade implemented via opacity

## Cursor

Props:

- path — array of { frame, x, y }
- clickFrames — array of frames when a click occurs
- sizePx, shape, blendMode from tokens

Rules:

- Position via interpolate() over the path points
- Click visual via spring() scaled pulse
- No CSS animations
- Rendered above the screen, inside the DeviceFrame

## Card

Props:

- width, height
- backgroundColor — from palette
- borderRadiusPx — from tokens
- paddingPx — multiple of spacing base
- children

## StateBadge

Props:

- state — success | warning | error | info
- label

Rules:

- Colors from palette.stateX
- Icon from iconography tokens
- No color-only signaling

## FocusRing

Props:

- targetRect — { x, y, w, h }
- appearFrame
- pulse — true | false

Rules:

- Appear via opacity interpolate
- Pulse via frame-driven scale
- No CSS outline animation

## LoadingOverlay

Props:

- startFrame
- endFrame

Rules:

- Spinner rotation = (frame / fps) \* 360
- No CSS animations

## Toast

Props:

- message
- type — success | error | info
- enterFrame, exitFrame

Rules:

- Enter via translateY + opacity interpolate
- Exit via translateY + opacity interpolate
- No CSS transitions

## Modal

Props:

- open
- openFrame, closeFrame
- children

Rules:

- Open via opacity + scale interpolate
- Close via reverse
- No CSS transitions

## SmartZoom (v2)

Props:

- width, height
- cursorPath — array of { frame, x, y } (shared with Cursor)
- zoomSegments — array of { startFrame, endFrame, zoom }
- followLagFrames, transitionFrames

Rules:

- Wraps the DeviceFrame content; implemented in `src/motion/SmartZoom.tsx`
- Camera curve from the `camera` role, cursor legs from the `cursor` role
- Focus is clamped so the zoomed view never shows outside the canvas
- No zoom while the cursor is idle

## TypingText (v2)

Props:

- text, startFrame
- cadence — { min, max } frames per character from `uiMockup.typing`
- seed — string from `uiMockup.typing.seed`

Rules:

- Character arrival frames come from a seeded generator, never `Math.random`
- Caret blink is frame-driven (a modulo on the frame), not a CSS animation

## Skeleton (v2)

Props:

- startFrame, endFrame
- shape — line | block | avatar

Rules:

- Placeholder shimmer is a frame-driven gradient position, linear on purpose (`// ms:linear`)
- Replaced by real content on the state-change frame; the swap uses the `state` curve crossfade

## Chart components

Any chart is a Remotion component:

- LineChart, BarChart, AreaChart, DonutChart, Heatmap
- Data is a fixed JSON inlined in the source
- No runtime fetch
- Values animate via interpolate() over the board's frame range
- Axes, labels, gridlines all follow style-tokens.type and palette

## Data components

Any table, metric, or number is a Remotion component:

- NumberRoll — counts up via interpolate
- TableRow — reveals per frame
- Sparkline — draws a path via SVG stroke-dashoffset driven by frame

## Rules

- Every UI component is a React component in Remotion.
- Every state change is frame-driven.
- No CSS transitions, no CSS keyframes, no Tailwind animation classes.
- All spacing is a multiple of style-tokens.uiMockup.spacingBasePx.
- All colors come from style-tokens.palette.
- All type comes from style-tokens.type.roles, using the uiLabel or uiValue role.
- All dimensions come from style-tokens.uiMockup.

## Rejected

- Using CSS transitions for hover
- Using Tailwind's hover:, focus:, active: pseudo-classes for state
- Using setInterval or setTimeout for animation
- Using requestAnimationFrame
- Using any library that assumes a running browser event loop
