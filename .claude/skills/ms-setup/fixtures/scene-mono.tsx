import React from "react";
import { AbsoluteFill, useCurrentFrame } from "remotion";
import { useMotion } from "../motion";

// Monotony: every eased motion uses the same curve.
export const SceneMono: React.FC = () => {
  const frame = useCurrentFrame();
  const m = useMotion();
  const a = m.tween(frame, [0, 12], [0, 1], "out-cubic");
  const b = m.tween(frame, [12, 24], [0, 1], "out-cubic");
  const c = m.tween(frame, [24, 36], [0, 1], "out-cubic");
  const d = m.tween(frame, [36, 48], [0, 1], "out-cubic");
  const e = m.tween(frame, [48, 60], [0, 1], "out-cubic");
  const f = m.tween(frame, [60, 72], [0, 1], "out-cubic");
  return <AbsoluteFill style={{ opacity: a * b * c * d * e * f }} />;
};
