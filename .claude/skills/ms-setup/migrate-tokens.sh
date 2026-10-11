#!/usr/bin/env bash
#
# Motion Studio — migrate style-tokens.json from tokenVersion 1 to 2
#
# Usage:
#   migrate-tokens.sh <in-v1.json> <out-v2.json> [--tone authoritative|punchy|measured|kinetic|playful]
#
# - v1 values always win. v2 sections are added with the defaults in tokens-v2-defaults.json.
# - The output is NOT frozen. Gate 6 (Look locked) must be re-approved with the diff.
# - Idempotent guard: a file that is already tokenVersion 2 is rejected.

set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
DEFAULTS="$HERE/tokens-v2-defaults.json"

IN=""; OUT=""; TONE="punchy"
while [ $# -gt 0 ]; do
  case "$1" in
    --tone) TONE="${2:-}"; shift 2 ;;
    -h|--help) sed -n '3,12p' "$0"; exit 0 ;;
    *) if [ -z "$IN" ]; then IN="$1"; elif [ -z "$OUT" ]; then OUT="$1"; else echo "unexpected argument: $1" >&2; exit 2; fi; shift ;;
  esac
done

[ -n "$IN" ] && [ -n "$OUT" ] || { echo "usage: migrate-tokens.sh <in-v1.json> <out-v2.json> [--tone T]" >&2; exit 2; }
[ -f "$IN" ] || { echo "input not found: $IN" >&2; exit 2; }
[ -f "$DEFAULTS" ] || { echo "defaults not found: $DEFAULTS" >&2; exit 2; }
case "$TONE" in authoritative|punchy|measured|kinetic|playful) ;; *) echo "invalid --tone: $TONE" >&2; exit 2 ;; esac
[ "$IN" != "$OUT" ] || { echo "refusing to overwrite the frozen v1 file; choose a new output path" >&2; exit 2; }

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

jq --slurpfile d "$DEFAULTS" --arg tone "$TONE" --arg now "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '
  ($d[0]) as $def
  | if (.tokenVersion // 1) >= 2 then error("already tokenVersion 2") else . end
  | . as $v1

  # layout.grid: "12-column" -> object
  | (if (.layout.grid | type) == "string"
       then .layout.grid = {
         columns: ((.layout.grid | capture("(?<n>[0-9]+)").n | tonumber) // 12),
         gutterPx: 24, baselinePx: 8 }
       else . end)

  # v2 defaults underneath, v1 values on top
  | ($def * .)

  # motion
  | .motion.tone = $tone
  | .motion.roles.entrance = ({authoritative:"out-quint", punchy:"out-expo", measured:"out-quart", kinetic:"out-expo", playful:"out-expo"}[$tone])
  | .motion.roles.exit = (if $tone == "authoritative" or $tone == "measured" then "in-cubic" else "in-expo" end)
  | .motion.motionBlur.enabled = ($tone != "authoritative" and $tone != "measured")
  | (if $tone == "playful"
       then .motion.curves["out-back"] = [0.34, 1.56, 0.64, 1]
          | .motion.springs.bouncy = {damping: 8, stiffness: 170, mass: 0.7}
          | .motion.choreography.overshootMaxPct = 30
       else . end)
  | ((.motion.easings // []) as $e
      | .motion.easings = ($e + ((.motion.curves | keys) - $e) + (if ($e | index("spring")) then [] else ["spring"] end)))

  # captions follow tone
  | .captions.style = ({authoritative:"cue", measured:"cue", punchy:"word-highlight", kinetic:"word-highlight", playful:"word-pop"}[$tone])

  # caption type roles derived from onScreenText
  | ((.type.roles | map(.role)) as $have
     | (.type.roles | map(select(.role == "onScreenText")) | .[0]) as $ost
     | if $ost == null then .
       else .type.roles += (
         [ ($ost | .role = "caption" | .weight = 700 | .sizePx = 44 | .lineHeightPx = 52),
           ($ost | .role = "captionActive" | .weight = 700 | .sizePx = 44 | .lineHeightPx = 52) ]
         | map(select(.role as $r | ($have | index($r)) | not)))
       end)

  # platform insets per aspect override
  | .layout.aspectOverrides |= ((. // []) | map(
      ({platformInsetsPx: (if .aspect == "9:16" then {top: 260, bottom: 380, left: 60, right: 120}
                           else {top: 0, bottom: 0, left: 0, right: 0} end)} * .)))

  # UI mockup additions (only when the run has a mockup)
  | (if .uiMockup != null then
       .uiMockup.cursor.curve = (.uiMockup.cursor.curve // "out-quart")
       | .uiMockup.cursor.path = (.uiMockup.cursor.path // "smoothed")
       | .uiMockup.smartZoom = ({enabled: true, maxZoom: 1.6, followLagFrames: 10, transitionFrames: 18} * (.uiMockup.smartZoom // {}))
       | .uiMockup.typing = ({cadenceFrames: {min: 2, max: 4}, seed: "typing"} * (.uiMockup.typing // {}))
     else . end)

  # provenance + re-approval
  | .migratedFrom = {version: 1, at: $now, tool: "migrate-tokens.sh", tone: $tone, previousFrozenAt: ($v1.frozenAt // null)}
  | .frozen = false
  | .frozenAt = null
  | .reapprovalRequired = true
' "$IN" > "$TMP"

mv "$TMP" "$OUT"
trap - EXIT
echo "migrated: $IN -> $OUT (tokenVersion 2, tone $TONE, frozen=false, reapprovalRequired=true)"
"$HERE/validate-tokens.sh" "$OUT"
