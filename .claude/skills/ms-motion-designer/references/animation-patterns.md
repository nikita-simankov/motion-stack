# Animation Patterns

Canonical Remotion patterns. Rejected CSS patterns.

## Entrance

const frame = useCurrentFrame();
const { fps } = useVideoConfig();
const progress = interpolate(frame, [0, fps], [0, 1], {
extrapolateLeft: "clamp",
extrapolateRight: "clamp",
easing: Easing.out(Easing.cubic),
});
const opacity = progress;
const translateY = interpolate(progress, [0, 1], [20, 0]);

<div style={{ opacity, transform: `translateY(${translateY}px)` }} />

## Spring landing

const frame = useCurrentFrame();
const { fps } = useVideoConfig();
const scale = spring({
frame,
fps,
config: { damping: 12, stiffness: 180, mass: 0.6 },
});

<div style={{ transform: `scale(${scale})` }} />

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

const frame = useCurrentFrame();
const { fps } = useVideoConfig();
const words = ["Stop", "deploying", "MCP", "wrong"];

return (

  <div>
    {words.map((word, i) => {
      const start = i * (fps * 0.2);
      const end = start + fps * 0.4;
      const opacity = interpolate(frame, [start, end], [0, 1], {
        extrapolateLeft: "clamp",
        extrapolateRight: "clamp",
      });
      const y = interpolate(frame, [start, end], [20, 0], {
        extrapolateLeft: "clamp",
        extrapolateRight: "clamp",
      });
      return (
        <div key={i} style={{ opacity, transform: `translateY(${y}px)` }}>
          {word}
        </div>
      );
    })}
  </div>
);

## Cursor click

const frame = useCurrentFrame();
const clickFrame = 240;
const position = interpolate(frame, [180, 240], [[200, 320], [410, 512]], {
extrapolateLeft: "clamp",
extrapolateRight: "clamp",
easing: Easing.inOut(Easing.cubic),
});
const isClicked = frame >= clickFrame;
const scale = isClicked ? spring({ frame: frame - clickFrame, fps, config: { damping: 10 } }) : 1;

## Loading spinner (frame-driven)

const frame = useCurrentFrame();
const { fps } = useVideoConfig();
const rotation = (frame / fps) \* 360;

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
const bgX = interpolate(frame, [0, durationInFrames], [0, -40]);
const fgX = interpolate(frame, [0, durationInFrames], [0, -120]);

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
- Every interpolate call clamps both sides.
- Every spring call uses explicit config.
- Every frame anchor is an integer.
- Every duration is in frames.
- Every timing value that appears in a comment is expressed in both frames and seconds.
