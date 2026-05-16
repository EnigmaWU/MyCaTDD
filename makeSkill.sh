#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILL_NAME="${1:-comment-alive-test-driven-development}"
SKILL_DIR="$REPO_ROOT/agentSkill/$SKILL_NAME"

if [[ ! -d "$SKILL_DIR" ]]; then
  echo "Skill directory not found: $SKILL_DIR" >&2
  exit 1
fi

mkdir -p "$SKILL_DIR/references"

ln -sfn "../../../methodPrompts/CaTDD_UserGuide.md" "$SKILL_DIR/references/CaTDD_UserGuide.md"
ln -sfn "../../../methodPrompts/CaTDD_DesignPrompt.md" "$SKILL_DIR/references/CaTDD_DesignPrompt.md"
ln -sfn "../../../methodPrompts/CaTDD_ImplTemplate.cxx" "$SKILL_DIR/references/CaTDD_ImplTemplate.cxx"
ln -sfn "../../../methodPrompts/CaTDD-UserGuide-PPT.md" "$SKILL_DIR/references/CaTDD-UserGuide-PPT.md"
ln -sfn "../../slashCommands" "$SKILL_DIR/slashCommands"

echo "Skill packaged with symlinked methodPrompts and slashCommands: $SKILL_DIR"
