#!/usr/bin/env bash
#
# Motion Studio — first-time setup
#
# Prefers MCP servers for external services. Falls back to API keys.
#

set -euo pipefail

MIN_NODE_MAJOR=20
MIN_NPM_MAJOR=10
MIN_PY_MAJOR=3
MIN_PY_MINOR=10

STUDIO_DIR="${STUDIO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
STUDIO_CONFIG="$STUDIO_DIR/runs/_studio.json"
MCP_CONFIG="$STUDIO_DIR/runs/_mcp.json"
CLIENT_DIR="$STUDIO_DIR/runs/_clients"
ENV_FILE="$STUDIO_DIR/.env"
ENV_EXAMPLE="$STUDIO_DIR/.env.example"

MODE="full"
PROFILE=""
DRY_RUN=0
AUTO_YES=0
VERBOSE=0
MCP_ONLY=0
API_KEY_ONLY=0

for arg in "$@"; do
  case "$arg" in
    --install-only)    MODE="install" ;;
    --creds-only)      MODE="creds" ;;
    --interview-only)  MODE="interview" ;;
    --scaffold-only)   MODE="scaffold" ;;
    --verify-only)     MODE="verify" ;;
    --dry-run)         DRY_RUN=1 ;;
    --yes)             AUTO_YES=1 ;;
    --verbose)         VERBOSE=1 ;;
    --mcp-only)        MCP_ONLY=1 ;;
    --api-key-only)    API_KEY_ONLY=1 ;;
    --profile)         shift; PROFILE="${1:-}" ;;
    --profile=*)       PROFILE="${arg#*=}" ;;
    *) echo "unknown arg: $arg" >&2 ;;
  esac
done

log()   { printf '\033[1;34m[setup]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[warn ]\033[0m %s\n' "$*" >&2; }
fail()  { printf '\033[1;31m[fail ]\033[0m %s\n' "$*" >&2; exit 1; }
ok()    { printf '\033[1;32m[ ok  ]\033[0m %s\n' "$*"; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then printf '  would run: %s\n' "$*"
  else [ "$VERBOSE" -eq 1 ] && printf '  $ %s\n' "$*"; "$@"; fi
}

need_cmd() { command -v "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------------------
# OS detection (unchanged)
# ---------------------------------------------------------------------------

detect_os() {
  case "$(uname -s)" in
    Darwin) OS="macos"; PKG="brew" ;;
    Linux)
      if   [ -f /etc/debian_version ]; then OS="debian"; PKG="apt-get"
      elif [ -f /etc/fedora-release ]; then OS="fedora"; PKG="dnf"
      elif [ -f /etc/arch-release ];   then OS="arch";   PKG="pacman"
      else OS="linux-unknown"; PKG="" ; fi ;;
    MINGW*|MSYS*|CYGWIN*) OS="windows"; PKG="" ;;
    *) OS="unknown"; PKG="" ;;
  esac
  log "OS detected: $OS (pkg: ${PKG:-none})"
  [ "$OS" = "unknown" ] && fail "unsupported OS"
  [ "$OS" = "windows" ] && fail "use WSL2"
  [ "$OS" = "linux-unknown" ] && fail "unsupported Linux distribution"
}

# ---------------------------------------------------------------------------
# MCP detection
# ---------------------------------------------------------------------------
#
# Detection uses the Claude environment's MCP registry, exposed via the
# `claude mcp list` command when available. If the command is not available,
# detection falls back to reading a local mcp.json if present.
#
# Each known service maps to one or more MCP server names.

MCP_SERVICES=(
  "elevenlabs:elevenlabs-mcp"
  "aws:aws-mcp,aws-api-mcp-server"
  "github:github-mcp,github"
  "notion:notion-mcp"
  "slack:slack-mcp"
  "gdrive:gdrive-mcp,google-drive-mcp"
  "figma:figma-mcp,figma"
)

mcp_list() {
  if need_cmd claude; then
    claude mcp list 2>/dev/null || true
  elif [ -f "$STUDIO_DIR/.mcp.json" ]; then
    jq -r '.mcpServers | keys[]' "$STUDIO_DIR/.mcp.json" 2>/dev/null || true
  fi
}

