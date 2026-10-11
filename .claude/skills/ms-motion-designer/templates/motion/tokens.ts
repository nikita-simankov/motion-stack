// Motion Studio v2 — token-driven motion runtime.
// Copied to src/motion/ by /ms-setup scaffold. Do not edit per project.
// Every curve, spring and choreography value comes from style-tokens.json (tokenVersion 2).

import React, { createContext, useContext, useMemo } from "react";
import { Easing, interpolate, spring } from "remotion";

export type Bezier = [number, number, number, number];
export type SpringConfig = { damping: number; stiffness: number; mass: number };

export type MotionTokens = {
  curves: Record<string, Bezier>;
  aliases: Record<string, string>;
  springs: Record<string, SpringConfig>;
  roles: { entrance: string; exit: string; state: string; camera: string; cursor: string };
  choreography: {
    exitRatio: number;
    staggerStepFrames: { min: number; max: number };
    staggerCapFrames: number;
    overlapPct: number;
    readHoldFramesPerWord: number;
    minHoldFrames: number;
    settleFrames: { min: number; max: number };
    overshootMaxPct: number;
  };
  motionBlur: {
    enabled: boolean;
    component: "CameraMotionBlur" | "HtmlInCanvasMotionBlur";
    shutterAngle: number;
    samples: number;
  };
};

const identity = (t: number): number => t;

export const makeMotion = (tokens: MotionTokens) => {
  const resolve = (name: string): string => tokens.aliases[name] ?? name;

  /** Named curve -> easing function. `linear` is only valid for continuous motion. */
  const ease = (name: string): ((t: number) => number) => {
    const key = resolve(name);
    if (key === "linear") return identity;
    const b = tokens.curves[key];
    if (!b) throw new Error(`Unknown curve "${name}". Declare it in style-tokens motion.curves.`);
    return Easing.bezier(b[0], b[1], b[2], b[3]);
  };

  /** Clamped on both sides, named curve. The only sanctioned way to tween a value. */
  const tween = (
    frame: number,
    range: readonly [number, number],
    out: readonly [number, number],
    curve: string,
  ): number =>
    interpolate(frame, range, out, {
      easing: ease(curve),
      extrapolateLeft: "clamp",
      extrapolateRight: "clamp",
    });

  /** Named spring preset. */
  const springOf = (frame: number, fps: number, preset: string, delay = 0): number => {
    const config = tokens.springs[preset];
    if (!config) throw new Error(`Unknown spring "${preset}". Declare it in style-tokens motion.springs.`);
    return spring({ frame, fps, delay, config });
  };

  /** Start-frame offset for item `index` of `count`, honouring step bounds and the total cap. */
  const staggerOffset = (index: number, count: number, step?: number): number => {
    const { staggerStepFrames, staggerCapFrames } = tokens.choreography;
    const wanted = step ?? staggerStepFrames.max;
    const bounded = Math.min(Math.max(wanted, staggerStepFrames.min), staggerStepFrames.max);
    if (count <= 1) return 0;
    const capped = Math.floor(staggerCapFrames / (count - 1));
    return index * Math.max(1, Math.min(bounded, capped));
  };

  /** Minimum on-screen hold for a text block. */
  const readFrames = (text: string): number => {
    const words = text.trim().split(/\s+/).filter(Boolean).length;
    return Math.max(tokens.choreography.minHoldFrames, words * tokens.choreography.readHoldFramesPerWord);
  };

  /** Exit duration derived from the entrance duration. Integer, never below 1. */
  const exitFrames = (entranceFrames: number): number =>
    Math.max(1, Math.round(entranceFrames * tokens.choreography.exitRatio));

  /** Frame at which a follower should start so it overlaps the leader's progress. */
  const overlapStart = (leaderStart: number, leaderFrames: number): number =>
    leaderStart + Math.round((leaderFrames * tokens.choreography.overlapPct) / 100);

  return { tokens, ease, tween, springOf, staggerOffset, readFrames, exitFrames, overlapStart };
};

export type Motion = ReturnType<typeof makeMotion>;

const MotionContext = createContext<Motion | null>(null);

export const MotionProvider: React.FC<{ tokens: MotionTokens; children: React.ReactNode }> = ({
  tokens,
  children,
}) => {
  const motion = useMemo(() => makeMotion(tokens), [tokens]);
  return React.createElement(MotionContext.Provider, { value: motion }, children);
};

export const useMotion = (): Motion => {
  const m = useContext(MotionContext);
  if (!m) throw new Error("useMotion() needs <MotionProvider tokens={...}> at the composition root.");
  return m;
};
