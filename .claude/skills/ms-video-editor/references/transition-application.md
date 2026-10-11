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

## Series-boundary transitions

### hard-cut

No transition wrapper. Two adjacent <TransitionSeries.Sequence> elements with no <TransitionSeries.Transition> between them.

### cut-on-action

Same as hard-cut at the Remotion level. The cut is aligned to a motion peak inside the scenes. The peak alignment is a boards decision; the editor respects it.

### match-cut

Same as hard-cut at the Remotion level. The visual anchor (shared shape, position, or color) is a boards decision.

## Custom transitions (React components in src/transitions/)

### whip

A directional blur applied to both scenes at the boundary.

export const whip = (direction: "left" | "right") => {
const WhipPresentation: React.FC<{ children: React.ReactNode }> = ({ children }) => {
const frame = useCurrentFrame();
const { durationInFrames } = useVideoConfig();
const progress = interpolate(frame, [0, durationInFrames], [0, 1], {
extrapolateLeft: "clamp",
extrapolateRight: "clamp",
});
const blur = interpolate(progress, [0, 0.5, 1], [0, 24, 0]);
const dx = direction === "left" ? -60 : 60;
return (
<AbsoluteFill
style={{
          filter: `blur(${blur}px)`,
          transform: `translateX(${interpolate(progress, [0, 1], [0, dx])}px)`,
        }} >
{children}
</AbsoluteFill>
);
};
return WhipPresentation;
};

### glitch

Frame-swapped offsets, chromatic aberration, and short noise bursts. Duration 6-15 frames.

### scale

One element grows to fill and reveals the next. The scale interpolates from 1.0 to a coverage value; the next scene starts at the coverage frame.

## Duration rules

- Minimum transition duration: 6 frames
- Maximum transition duration: 90 frames
- Standard: 8-24 frames for short-form
- Duration is always an integer and matches the frozen motion bucket

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
- Transitions that use `filter: blur()` without frame-driven interpolation
- Any transition whose behavior differs between local and Lambda renders

## Determinism

Custom transitions must be frame-driven with no randomness and no dependence on time. They must render identically across runs.
