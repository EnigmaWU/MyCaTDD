#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

pairs=(
  "README.md|README_ZH.md"
  "methodPrompts/README.md|methodPrompts/README_ZH.md"
  "methodPrompts/README_UserGuide.md|methodPrompts/README_UserGuide_ZH.md"
  "slashCommands/README.md|slashCommands/README_ZH.md"
  "slashCommands/README_UserGuide.md|slashCommands/README_UserGuide_ZH.md"
  "codeAgents/utCodeAgentCLI/README.md|codeAgents/utCodeAgentCLI/README_ZH.md"
  "codeAgents/utCodeAgentCLI/README_UserGuide.md|codeAgents/utCodeAgentCLI/README_UserGuide_ZH.md"
  "codeAgents/utCodeAgentCLI/README_UsageDesign.md|codeAgents/utCodeAgentCLI/README_UsageDesign_ZH.md"
  "agentSkills/README.md|agentSkills/README_ZH.md"
  "agentSkills/README_UserGuide.md|agentSkills/README_UserGuide_ZH.md"
)

has_error=0

check_pair() {
  local en_rel="$1"
  local zh_rel="$2"
  local en="$REPO_ROOT/$en_rel"
  local zh="$REPO_ROOT/$zh_rel"

  if [[ ! -f "$en" ]]; then
    echo "[mirror-check] Missing file: $en_rel" >&2
    has_error=1
    return
  fi

  if [[ ! -f "$zh" ]]; then
    echo "[mirror-check] Missing file: $zh_rel" >&2
    has_error=1
    return
  fi

  local en_tmp
  local zh_tmp
  en_tmp="$(mktemp)"
  zh_tmp="$(mktemp)"
  trap 'rm -f "$en_tmp" "$zh_tmp"' RETURN

  awk '/^#{1,6} /{print length($1), $1}' "$en" > "$en_tmp"
  awk '/^#{1,6} /{print length($1), $1}' "$zh" > "$zh_tmp"

  if ! diff -u "$en_tmp" "$zh_tmp" > /dev/null; then
    echo "[mirror-check] Heading structure mismatch:" >&2
    echo "  EN: $en_rel" >&2
    echo "  ZH: $zh_rel" >&2
    echo "  Expected same heading levels/count in both files." >&2
    has_error=1
    return
  fi

  local en_count
  local zh_count
  en_count="$(wc -l < "$en_tmp" | tr -d '[:space:]')"
  zh_count="$(wc -l < "$zh_tmp" | tr -d '[:space:]')"

  echo "[mirror-check] OK ($en_count headings): $en_rel <-> $zh_rel"
}

for pair in "${pairs[@]}"; do
  en_rel="${pair%%|*}"
  zh_rel="${pair##*|}"
  check_pair "$en_rel" "$zh_rel"
done

if [[ "$has_error" -ne 0 ]]; then
  echo "[mirror-check] FAILED" >&2
  exit 1
fi

echo "[mirror-check] PASSED"
