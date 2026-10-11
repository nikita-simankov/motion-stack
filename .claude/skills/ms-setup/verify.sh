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