detect_mcp() {
  # detect_mcp <service> → echoes the MCP server name if bound, else empty
  local service="$1"
  local names=""
  for entry in "${MCP_SERVICES[@]}"; do
    if [ "${entry%%:*}" = "$service" ]; then names="${entry#*:}"; break; fi
  done
  [ -z "$names" ] && return 0

  local available
  available="$(mcp_list)"
  [ -z "$available" ] && return 0

  IFS=',' read -ra cand <<< "$names"
  for name in "${cand[@]}"; do
    if echo "$available" | grep -qx "$name"; then
      echo "$name"; return 0
    fi
  done
  return 0
}

# ---------------------------------------------------------------------------
# Credential resolution
# ---------------------------------------------------------------------------

resolve_service() {
  # resolve_service <service> <envVar> <humanName> <capabilitiesCSV>
  local service="$1" envVar="$2" humanName="$3" caps="$4"

  log "resolving $humanName"

  if [ "$API_KEY_ONLY" -eq 0 ]; then
    local mcp
    mcp="$(detect_mcp "$service")"
    if [ -n "$mcp" ]; then
      ok "  MCP bound: $mcp"
      jq -n \
        --arg service "$service" \
        --arg mcp "$mcp" \
        --arg caps "$caps" \
        '{service: $service, mcpServerName: $mcp, boundAt: (now | todate), capabilities: ($caps | split(",")), fallback: null}' \
        >> "$MCP_CONFIG.tmp"
      return 0
    fi
    if [ "$MCP_ONLY" -eq 1 ]; then
      fail "no MCP server for $humanName; configure one of the known MCP servers and re-run"
    fi
  fi

  # API-key fallback
  local existing=""
  [ -f "$ENV_FILE" ] && existing="$(grep -E "^${envVar}=" "$ENV_FILE" | cut -d= -f2- || true)"
  if [ -z "$existing" ] && [ -z "${!envVar:-}" ]; then
    if [ "$AUTO_YES" -eq 1 ]; then
      warn "  no MCP and --yes set; skipping $humanName (set $envVar later)"
      jq -n \
        --arg service "$service" --arg envVar "$envVar" --arg caps "$caps" \
        '{service: $service, mcpServerName: null, boundAt: (now | todate), capabilities: ($caps | split(",")), fallback: {type: "api-key", envVar: $envVar, present: false}}' \
        >> "$MCP_CONFIG.tmp"
      return 0
    fi
    local key
    read -r -s -p "  no MCP for $humanName. Enter $envVar (hidden, blank to skip): " key; echo
    [ -n "$key" ] && echo "${envVar}=${key}" >> "$ENV_FILE"
  fi
  ok "  using API key via $envVar"
  jq -n \
    --arg service "$service" --arg envVar "$envVar" --arg caps "$caps" \
    '{service: $service, mcpServerName: null, boundAt: (now | todate), capabilities: ($caps | split(",")), fallback: {type: "api-key", envVar: $envVar, present: true}}' \
    >> "$MCP_CONFIG.tmp"
}

resolve_credentials() {
  log "resolving external service credentials (MCP-first)"
  : > "$MCP_CONFIG.tmp"
  : > "$ENV_FILE"
  chmod 600 "$ENV_FILE"

  resolve_service "elevenlabs" "ELEVENLABS_API_KEY" "ElevenLabs" "tts,ivc,dubbing"

  if [ "$AWS_NEEDED" = "1" ]; then
    resolve_service "aws" "AWS_ACCESS_KEY_ID" "AWS (Lambda render)" "lambda,s3,iam"
    if [ -z "$(detect_mcp aws)" ]; then
      local region
      read -r -p "  AWS_REGION [us-east-1]: " region
      region="${region:-us-east-1}"
      echo "AWS_REGION=$region" >> "$ENV_FILE"
      if [ -z "${AWS_SECRET_ACCESS_KEY:-}" ]; then
        local secret
        read -r -s -p "  AWS_SECRET_ACCESS_KEY (hidden, blank to skip): " secret; echo
        [ -n "$secret" ] && echo "AWS_SECRET_ACCESS_KEY=$secret" >> "$ENV_FILE"
      fi
    fi
  fi

  jq -s '.' "$MCP_CONFIG.tmp" > "$MCP_CONFIG"
  rm -f "$MCP_CONFIG.tmp"

  cat > "$ENV_EXAMPLE" <<'EOF'
ELEVENLABS_API_KEY=your_key_here
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=us-east-1
REMOTION_LAMBDA_ROLE_ARN=
REMOTION_LAMBDA_SITE_URL=
EOF

  ok "credentials resolved"
  ok "  MCP bindings → $MCP_CONFIG"
  ok "  API-key fallbacks → $ENV_FILE (chmod 600)"
}

