# Board Granularity

A board is a single visual moment. Not a script beat, not a frame.

## Split rules

A beat splits into multiple boards when any of these is true:

- A cut occurs inside the beat
- A reveal, mask, or wipe changes the frame mid-beat
- A UI state changes (default -> loading -> success)
- A type sequence groups into two or more distinct sets
- A subject leaves and a new subject enters
- A transition in or out is different at the two ends of the beat

Split the beat at the frame of the change, not at a round number.

## Merge rules

Two beats merge into one board when both are true:

- Neither beat contains a visual change mid-beat
- They share the same framing, subject, and motion direction

Merging is allowed only when the script permitted a connective beat and the merge keeps the total beat count within the runtime's band. Merging for density alone is rejected.

## Density guidance

Per runtime:

15s 4-6 boards (avg 1 board per 3s)
30s 8-12 boards (avg 1 board per 3s)
60s 16-24 boards (avg 1 board per 3s)
90s 24-36 boards (avg 1 board per 3s)

Out-of-range density requires a reason logged in densityLog:

- High density (more boards) is allowed for: UI demos, list structures, kinetic type, product walkthroughs
- Low density (fewer boards) is allowed for: cinematic single-take motion, slow narrative beats, silence

## Examples

### One beat, one board

A proof beat with a single animated chart and a VO line that runs the full beat. No mid-beat change. One board.

### One beat, three boards

A UI demo beat: app default state, click, success state. Three boards at three frame anchors.

### Two beats, one board

Two connective beats back-to-back with no visual change and a shared VO line. Merge to one board.

### Beat overrun

A beat that needs 12 seconds at 30fps (360 frames) is within the per-beat max. A beat that needs 20 seconds (600 frames) exceeds the beat max and must split into two script beats at the script stage, not the board stage. Boards never re-beat the script.

## Split mechanics

When splitting a beat:

- The new boards inherit the beat's claimIds, VO text, on-screen text, and audio note
- Each board carries a slice of the VO frame range if the VO spans the split
- The transitionOut of the earlier board and transitionIn of the later board are set to the mid-beat change type

## Merge mechanics

When merging two beats:

- The merged board inherits both beats' claimIds
- The merged board's VO text concatenates the two lines with explicit silence between
- The merged board's audio note covers both beats
- The merged board's frame range is the sum of both
- The merged board's transitionIn comes from the first beat, transitionOut from the second

## Anti-patterns

- Splitting for density without a visual change
- Merging for density without a shared subject
- Splitting a beat because the motion designer wants more frames
- Merging a beat because the writer overran the runtime (that's a script problem)
- Splitting the hook into more than two boards
- Any split or merge that changes the script beat count without a script revision
