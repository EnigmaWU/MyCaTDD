#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SUPPORTED_SKILL="comment-alive-test-driven-development"
SKILL_NAME="${1:-$SUPPORTED_SKILL}"

if [[ "$SKILL_NAME" != "$SUPPORTED_SKILL" ]]; then
  echo "Unsupported skill '$SKILL_NAME'. Supported: $SUPPORTED_SKILL" >&2
  exit 1
fi

SKILL_DIR="$SCRIPT_DIR/$SKILL_NAME"

if [[ ! -d "$SKILL_DIR" ]]; then
  echo "Skill directory not found: $SKILL_DIR" >&2
  exit 1
fi

mkdir -p "$SKILL_DIR/references"

required_sources=(
  "$REPO_ROOT/README_UserGuide.md"
  "$REPO_ROOT/methodPrompts/CaTDD_methodPrompt.md"
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

legacy_user_guide_ref="$SKILL_DIR/references/CaTDD_""UserGuide.md"
legacy_method_prompt_ref="$SKILL_DIR/references/CaTDD_""Design""Prompt.md"
rm -f "$legacy_user_guide_ref"
rm -f "$legacy_method_prompt_ref"

ln -sfn "../../../README_UserGuide.md" "$SKILL_DIR/references/README_UserGuide.md"
ln -sfn "../../../methodPrompts/CaTDD_methodPrompt.md" "$SKILL_DIR/references/CaTDD_methodPrompt.md"
ln -sfn "../../../methodPrompts/CaTDD_ImplTemplate.cxx" "$SKILL_DIR/references/CaTDD_ImplTemplate.cxx"
ln -sfn "../../../methodPrompts/CaTDD-UserGuide-PPT.md" "$SKILL_DIR/references/CaTDD-UserGuide-PPT.md"
ln -sfn "../../slashCommands" "$SKILL_DIR/slashCommands"

if [[ ! -L "$SKILL_DIR/slashCommands" || ! -e "$SKILL_DIR/slashCommands" ]]; then
  echo "Failed to link slashCommands into skill package" >&2
  exit 1
fi

echo "Skill packaged with symlinked methodPrompts and slashCommands: $SKILL_DIR"