# ---------------------------------------------------------------------------
# Install (unchanged from prior version)
# ---------------------------------------------------------------------------

ensure_homebrew() { [ "$OS" = "macos" ] && ! need_cmd brew && run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true; }
apt_install() { run sudo apt-get update; run sudo apt-get install -y "$@"; }
dnf_install() { run sudo dnf install -y "$@"; }
pacman_install() { run sudo pacman -S --noconfirm "$@"; }
brew_install() { run brew install "$@"; }

install_system_tools() {
  case "$PKG" in
    brew)    brew_install git jq python@3.11 curl ;;
    apt-get) apt_install git jq python3 python3-pip python3-venv curl ;;
    dnf)     dnf_install git jq python3 python3-pip curl ;;
    pacman)  pacman_install git jq python python-pip curl ;;
  esac
}

ensure_node() {
  if need_cmd node; then
    local major; major="$(node -p 'process.versions.node.split(".")[0]')"
    [ "$major" -ge "$MIN_NODE_MAJOR" ] && { ok "node $(node -v)"; return 0; }
  fi
  case "$PKG" in
    brew)    brew_install node@20 ;;
    apt-get) run curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -; apt_install nodejs ;;
    dnf)     run curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -; dnf_install nodejs ;;
    pacman)  pacman_install nodejs npm ;;
  esac
}

install_npm_packages() {
  cd "$STUDIO_DIR"
  [ -f package.json ] || run npm init -y >/dev/null
  run npm install --save-exact \
    remotion@4.0.130 @remotion/cli@4.0.130 @remotion/lambda@4.0.130 \
    @remotion/transitions@4.0.130 @remotion/lottie@4.0.130 \
    @remotion/rive@4.0.130 @remotion/three@4.0.130 \
    @remotion/google-fonts@4.0.130 @remotion/web-renderer@4.0.130 \
    react@18.3.1 react-dom@18.3.1 typescript@5.5.4 \
    @types/react@18.3.5 @types/node@20.16.5
}

install_python_packages() {
  cd "$STUDIO_DIR"
  [ -d .venv ] || run python3 -m venv .venv
  run ./.venv/bin/pip install --upgrade pip
  run ./.venv/bin/pip install "elevenlabs>=1.0"
}

install_aws() {
  if [ "$AWS_NEEDED" = "1" ] && [ -z "$(detect_mcp aws)" ]; then
    case "$PKG" in
      brew)    brew_install awscli ;;
      apt-get) apt_install awscli ;;
      dnf)     dnf_install awscli ;;
      pacman)  pacman_install aws-cli ;;
    esac
  fi
}

# ---------------------------------------------------------------------------
# Interview (unchanged)
# ---------------------------------------------------------------------------

ask() {
  local var="$1" prompt="$2" default="$3"; shift 3
  local choices=("$@")
  echo
  echo "$prompt"
  local i=1
  for c in "${choices[@]}"; do
    if [ "$i" -eq 1 ] && [ -n "$default" ]; then printf '  A*  %s\n' "$c"
    else printf '  %s   %s\n' "$(printf '%s' "$i" | tr 1 A)" "$c"; fi
    i=$((i+1))
  done
  printf '  E   Other\n'
  local answer=""
  if [ "$AUTO_YES" -eq 1 ] && [ -n "$default" ]; then answer="$default"
  else read -r -p "  > " answer; fi
  [ -z "$answer" ] && answer="A"
  case "$answer" in
    a|A) eval "$var='${choices[0]}'" ;;
    b|B) eval "$var='${choices[1]}'" ;;
    c|C) eval "$var='${choices[2]}'" ;;
    d|D) eval "$var='${choices[3]}'" ;;
    e|E) read -r -p "  custom: " custom; eval "$var='\$custom'" ;;
    *)   eval "$var='$answer'" ;;
  esac
  printf '\033[1;32m  locked:\033[0m %s\n' "$(eval echo \$$var)"
}

