#!/usr/bin/env bash
#
# Motion Studio — validate a tokenVersion 2 style-tokens.json
#
# Usage: validate-tokens.sh <style-tokens.json>
# Exit 0 when clean, 1 when any rule fails. Failures are printed one per line.

set -euo pipefail

FILE="${1:-}"
[ -n "$FILE" ] && [ -f "$FILE" ] || { echo "usage: validate-tokens.sh <style-tokens.json>" >&2; exit 2; }
jq empty "$FILE" 2>/dev/null || { echo "[fail ] not valid JSON: $FILE" >&2; exit 1; }

ERRORS="$(jq -r '
  def isnum: type == "number";
  def bezier_ok: (type == "array") and (length == 4) and (all(.[]; isnum)) and (.[0] >= 0 and .[0] <= 1) and (.[2] >= 0 and .[2] <= 1);
  def has_all(keys): . as $o | (keys | all(. as $k | $o | has($k)));

  . as $t
  | ($t.motion // {}) as $m
  | ($m.curves // {}) as $curves
  | ($m.aliases // {}) as $aliases
  | ($m.springs // {}) as $springs
  | ($m.choreography // {}) as $c
  | ($m.tone // "punchy") as $tone
  | ["linear", "spring", "bounce"] as $builtin
  | ["hard-cut","cut-on-action","match-cut","wipe","mask","dissolve","glitch","scale","whip","shape-wipe","iris","object-wipe","morph"] as $allowedTransitions
  | ["cue","word-highlight","word-pop"] as $captionStyles
  | [
      (if $t.tokenVersion != 2 then "tokenVersion must be 2" else empty end),

      # curves
      ($curves | to_entries[] | select(.value | bezier_ok | not) | "curve \(.key): needs [x1,y1,x2,y2] with x1,x2 in 0..1"),
      (if ($curves | length) < 5 then "motion.curves needs at least 5 named curves" else empty end),

      # easings resolve
      (($m.easings // [])[] as $e
        | select(($curves | has($e)) or ($aliases | has($e)) or ($builtin | index($e)) | not)
        | "easing \"\($e)\" is not a curve, alias or builtin"),

      # alias targets exist
      ($aliases | to_entries[] | . as $a | select(($curves | has($a.value)) | not) | "alias \($a.key) -> \($a.value): target curve missing"),

      # role curves exist and are real curves
      (["entrance","exit","state","camera","cursor"][] as $r
        | (($m.roles // {})[$r]) as $name
        | if $name == null then "motion.roles.\($r) missing"
          elif (($curves | has($name)) or ($aliases | has($name))) | not then "motion.roles.\($r) = \"\($name)\" is not a declared curve"
          else empty end),

      # springs
      (if ($springs | length) < 1 then "motion.springs needs at least one preset" else empty end),
      ($springs | to_entries[]
        | select((.value | has_all(["damping","stiffness","mass"])) | not)
        | "spring \(.key): needs damping, stiffness, mass"),
      ($springs | to_entries[]
        | select((.value.damping // 0) <= 0 or (.value.stiffness // 0) <= 0 or (.value.mass // 0) <= 0)
        | "spring \(.key): damping, stiffness, mass must be > 0"),

      # spring overshoot budget: zeta = c / (2*sqrt(k*m)); overshoot = exp(-pi*zeta/sqrt(1-zeta^2)) when zeta < 1
      ($springs | to_entries[] | . as $sp
        | select(($sp.value | has_all(["damping","stiffness","mass"])) and (($sp.value.damping // 0) > 0) and (($sp.value.stiffness // 0) > 0) and (($sp.value.mass // 0) > 0))
        | ($sp.value.damping / (2 * (($sp.value.stiffness * $sp.value.mass) | sqrt))) as $z
        | (if $z >= 1 then 0 else ((-3.141592653589793 * $z / ((1 - $z * $z) | sqrt)) | exp) * 100 end) as $os
        | select($os > ($c.overshootMaxPct // 12))
        | "spring \($sp.key): overshoots \($os | floor)% (budget choreography.overshootMaxPct = \($c.overshootMaxPct // 12))"),

      # tone rules: overshoot curves and bouncy springs are playful only
      (if $tone != "playful" and ($curves | has("out-back")) then "out-back curve is playful-tone only (tone: \($tone))" else empty end),
      (if $tone != "playful" and ($springs | has("bouncy")) then "bouncy spring is playful-tone only (tone: \($tone))" else empty end),
      (if $tone != "playful" and (($m.easings // []) | index("bounce")) then "bounce easing is playful-tone only (tone: \($tone))" else empty end),

      # choreography
      (if ($c.exitRatio | isnum | not) or $c.exitRatio < 0.5 or $c.exitRatio > 0.8 then "choreography.exitRatio must be 0.5..0.8" else empty end),
      (if ($c.staggerStepFrames.min | isnum | not) or ($c.staggerStepFrames.max | isnum | not)
          or $c.staggerStepFrames.min < 1 or $c.staggerStepFrames.max < $c.staggerStepFrames.min or $c.staggerStepFrames.max > 8
        then "choreography.staggerStepFrames needs 1 <= min <= max <= 8" else empty end),
      (if ($c.staggerCapFrames | isnum | not) or $c.staggerCapFrames < 6 or $c.staggerCapFrames > 30 then "choreography.staggerCapFrames must be 6..30" else empty end),
      (if ($c.overlapPct | isnum | not) or $c.overlapPct < 40 or $c.overlapPct > 90 then "choreography.overlapPct must be 40..90" else empty end),
      (if ($c.readHoldFramesPerWord | isnum | not) or $c.readHoldFramesPerWord < 6 or $c.readHoldFramesPerWord > 15 then "choreography.readHoldFramesPerWord must be 6..15" else empty end),
      (if ($c.minHoldFrames | isnum | not) or $c.minHoldFrames < 12 then "choreography.minHoldFrames must be >= 12" else empty end),
      (if ($c.settleFrames.min | isnum | not) or ($c.settleFrames.max | isnum | not) or $c.settleFrames.min < 4 or $c.settleFrames.max < $c.settleFrames.min or $c.settleFrames.max > 30 then "choreography.settleFrames needs 4 <= min <= max <= 30" else empty end),
      (if ($c.overshootMaxPct | isnum | not) or $c.overshootMaxPct < 0 or $c.overshootMaxPct > 35 then "choreography.overshootMaxPct must be 0..35" else empty end),

      # motion blur
      (if ($m.motionBlur.shutterAngle | isnum | not) or $m.motionBlur.shutterAngle <= 0 or $m.motionBlur.shutterAngle > 360 then "motionBlur.shutterAngle must be 1..360" else empty end),
      (if ($m.motionBlur.samples | isnum | not) or $m.motionBlur.samples < 1 or $m.motionBlur.samples > 16 then "motionBlur.samples must be 1..16" else empty end),

      # transitions
      (($m.transitionSet // [])[] as $x | select($allowedTransitions | index($x) | not) | "transition \"\($x)\" is not in the vocabulary"),

      # type
      (if (($t.type.families // []) | length) > 2 then "type.families: maximum 2 families" else empty end),
      (if ((($t.type.roles // []) | map(.role)) | index("caption")) == null then "type.roles needs a caption role" else empty end),

      # captions
      (if ($captionStyles | index($t.captions.style)) == null then "captions.style must be one of \($captionStyles | join(", "))" else empty end),
      (if ($t.captions.maxWordsPerPage | isnum | not) or $t.captions.maxWordsPerPage < 1 or $t.captions.maxWordsPerPage > 8 then "captions.maxWordsPerPage must be 1..8" else empty end),

      # layout
      (if ($t.layout.grid | type) != "object" or ($t.layout.grid.columns | isnum | not) then "layout.grid must be an object with columns, gutterPx, baselinePx" else empty end),
      (($t.layout.aspectOverrides // [])[] | select(has("platformInsetsPx") | not) | "layout.aspectOverrides \(.aspect): platformInsetsPx missing"),

      # UI mockup (only when present)
      (if $t.uiMockup != null and ($t.uiMockup.smartZoom | type) != "object" then "uiMockup.smartZoom missing" else empty end),

      # freeze state
      (if $t.frozen == true and $t.reapprovalRequired == true then "frozen=true with reapprovalRequired=true is inconsistent" else empty end)
    ]
  | .[]
' "$FILE")"

if [ -n "$ERRORS" ]; then
  while IFS= read -r line; do printf '\033[1;31m[fail ]\033[0m %s\n' "$line"; done <<< "$ERRORS"
  exit 1
fi
printf '\033[1;32m[ ok  ]\033[0m %s is a valid tokenVersion 2 file\n' "$FILE"
