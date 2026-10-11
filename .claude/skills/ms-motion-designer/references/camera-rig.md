# Camera, Depth and Motion Runtime

The `src/motion/` runtime and the camera patterns that sit on it. Source: `ms-motion-designer/templates/motion/`, copied into the project by `/ms-setup scaffold`. Do not edit the copies per project; propose changes to the templates.

## Runtime files

| file | exports | purpose |
|---|---|---|
| `tokens.ts` | `MotionProvider`, `useMotion`, `makeMotion` | token-driven `ease`, `tween`, `springOf`, `staggerOffset`, `readFrames`, `exitFrames`, `overlapStart` |
| `KineticText.tsx` | `KineticText`, `NumberRoll` | kinetic type presets (`kinetic-type.md`) |
| `WordCaptions.tsx` | `WordCaptions`, `pageWords` | word-level captions from `vo.json` words |
| `CameraRig.tsx` | `CameraRig`, `ParallaxLayer`, `cameraAt` | virtual camera and depth layers |
| `SmartZoom.tsx` | `SmartZoom`, `cursorAt`, `zoomAt` | cursor-following zoom for product demos |
| `MotionBlur.tsx` | `MotionBlur` | blur inside declared frame ranges |
| `MeshGradient.tsx` | `MeshGradient` | seeded noise-driven gradient |

Wrap the composition once:

```tsx
import tokens from "../style-tokens.json";
<MotionProvider tokens={tokens.motion as MotionTokens}>{scene}</MotionProvider>
```

Scenes read curves, springs and stagger through `useMotion()`. They never import `Easing`, never write a bezier, and never pass an inline spring config.

## Camera rig

A scene with a camera move wraps its layers:

```tsx
<CameraRig moves={[{ startFrame: 0, endFrame: 90, curve: "in-out-quart",
                     from: { x: 0, y: 0, zoom: 1, rotateDeg: 0 },
                     to:   { x: 40, y: 0, zoom: 1.15, rotateDeg: 0 } }]}
           focusDepth={0} blurPerDepthPx={2}>
  <ParallaxLayer depth={2}>{background}</ParallaxLayer>
  <ParallaxLayer depth={0}>{subject}</ParallaxLayer>
  <ParallaxLayer depth={-0.5}>{foregroundAccent}</ParallaxLayer>
</CameraRig>
```

- Camera state is a pure function of the frame (`cameraAt`). Layers sample it; nothing is stateful, so renders are deterministic.
- `depth` 0 moves one to one with the camera. Positive depth is farther (moves and scales less). Negative is nearer.
- Blur grows with distance from `focusDepth` (`blurPerDepthPx`, capped at `maxBlurPx`). It is computed from the frame, so it is frame-driven.
- Limits come from `camera`: `maxZoom` (1.25 default). Moves use the `camera` curve role; long moves (45 to 90 frames) may use `in-out-expo`.
- Parallax layers: two to four. More than four reads as noise.
- A camera move never crosses a board boundary (the v1 rule stands). A cross-boundary move is a transition.

## Smart zoom (product demos)

`SmartZoom` frames the action in a UI mockup:

- `cursorAt(frame, path, ease, curve)`: each leg of the cursor path eases with the `cursor` role curve (out-quart by default). Add overshoot by choosing a curve, not by hand-tuning positions.
- The camera follows the cursor with `followLagFrames` (10 by default) so it never feels glued to it, and `zoomSegments` ease in and out with the `camera` curve.
- The focus point is clamped so a zoomed view never shows outside the canvas.
- Typical zoom: 1.3 to 1.6x on the control being used, back to 1x on the result. Never zoom while the cursor is idle.

## Depth on a flat piece

Without 3D, depth comes from layered parallax, depth blur, scale difference, and shadow. 3D (`@remotion/three`, intake Q17=C) is for subjects that need real rotation or lighting; its spec is the Q17=C sub-spec in `ms-asset-generator/references/asset-types.md`.

## Determinism

- Everything above depends only on the frame and the tokens.
- `MeshGradient` takes a string seed; `noise2D` returns the same value for the same seed, x and y.
- `MotionBlur` renders sub-frames; the local and Lambda parity check in scene QA covers it.

## Rejected

- Writing camera moves as raw `transform` strings in the scene
- A `ParallaxLayer` outside a `CameraRig`
- More than 1.25x total zoom on a non-UI scene without a board note
- Depth blur on text a viewer must read
