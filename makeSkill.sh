#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SUPPORTED_SKILL="comment-alive-test-driven-development"
SKILL_NAME="${1:-$SUPPORTED_SKILL}"

if [[ "$SKILL_NAME" != "$SUPPORTED_SKILL" ]]; then
  echo "Unsupported skill '$SKILL_NAME'. Supported: $SUPPORTED_SKILL" >&2
  exit 1
fi

SKILL_DIR="$REPO_ROOT/agentSkill/$SKILL_NAME"

if [[ ! -d "$SKILL_DIR" ]]; then
  echo "Skill directory not found: $SKILL_DIR" >&2
  exit 1
fi

mkdir -p "$SKILL_DIR/references"

required_sources=(
  "$REPO_ROOT/methodPrompts/CaTDD_UserGuide.md"
  "$REPO_ROOT/methodPrompts/CaTDD_DesignPrompt.md"
  "$REPO_ROOT/methodPrompts/CaTDD_ImplTemplate.cxx"
  "$REPO_ROOT/methodPrompts/CaTDD-UserGuide-PPT.md"
  "$REPO_ROOT/slashCommands"
)

for source in "${required_sources[@]}"; do
  if [[ ! -e "$source" ]]; then
    echo "Required source not found: $source" >&2
    exit 1
  fi
done

ln -sfn "../../../methodPrompts/CaTDD_UserGuide.md" "$SKILL_DIR/references/CaTDD_UserGuide.md"
ln -sfn "../../../methodPrompts/CaTDD_DesignPrompt.md" "$SKILL_DIR/references/CaTDD_DesignPrompt.md"
ln -sfn "../../../methodPrompts/CaTDD_ImplTemplate.cxx" "$SKILL_DIR/references/CaTDD_ImplTemplate.cxx"
ln -sfn "../../../methodPrompts/CaTDD-UserGuide-PPT.md" "$SKILL_DIR/references/CaTDD-UserGuide-PPT.md"
# SKILL_DIR is /repo/agentSkill/<skill>, so ../../slashCommands resolves to /repo/slashCommands.
ln -sfn "../../slashCommands" "$SKILL_DIR/slashCommands"

echo "Skill packaged with symlinked methodPrompts and slashCommands: $SKILL_DIR"