ask_multi() {
  local var="$1" prompt="$2" default="$3"
  echo; echo "$prompt"
  echo "  enter comma-separated letters, or 'default' for the starred set"
  echo "  A*  LinkedIn   B  Instagram Reels   C  TikTok   D  YouTube Shorts   E  X   F  Other"
  local answer=""
  if [ "$AUTO_YES" -eq 1 ]; then answer="default"; else read -r -p "  > " answer; fi
  [ -z "$answer" ] && answer="default"
  if [ "$answer" = "default" ]; then eval "$var='$default'"
  else
    local out=""
    IFS=',' read -ra parts <<< "$answer"
    for p in "${parts[@]}"; do
      case "$(echo "$p" | tr 'a-z' 'A-Z' | xargs)" in
        A) out="$out linkedin" ;; B) out="$out instagram" ;;
        C) out="$out tiktok" ;; D) out="$out youtube" ;;
        E) out="$out x" ;; F) read -r -p "  custom: " c; out="$out $c" ;;
      esac
    done
    eval "$var='$(echo $out | xargs)'"
  fi
  printf '\033[1;32m  locked:\033[0m %s\n' "$(eval echo \$$var)"
}

interview() {
  echo; echo "============================================================"
  echo "MOTION STUDIO — SETUP INTERVIEW"
  echo "============================================================"

  ask STUDIO_NAME "Q1 — Studio identity. Studio name?" "A" "Motion Studio" "Personal studio" "I'll type it"
  ask_multi PRIMARY_CHANNELS "Q2 — Primary channels." "linkedin instagram tiktok youtube"
  ask_multi CONTENT_CATEGORIES "Q3 — Content categories." "explainers product-demos thought-leadership"
  ask CADENCE "Q4 — Default posting cadence per platform." "A" "1 per week" "2-3 per week" "Daily" "Campaign-based"
  ask DESIGN_POSTURE "Q5 — Design system posture." "A" "Create from scratch now" "Use studio default" "Import from a client profile" "Define per-project"
  ask PALETTE_SOURCE "Q6 — Brand palette source." "A" "Provide hexes now" "Extract from brand assets" "Use studio default" "Define per-project"
  ask VOICE_POSTURE "Q7 — Brand voice posture." "A" "Create from scratch now" "Use studio default" "Import from a client profile" "Define per-project"
  ask VO_STRATEGY "Q8 — Default voice strategy." "A" "Professional VO (ElevenLabs Multilingual v2)" "Founder or client voice (Instant Voice Cloning)" "Text-on-screen only" "AI voice disclosed (ElevenLabs Turbo v2.5)"
  ask MOTION_STACK "Q9 — Motion stack defaults." "A" "Remotion standard (local render)" "Remotion + Lambda (distributed render)" "Remotion + Three.js (3D content)" "Remotion + Lottie/Rive (vector motion)"
  ask DELIVERY "Q10 — Delivery defaults." "A" "1 master + platform-native cuts" "1 master only" "1 master + cuts + 3 short teasers" "Full campaign set"

  case "$MOTION_STACK" in *Lambda*) AWS_NEEDED=1 ;; *) AWS_NEEDED=0 ;; esac

  read -r -p "  timezone [$(date +%Z)]: " TZ_INPUT
  TIMEZONE="${TZ_INPUT:-$(date +%Z)}"
  read -r -p "  primary market [United States]: " MARKET_INPUT
  PRIMARY_MARKET="${MARKET_INPUT:-United States}"

  [ "$PALETTE_SOURCE" = "Provide hexes now" ] && read -r -p "  palette hexes (csv): " PALETTE_HEXES
  [ "$VO_STRATEGY" = "Professional VO (ElevenLabs Multilingual v2)" ] && read -r -p "  ElevenLabs voice_id (blank for studio default): " ELEVENLABS_VOICE_ID

  echo; echo "============================================================"
  echo "STUDIO PROFILE"
  echo "============================================================"
  printf '  studio:            %s\n' "$STUDIO_NAME"
  printf '  channels:          %s\n' "$PRIMARY_CHANNELS"
  printf '  categories:        %s\n' "$CONTENT_CATEGORIES"
  printf '  cadence:           %s\n' "$CADENCE"
  printf '  design system:     %s\n' "$DESIGN_POSTURE"
  printf '  palette source:    %s\n' "$PALETTE_SOURCE"
  printf '  brand voice:       %s\n' "$VOICE_POSTURE"
  printf '  voice strategy:    %s\n' "$VO_STRATEGY"
  printf '  motion stack:      %s\n' "$MOTION_STACK"
  printf '  delivery:          %s\n' "$DELIVERY"
  printf '  timezone:          %s\n' "$TIMEZONE"
  printf '  primary market:    %s\n' "$PRIMARY_MARKET"
  printf '  AWS needed:        %s\n' "$AWS_NEEDED"
  echo
  read -r -p "lock studio profile? [yes / no] " confirm
  [ "$confirm" = "yes" ] || fail "aborted by user"
}

