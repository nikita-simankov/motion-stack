#!/usr/bin/env python3
"""Motion proof sheet: contact sheet + motion-energy plot for a rendered scene or master.

    proof_sheet.py <video.mp4> --out <dir> [--fps 30] [--step 3] [--max-static 45] [--eps 0.3]
    proof_sheet.py --selftest

Writes into <dir>:
  contact-sheet.png   one still every --step frames
  energy.svg          mean absolute frame difference per frame (motion energy) with dead holds shaded
  summary.json        { frames, meanEnergy, peakFrames, staticRuns[], flags[] }

Reading the energy plot:
  - an eased move is a hump: energy rises fast and decays (out curves) or rises slowly (in curves)
  - a linear move is a flat plateau
  - a spring landing shows a hump, a dip, and a smaller second hump (overshoot)
  - a dead hold is a flat line at zero; runs longer than --max-static frames are flagged ANIM-14

Requires ffmpeg and numpy. The energy is measured at 96x96 grayscale, so it ranks motion; it is not a
pixel-accurate velocity.
"""
from __future__ import annotations

import argparse
import json
import math
import subprocess
import sys
from pathlib import Path

W = H = 96


def read_frames(video: str):
    import numpy as np

    proc = subprocess.run(
        ["ffmpeg", "-v", "error", "-i", video, "-vf", f"scale={W}:{H},format=gray", "-f", "rawvideo", "-"],
        capture_output=True, check=True,
    )
    buf = proc.stdout
    n = len(buf) // (W * H)
    if n == 0:
        raise SystemExit("no frames decoded")
    return np.frombuffer(buf[: n * W * H], dtype=np.uint8).reshape(n, W, H).astype("float32")


def energy_series(frames) -> list[float]:
    import numpy as np

    diffs = np.abs(frames[1:] - frames[:-1]).mean(axis=(1, 2))
    return [0.0] + [float(x) for x in diffs]


def static_runs(energy: list[float], eps: float, min_len: int) -> list[dict]:
    runs, start = [], None
    for i, e in enumerate(energy + [math.inf]):
        if e < eps and start is None:
            start = i
        elif e >= eps and start is not None:
            if i - start >= min_len:
                runs.append({"start": start, "end": i - 1, "length": i - start})
            start = None
    return runs


def svg_plot(energy: list[float], runs: list[dict], fps: int) -> str:
    w, h, pad = 1200, 260, 36
    n = len(energy)
    top = max(max(energy), 1e-6)
    x = lambda i: pad + (w - 2 * pad) * i / max(1, n - 1)
    y = lambda e: h - pad - (h - 2 * pad) * e / top
    pts = " ".join(f"{x(i):.1f},{y(e):.1f}" for i, e in enumerate(energy))
    shade = "".join(
        f'<rect x="{x(r["start"]):.1f}" y="{pad}" width="{max(1.0, x(r["end"]) - x(r["start"])):.1f}" height="{h - 2 * pad}" fill="#ef4444" opacity="0.18"/>'
        for r in runs
    )
    ticks = "".join(
        f'<line x1="{x(i):.1f}" y1="{h - pad}" x2="{x(i):.1f}" y2="{h - pad + 5}" stroke="#888"/>'
        f'<text x="{x(i):.1f}" y="{h - pad + 18}" font-size="11" text-anchor="middle" fill="#666">{i / fps:.1f}s</text>'
        for i in range(0, n, max(1, fps))
    )
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}" font-family="sans-serif">'
        f'<rect width="{w}" height="{h}" fill="#fff"/>{shade}'
        f'<line x1="{pad}" y1="{h - pad}" x2="{w - pad}" y2="{h - pad}" stroke="#888"/>'
        f'<polyline points="{pts}" fill="none" stroke="#2563eb" stroke-width="1.6"/>{ticks}'
        f'<text x="{pad}" y="20" font-size="12" fill="#333">motion energy per frame (peak {top:.2f}); red = dead hold</text></svg>'
    )


def contact_sheet(video: str, out: Path, frames: int, step: int, cols: int = 12) -> None:
    count = math.ceil(frames / step)
    rows = max(1, math.ceil(count / cols))
    subprocess.run(
        ["ffmpeg", "-y", "-v", "error", "-i", video, "-vf",
         f"select='not(mod(n\\,{step}))',scale=160:-1,tile={cols}x{rows}", "-frames:v", "1", "-vsync", "0", str(out)],
        check=True,
    )


def build(video: str, out_dir: Path, fps: int, step: int, max_static: int, eps: float) -> dict:
    out_dir.mkdir(parents=True, exist_ok=True)
    frames = read_frames(video)
    energy = energy_series(frames)
    runs = static_runs(energy, eps, max_static)
    peaks = sorted(range(len(energy)), key=lambda i: energy[i], reverse=True)[:5]
    (out_dir / "energy.svg").write_text(svg_plot(energy, runs, fps), encoding="utf-8")
    contact_sheet(video, out_dir / "contact-sheet.png", len(energy), step)
    summary = {
        "frames": len(energy),
        "meanEnergy": round(sum(energy) / len(energy), 3),
        "peakFrames": sorted(peaks),
        "staticRuns": runs,
        "flags": [{"code": "ANIM-14", "message": f"dead hold of {r['length']} frames ({r['start']}-{r['end']}) exceeds {max_static}"} for r in runs],
    }
    (out_dir / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    return summary


def _selftest() -> int:
    import tempfile

    import numpy as np  # noqa: F401

    tmp = Path(tempfile.mkdtemp())
    video = str(tmp / "t.mp4")
    # 90 frames @30fps: a moving box for 30 frames, a dead hold for 60 frames
    graph = "[0][1]overlay=x='if(lt(n,30),n*8,232)':y=100"
    subprocess.run(
        ["ffmpeg", "-y", "-v", "error", "-f", "lavfi", "-i", "color=c=black:s=320x320:r=30",
         "-f", "lavfi", "-i", "color=c=white:s=60x60:r=30", "-filter_complex", graph,
         "-frames:v", "90", "-pix_fmt", "yuv420p", video],
        check=True,
    )
    s = build(video, tmp / "out", fps=30, step=3, max_static=45, eps=0.3)
    assert s["frames"] == 90, s
    assert len(s["staticRuns"]) == 1 and s["staticRuns"][0]["length"] >= 55, s["staticRuns"]
    assert s["flags"] and s["flags"][0]["code"] == "ANIM-14", s["flags"]
    assert all(p < 32 for p in s["peakFrames"]), s["peakFrames"]
    assert (tmp / "out" / "contact-sheet.png").stat().st_size > 1000
    assert "<polyline" in (tmp / "out" / "energy.svg").read_text()
    print("selftest ok:", json.dumps({"frames": s["frames"], "staticRuns": s["staticRuns"], "peaks": s["peakFrames"]}))
    return 0


def main() -> int:
    if "--selftest" in sys.argv:
        return _selftest()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("video")
    ap.add_argument("--out", required=True)
    ap.add_argument("--fps", type=int, default=30)
    ap.add_argument("--step", type=int, default=3)
    ap.add_argument("--max-static", type=int, default=45)
    ap.add_argument("--eps", type=float, default=0.3)
    a = ap.parse_args()
    s = build(a.video, Path(a.out), a.fps, a.step, a.max_static, a.eps)
    print(json.dumps(s, indent=2))
    return 1 if s["flags"] else 0


if __name__ == "__main__":
    sys.exit(main())
