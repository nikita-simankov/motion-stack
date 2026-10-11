# Motion Language

Motion is locked as a set of named primitives with frame-based timing.

## Buckets

micro 6-12 frames cursor blips, label swaps, icon state changes
short 12-24 frames element reveals, type-in, card entrances
medium 24-45 frames beat transitions, layout shifts, scene entrances
long 45-90 frames scene transitions, push-ins, cinematic moves

## Easing set

linear continuous motion only: progress bars, cursor tracking, marquee
ease-out default for entrances (things arriving on screen)
ease-in default for exits (things leaving screen)
ease-in-out default for state changes (A -> B in place)
spring reserved for landing moments: CTA appearing, success state
bounce reserved for playful tone only; never with authoritative tone

## Transition set

Locked to the transitions actually used in boards.json. A transition not present in boards.json cannot be added at this gate; add it at stage 5 instead.

Standard set:

- hard-cut
- cut-on-action
- match-cut
- wipe
- mask
- dissolve
- glitch
- scale
- whip

## Remotion primitives

- interpolate for all frame-anchored motion with named easings
- spring for landing moments; use natural spring config or a named preset
- Sequence and Series for timing, not for motion
- AbsoluteFill for layering
- No CSS transitions, no CSS keyframes, no Tailwind animation classes

## Rules

- Every motion is expressed in frames, never seconds
- Every motion has a bucket, an easing, and a duration inside the bucket range
- Every motion has a start state and an end state
- Every motion has a Remotion primitive
- Motion notes never prescribe bezier control points; ease naming is enough
- Motion never crosses a board boundary. Cross-boundary motion is a transition.

## Compatibility with stage 5

Stage 5 boards carry motionNotes. At this gate, verify:

- Every motionNote maps to a bucket in the bucket set
- Every motionNote's easing exists in the easing set
- Every transition in boards.json exists in the transition set

Any board motion that cannot be mapped to the set is a blocker and triggers a stage 5 rollback or an explicit override, not an edit here.

## Compatibility with Remotion

- interpolate with the four standard easings maps directly
- spring maps to Remotion's spring()
- Custom easings are declared as cubic bezier arrays in the token set and consumed via interpolate

## Anti-patterns

- "Fade in over 0.3s" — seconds, no bucket
- "Slide up with ease" — no easing, no frames
- "CSS ease-in-out" — CSS forbidden
- "Tailwind transition-all" — forbidden
- "Springy bounce" — two easings, no bucket, no frames
- "Smooth" — no easing, no frames, no bucket
