// Motion Studio v2 — virtual camera, parallax layers, depth blur (see references/camera-rig.md).
// Camera state is a pure function of the frame. Layers sample it; nothing is stateful.

import React, { createContext, useContext } from "react";
import { AbsoluteFill, interpolate, useCurrentFrame } from "remotion";
import { useMotion } from "./tokens";

export type CameraState = { x: number; y: number; zoom: number; rotateDeg: number };

export type CameraMove = {
  startFrame: number;
  endFrame: number;
  from: CameraState;
  to: CameraState;
  /** Named curve from style-tokens motion.curves. */
  curve: string;
};

const REST: CameraState = { x: 0, y: 0, zoom: 1, rotateDeg: 0 };

/** Pure: resolve camera state at a frame from an ordered list of moves. */
export const cameraAt = (
  frame: number,
  moves: CameraMove[],
  ease: (name: string) => (t: number) => number,
): CameraState => {
  let state = moves.length ? moves[0].from : REST;
  for (const mv of moves) {
    if (frame < mv.startFrame) break;
    const t = interpolate(frame, [mv.startFrame, mv.endFrame], [0, 1], {
      extrapolateLeft: "clamp",
      extrapolateRight: "clamp",
      easing: ease(mv.curve),
    });
    state = {
      x: mv.from.x + (mv.to.x - mv.from.x) * t,
      y: mv.from.y + (mv.to.y - mv.from.y) * t,
      zoom: mv.from.zoom + (mv.to.zoom - mv.from.zoom) * t,
      rotateDeg: mv.from.rotateDeg + (mv.to.rotateDeg - mv.from.rotateDeg) * t,
    };
  }
  return state;
};

type RigContext = { camera: CameraState; focusDepth: number; blurPerDepthPx: number; maxBlurPx: number };
const Ctx = createContext<RigContext | null>(null);

export const CameraRig: React.FC<{
  moves: CameraMove[];
  /** Depth that stays sharp. 0 is the focal plane. */
  focusDepth?: number;
  blurPerDepthPx?: number;
  maxBlurPx?: number;
  children: React.ReactNode;
}> = ({ moves, focusDepth = 0, blurPerDepthPx = 0, maxBlurPx = 12, children }) => {
  const frame = useCurrentFrame();
  const m = useMotion();
  const camera = cameraAt(frame, moves, m.ease);
  return (
    <Ctx.Provider value={{ camera, focusDepth, blurPerDepthPx, maxBlurPx }}>
      <AbsoluteFill>{children}</AbsoluteFill>
    </Ctx.Provider>
  );
};

/**
 * depth 0 moves 1:1 with the camera. depth > 0 is farther (moves less, scales less).
 * depth < 0 is nearer (moves more). Blur grows with distance from focusDepth.
 */
export const ParallaxLayer: React.FC<{ depth: number; children: React.ReactNode }> = ({ depth, children }) => {
  const rig = useContext(Ctx);
  if (!rig) throw new Error("ParallaxLayer must be inside <CameraRig>.");
  const k = 1 / (1 + depth);
  const { camera } = rig;
  const scale = 1 + (camera.zoom - 1) * k;
  const blur = Math.min(rig.maxBlurPx, Math.abs(depth - rig.focusDepth) * rig.blurPerDepthPx);
  return (
    <AbsoluteFill
      style={{
        transform: `translate(${-camera.x * k}px, ${-camera.y * k}px) scale(${scale}) rotate(${camera.rotateDeg * k}deg)`,
        transformOrigin: "50% 50%",
        filter: blur > 0 ? `blur(${blur.toFixed(2)}px)` : undefined,
      }}
    >
      {children}
    </AbsoluteFill>
  );
};
