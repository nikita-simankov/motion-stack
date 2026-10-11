# Grade Pipeline

Fixed operation order, Remotion implementation.

## Order (fixed)

1. grain
2. halation
3. chromaticAberration
4. vignette
5. contrastCurve
6. lut
7. blackClamp
8. whiteClamp
9. rolloff
10. outputTransform

The order is not a preference. It is the pipeline. Deviating is a GRD-xx defect.

## Remotion implementation

The graded master is a React component that layers operations above the picture-locked master.

Pattern:

import { AbsoluteFill } from "remotion";
import { Master } from "./Master";
import { Grain } from "./grade/Grain";
import { Halation } from "./grade/Halation";
import { ChromaticAberration } from "./grade/ChromaticAberration";
import { Vignette } from "./grade/Vignette";
import { ContrastCurve } from "./grade/ContrastCurve";
import { Lut } from "./grade/Lut";
import { BlackWhiteClamp } from "./grade/BlackWhiteClamp";
import { HighlightRolloff } from "./grade/HighlightRolloff";
import { OutputTransform } from "./grade/OutputTransform";

export const GradedMaster: React.FC = () => (
<AbsoluteFill>
<OutputTransform>
<HighlightRolloff>
<BlackWhiteClamp>
<Lut>
<ContrastCurve>
<Vignette>
<ChromaticAberration>
<Halation>
<Grain>
<Master />
</Grain>
</Halation>
</ChromaticAberration>
</Vignette>
</ContrastCurve>
</Lut>
</BlackWhiteClamp>
</HighlightRolloff>
</OutputTransform>
</AbsoluteFill>
);

The nesting expresses the pipeline order from outermost (applied last) to innermost (applied first).

## Implementation constraints

- Every operation is a React component in Remotion.
- Every operation reads useCurrentFrame() for animation.
- No CSS filters, no Tailwind filters.
- Every pixel operation is implemented via WebGL, WebAssembly, or an offscreen canvas in a Remotion context.
- No third-party compositor outside Remotion.
- No post-processing at the encoder.

## Determinism

Every operation is deterministic:

- Grain uses a seeded noise field, seed derived from frame index.
- Halation, aberration, and vignette are pure functions of input.
- Contrast curve uses fixed anchors.
- LUT is a fixed .cube.
- Clamps are fixed.
- Rolloff is fixed.
- Output transform is fixed.

No operation uses unseeded randomness, system time, or network.

## Performance

Grade operations are per-pixel. For 1080x1920 at 30fps, per-frame cost matters.

Guidelines:

- Grain, halation, and vignette are the cheapest. Fine per frame.
- Chromatic aberration with radial offset is medium cost.
- Contrast curve, LUT, and clamps are cheapest as a single combined LUT operation.
- Combine curve + LUT + clamps into a single 3D LUT at build time when possible. This reduces per-frame cost from 3 operations to 1.

## Rejected patterns

- CSS filter: blur(), contrast(), saturate()
- Tailwind filter classes
- Post-processing at the encoder (ffmpeg filters after Remotion)
- Non-deterministic noise
- Any operation that changes frame timing
- Any operation that reads external files at render time except the .cube

## Rollback to gate 6

Any change to the grade pipeline structure (adding, removing, or reordering an operation) requires a rollback to gate 6. The pipeline shape is part of the frozen token contract.
