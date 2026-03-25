#!/usr/bin/env bash
# Git Guardrails — blocks dangerous git commands in Claude Code
# Reads tool_input JSON from stdin, checks the command field.

set -euo pipefail

INPUT="$(cat)"
COMMAND="$(echo "$INPUT" | jq -r '.tool_input.command // empty')"

# No command field → not our concern
[[ -z "$COMMAND" ]] && exit 0

# Patterns to block
BLOCKED_PATTERNS=(
  'git\s+reset\s+--hard'
  'git\s+clean\s+-[fd]'
  'git\s+branch\s+-D'
  'git\s+checkout\s+\.'
  'git\s+restore\s+\.'
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qEi "$pattern"; then
    echo "BLOCKED: «$COMMAND» — no tienes autorización para ejecutar este comando destructivo de git. Pide confirmación al usuario." >&2
    exit 2
  fi
done

exit 0
