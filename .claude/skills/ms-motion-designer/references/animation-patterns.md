# Animation Patterns

Canonical Remotion patterns. Rejected CSS patterns.

## Setup

Scenes read curves, springs and stagger from tokens:

const frame = useCurrentFrame();
const { fps } = useVideoConfig();
const m = useMotion(); // from src/motion, token contract v2

Never import `Easing` in a scene (ANIM-04). Never pass an inline spring config (ANIM-10). Never call `interpolate()` without an easing unless the motion is continuous and marked `// ms:linear` (ANIM-06).

## Entrance

const start = 12;
const progress = m.tween(frame, [start, start + 18], [0, 1], m.tokens.roles.entrance);
const translateY = interpolate(progress, [0, 1], [24, 0]);

<div style={{ opacity: progress, transform: `translateY(${translateY}px)` }} />

`m.tween` clamps both sides and uses the named curve. The second `interpolate` maps an already-eased 0..1 value to pixels, so it is linear on purpose.

## Exit

const exitLen = m.exitFrames(18); // 12 frames, 65% of the entrance
const out = m.tween(frame, [exitStart, exitStart + exitLen], [1, 0], m.tokens.roles.exit);

## Spring landing

const scale = m.springOf(frame, fps, "land", landFrame);

<div style={{ transform: `scale(${scale})` }} />

Presets: land, snappy, soft, heavy (bouncy only in playful tone). See `ms-styleframe-designer/references/motion-curves.md`.

## Stagger

{items.map((item, i) => {
  const start = base + m.staggerOffset(i, items.length);
  const t = m.tween(frame, [start, start + 16], [0, 1], m.tokens.roles.entrance);
  return <Row key={item.id} style={{ opacity: t, transform: `translateY(${(1 - t) * 20}px)` }} />;
})}

The offset uses the item index. A group that animates with no index offset is ANIM-07.

## Overlap

const leaderStart = 20;
const leaderLen = 18;
const followerStart = m.overlapStart(leaderStart, leaderLen); // starts at 65% of the leader

## Masked line reveal

<div style={{ overflow: "hidden", height: lineHeightPx }}>
  <div style={{ transform: `translateY(${m.tween(frame, [s, s + 20], [100, 0], m.tokens.roles.entrance)}%)` }}>{line}</div>
</div>

Use the `KineticText` component (`preset="mask-line"`) rather than rebuilding this.

## Shape morph

import { interpolatePath } from "@remotion/paths";

const d = interpolatePath(m.tween(frame, [s, s + 24], [0, 1], m.tokens.roles.state), pathA, pathB);
<path d={d} />

Both paths must have compatible structure. Colours come from the palette.

## Seeded noise drift

import { noise2D } from "@remotion/noise";

const x = noise2D("hero-drift-x", frame / 90, 0) * 12; // seed is a string; same seed, same value

Seeds are constants in the source. `Math.random()` is still rejected.

## Timing with Sequence

<Sequence from={30} durationInFrames={60}>
  <MyElement />
</Sequence>

No motion inside <Sequence>'s props. Motion is inside the child.

## Series

<Series>
  <Series.Sequence durationInFrames={90}>
    <BeatOne />
  </Series.Sequence>
  <Series.Sequence durationInFrames={60}>
    <BeatTwo />
  </Series.Sequence>
</Series>

Series for sequential content. Not for motion.

## Transition between scenes

<TransitionSeries>
  <TransitionSeries.Sequence durationInFrames={90}>
    <SceneA />
  </TransitionSeries.Sequence>
  <TransitionSeries.Transition
    presentation={fade()}
    timing={linearTiming({ durationInFrames: 15 })}
  />
  <TransitionSeries.Sequence durationInFrames={120}>
    <SceneB />
  </TransitionSeries.Sequence>
</TransitionSeries>

## Kinetic type

Use the preset library (`KineticText`, `NumberRoll`). See `ms-styleframe-designer/references/kinetic-type.md`.

<KineticText preset="word-lockup" lines={["Stop deploying MCP wrong"]} wordFrames={voWordFrames} startFrame={0} entranceFrames={14} ... />

## Cursor click

const frame = useCurrentFrame();
const clickFrame = 240;
const position = cursorAt(frame, cursorPath, m.ease, m.tokens.roles.cursor); // eased legs, token curve
const isClicked = frame >= clickFrame;
const scale = isClicked ? m.springOf(frame, fps, "snappy", clickFrame) : 1;

For a camera that follows the cursor, use `SmartZoom`.

## Loading spinner (frame-driven)

const frame = useCurrentFrame();
const { fps } = useVideoConfig();
const rotation = (frame / fps) \* 360; // ms:linear continuous

<div style={{ transform: `rotate(${rotation}deg)` }} />

No CSS animation. No @keyframes.

## Progress bar

const frame = useCurrentFrame();
const { durationInFrames } = useVideoConfig();
const widthPct = (frame / durationInFrames) \* 100;

<div style={{ width: `${widthPct}%` }} />

## Parallax

const frame = useCurrentFrame();
const { durationInFrames } = useVideoConfig();
const clamp = { extrapolateLeft: "clamp", extrapolateRight: "clamp" } as const;
// ms:linear continuous drift across the scene
const bgX = interpolate(frame, [0, durationInFrames], [0, -40], clamp);
// ms:linear continuous drift across the scene
const fgX = interpolate(frame, [0, durationInFrames], [0, -120], clamp);

For camera-driven parallax with depth and blur, use `CameraRig` and `ParallaxLayer` (`camera-rig.md`).

<div>
  <div style={{ transform: `translateX(${bgX}px)` }}>background</div>
  <div style={{ transform: `translateX(${fgX}px)` }}>foreground</div>
</div>

## Rejected patterns

### CSS transitions

/_ rejected _/
.foo {
transition: opacity 0.3s ease;
}

### CSS animations

/_ rejected _/
@keyframes fadeIn {
from { opacity: 0; }
to { opacity: 1; }
}

### Tailwind animation classes

/_ rejected _/

<div className="animate-fade-in transition-all duration-300">...</div>

### setTimeout

// rejected
useEffect(() => {
setTimeout(() => setVisible(true), 300);
}, []);

### requestAnimationFrame

// rejected
useEffect(() => {
let raf: number;
const tick = () => {
// ...
raf = requestAnimationFrame(tick);
};
raf = requestAnimationFrame(tick);
return () => cancelAnimationFrame(raf);
}, []);

### Math.random at render time

// rejected
const x = Math.random() \* 100;

// accepted
const x = seededRandom(frame) \* 100;

### Date.now() at render time

// rejected
const t = Date.now();

## Rules

- Every animated element has an explicit start and end frame.
- Every interpolate call clamps both sides (ANIM-11) and has a named easing or `// ms:linear` (ANIM-06).
- Every spring call uses a named preset (ANIM-10).
- Every group of three or more staggers (ANIM-07).
- A scene with six or more eased motions uses at least two curves (ANIM-09).
- Every frame anchor is an integer.
- Every duration is in frames.
- Every timing value that appears in a comment is expressed in both frames and seconds.
