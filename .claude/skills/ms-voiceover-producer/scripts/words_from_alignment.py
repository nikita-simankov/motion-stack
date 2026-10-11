#!/usr/bin/env python3
"""Convert ElevenLabs character-level alignment into word-level frame timings.

    words_from_alignment.py <alignment.json> --fps 30 --line-start-frame 0 --line-end-frame 90
                            [--trim-lead-ms 0] [--bridge-gap-frames 6]
    words_from_alignment.py --selftest

Input is the `alignment` object from the text-to-speech "with timestamps" response:
    { "characters": [...], "character_start_times_seconds": [...], "character_end_times_seconds": [...] }
(a file holding the whole response, with `alignment` as a key, is also accepted).

Output (stdout): [{"text": "Stop", "startFrame": 0, "endFrame": 12}, ...] in master-timeline frames.

Rules:
  - Words are whitespace-delimited runs of characters; punctuation stays attached (it is script text).
  - times are shifted by --trim-lead-ms (leading silence removed in processing) before conversion.
  - frames are integers; every word lasts at least 1 frame; words never overlap; all stay inside the line.
  - a gap of <= --bridge-gap-frames between words is closed (end := next start) so highlights do not flicker.
"""
from __future__ import annotations

import argparse
import json
import sys


def words_from_alignment(alignment: dict, fps: int, line_start: int, line_end: int,
                         trim_lead_ms: float = 0.0, bridge_gap: int = 6) -> list[dict]:
    chars = alignment["characters"]
    starts = alignment["character_start_times_seconds"]
    ends = alignment["character_end_times_seconds"]
    if not (len(chars) == len(starts) == len(ends)):
        raise ValueError("alignment arrays differ in length")

    trim = trim_lead_ms / 1000.0

    def frame(t: float) -> int:
        return line_start + round((t - trim) * fps)

    words: list[dict] = []
    buf, w_start, w_end = "", None, None
    for ch, s, e in zip(chars, starts, ends):
        if ch.isspace():
            if buf:
                words.append({"text": buf, "t0": w_start, "t1": w_end})
                buf, w_start, w_end = "", None, None
            continue
        if not buf:
            w_start = s
        buf += ch
        w_end = e
    if buf:
        words.append({"text": buf, "t0": w_start, "t1": w_end})

    out: list[dict] = []
    for w in words:
        a, b = frame(w["t0"]), frame(w["t1"])
        a = max(line_start, min(a, line_end - 1))
        b = max(a + 1, min(b, line_end))
        out.append({"text": w["text"], "startFrame": a, "endFrame": b})

    for i in range(1, len(out)):
        prev, cur = out[i - 1], out[i]
        if cur["startFrame"] < prev["endFrame"]:
            cur["startFrame"] = prev["endFrame"]
            cur["endFrame"] = max(cur["endFrame"], cur["startFrame"] + 1)
        gap = cur["startFrame"] - prev["endFrame"]
        if 0 < gap <= bridge_gap:
            prev["endFrame"] = cur["startFrame"]
    if out:
        out[-1]["endFrame"] = min(out[-1]["endFrame"], line_end)
        if out[-1]["endFrame"] <= out[-1]["startFrame"]:
            out[-1]["startFrame"] = out[-1]["endFrame"] - 1
    return out


def _selftest() -> int:
    text = "Stop deploying MCP wrong."
    # 0.10s per character, 0.05s lead silence, one trimmed away
    chars = list(text)
    starts = [0.05 + i * 0.1 for i in range(len(chars))]
    ends = [s + 0.1 for s in starts]
    al = {"characters": chars, "character_start_times_seconds": starts, "character_end_times_seconds": ends}
    got = words_from_alignment(al, fps=30, line_start=90, line_end=180, trim_lead_ms=50, bridge_gap=6)
    assert [w["text"] for w in got] == ["Stop", "deploying", "MCP", "wrong."], got
    assert got[0]["startFrame"] == 90, got[0]
    for w in got:
        assert isinstance(w["startFrame"], int) and isinstance(w["endFrame"], int)
        assert 90 <= w["startFrame"] < w["endFrame"] <= 180, w
    for a, b in zip(got, got[1:]):
        assert a["endFrame"] <= b["startFrame"], (a, b)
        assert b["startFrame"] - a["endFrame"] <= 6, "gap not bridged"
    # clamp: alignment running past the line end must not escape the line
    long_al = {"characters": list("ab cd"), "character_start_times_seconds": [0, .5, 1, 5, 5.5], "character_end_times_seconds": [.5, 1, 1.2, 5.5, 6]}
    clamped = words_from_alignment(long_al, fps=30, line_start=0, line_end=60)
    assert all(0 <= w["startFrame"] < w["endFrame"] <= 60 for w in clamped), clamped
    print("selftest ok:", json.dumps(got))
    return 0


def main() -> int:
    if "--selftest" in sys.argv:
        return _selftest()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("alignment")
    ap.add_argument("--fps", type=int, default=30)
    ap.add_argument("--line-start-frame", type=int, required=True)
    ap.add_argument("--line-end-frame", type=int, required=True)
    ap.add_argument("--trim-lead-ms", type=float, default=0.0)
    ap.add_argument("--bridge-gap-frames", type=int, default=6)
    a = ap.parse_args()
    data = json.load(open(a.alignment, encoding="utf-8"))
    al = data.get("alignment", data)
    print(json.dumps(words_from_alignment(al, a.fps, a.line_start_frame, a.line_end_frame, a.trim_lead_ms, a.bridge_gap_frames), indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
