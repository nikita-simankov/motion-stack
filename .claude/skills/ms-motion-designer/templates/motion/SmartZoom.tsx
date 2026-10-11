// Motion Studio v2 — cursor path + camera that follows it (see ui-mockup-components.md).
// Product demos: smoothed cursor with lag, zoom segments that frame the action.

import React from "react";
import { AbsoluteFill, interpolate, useCurrentFrame } from "remotion";
import { useMotion } from "./tokens";

export type PathPoint = { frame: number; x: number; y: number };
export type ZoomSegment = { startFrame: number; endFrame: number; zoom: number };

/** Pure: cursor position at a frame. Each leg eases with the named curve. */
export const cursorAt = (
  frame: number,
  path: PathPoint[],
  ease: (name: string) => (t: number) => number,
  curve: string,
): { x: number; y: number } => {
  if (path.length === 0) return { x: 0, y: 0 };
  if (frame <= path[0].frame) return { x: path[0].x, y: path[0].y };
  for (let i = 1; i < path.length; i++) {
    const a = path[i - 1];
    const b = path[i];
    if (frame <= b.frame) {
      const opts = { extrapolateLeft: "clamp", extrapolateRight: "clamp", easing: ease(curve) } as const;
      return {
        x: interpolate(frame, [a.frame, b.frame], [a.x, b.x], opts),
        y: interpolate(frame, [a.frame, b.frame], [a.y, b.y], opts),
      };
    }
  }
  const last = path[path.length - 1];
  return { x: last.x, y: last.y };
};

/** Pure: zoom factor at a frame. Segments ease in and out with the camera curve. */
export const zoomAt = (
  frame: number,
  segments: ZoomSegment[],
  ease: (name: string) => (t: number) => number,
  curve: string,
  transitionFrames: number,
): number => {
  let zoom = 1;
  for (const s of segments) {
    const opts = { extrapolateLeft: "clamp", extrapolateRight: "clamp", easing: ease(curve) } as const;
    const zin = interpolate(frame, [s.startFrame, s.startFrame + transitionFrames], [1, s.zoom], opts);
    const zout = interpolate(frame, [s.endFrame - transitionFrames, s.endFrame], [s.zoom, 1], opts);
    if (frame >= s.startFrame && frame <= s.endFrame) zoom = Math.max(zoom, Math.min(zin, zout));
  }
  return zoom;
};

export const SmartZoom: React.FC<{
  width: number;
  height: number;
  cursorPath: PathPoint[];
  zoomSegments: ZoomSegment[];
  /** Frames the camera trails the cursor so it never feels glued to it. */
  followLagFrames: number;
  transitionFrames: number;
  children: React.ReactNode;
}> = ({ width, height, cursorPath, zoomSegments, followLagFrames, transitionFrames, children }) => {
  const frame = useCurrentFrame();
  const m = useMotion();
  const zoom = zoomAt(frame, zoomSegments, m.ease, m.tokens.roles.camera, transitionFrames);
  const focus = cursorAt(Math.max(0, frame - followLagFrames), cursorPath, m.ease, m.tokens.roles.cursor);

  // Keep the focus point centred, but never reveal outside the canvas.
  const maxX = ((zoom - 1) * width) / 2;
  const maxY = ((zoom - 1) * height) / 2;
  const tx = Math.max(-maxX, Math.min(maxX, (width / 2 - focus.x) * (zoom - 1)));
  const ty = Math.max(-maxY, Math.min(maxY, (height / 2 - focus.y) * (zoom - 1)));

  return (
    <AbsoluteFill style={{ transform: `translate(${tx}px, ${ty}px) scale(${zoom})`, transformOrigin: "50% 50%" }}>
      {children}
    </AbsoluteFill>
  );
};
