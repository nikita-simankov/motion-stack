# Frame Mapping

Every frame of the runtime is claimed by exactly one board. This file describes the procedure that guarantees it.

## Coverage algorithm

1. Start with script.runtimeFrames. This is the target total.
2. Walk the script beats in order. For each beat, decide granularity (see board-granularity.md).
3. Assign each board a frame range that is contiguous with the previous board.
4. Sum the board durations. The total must equal runtimeFrames.
5. If the total is under, add frames to the longest boards (max: per-beat max from beat-timing).
6. If the total is over, cut frames from the shortest boards (min: per-beat min) or merge two adjacent boards.
7. Fill coverage.claimedFrames, coverage.uncoveredFrames, coverage.overlappingFrames, coverage.orphanBoards.
8. Fail the audit if any of the last three lists are non-empty.

## Remotion Sequence mapping

For every board:

- remotionSequence.from = board.frameStart
- remotionSequence.durationInFrames = board.durationFrames
- remotionSequence.transitionOut = board.transitionOut

Sub-sequences are optional and used when a board contains internal timed elements:

- Kinetic type groups
- UI interaction steps
- Multi-stage motion
- Overlay text that appears mid-board

Sub-sequences follow the same rules: contiguous, non-overlapping, total to the parent board's duration.

## Transition pairing

For consecutive boards B*n and B*(n+1):

- B*n.transitionOut must equal B*(n+1).transitionIn
- The transition is scheduled at the boundary frame B*n.frameEnd (= B*(n+1).frameStart)
- <TransitionSeries> is the standard Remotion implementation when any board uses a non-hard-cut transition

Exception: when the transition type differs (e.g. B*n wants to whip out and B*(n+1) wants a cut in), the pair is resolved as the stronger of the two, and the mismatch is logged in boards.json under densityLog with a reason.

## UI mockup mapping

When uiMockup is not null:

- The board maps to a nested <Sequence> inside the parent board's Sequence
- Device frame is a React component with fixed dimensions from style tokens
- Interaction state is frame-driven: state changes at specific frame anchors, implemented via useCurrentFrame comparison
- Cursor is its own component, animated via interpolate for position and via frame threshold for clicks
- Loading, success, and error states are separate boards, each with its own Sequence

## Density window

Boards per 10 seconds:

- Window 1: frames 0 to 300 (0-10s at 30fps)
- Window 2: frames 300 to 600
- Window 3: frames 600 to 900
- ... for longer runtimes

Per window, count boards whose frameStart falls inside the window. Record in densityLog. Out-of-range windows carry a reason.

## Audit checklist

- [ ] claimedFrames == runtimeFrames
- [ ] uncoveredFrames empty
- [ ] overlappingFrames empty
- [ ] orphanBoards empty
- [ ] Every board's remotionSequence.from equals its frameStart
- [ ] Every board's remotionSequence.durationInFrames equals its durationFrames
- [ ] Every transition pair matches
- [ ] Every UI board has device, state, and frameDriven = true
- [ ] Every motionNotes entry carries a Remotion primitive
- [ ] No board requires CSS transitions or Tailwind animation classes
- [ ] No board requires a renderer outside the brief's motion stack
