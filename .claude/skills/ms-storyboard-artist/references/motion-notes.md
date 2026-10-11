# Motion Notes

Motion notes describe what moves and how, using Remotion primitives and frame anchors. They are not a motion design — they are an instruction sheet the motion designer can implement without a second meeting.

## Template

For every animated element:

- element — the name of the element (a layer, a component, a text block)
- from — starting state (position, scale, rotation, opacity, color, shape, value)
- to — ending state
- easing — linear | ease-in | ease-out | ease-in-out | spring | bounce | null
- frameAnchorStart, frameAnchorEnd — the frames between which the motion runs
- remotionPrimitive — interpolate | spring | Sequence | AbsoluteFill | Series | custom

## Example: push-in on the hook number

element: hook number
from: scale 1.0, y +20, opacity 0.0
to: scale 1.08, y 0, opacity 1.0
easing: ease-out
frameAnchorStart: 0
frameAnchorEnd: 30
remotionPrimitive: interpolate

## Example: stacked list reveal

element: list item 3
from: opacity 0.0, x -40
to: opacity 1.0, x 0
easing: ease-out
frameAnchorStart: 180
frameAnchorEnd: 210
remotionPrimitive: interpolate

## Example: UI cursor click

element: cursor
from: position (200, 320)
to: position (410, 512)
easing: ease-in-out
frameAnchorStart: 240
frameAnchorEnd: 270
remotionPrimitive: interpolate

## Example: spring landing on the CTA

element: CTA button
from: scale 0.8
to: scale 1.0
easing: spring
frameAnchorStart: 800
frameAnchorEnd: 830
remotionPrimitive: spring

## Accepted phrasings

- "scale 1.0 -> 1.08, frames 0-30, ease-out, via interpolate"
- "opacity 0 -> 1, frames 180-210, ease-out, via interpolate"
- "spring from scale 0.8 to 1.0, frames 800-830"
- "cursor translate from (200,320) to (410,512), frames 240-270, ease-in-out"

## Rejected phrasings

- "fade in" — no start state, no end state, no easing, no frame range
- "slides up" — no frame range, no easing
- "animates in via CSS" — CSS is forbidden
- "Tailwind transition" — Tailwind animations are forbidden
- "make it pop" — no frame, no element, no delta
- "smoothly" — no easing, no frame range
- "quickly" — no frame range
- "over half a second" — seconds instead of frames
- "when the user clicks" — no frame anchor

## Rules

- Every motion note references a Remotion primitive.
- Every motion note has a frame anchor.
- Every motion note has a start and end state.
- Easing is named when it matters and left null when the motion designer should decide.
- Motion notes never prescribe bezier control points.
- Motion notes never span boards. A motion that crosses a board boundary is either two motion notes or a transition.

## Coverage

Every board carries motion notes for every element that animates on that board. Elements that are static on a board are not listed. Boards with no motion notes carry a single note: "static".

## Handoff

The motion designer reads motionNotes as a checklist. If a motion note cannot be implemented with the listed Remotion primitive, the motion designer raises it before stage 8 starts, not during.
