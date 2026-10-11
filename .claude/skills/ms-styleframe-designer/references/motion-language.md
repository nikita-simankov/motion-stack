# Motion Language

Motion is locked as a set of named primitives with frame-based timing. v2 (tokenVersion 2) replaces the six-name easing set with a named curve library, spring presets, and choreography rules. Full spec: `motion-curves.md`.

## Buckets

micro 6-12 frames cursor blips, label swaps, icon state changes
short 12-24 frames element reveals, type-in, card entrances
medium 24-45 frames beat transitions, layout shifts, scene entrances
long 45-90 frames scene transitions, push-ins, cinematic moves

## Curves and roles

Curves are named bezier arrays in `motion.curves`. Five roles choose the default: entrance, exit, state, camera, cursor (table in `motion-curves.md`).

linear continuous motion only: progress bars, cursor tracking, marquee. Mark `// ms:linear`
entrance default for things arriving on screen (out-expo, out-quint or out-quart by tone)
exit default for things leaving screen (in-cubic or in-expo by tone), 65% of the entrance length
state default for state changes in place (in-out-quart)
camera default for camera moves (in-out-quart; in-out-expo for long moves)
cursor default for cursor legs (out-quart)
spring named presets only: land, snappy, soft, heavy. Reserved for landing moments (CTA, success state)
bounce / out-back / bouncy playful tone only; never with authoritative tone

### v1 names

`ease-out`, `ease-in`, `ease-in-out` remain valid in boards and motion notes. They resolve through `motion.aliases` to out-cubic, in-cubic and in-out-cubic. v1 files stay readable (see `token-migration-v1-to-v2.md`).

## Choreography

Entrances stagger (2 to 6 frames, total at most 20). The next element starts at 65% of the last one's progress. Exits are 65% of the entrance. Text holds at least 10 frames per word (minimum 24). Springs settle within 8 to 24 frames and overshoot at most 12%. Values live in `motion.choreography`.

## Transition set

Locked to the transitions actually used in boards.json. A transition not present in boards.json cannot be added at this gate; add it at stage 5 instead.

Vocabulary:

- hard-cut
- cut-on-action
- match-cut
- wipe
- mask
- dissolve
- glitch
- scale
- whip
- shape-wipe (v2)
- iris (v2)
- object-wipe (v2)
- morph (v2)

Implementation notes for the v2 entries are in `ms-video-editor/references/transition-application.md`.

## Remotion primitives

- `interpolate` with a named curve (through `m.tween`) for all frame-anchored motion
- `spring` through a named preset (`m.springOf`) for landing moments
- Sequence and Series for timing, not for motion
- AbsoluteFill for layering
- `<MotionBlur>` for blur on fast moves; `<CameraRig>` for camera and depth
- No CSS transitions, no CSS keyframes, no Tailwind animation classes

## Rules

- Every motion is expressed in frames, never seconds
- Every motion has a bucket, a curve, and a duration inside the bucket range
- Every motion has a start state and an end state
- Every motion has a Remotion primitive
- Motion notes reference curves by name; they never prescribe bezier control points
- Motion never crosses a board boundary. Cross-boundary motion is a transition.
- A group of three or more items staggers (ANIM-07)
- A scene with six or more eased motions uses at least two distinct curves (ANIM-09)

## Compatibility with stage 5

Stage 5 boards carry motionNotes. At this gate, verify:

- Every motionNote maps to a bucket in the bucket set
- Every motionNote's curve exists in `motion.curves`, `motion.aliases`, or is `linear` / `spring`
- Every transition in boards.json exists in the transition set

Any board motion that cannot be mapped to the set is a blocker and triggers a stage 5 rollback or an explicit override, not an edit here.

## Compatibility with Remotion

- Curves resolve to `Easing.bezier` through `makeMotion().ease`
- Springs resolve to Remotion's `spring()` with an explicit preset config
- Custom curves are declared in the token set as cubic bezier arrays and consumed by name; they are never typed into a scene

## Anti-patterns

- "Fade in over 0.3s" — seconds, no bucket
- "Slide up with ease" — no curve, no frames
- "CSS ease-in-out" — CSS forbidden
- "Tailwind transition-all" — forbidden
- "Springy bounce" — no preset, no bucket, no frames
- "Smooth" — no curve, no frames, no bucket
- Every element on one curve, starting on one frame — no craft
