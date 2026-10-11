# Beat Grid

Cuts and hits land on music. `scripts/beat_grid.py` turns a music stem into integer beat and onset frames, and proposes how far each cut should move to sit on one.

```
beat_grid.py grid <music-stem.wav> --fps 30 --offset-ms <cue start on the master, in ms> > grid.json
beat_grid.py snap --grid grid.json --cuts 31,62,95 --snap-frames 2 > snap.json
```

`grid` needs `librosa` (optional ms-setup package). `snap` is pure Python.

## grid.json

| field | meaning |
|---|---|
| bpm | tracked tempo. Approximate: on a 120 BPM click track it reported 117.45. Octave errors (half or double time) are common. Use beat positions, not the BPM number, for cutting |
| beatsFrames | tracked beats as master-timeline frames |
| onsetsFrames | every detected onset |
| strongOnsetsFrames | onsets above the 75th percentile of strength |

## Snap rules

- A cut moves to the nearest beat or strong onset only when the shift is at most `rhythm.beatGrid.snapFrames` (2 by default). Otherwise it stays, and is listed in `unsnapped`.
- Beats win ties over onsets.
- The proposal is advisory. The editor owns the cut: a snapped cut must not break a board's cut-on-action peak or move a VO anchor by more than 1 frame (the existing alignment tolerance). Decisions are recorded in `timeline.json`.
- Existing rule stands: never cut a music cue on a beat that lands within 2 frames of a board cut. The board cut owns the moment. The snap tool applies the other way round: it nudges the cut toward the beat, not the music toward the cut.
- Time-stretch limit (3%) and "never pitch-shift" are unchanged.
- A piece whose tone is authoritative or measured may set `rhythm.beatGrid.required: false` and skip snapping.

## Audio-reactive visuals

When `rhythm.audioReactive.enabled` is true, a visual may follow the music stem through `@remotion/media-utils` (`visualizeAudio` over the pre-rendered music stem, not the live mix). Rules:

- Derive from the finished music stem file, never from microphone or runtime audio.
- Smooth with `smoothingFrames` (3 by default) so it does not flicker.
- One reactive element per beat. Reactive motion follows the same curve and bucket rules as any other motion.

## Verification

`beat_grid.py --selftest` generates a 120 BPM click track, checks that tracked beats land on the expected frames (every 15 frames at 30 fps), and checks the snap logic.
