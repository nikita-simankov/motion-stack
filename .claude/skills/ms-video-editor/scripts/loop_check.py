#!/usr/bin/env python3
"""Seamless-loop seam check: how different is the last frame from the first?

    loop_check.py <video.mp4> [--max-diff 6.0] [--window 6]
    loop_check.py --selftest

Compares frame 0 with the final frame, and with each of the final --window frames, at 96x96 grayscale.
Prints JSON { "firstToLast", "bestInWindow", "pass" }. Exit 0 when the final frame is within --max-diff
(mean absolute difference, 0-255) of the first, 1 otherwise. Requires ffmpeg and numpy.

The check ranks seams; it does not replace looking at the loop. A loop that passes can still jump if
the audio or a caption does not loop with it (see ms-video-editor/references/seamless-loop.md).
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys

W = H = 96


def frames(video: str):
    import numpy as np

    out = subprocess.run(
        ["ffmpeg", "-v", "error", "-i", video, "-vf", f"scale={W}:{H},format=gray", "-f", "rawvideo", "-"],
        capture_output=True, check=True,
    ).stdout
    n = len(out) // (W * H)
    if n < 2:
        raise SystemExit("need at least 2 frames")
    return np.frombuffer(out[: n * W * H], dtype=np.uint8).reshape(n, W, H).astype("float32")


def check(video: str, max_diff: float, window: int) -> dict:
    import numpy as np

    f = frames(video)
    first, last = f[0], f[-1]
    d_last = float(np.abs(first - last).mean())
    tail = f[-window:]
    d_tail = [float(np.abs(first - t).mean()) for t in tail]
    best = int(np.argmin(d_tail))
    return {
        "frames": int(len(f)),
        "firstToLast": round(d_last, 3),
        "bestInWindow": {"framesFromEnd": window - 1 - best, "diff": round(d_tail[best], 3)},
        "maxDiff": max_diff,
        "pass": d_last <= max_diff,
    }


def _write_clip(path: str, xs: list[int]) -> None:
    """Write a clip with a white 60px box at x = xs[n] on frame n (frame-exact, via raw frames)."""
    import numpy as np

    size = 320
    raw = bytearray()
    for x in xs:
        frame = np.zeros((size, size), dtype=np.uint8)
        frame[100:160, x : x + 60] = 255
        raw += frame.tobytes()
    subprocess.run(
        ["ffmpeg", "-y", "-v", "error", "-f", "rawvideo", "-pix_fmt", "gray", "-s", f"{size}x{size}", "-r", "30", "-i", "-",
         "-c:v", "libx264", "-crf", "10", "-pix_fmt", "yuv420p", path],
        input=bytes(raw), check=True,
    )


def _selftest() -> int:
    import math
    import tempfile
    from pathlib import Path

    tmp = Path(tempfile.mkdtemp())
    loop, jump = str(tmp / "loop.mp4"), str(tmp / "jump.mp4")
    n = 60
    # loop: the box goes out and returns to where it started; jump: it ends somewhere else
    _write_clip(loop, [round(40 + 200 * math.sin(math.pi * i / (n - 1))) for i in range(n)])
    _write_clip(jump, [round(40 + 200 * i / (n - 1)) for i in range(n)])
    a, b = check(loop, 6.0, 6), check(jump, 6.0, 6)
    assert a["pass"] and not b["pass"], (a, b)
    assert a["firstToLast"] < 1.0 and b["firstToLast"] > 10.0, (a, b)
    print("selftest ok:", json.dumps({"loop": a["firstToLast"], "jump": b["firstToLast"]}))
    return 0


def main() -> int:
    if "--selftest" in sys.argv:
        return _selftest()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("video")
    ap.add_argument("--max-diff", type=float, default=6.0)
    ap.add_argument("--window", type=int, default=6)
    a = ap.parse_args()
    r = check(a.video, a.max_diff, a.window)
    print(json.dumps(r, indent=2))
    return 0 if r["pass"] else 1


if __name__ == "__main__":
    sys.exit(main())
