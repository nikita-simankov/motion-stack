#!/usr/bin/env python3
"""Motion Studio v2 motion lint.

Static checks over scene source (src/scenes/**). Backs `/ms-motion-designer audit`
and the QA defect codes in ms-quality-assurance/references/defect-taxonomy.md.

    audit_motion.py <path>... [--tokens style-tokens.json] [--json] [--strict]

Exit status: 0 clean (warnings allowed unless --strict), 1 errors found, 2 usage.
Suppress one finding with a comment on the same or previous line:
    // ms:allow ANIM-07 reason
Mark intentionally linear continuous motion (progress bars, marquees, tracking):
    // ms:linear
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from collections import Counter
from pathlib import Path

ERROR, WARN = "error", "warn"

RULES = {
    "ANIM-01": (ERROR, "CSS transition or CSS animation"),
    "ANIM-02": (ERROR, "Tailwind animation class"),
    "ANIM-03": (ERROR, "Time- or event-loop-driven animation (setTimeout, setInterval, requestAnimationFrame, Math.random, Date.now)"),
    "ANIM-04": (ERROR, "Raw Easing.* in scene source; use named curves from tokens (m.tween / m.ease)"),
    "ANIM-06": (ERROR, "interpolate() without an easing (linear by default); name a curve or mark // ms:linear"),
    "ANIM-07": (WARN, "Group animated in .map() with no per-item timing offset (no stagger)"),
    "ANIM-09": (WARN, "One curve covers more than 80% of the eased motion in this file"),
    "ANIM-10": (ERROR, "spring() with an inline config; use a named preset (m.springOf)"),
    "ANIM-11": (ERROR, "interpolate() not clamped on both sides"),
    "ANIM-13": (WARN, "Static literal blur(); blur must be frame-driven or come from MotionBlur / CameraRig"),
    "ANIM-16": (ERROR, "Hex colour not present in the frozen palette"),
}

HEX = re.compile(r"#(?:[0-9a-fA-F]{8}|[0-9a-fA-F]{6}|[0-9a-fA-F]{4}|[0-9a-fA-F]{3})\b")


def mask_comments(src: str) -> tuple[str, dict[int, str]]:
    """Blank out comments (keeping offsets) and collect comment text per line."""
    out = list(src)
    comments: dict[int, str] = {}
    i, n, line = 0, len(src), 1
    quote = ""
    while i < n:
        c = src[i]
        if c == "\n":
            line += 1
        if quote:
            if c == "\\":
                i += 2
                continue
            if c == quote:
                quote = ""
            i += 1
            continue
        if c in "'\"`":
            quote = c
            i += 1
            continue
        if src.startswith("//", i):
            j = src.find("\n", i)
            j = n if j == -1 else j
            comments[line] = comments.get(line, "") + src[i:j]
            for k in range(i, j):
                out[k] = " "
            i = j
            continue
        if src.startswith("/*", i):
            j = src.find("*/", i + 2)
            j = n if j == -1 else j + 2
            for k in range(i, j):
                if out[k] != "\n":
                    out[k] = " "
            comments[line] = comments.get(line, "") + src[i:j]
            line += src.count("\n", i, j)
            i = j
            continue
        i += 1
    return "".join(out), comments


def call_extent(src: str, open_idx: int) -> int:
    """Index of the matching ')' for the '(' at open_idx; -1 if unbalanced."""
    depth, i, n, quote = 0, open_idx, len(src), ""
    while i < n:
        c = src[i]
        if quote:
            if c == "\\":
                i += 2
                continue
            if c == quote:
                quote = ""
        elif c in "'\"`":
            quote = c
        elif c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                return i
        i += 1
    return -1


def calls(src: str, pattern: str):
    for m in re.finditer(pattern, src):
        open_idx = src.find("(", m.start())
        end = call_extent(src, open_idx)
        if end != -1:
            yield m.start(), src[open_idx + 1 : end]


def audit_file(path: Path, palette: set[str] | None) -> list[dict]:
    raw = path.read_text(encoding="utf-8")
    src, comments = mask_comments(raw)
    findings: list[dict] = []

    def lineno(idx: int) -> int:
        return raw.count("\n", 0, idx) + 1

    def allowed(code: str, line: int) -> bool:
        return any(f"ms:allow {code}" in comments.get(l, "") for l in (line, line - 1))

    def linear_marked(line: int) -> bool:
        return any("ms:linear" in comments.get(l, "") for l in (line, line - 1))

    def add(code: str, idx: int, extra: str = ""):
        line = lineno(idx)
        if allowed(code, line):
            return
        sev, msg = RULES[code]
        if any(f["code"] == code and f["line"] == line for f in findings):
            return
        findings.append({"file": str(path), "line": line, "code": code, "severity": sev, "message": msg + (f" ({extra})" if extra else "")})

    # ANIM-01 / 02 / 03 / 04 / 13 -- plain pattern checks
    for m in re.finditer(r"@keyframes|\banimation\s*:|\banimationName\b|\btransition\s*:|\btransitionProperty\b", src):
        add("ANIM-01", m.start())
    for m in re.finditer(r"""(?:className\s*=\s*|class\s*=\s*)[{"'`][^"'`}]*\b(?:animate-|transition(?:-|\b)|duration-|delay-|ease-)""", src):
        add("ANIM-02", m.start())
    for m in re.finditer(r"\bsetTimeout\s*\(|\bsetInterval\s*\(|\brequestAnimationFrame\s*\(|\bMath\.random\s*\(|\bDate\.now\s*\(|\bnew Date\s*\(\s*\)", src):
        add("ANIM-03", m.start())
    for m in re.finditer(r"(?<![\w.])Easing\.\w+", src):
        add("ANIM-04", m.start())
    for m in re.finditer(r"blur\(\s*\d", src):
        add("ANIM-13", m.start())

    # ANIM-06 / 11 -- interpolate()
    eased: Counter[str] = Counter()
    for idx, args in calls(src, r"(?<![\w.])interpolate\s*\("):
        has_easing = re.search(r"\beasing\s*:", args) is not None
        if not has_easing and not linear_marked(lineno(idx)):
            add("ANIM-06", idx)
        if not (re.search(r"\bextrapolateLeft\s*:", args) and re.search(r"\bextrapolateRight\s*:", args)):
            add("ANIM-11", idx)

    # ANIM-10 -- spring() inline config
    for idx, args in calls(src, r"(?<![\w.])spring\s*\("):
        if re.search(r"\bconfig\s*:\s*\{", args):
            add("ANIM-10", idx)

    # ANIM-07 -- animated .map() without a per-item offset
    for idx, args in calls(src, r"\.map\s*\("):
        if not re.search(r"(?<![\w.])(?:interpolate|spring|tween|springOf)\s*\(|\.tween\s*\(|\.springOf\s*\(", args):
            continue
        params = re.match(r"\s*(?:async\s*)?\(?\s*([A-Za-z_$][\w$]*)\s*(?:,\s*([A-Za-z_$][\w$]*))?", args)
        index_name = params.group(2) if params else None
        if not index_name:
            add("ANIM-07", idx, "no index parameter")
            continue
        body = args[params.end():]
        uses = [u for u in re.finditer(rf"(?<![\w$]){re.escape(index_name)}(?![\w$])", body)]
        # a use only inside key={...} does not offset timing
        timing_uses = [u for u in uses if not re.search(r"key\s*=\s*\{\s*$", body[max(0, u.start() - 12) : u.start()])]
        if not timing_uses:
            add("ANIM-07", idx, f"index `{index_name}` never used for timing")

    # curve usage -> ANIM-09 monotony
    for _, args in calls(src, r"\.tween\s*\("):
        m = re.search(r"""['"]([\w-]+)['"]\s*\)?\s*$""", args.strip())
        if m:
            eased[m.group(1)] += 1
    for m in re.finditer(r"""\.ease\s*\(\s*['"]([\w-]+)['"]""", src):
        eased[m.group(1)] += 1
    for m in re.finditer(r"\broles\.(entrance|exit|state|camera|cursor)\b", src):
        eased[f"role:{m.group(1)}"] += 1
    total = sum(eased.values())
    if total >= 6:
        name, count = eased.most_common(1)[0]
        if count / total > 0.8:
            add("ANIM-09", 0, f"{name} = {count}/{total}")

    # ANIM-16 -- palette drift
    if palette is not None:
        for m in HEX.finditer(src):
            if normalise_hex(m.group(0)) not in palette:
                add("ANIM-16", m.start(), m.group(0))

    return findings


def normalise_hex(h: str) -> str:
    h = h.lstrip("#").lower()
    if len(h) in (3, 4):
        h = "".join(c * 2 for c in h)
    return "#" + h[:6]


def palette_from_tokens(path: Path) -> set[str]:
    tokens = json.loads(path.read_text(encoding="utf-8"))
    found: set[str] = set()

    def walk(node):
        if isinstance(node, dict):
            for v in node.values():
                walk(v)
        elif isinstance(node, list):
            for v in node:
                walk(v)
        elif isinstance(node, str) and HEX.fullmatch(node):
            found.add(normalise_hex(node))

    walk(tokens.get("palette", {}))
    return found


def collect(paths: list[str], exclude: list[str]) -> list[Path]:
    files: list[Path] = []
    for p in map(Path, paths):
        if p.is_dir():
            files += sorted(f for f in p.rglob("*") if f.suffix in (".ts", ".tsx"))
        elif p.is_file():
            files.append(p)
    return [f for f in files if not any(x in f.as_posix() for x in exclude)]


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("paths", nargs="+")
    ap.add_argument("--tokens", help="style-tokens.json; enables the ANIM-16 palette check")
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--strict", action="store_true", help="warnings fail the run")
    ap.add_argument("--exclude", action="append", default=["/motion/", "node_modules"], help="substring filter (repeatable)")
    args = ap.parse_args()

    files = collect(args.paths, args.exclude)
    if not files:
        print("no .ts/.tsx files found", file=sys.stderr)
        return 2
    palette = palette_from_tokens(Path(args.tokens)) if args.tokens else None

    findings: list[dict] = []
    for f in files:
        findings += audit_file(f, palette)

    errors = [f for f in findings if f["severity"] == ERROR]
    warns = [f for f in findings if f["severity"] == WARN]

    if args.json:
        print(json.dumps({"files": len(files), "errors": len(errors), "warnings": len(warns), "findings": findings}, indent=2))
    else:
        for f in findings:
            print(f'{f["file"]}:{f["line"]}: {f["code"]} [{f["severity"]}] {f["message"]}')
        print(f"\n{len(files)} file(s), {len(errors)} error(s), {len(warns)} warning(s)")

    return 1 if errors or (args.strict and warns) else 0


if __name__ == "__main__":
    sys.exit(main())
