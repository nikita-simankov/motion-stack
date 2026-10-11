// Motion Studio v2 — token-driven motion blur (see motion-curves.md, "Motion blur").
// Wraps children in <CameraMotionBlur> only inside declared frame ranges, so static
// holds stay sharp and render time stays flat. Replaces raw filter: blur() transitions.

import React from "react";
import { useCurrentFrame } from "remotion";
import { CameraMotionBlur } from "@remotion/motion-blur";
import { useMotion } from "./tokens";

export type FrameRange = { startFrame: number; endFrame: number };

export const MotionBlur: React.FC<{ ranges: FrameRange[]; children: React.ReactNode }> = ({ ranges, children }) => {
  const frame = useCurrentFrame();
  const { tokens } = useMotion();
  const cfg = tokens.motionBlur;
  const active = cfg.enabled && ranges.some((r) => frame >= r.startFrame && frame <= r.endFrame);
  if (!active) return <>{children}</>;
  return (
    <CameraMotionBlur shutterAngle={cfg.shutterAngle} samples={cfg.samples}>
      {children}
    </CameraMotionBlur>
  );
};
