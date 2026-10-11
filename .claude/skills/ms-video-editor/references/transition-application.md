# Transition Application

Transition implementation per type. Every transition is a Remotion primitive or a custom component.

## Standard transitions (from @remotion/transitions)

### dissolve / fade

import { dissolve } from "@remotion/transitions/dissolve";

<TransitionSeries.Transition
presentation={dissolve()}
timing={linearTiming({ durationInFrames: 12 })}
/>

### slide

import { slide } from "@remotion/transitions/slide";

<TransitionSeries.Transition
presentation={slide({ direction: "from-left" })}
timing={linearTiming({ durationInFrames: 12 })}
/>

### wipe

import { wipe } from "@remotion/transitions/wipe";

<TransitionSeries.Transition
presentation={wipe({ direction: "from-top" })}
timing={linearTiming({ durationInFrames: 12 })}
/>

### flip

import { flip } from "@remotion/transitions/flip";

### clockWipe

import { clockWipe } from "@remotion/transitions/clock-wipe";

### iris (v2)

import { iris } from "@remotion/transitions/iris";

<TransitionSeries.Transition
presentation={iris({ width, height })}
timing={linearTiming({ durationInFrames: 14 })}
/>

Native presentation. Use for a focus-in on the next subject. Timing may use `springTiming` with the `soft` preset.

## Series-boundary transitions

### hard-cut

No transition wrapper. Two adjacent <TransitionSeries.Sequence> elements with no <TransitionSeries.Transition> between them.

### cut-on-action

Same as hard-cut at the Remotion level. The cut is aligned to a motion peak inside the scenes. The peak alignment is a boards decision; the editor respects it.

### match-cut

Same as hard-cut at the Remotion level. The visual anchor (shared shape, position, or color) is a boards decision.

## Custom transitions (React components in src/transitions/)

### whip

A fast directional move with real motion blur on both scenes at the boundary. Duration 6 to 12 frames.

const WhipPresentation = ({ children, presentationDirection, presentationProgress }) => {
  const m = useMotion();
  const dir = direction === "left" ? -1 : 1;
  const p = m.ease("in-out-expo")(presentationProgress);
  const x = presentationDirection === "exiting" ? dir * p * 1.0 * width : dir * (p - 1) * width * -1;
  return (
    <AbsoluteFill style={{ transform: `translateX(${x}px)` }}>
      <MotionBlur ranges={[{ startFrame: 0, endFrame: 12 }]}>{children}</MotionBlur>
    </AbsoluteFill>
  );
};

The blur comes from `<MotionBlur>` (token `motion.motionBlur`: shutter angle and samples), not from a hand-written `filter: blur()`. The move uses the `in-out-expo` curve through `m.ease`. Whip is in `motionBlur.appliesTo` by default.

### glitch

Frame-swapped offsets, chromatic aberration, and short noise bursts. Duration 6-15 frames.

### scale

One element grows to fill and reveals the next. The scale interpolates from 1.0 to a coverage value on the `camera` curve; the next scene starts at the coverage frame. In `motionBlur.appliesTo`.

### shape-wipe (v2)

The next scene is revealed through a shape that grows (circle, rounded rect, star, spark from `@remotion/shapes`), used as a mask.

- Mask path from `makeCircle` / `makeRect` / `makeStar` etc.; scale it on the `state` curve until it covers the canvas.
- The shape comes from the brand (iconography tokens) where possible.
- Duration 12 to 24 frames.

### object-wipe (v2)

A foreground object travels across the frame and its trailing edge reveals the next scene (a card, a cursor, a product).

- The object is a layer in scene A that continues into scene B (same component, shared start state) so it reads as one move.
- Move on the `camera` curve. Blur it with `<MotionBlur>`.
- Duration 12 to 30 frames. Board names the object.

### morph (v2)

One shape becomes another across the cut.

- `interpolatePath(progress, pathA, pathB)` from `@remotion/paths`; progress from the `state` curve.
- Both paths share structure (same command count); use `resetPath` / `scalePath` / `translatePath` to align them.
- The end frame of A and the start frame of B share the shape's position so the cut hides inside the morph.
- Duration 18 to 45 frames.

## Duration rules

- Minimum transition duration: 6 frames
- Maximum transition duration: 90 frames
- Standard: 8-24 frames for short-form
- Duration is always an integer and matches the frozen motion bucket
- Custom presentations take their curve from tokens (`useMotion().ease`), never an inline curve

## Frozen set

The transition set is frozen at gate 6. Transitions used must be in the frozen set. Adding a transition not in the set is a rollback to gate 6.

## Transition pairs

For every cut between scene N and scene N+1:

- transitionOut of N equals transitionIn of N+1
- If they differ, the pair is resolved as the stronger of the two and the mismatch is recorded in timeline.json with a reason

## Rejected patterns

- CSS transitions (rejected at any stage)
- CSS keyframes
- Third-party transition libraries outside @remotion/transitions
- Transitions that extend the master duration
- Transitions longer than 90 frames or shorter than 6 frames
- Transitions that use a literal `filter: blur()` instead of `<MotionBlur>` (ANIM-13)
- Raw `Easing.*` or a bezier typed into a custom transition (ANIM-04); use `m.ease(name)`
- Any transition whose behavior differs between local and Lambda renders

## Determinism

Custom transitions must be frame-driven with no randomness and no dependence on time. They must render identically across runs.
