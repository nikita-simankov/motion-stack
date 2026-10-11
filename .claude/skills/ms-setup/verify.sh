#!/usr/bin/env bash
#
# Motion Studio — verify environment and credential resolution
#

set -euo pipefail

STUDIO_DIR="${STUDIO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
MCP_CONFIG="$STUDIO_DIR/runs/_mcp.json"
ENV_FILE="$STUDIO_DIR/.env"
FAILED=0

check()      { local l="$1"; shift; if "$@" >/dev/null 2>&1; then printf '\033[1;32m[ ok  ]\033[0m %s\n' "$l"; else printf '\033[1;31m[fail ]\033[0m %s\n' "$l"; FAILED=1; fi; }
check_cmd()  { local l="$1" c="$2"; if command -v "$c" >/dev/null 2>&1; then printf '\033[1;32m[ ok  ]\033[0m %s (%s)\n' "$l" "$("$c" --version 2>&1 | head -n1)"; else printf '\033[1;31m[fail ]\033[0m %s (not found)\n' "$l"; FAILED=1; fi; }

echo "Motion Studio — verification"
echo "dir: $STUDIO_DIR"; echo

check_cmd "node" node
check_cmd "npm" npm
check_cmd "python3" python3
check_cmd "git" git
check_cmd "jq" jq

check "src/Root.tsx"        test -f "$STUDIO_DIR/src/Root.tsx"
check "remotion.config.ts"  test -f "$STUDIO_DIR/remotion.config.ts"
check "tsconfig.json"       test -f "$STUDIO_DIR/tsconfig.json"
check "package.json"        test -f "$STUDIO_DIR/package.json"
check "_studio.json"        test -f "$STUDIO_DIR/runs/_studio.json"
check "_mcp.json"           test -f "$MCP_CONFIG"
check ".gitignore"          test -f "$STUDIO_DIR/.gitignore"
check ".env is gitignored"  grep -q '^\.env' "$STUDIO_DIR/.gitignore"
check "_mcp is gitignored"  grep -q '^runs/_mcp.json' "$STUDIO_DIR/.gitignore"
check "remotion installed"  test -d "$STUDIO_DIR/node_modules/remotion"
check "elevenlabs venv"     test -d "$STUDIO_DIR/.venv"

[ -f "$STUDIO_DIR/runs/_studio.json" ] && check "studio json valid" jq empty "$STUDIO_DIR/runs/_studio.json"
[ -f "$MCP_CONFIG" ] && check "mcp json valid" jq empty "$MCP_CONFIG"

# ---------------------------------------------------------------------------
# Token contract v2 runtime and tooling
# ---------------------------------------------------------------------------
HERE="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$(cd "$HERE/.." && pwd)"
SCRATCH="$(mktemp -d)"; trap 'rm -rf "$SCRATCH"' EXIT

echo
echo "Token contract v2"
check "motion runtime (src/motion/tokens.ts)" test -f "$STUDIO_DIR/src/motion/tokens.ts"
check "whip + shape-wipe transitions"         test -f "$STUDIO_DIR/src/transitions/whip.tsx" -a -f "$STUDIO_DIR/src/transitions/shapeWipe.tsx"
check "react 19 (required by @remotion/transitions)" bash -c "cd '$STUDIO_DIR' && node -e \"process.exit(parseInt(require('react/package.json').version)>=19?0:1)\""

check "migrate v1 fixture, validate v2"       "$HERE/migrate-tokens.sh" "$HERE/fixtures/tokens-v1.json" "$SCRATCH/v2.json"
check "validator rejects a bad v2 file"       bash -c "! '$HERE/validate-tokens.sh' <(jq '.motion.roles.entrance=\"nope\"' '$SCRATCH/v2.json') >/dev/null 2>&1"
check "motion lint: good fixture is clean"    python3 -I "$HERE/audit_motion.py" "$HERE/fixtures/scene-good.tsx" --tokens "$SCRATCH/v2.json" --strict
check "motion lint: bad fixture hits every error code" bash -c "
  out=\$(python3 -I '$HERE/audit_motion.py' '$HERE/fixtures/scene-bad.tsx' --tokens '$SCRATCH/v2.json' --json || true)
  for c in ANIM-01 ANIM-02 ANIM-03 ANIM-04 ANIM-06 ANIM-10 ANIM-11 ANIM-16; do echo \"\$out\" | jq -e --arg c \$c '[.findings[].code]|index(\$c)' >/dev/null || exit 1; done"
