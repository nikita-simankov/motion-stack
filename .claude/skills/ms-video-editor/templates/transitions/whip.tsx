// Motion Studio v2 — whip transition: directional move on a token curve with token-driven motion blur.
// Copied to src/transitions/ by /ms-setup scaffold. Used inside <TransitionSeries.Transition>.

import React from "react";
import { AbsoluteFill } from "remotion";
import { CameraMotionBlur } from "@remotion/motion-blur";
import type { TransitionPresentation, TransitionPresentationComponentProps } from "@remotion/transitions";
import { useMotion } from "../motion";

export type WhipProps = { direction: "left" | "right"; width: number; curve?: string };

const WhipComponent: React.FC<TransitionPresentationComponentProps<WhipProps>> = ({
  children,
  presentationDirection,
  presentationProgress,
  passedProps,
}) => {
  const m = useMotion();
  const cfg = m.tokens.motionBlur;
  const sign = passedProps.direction === "left" ? -1 : 1;
  const p = m.ease(passedProps.curve ?? "in-out-expo")(presentationProgress);
  // exiting scene leaves in `direction`; entering scene arrives from the opposite side
  const x = presentationDirection === "exiting" ? sign * p * passedProps.width : sign * (p - 1) * passedProps.width;
  const layer = <AbsoluteFill style={{ transform: `translateX(${x}px)` }}>{children}</AbsoluteFill>;
  if (!cfg.enabled) return layer;
  return (
    <CameraMotionBlur shutterAngle={cfg.shutterAngle} samples={cfg.samples}>
      {layer}
    </CameraMotionBlur>
  );
};

export const whip = (props: WhipProps): TransitionPresentation<WhipProps> => ({
  component: WhipComponent,
  props,
});