# ---------------------------------------------------------------------------
# Scaffold (unchanged, plus runs/_mcp.json)
# ---------------------------------------------------------------------------

scaffold() {
  cd "$STUDIO_DIR"
  mkdir -p skills runs/_clients runs/_sfx/{impacts,transitions,ui,ambient,accents,risers,stingers,synthesized} runs/_luts runs/_studio src/{scenes,transitions,grade,thumbnails} public out
  for d in skills runs/_clients runs/_sfx runs/_luts runs/_studio src/scenes src/transitions src/grade src/thumbnails public; do [ -f "$d/.gitkeep" ] || touch "$d/.gitkeep"; done
  [ -f src/Root.tsx ] || cat > src/Root.tsx <<'EOF'
import { Composition } from "remotion";
export const RemotionRoot: React.FC = () => (<></>);
EOF
  [ -f src/index.ts ] || cat > src/index.ts <<'EOF'
import { registerRoot } from "remotion";
import { RemotionRoot } from "./Root";
registerRoot(RemotionRoot);
EOF
  [ -f remotion.config.ts ] || cat > remotion.config.ts <<'EOF'
import { Config } from "@remotion/cli/config";
Config.setVideoImageFormat("jpeg");
Config.setOverwriteOutput(true);
Config.setCodec("h264");
Config.setCrf(18);
EOF
  [ -f tsconfig.json ] || cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "lib": ["ES2022", "DOM"]
  },
  "include": ["src"]
}
EOF
  cat > .gitignore <<'EOF'