check "motion lint: monotony fixture warns ANIM-09" bash -c "python3 -I '$HERE/audit_motion.py' '$HERE/fixtures/scene-mono.tsx' --json | jq -e '[.findings[].code]|index(\"ANIM-09\")' >/dev/null"
PROOF_PY="python3"; [ -x "$STUDIO_DIR/.venv/bin/python" ] && PROOF_PY="$STUDIO_DIR/.venv/bin/python"
if command -v ffmpeg >/dev/null 2>&1 && "$PROOF_PY" -c "import numpy" >/dev/null 2>&1; then
  check "motion proof sheet self-test"        "$PROOF_PY" -W ignore "$SKILLS_DIR/ms-motion-designer/scripts/proof_sheet.py" --selftest
else
  printf '\033[1;33m[warn ]\033[0m ffmpeg or numpy missing: motion proof sheet unavailable\n'
fi
if command -v ffmpeg >/dev/null 2>&1 && "$PROOF_PY" -c "import numpy" >/dev/null 2>&1; then
  check "loop seam checker self-test"         "$PROOF_PY" -W ignore "$SKILLS_DIR/ms-video-editor/scripts/loop_check.py" --selftest
fi
check "VO word timing converter self-test"    python3 -I "$SKILLS_DIR/ms-voiceover-producer/scripts/words_from_alignment.py" --selftest

BEAT_PY="python3"; [ -x "$STUDIO_DIR/.venv/bin/python" ] && BEAT_PY="$STUDIO_DIR/.venv/bin/python"
if "$BEAT_PY" -c "import librosa" >/dev/null 2>&1; then
  check "beat grid self-test (librosa)"       "$BEAT_PY" -W ignore "$SKILLS_DIR/ms-music-supervisor/scripts/beat_grid.py" --selftest
else
  printf '\033[1;33m[warn ]\033[0m librosa not installed: beat-grid snapping unavailable (optional)\n'
fi

# Any project token file must be v2-valid, or be a v1 file awaiting `/ms-command migrate`
for tf in "$STUDIO_DIR"/runs/*/style-tokens.json; do
  [ -f "$tf" ] || continue
  if [ "$(jq -r '.tokenVersion // 1' "$tf")" = "2" ]; then
    check "tokens valid: ${tf#$STUDIO_DIR/}" "$HERE/validate-tokens.sh" "$tf"
  else
    printf '\033[1;33m[warn ]\033[0m %s is tokenVersion 1 (read-compatible); run /ms-command migrate\n' "${tf#$STUDIO_DIR/}"
  fi
done

if [ -f "$MCP_CONFIG" ]; then
  echo
  echo "MCP bindings and fallbacks"
  jq -r '.[] | "  \(.service): \(if .mcpServerName then "MCP:\(.mcpServerName)" else "API-key:\(.fallback.envVar)" end)"' "$MCP_CONFIG" || true
fi

if [ -f "$ENV_FILE" ]; then
  echo
  echo "API-key fallbacks in .env"
  while IFS= read -r line; do
    case "$line" in
      ""|\#*) continue ;;
      *=*) k="${line%%=*}"; v="${line#*=}"
           if [ -n "$v" ]; then printf '\033[1;32m[ ok  ]\033[0m %s set\n' "$k"; else printf '\033[1;33m[warn ]\033[0m %s empty\n' "$k"; fi ;;
    esac
  done < "$ENV_FILE"
fi

echo
[ "$FAILED" -eq 1 ] && { printf '\033[1;31mverify failed\033[0m\n'; exit 1; }
printf '\033[1;32mverify passed\033[0m\n'