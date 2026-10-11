import React, { useEffect, useState } from "react";
import { AbsoluteFill, Easing, interpolate, spring, useCurrentFrame } from "remotion";

export const SceneBad: React.FC = () => {
  const frame = useCurrentFrame();
  const [on, setOn] = useState(false);
  useEffect(() => {
    setTimeout(() => setOn(true), 300);
  }, []);
  const items = ["a", "b", "c", "d"];
  const x = Math.random() * 100;
  return (
    <AbsoluteFill style={{ background: "#ff00aa", transition: "opacity 0.3s ease", filter: "blur(12px)" }}>
      <div className="animate-fade-in transition-all duration-300">{String(on)}</div>
      {items.map((word) => {
        const o = interpolate(frame, [0, 20], [0, 1]);
        const y = interpolate(frame, [0, 20], [20, 0], {
          extrapolateLeft: "clamp",
          extrapolateRight: "clamp",
          easing: Easing.out(Easing.cubic),
        });
        return <div key={word} style={{ opacity: o, transform: `translateY(${y + x}px)` }}>{word}</div>;
      })}
      <div style={{ transform: `scale(${spring({ frame, fps: 30, config: { damping: 12 } })})` }}>cta</div>
      <style>{`@keyframes pulse { from { opacity: 0 } to { opacity: 1 } }`}</style>
    </AbsoluteFill>
  );
};
