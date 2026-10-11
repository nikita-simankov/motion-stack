// Motion Studio v2 — seeded noise-driven mesh gradient (see looks.md, "Surfaces").
// Colours must come from the frozen palette. Deterministic: depends only on seed + frame.

import React from "react";
import { AbsoluteFill, useCurrentFrame } from "remotion";
import { noise2D } from "@remotion/noise";

export type MeshPoint = { color: string; x: number; y: number; radiusPct: number };

export const MeshGradient: React.FC<{
  base: string;
  points: MeshPoint[];
  seed: string;
  /** Max drift of each point, in percent of the canvas. */
  amplitudePct: number;
  /** Frames for one noise unit; larger is slower. */
  framesPerCycle: number;
}> = ({ base, points, seed, amplitudePct, framesPerCycle }) => {
  const frame = useCurrentFrame();
  const t = frame / framesPerCycle;
  const layers = points.map((p, i) => {
    const dx = noise2D(`${seed}-x${i}`, t, i) * amplitudePct;
    const dy = noise2D(`${seed}-y${i}`, t, i + 100) * amplitudePct;
    const x = (p.x + dx).toFixed(2);
    const y = (p.y + dy).toFixed(2);
    return `radial-gradient(circle at ${x}% ${y}%, ${p.color} 0%, transparent ${p.radiusPct}%)`;
  });
  return <AbsoluteFill style={{ backgroundColor: base, backgroundImage: layers.join(", ") }} />;
};
