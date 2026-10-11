# Shot Vocabulary

Framing, motion direction, and transitions. Each definition carries a Remotion implementation note.

## Framing

### full-frame

Subject fills the canvas edge to edge.
Remotion: <AbsoluteFill> with a single dominant element, no padding.
Use for: hooks, punchlines, single-number beats.

### inset

Subject sits inside a bordered region, e.g. a UI card, a device frame, a window chrome.
Remotion: nested <AbsoluteFill> with explicit width, height, border-radius.
Use for: UI mockups, screenshot beats, code windows.

### split

Two subjects share the canvas, one dominant.
Remotion: flex row with explicit flex weights; not 50/50 unless intentional.
Use for: contrast, before/after, us/them.

### stack

Vertical stack of 2-4 elements of equal or weighted importance.
Remotion: flex column with gap; no CSS transition-based reveals.
Use for: lists, steps, sequential points.

### grid

NxM arrangement of equal-weight elements.
Remotion: CSS grid with fixed rows/cols; per-cell animation via useCurrentFrame.
Use for: competitive landscape, feature matrix, side-by-side comparisons.

### overlay

Text or graphic on top of a base image or animation.
Remotion: <AbsoluteFill> layers with z-index order; text animated on its own timeline.
Use for: quote cards, stat callouts, captions over motion.

### reveal

Subject enters the frame from off-canvas or behind a mask.
Remotion: <Sequence> with clip-path or mask-image animated via interpolate.
Use for: first appearance, dramatic entrance, transition into a new beat.

### isolated

Single element on a flat or gradient field.
Remotion: <AbsoluteFill> with background color, single centered element.
Use for: strong single statements, silence beats, CTA.

## Motion direction

### push-in

Scale up on the subject.
Remotion: interpolate(scale, [0, duration], [1, 1.15]).
Use for: tension build, emphasis, beat landing.

### pull-out

Scale down from the subject.
Remotion: interpolate(scale, [0, duration], [1.15, 1]).
Use for: reveal context, calm after tension.

### pan

Horizontal move.
Remotion: translateX via interpolate. Motion designer chooses whether the subject or the frame moves.
Use for: sequential content, wide comparisons.

### tilt

Vertical move.
Remotion: translateY via interpolate.
Use for: stack reveals, scroll simulations, UI demos.

### parallax

Layered move at different rates.
Remotion: multiple interpolate calls with different ranges per layer.
Use for: depth, cinematic moments, title sequences.

### morph

One shape becomes another.
Remotion: SVG path interpolation or <Lottie> morph, or React state swap at a frame anchor.
Use for: transformation beats, icon changes, transitions.

### track

Following a moving subject.
Remotion: translateX/Y derived from the subject's position, not a fixed value.
Use for: cursor follows, character follows, object follows.

### static

No camera move. Internal motion only.
Remotion: no translate or scale on the container; only element-level animation.
Use for: kinetic type, single-card messages, dense UI demos.

## Transitions

### hard-cut

Instantaneous frame swap.
Remotion: <Sequence> boundary; the earlier Sequence ends on frame N, the later starts on N+1.
Use for: pace, punchlines, list items.

### cut-on-action

Cut at the peak of a movement.
Remotion: schedule the cut frame to coincide with the peak of an interpolate curve.
Use for: energy, match-cut setups.

### match-cut

Cut on shape, motion, or color continuity.
Remotion: end frame of A and start frame of B share a visual anchor (shape, position, color).
Use for: elegant transitions, seamless sequences.

### wipe

Directional reveal of the next frame.
Remotion: clip-path or mask animated via interpolate on a direction vector.
Use for: scene changes, before/after, reveal pacing.

### mask

Shape-based reveal.
Remotion: SVG mask or mask-image with an interpolated shape.
Use for: logo reveals, subject entrances, transitions into UI.

### dissolve

Cross-fade.
Remotion: <TransitionSeries> with a dissolve, or two overlapping <Sequence> elements with opacity interpolate.
Use for: calm transitions, time passing, mood shifts.

### glitch

Brief distortion.
Remotion: rapid frame-swapped offsets, chromatic aberration, or short noise bursts.
Use for: system errors, security moments, energy spikes.

### scale

One element grows to fill and reveals the next.
Remotion: element scale interpolated to cover the canvas, then a Sequence boundary.
Use for: "zoom into the detail" transitions.

### whip

Fast directional blur.
Remotion: heavy directional blur on a large translate, timed short (<= 6 frames).
Use for: high-energy pace, reel-style cuts.

## Rejected vocabulary

- "Fade in" as a motion direction (that's a transition, and it's a dissolve)
- "Slide up" without a named easing or frame range
- "Animate in" without a start state and end state
- "Make it pop" (no frame, no element, no delta)
- Any phrasing that implies CSS transitions or Tailwind animation classes
- Any transition described only in seconds, not frames
