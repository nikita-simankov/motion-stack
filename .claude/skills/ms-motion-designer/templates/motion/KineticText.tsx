// Motion Studio v2 — kinetic type presets (see ms-styleframe-designer/references/kinetic-type.md).
// All motion is frame-driven. Wrapping is explicit via maxWidthPx; nothing relies on browser auto-wrap.

import React from "react";
import { interpolate, useCurrentFrame, useVideoConfig } from "remotion";
import { fitText } from "@remotion/layout-utils";
import { useMotion } from "./tokens";

export type KineticPreset =
  | "mask-line"
  | "word-rise"
  | "word-lockup"
  | "weight-swell"
  | "outline-fill";

export type KineticTextProps = {
  preset: KineticPreset;
  /** One string per line. Lines never reflow. */
  lines: string[];
  startFrame: number;
  /** Duration of one element's entrance, in frames (must sit inside a motion bucket). */
  entranceFrames: number;
  /** CSS font shorthand pieces, taken from the type role in style-tokens. */
  fontFamily: string;
  fontWeight: number;
  fontSizePx: number;
  lineHeightPx: number;
  trackingEm: number;
  color: string;
  maxWidthPx: number;
  /** When true, shrink fontSizePx so the longest line fits maxWidthPx. */
  fit?: boolean;
  /** word-lockup only: absolute frame at which each word lands (from vo.json words). */
  wordFrames?: number[];
  /** weight-swell only: variable-font weight range. */
  weightRange?: readonly [number, number];
  /** outline-fill only: fill colour; `color` is used for the outline. */
  fillColor?: string;
  align?: "left" | "center";
};

const baseStyle = (p: KineticTextProps, sizePx: number): React.CSSProperties => ({
  fontFamily: p.fontFamily,
  fontWeight: p.fontWeight,
  fontSize: sizePx,
  lineHeight: `${p.lineHeightPx}px`,
  letterSpacing: `${p.trackingEm}em`,
  color: p.color,
  whiteSpace: "pre",
});

export const KineticText: React.FC<KineticTextProps> = (props) => {
  const frame = useCurrentFrame();
  useVideoConfig();
  const m = useMotion();
  const { preset, lines, startFrame, entranceFrames, maxWidthPx } = props;
  const entrance = m.tokens.roles.entrance;
  const align = props.align ?? "left";

  let sizePx = props.fontSizePx;
  if (props.fit) {
    const longest = lines.reduce((a, b) => (b.length > a.length ? b : a), "");
    const fitted = fitText({
      text: longest,
      withinWidth: maxWidthPx,
      fontFamily: props.fontFamily,
      fontWeight: props.fontWeight,
      letterSpacing: `${props.trackingEm}em`,
    }).fontSize;
    sizePx = Math.min(sizePx, fitted);
  }

  const wrap: React.CSSProperties = {
    width: maxWidthPx,
    display: "flex",
    flexDirection: "column",
    alignItems: align === "center" ? "center" : "flex-start",
  };

  // Flat word list so stagger and lock-up share one index space.
  const words = lines.flatMap((line, li) =>
    line.split(" ").map((w, wi, arr) => ({ w: wi < arr.length - 1 ? `${w} ` : w, li })),
  );
  const totalWords = words.length;

  if (preset === "mask-line") {
    return (
      <div style={wrap}>
        {lines.map((line, i) => {
          const s = startFrame + m.staggerOffset(i, lines.length);
          const y = m.tween(frame, [s, s + entranceFrames], [100, 0], entrance);
          return (
            <div key={i} style={{ overflow: "hidden", height: props.lineHeightPx }}>
              <div style={{ ...baseStyle(props, sizePx), transform: `translateY(${y}%)` }}>{line}</div>
            </div>
          );
        })}
      </div>
    );
  }

  if (preset === "word-rise" || preset === "word-lockup") {
    return (
      <div style={wrap}>
        {lines.map((_, li) => (
          <div key={li} style={{ display: "flex", height: props.lineHeightPx }}>
            {words
              .map((word, gi) => ({ word, gi }))
              .filter(({ word }) => word.li === li)
              .map(({ word, gi }) => {
                const s =
                  preset === "word-lockup" && props.wordFrames
                    ? props.wordFrames[gi] ?? startFrame
                    : startFrame + m.staggerOffset(gi, totalWords);
                const t = m.tween(frame, [s, s + entranceFrames], [0, 1], entrance);
                const y = interpolate(t, [0, 1], [sizePx * 0.35, 0]);
                const scale = preset === "word-lockup" ? interpolate(t, [0, 1], [1.12, 1]) : 1;
                return (
                  <span
                    key={gi}
                    style={{
                      ...baseStyle(props, sizePx),
                      opacity: t,
                      display: "inline-block",
                      transform: `translateY(${y}px) scale(${scale})`,
                      transformOrigin: "50% 80%",
                    }}
                  >
                    {word.w}
                  </span>
                );
              })}
          </div>
        ))}
      </div>
    );
  }

  if (preset === "weight-swell") {
    const [w0, w1] = props.weightRange ?? [props.fontWeight, Math.min(900, props.fontWeight + 300)];
    const wght = m.tween(frame, [startFrame, startFrame + entranceFrames], [w0, w1], m.tokens.roles.state);
    const o = m.tween(frame, [startFrame, startFrame + Math.round(entranceFrames / 2)], [0, 1], entrance);
    return (
      <div style={wrap}>
        {lines.map((line, i) => (
          <div
            key={i}
            style={{
              ...baseStyle(props, sizePx),
              opacity: o,
              fontVariationSettings: `"wght" ${wght.toFixed(2)}`,
            }}
          >
            {line}
          </div>
        ))}
      </div>
    );
  }

  // outline-fill
  const fill = m.tween(frame, [startFrame, startFrame + entranceFrames], [0, 100], m.tokens.roles.state);
  return (
    <div style={wrap}>
      {lines.map((line, i) => (
        <div
          key={i}
          style={{
            ...baseStyle(props, sizePx),
            color: "transparent",
            WebkitTextStroke: `2px ${props.color}`,
            backgroundImage: `linear-gradient(90deg, ${props.fillColor ?? props.color} ${fill}%, transparent ${fill}%)`,
            WebkitBackgroundClip: "text",
            backgroundClip: "text",
          }}
        >
          {line}
        </div>
      ))}
    </div>
  );
};

/** Number roll: counts from `from` to `to` over `entranceFrames`, tabular figures required. */
export const NumberRoll: React.FC<{
  from: number;
  to: number;
  startFrame: number;
  entranceFrames: number;
  decimals?: number;
  prefix?: string;
  suffix?: string;
  style: React.CSSProperties;
}> = ({ from, to, startFrame, entranceFrames, decimals = 0, prefix = "", suffix = "", style }) => {
  const frame = useCurrentFrame();
  const m = useMotion();
  const v = m.tween(frame, [startFrame, startFrame + entranceFrames], [from, to], m.tokens.roles.entrance);
  return (
    <span style={{ ...style, fontVariantNumeric: "tabular-nums" }}>
      {prefix}
      {v.toFixed(decimals)}
      {suffix}
    </span>
  );
};
