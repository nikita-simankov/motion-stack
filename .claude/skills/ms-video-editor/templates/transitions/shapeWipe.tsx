// Motion Studio v2 — shape-wipe: the entering scene is revealed through a growing shape.
// Shapes: circle, inset (rounded rectangle). Other shapes follow the same pattern with a
// clip-path or SVG mask; add them as new presets, not one-offs.

import React from "react";
import { AbsoluteFill } from "remotion";
import type { TransitionPresentation, TransitionPresentationComponentProps } from "@remotion/transitions";
import { useMotion } from "../motion";

export type ShapeWipeProps = {
  shape: "circle" | "inset";
  width: number;
  height: number;
  /** Reveal origin in canvas pixels. Defaults to the centre. */
  originX?: number;
  originY?: number;
  curve?: string;
  cornerRadiusPx?: number;
};

const ShapeWipeComponent: React.FC<TransitionPresentationComponentProps<ShapeWipeProps>> = ({
  children,
  presentationDirection,
  presentationProgress,
  passedProps,
}) => {
  const m = useMotion();
  const { shape, width, height } = passedProps;
  const ox = passedProps.originX ?? width / 2;
  const oy = passedProps.originY ?? height / 2;
  const p = m.ease(passedProps.curve ?? m.tokens.roles.state)(presentationProgress);

  if (presentationDirection === "exiting") {
    return <AbsoluteFill>{children}</AbsoluteFill>;
  }

  let clipPath: string;
  if (shape === "circle") {
    // radius that reaches the farthest corner from the origin
    const rMax = Math.hypot(Math.max(ox, width - ox), Math.max(oy, height - oy));
    clipPath = `circle(${(p * rMax).toFixed(2)}px at ${ox}px ${oy}px)`;
  } else {
    const left = ox * (1 - p);
    const right = (width - ox) * (1 - p);
    const top = oy * (1 - p);
    const bottom = (height - oy) * (1 - p);
    const r = (passedProps.cornerRadiusPx ?? 48) * (1 - p);
    clipPath = `inset(${top.toFixed(2)}px ${right.toFixed(2)}px ${bottom.toFixed(2)}px ${left.toFixed(2)}px round ${r.toFixed(2)}px)`;
  }
  return <AbsoluteFill style={{ clipPath }}>{children}</AbsoluteFill>;
};

export const shapeWipe = (props: ShapeWipeProps): TransitionPresentation<ShapeWipeProps> => ({
  component: ShapeWipeComponent,
  props,
});
