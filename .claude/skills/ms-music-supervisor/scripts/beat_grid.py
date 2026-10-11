#!/usr/bin/env python3
"""Beat grid for cut-to-music sync.

    beat_grid.py grid <audio> [--fps 30] [--offset-ms 0] > grid.json
    beat_grid.py snap --grid grid.json --cuts 31,62,95 [--snap-frames 2] > snap.json
    beat_grid.py --selftest

`grid` needs librosa (installed by ms-setup as an optional package). `snap` is pure Python.

grid.json: { "fps", "bpm", "beatsFrames": [..], "onsetsFrames": [..], "strongOnsetsFrames": [..] }
  - beatsFrames: tracked beat positions, integer frames on the master timeline
  - onsetsFrames: every detected onset; strongOnsetsFrames: onsets above the 75th-percentile strength
  - --offset-ms places the music cue on the master timeline (cue.frameStart expressed in ms)

snap.json: { "cuts": [{ "frame", "snapped", "target", "shift", "kind" }], "unsnapped": [..] }
  - a cut moves to the nearest beat/strong onset only when |shift| <= --snap-frames
  - the proposal is advisory: the editor owns the cut and records the decision in timeline.json
"""
from __future__ import annotations

import argparse
import json
import sys


def grid_from_audio(path: str, fps: int, offset_ms: float) -> dict:
    import librosa  # deferred: optional dependency
    import numpy as np

    y, sr = librosa.load(path, sr=22050, mono=True)
    hop = 512
    onset_env = librosa.onset.onset_strength(y=y, sr=sr, hop_length=hop)
    tempo, beat_idx = librosa.beat.beat_track(onset_envelope=onset_env, sr=sr, hop_length=hop)
    beat_t = librosa.frames_to_time(beat_idx, sr=sr, hop_length=hop)
    on_idx = librosa.onset.onset_detect(onset_envelope=onset_env, sr=sr, hop_length=hop, backtrack=False)
    on_t = librosa.frames_to_time(on_idx, sr=sr, hop_length=hop)
    strengths = onset_env[on_idx] if len(on_idx) else np.array([])
    cut = np.percentile(strengths, 75) if len(strengths) else 0.0
    strong_t = on_t[strengths >= cut] if len(on_idx) else on_t

    def to_frames(times) -> list[int]:
        return sorted({int(round(t * fps + offset_ms / 1000.0 * fps)) for t in times})

    bpm = float(np.atleast_1d(tempo)[0])
    return {"fps": fps, "bpm": round(bpm, 2), "beatsFrames": to_frames(beat_t),
            "onsetsFrames": to_frames(on_t), "strongOnsetsFrames": to_frames(strong_t)}


def snap_cuts(grid: dict, cuts: list[int], snap_frames: int) -> dict:
    beats = grid["beatsFrames"]
    strong = grid.get("strongOnsetsFrames", [])
    out, unsnapped = [], []
    for c in cuts:
        best = None  # (abs shift, shift, target, kind)
        for kind, pool in (("beat", beats), ("onset", strong)):
            for t in pool:
                d = t - c
                cand = (abs(d), d, t, kind)
                if best is None or cand[0] < best[0] or (cand[0] == best[0] and kind == "beat"):
                    best = cand
        if best is not None and best[0] <= snap_frames:
            out.append({"frame": c, "snapped": True, "target": best[2], "shift": best[1], "kind": best[3]})
        else:
            out.append({"frame": c, "snapped": False, "target": None, "shift": 0, "kind": None})
            unsnapped.append(c)
    return {"cuts": out, "unsnapped": unsnapped}


def _selftest() -> int:
    import math
    import struct
    import tempfile
    import wave

    sr, bpm, seconds, fps = 22050, 120, 8, 30
    period = 60.0 / bpm
    samples = [0.0] * (sr * seconds)
    t = 0.0
    while t < seconds:
        i0 = int(t * sr)
        for k in range(220):  # 10 ms click burst
            if i0 + k < len(samples):
                samples[i0 + k] = 0.9 * math.sin(2 * math.pi * 1000 * k / sr) * (1 - k / 220)
        t += period
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
        name = f.name
    with wave.open(name, "wb") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(sr)
        w.writeframes(b"".join(struct.pack("<h", int(max(-1, min(1, s)) * 32767)) for s in samples))

    g = grid_from_audio(name, fps, 0)
    assert 115 <= g["bpm"] <= 125 or 58 <= g["bpm"] <= 62 or 235 <= g["bpm"] <= 245, g["bpm"]  # octave errors are common
    expected = [round(i * period * fps) for i in range(int(seconds / period))]  # every 15 frames
    hits = sum(1 for e in expected if any(abs(e - b) <= 1 for b in g["beatsFrames"] + g["onsetsFrames"]))
    assert hits >= len(expected) - 2, (hits, len(expected), g["beatsFrames"][:12])

    s = snap_cuts({"beatsFrames": [0, 15, 30, 45, 60], "strongOnsetsFrames": [22]}, [14, 31, 40, 52], 2)
    by = {c["frame"]: c for c in s["cuts"]}
    assert by[14]["target"] == 15 and by[14]["shift"] == 1
    assert by[31]["target"] == 30 and by[31]["shift"] == -1
    assert by[40]["snapped"] is False  # 5 frames from the nearest beat
    assert by[52]["snapped"] is False
    assert s["unsnapped"] == [40, 52]
    print(f"selftest ok: bpm={g['bpm']}, {hits}/{len(expected)} click positions matched, snap logic ok")
    return 0


def main() -> int:
    if "--selftest" in sys.argv:
        return _selftest()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    g = sub.add_parser("grid"); g.add_argument("audio"); g.add_argument("--fps", type=int, default=30); g.add_argument("--offset-ms", type=float, default=0.0)
    s = sub.add_parser("snap"); s.add_argument("--grid", required=True); s.add_argument("--cuts", required=True); s.add_argument("--snap-frames", type=int, default=2)
    a = ap.parse_args()
    if a.cmd == "grid":
        print(json.dumps(grid_from_audio(a.audio, a.fps, a.offset_ms), indent=2))
    else:
        grid = json.load(open(a.grid, encoding="utf-8"))
        print(json.dumps(snap_cuts(grid, [int(x) for x in a.cuts.split(",") if x.strip()], a.snap_frames), indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