node_modules/
.venv/
out/
.env
runs/_mcp.json
runs/*/audio/raw/
runs/*/audio/archive/
runs/*/previews/
runs/*/deliverables/
runs/*/distribution/
.DS_Store
*.log
EOF
}

write_studio_config() {
  mkdir -p "$(dirname "$STUDIO_CONFIG")"
  local target="$STUDIO_CONFIG" kind="studio"
  [ -n "$PROFILE" ] && { target="$CLIENT_DIR/$PROFILE.json"; kind="client"; mkdir -p "$CLIENT_DIR"; }
  jq -n \
    --arg kind "$kind" --arg name "$STUDIO_NAME" \
    --arg slug "$(echo "$STUDIO_NAME" | tr 'A-Z' 'a-z' | tr -cs 'a-z0-9' '-' | sed 's/-$//')" \
    --arg channels "$PRIMARY_CHANNELS" --arg categories "$CONTENT_CATEGORIES" \
    --arg cadence "$CADENCE" --arg design "$DESIGN_POSTURE" \
    --arg palette "$PALETTE_SOURCE" --arg paletteHexes "${PALETTE_HEXES:-}" \
    --arg voice "$VOICE_POSTURE" --arg voStrategy "$VO_STRATEGY" \
    --arg voId "${ELEVENLABS_VOICE_ID:-}" \
    --arg motion "$MOTION_STACK" --arg delivery "$DELIVERY" \
    --arg tz "$TIMEZONE" --arg market "$PRIMARY_MARKET" \
    '{
      kind: $kind,
      studioName: $name,
      studioSlug: $slug,
      primaryChannels: ($channels | split(" ")),
      contentCategories: ($categories | split(" ")),
      defaultCadence: $cadence,
      designSystemPosture: $design,
      paletteSource: $palette,
      paletteHexes: ($paletteHexes | if . == "" then [] else split(",") end),
      brandVoicePosture: $voice,
      defaultVoiceStrategy: $voStrategy,
      defaultVoiceId: ($voId | if . == "" then null else . end),
      motionStackDefaults: $motion,
      deliveryDefaults: $delivery,
      timezone: $tz,
      primaryMarket: $market,
      createdAt: (now | todate),
      version: "1.0"
    }' > "$target"
}

verify() {
  local failed=0
  for c in node npm python3 git jq; do need_cmd "$c" || { warn "$c missing"; failed=1; }; done
  [ -d "$STUDIO_DIR/src" ] || { warn "src/ missing"; failed=1; }
  [ -f "$STUDIO_DIR/src/Root.tsx" ] || { warn "src/Root.tsx missing"; failed=1; }
  [ -f "$STUDIO_DIR/remotion.config.ts" ] || { warn "remotion.config.ts missing"; failed=1; }
  [ -f "$STUDIO_CONFIG" ] || { warn "_studio.json missing"; failed=1; }
  [ -f "$MCP_CONFIG" ] || { warn "_mcp.json missing (run --creds-only)"; failed=1; }
  [ -f "$STUDIO_CONFIG" ] && jq empty "$STUDIO_CONFIG" || true
  [ -f "$MCP_CONFIG" ] && jq empty "$MCP_CONFIG" || true
  grep -q '^\.env' "$STUDIO_DIR/.gitignore" || { warn ".env not gitignored"; failed=1; }
  grep -q '^runs/_mcp.json' "$STUDIO_DIR/.gitignore" || { warn "_mcp.json not gitignored"; failed=1; }

  # Every required service resolved
  if [ -f "$MCP_CONFIG" ]; then
    if ! jq -e '.[] | select(.service=="elevenlabs")' "$MCP_CONFIG" >/dev/null; then
      warn "elevenlabs not resolved (no MCP, no API key)"; failed=1
    fi
    if [ "$AWS_NEEDED" = "1" ]; then
      if ! jq -e '.[] | select(.service=="aws")' "$MCP_CONFIG" >/dev/null; then
        warn "aws not resolved (no MCP, no API key)"; failed=1
      fi
    fi
  fi

  [ "$failed" -eq 1 ] && fail "verify failed"
  ok "environment verified"
}

main() {
  detect_os
  case "$MODE" in
    install)
      ensure_homebrew; install_system_tools; ensure_node; install_npm_packages; install_python_packages; AWS_NEEDED=0; install_aws; verify ;;
    creds)
      # AWS_NEEDED unknown here; resolve elevenlabs, and aws when the studio config says Lambda
      if [ -f "$STUDIO_CONFIG" ] && jq -e '.motionStackDefaults | test("Lambda")' "$STUDIO_CONFIG" >/dev/null; then
        AWS_NEEDED=1
      else
        AWS_NEEDED=0
      fi
      resolve_credentials ;;
    interview)
      interview; write_studio_config ;;
    scaffold)
      scaffold; verify ;;
    verify)
      verify ;;
    full)
      ensure_homebrew; install_system_tools; ensure_node
      install_npm_packages; install_python_packages
      interview
      install_aws
      resolve_credentials
      scaffold
      write_studio_config
      verify
      echo
      echo "============================================================"
      echo "MOTION STUDIO — SETUP COMPLETE"
      echo "============================================================"
      printf '  studio:      %s\n' "$STUDIO_NAME"
      printf '  profile:     %s\n' "$STUDIO_CONFIG"
      printf '  mcp:         %s\n' "$MCP_CONFIG"
      printf '  env:         %s\n' "$ENV_FILE"
      echo "  next:        /ms-command intake"
      echo "============================================================" ;;
  esac
}

main "$@"