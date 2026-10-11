import React from "react";
import { AbsoluteFill, interpolate, useCurrentFrame, useVideoConfig } from "remotion";
import { useMotion } from "../motion";

export const SceneGood: React.FC = () => {
  const frame = useCurrentFrame();
  useVideoConfig();
  const m = useMotion();
  const items = ["Stop", "deploying", "MCP", "wrong"];
  // ms:linear progress bar is continuous motion
  const sweep = interpolate(frame, [0, 90], [0, 100], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });
  return (
    <AbsoluteFill style={{ backgroundColor: "#0A0A0A", color: "#F5F5F5" }}>
      {items.map((word, i) => {
        const start = 6 + m.staggerOffset(i, items.length);
        const y = m.tween(frame, [start, start + 18], [24, 0], "out-expo");
        const o = m.tween(frame, [start, start + 12], [0, 1], "out-cubic");
        return (
          <div key={i} style={{ opacity: o, transform: `translateY(${y}px)` }}>
            {word}
          </div>
        );
      })}
      <div style={{ width: `${sweep}%`, height: 4, backgroundColor: "#3B82F6" }} />
      <div style={{ opacity: m.tween(frame, [60, 72], [1, 0], "in-cubic") }}>exit</div>
      <div style={{ transform: `scale(${m.springOf(frame, 30, "land")})` }}>cta</div>
    </AbsoluteFill>
  );
};
