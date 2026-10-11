// Motion Studio v2 — word-level captions (see ms-finishing-suite/references/caption-pipeline.md).
// Input is vo.json `words` (integer frames, already shifted to the master timeline).
// Paging is computed in frames, so cues land exactly where the VO does.

import React from "react";
import { interpolate, useCurrentFrame } from "remotion";
import { useMotion } from "./tokens";

export type CaptionWord = { text: string; startFrame: number; endFrame: number };
export type CaptionPage = { words: CaptionWord[]; startFrame: number; endFrame: number };
export type CaptionStyle = "cue" | "word-highlight" | "word-pop";

export type PagingOptions = {
  maxWordsPerPage: number;
  /** Start a new page when the silence between two words is at least this many frames. */
  breakOnGapFrames: number;
};

/** Pure, deterministic paging. Exported for tests and for the SRT/VTT sidecar writer. */
export const pageWords = (words: CaptionWord[], opts: PagingOptions): CaptionPage[] => {
  const pages: CaptionPage[] = [];
  let current: CaptionWord[] = [];
  const flush = () => {
    if (current.length === 0) return;
    pages.push({
      words: current,
      startFrame: current[0].startFrame,
      endFrame: current[current.length - 1].endFrame,
    });
    current = [];
  };
  words.forEach((w, i) => {
    const prev = words[i - 1];
    const gap = prev ? w.startFrame - prev.endFrame : 0;
    const prevEndsSentence = prev ? /[.!?]$/.test(prev.text.trim()) : false;
    if (current.length >= opts.maxWordsPerPage || gap >= opts.breakOnGapFrames || prevEndsSentence) flush();
    current.push(w);
  });
  flush();
  return pages;
};

export type WordCaptionsProps = {
  words: CaptionWord[];
  style: CaptionStyle;
  maxWordsPerPage: number;
  breakOnGapFrames: number;
  fontFamily: string;
  fontWeight: number;
  fontSizePx: number;
  lineHeightPx: number;
  color: string;
  activeColor: string;
  /** rgba()/8-digit hex including alpha; the scrim is a Remotion element, never CSS text-shadow. */
  scrimColor: string;
  /** Safe-zone insets from platform-specs for this aspect. */
  insetBottomPx: number;
  insetSidePx: number;
  fadeFrames: number;
};

export const WordCaptions: React.FC<WordCaptionsProps> = (p) => {
  const frame = useCurrentFrame();
  const m = useMotion();
  const pages = React.useMemo(
    () => pageWords(p.words, { maxWordsPerPage: p.maxWordsPerPage, breakOnGapFrames: p.breakOnGapFrames }),
    [p.words, p.maxWordsPerPage, p.breakOnGapFrames],
  );
  const page = pages.find((pg) => frame >= pg.startFrame && frame <= pg.endFrame + p.fadeFrames);
  if (!page) return null;

  const fadeIn = interpolate(frame, [page.startFrame, page.startFrame + p.fadeFrames], [0, 1], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });
  const fadeOut = interpolate(frame, [page.endFrame, page.endFrame + p.fadeFrames], [1, 0], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });

  return (
    <div
      style={{
        position: "absolute",
        left: p.insetSidePx,
        right: p.insetSidePx,
        bottom: p.insetBottomPx,
        display: "flex",
        justifyContent: "center",
        opacity: Math.min(fadeIn, fadeOut),
      }}
    >
      <div
        style={{
          background: p.scrimColor,
          padding: "12px 20px",
          borderRadius: 12,
          display: "flex",
          flexWrap: "wrap",
          justifyContent: "center",
          columnGap: "0.28em",
          fontFamily: p.fontFamily,
          fontWeight: p.fontWeight,
          fontSize: p.fontSizePx,
          lineHeight: `${p.lineHeightPx}px`,
        }}
      >
        {page.words.map((w, i) => {
          const active = frame >= w.startFrame && frame < w.endFrame;
          const spoken = frame >= w.startFrame;
          const pop =
            p.style === "word-pop" ? m.tween(frame, [w.startFrame, w.startFrame + 5], [0.9, 1], m.tokens.roles.entrance) : 1;
          const color = p.style !== "cue" && active ? p.activeColor : p.color;
          return (
            <span
              key={i}
              style={{
                color,
                opacity: p.style === "cue" ? 1 : spoken ? 1 : 0.55,
                display: "inline-block",
                transform: `scale(${pop})`,
                transformOrigin: "50% 80%",
              }}
            >
              {w.text}
            </span>
          );
        })}
      </div>
    </div>
  );
};
