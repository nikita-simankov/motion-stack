#!/usr/bin/env bash
#
# Motion Studio — motion lint wrapper
#
# Usage: audit-motion.sh [path ...] [--tokens runs/<id>/style/style-tokens.json] [--json] [--strict]
# Defaults to src/scenes. See audit_motion.py for the rule list.

set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ARGS=("$@")
[ $# -gt 0 ] && case "$1" in -*) ARGS=("src/scenes" "$@") ;; esac
[ $# -eq 0 ] && ARGS=("src/scenes")
exec python3 -I "$HERE/audit_motion.py" "${ARGS[@]}"
