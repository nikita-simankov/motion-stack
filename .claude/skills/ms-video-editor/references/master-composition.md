# Master Composition

The master timeline is a single Remotion <Composition> that sequences every scene and places every audio stem.

## File

src/Master.tsx — the master component
src/Root.tsx — the registry

## Master.tsx pattern

import {
AbsoluteFill,
Audio,
Series,
staticFile,
TransitionSeries,
linearTiming,
} from "remotion";
import { SceneB01 } from "./scenes/B01";
import { SceneB02 } from "./scenes/B02";
import { dissolve } from "@remotion/transitions/dissolve";

export const Master: React.FC = () => {
return (
<AbsoluteFill>
<TransitionSeries>
<TransitionSeries.Sequence durationInFrames={60}>
<SceneB01 />
</TransitionSeries.Sequence>
<TransitionSeries.Transition
presentation={dissolve()}
timing={linearTiming({ durationInFrames: 8 })}
/>
<TransitionSeries.Sequence durationInFrames={240}>
<SceneB02 />
</TransitionSeries.Sequence>
{/_ ... every scene in board order ... _/}
</TransitionSeries>

      <Audio src={staticFile("audio/vo-stem.wav")} startFrom={0} />
      <Audio src={staticFile("audio/sfx-stem.wav")} startFrom={0} />
      <Audio src={staticFile("audio/music-stem.wav")} startFrom={0} />
    </AbsoluteFill>

);
};

## Root.tsx registration

<Composition
  id="<slug>-master"
  component={Master}
  durationInFrames={900}
  fps={30}
  width={1080}
  height={1920}
  defaultProps={{}}
/>

Rules:

- One master composition per run.
- The master is the only composition that carries audio.
- Per-scene compositions remain for preview.
- The master's defaultProps are empty. All data is imported statically.
- No runtime props on the master.

## Series vs TransitionSeries

- If the piece has no non-hard-cut transitions, use <Series>.
- If the piece has any non-hard-cut transition, use <TransitionSeries> for the entire sequence.
- Do not mix Series and TransitionSeries in one master.

## Hard cuts in TransitionSeries

A hard cut in TransitionSeries uses a zero-duration transition or a Series boundary. The preferred pattern is a Series boundary inside a TransitionSeries:

<TransitionSeries.Sequence durationInFrames={60}>...</TransitionSeries.Sequence>
<TransitionSeries.Sequence durationInFrames={240}>...</TransitionSeries.Sequence>

No transition wrapper between them = hard cut.

## Transitions library

- @remotion/transitions provides dissolve, fade, slide, wipe, flip, clockWipe.
- cut-on-action, match-cut, and hard-cut are Series boundaries or duration-0 transitions.
- glitch, whip, and scale are custom React components.
- Custom transitions live in src/transitions/ and are unit-testable in isolation.

## Audio

- Each stem is a single <Audio> element.
- startFrom: 0 places the stem starting at frame 0.
- The stem's internal anchors place every line, SFX, and cue.
- No additional <Audio> elements per line, per SFX, or per cue.
- No <Audio> element with a startFrom other than 0 unless the manifest specifies.
- No Audio gain at the master level unless the manifest's mix section specifies a nonzero value.

## AbsoluteFill layering

- Picture is the base.
- Audio is on top (audio doesn't render visually).
- If the master ever adds overlays (e.g., a caption track in stage 14), they layer above the picture.

## Determinism

- No Math.random, no Date.now(), no network at render time.
- All imports are static.
- Fonts loaded via @remotion/google-fonts at module top.
- No environment variables read at render time.

## Master source hash

- The hash of src/Master.tsx and src/Root.tsx is computed at lock.
- The hash is recorded in timeline.json and run.json.
- Any change to either file invalidates the lock and forces a rollback.

## Rejected patterns

- Adding scenes via props at render time
- Fetching scene lists at render time
- Dynamic imports based on runtime conditions
- Non-<Series> sequencing via manual delays
- Per-line <Audio> elements instead of a single stem
- Any CSS transition or Tailwind animation class
- Any external timeline file (EDL, FCPXML, OTIO) as the source of truth — source is Remotion

## Optional: external timeline export

For handoff to a finishing house, the master may be exported as:

- An EDL (edit decision list) with frame-accurate cut points
- An OTIO timeline referencing scene renders

Rules:

- The export is generated from timeline.json, not authored by hand.
- The export never replaces the master composition as the source of truth.
- The export is regenerated whenever timeline.json changes.
