#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALLER="$REPO_ROOT/scripts/installCaTDD4Copilot.sh"
TARGET_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

fail() {
  echo "[installCaTDD4Copilot-test] $*" >&2
  exit 1
}

[[ -x "$INSTALLER" ]] || fail "missing executable installer: scripts/installCaTDD4Copilot.sh"

"$INSTALLER" --target "$TARGET_DIR" --clean-prompts

[[ -f "$TARGET_DIR/.catdd/methodPrompts/README.md" ]] || fail "missing installed methodPrompts"
[[ -f "$TARGET_DIR/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "missing installed slashCommands"
[[ -f "$TARGET_DIR/.github/instructions/catdd.instructions.md" ]] || fail "missing Copilot CaTDD instruction file"

source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f -name 'UT_*.md' | wc -l | tr -d '[:space:]')"
prompt_count="$(find "$TARGET_DIR/.github/prompts" -type f -name 'UT_*.prompt.md' | wc -l | tr -d '[:space:]')"

[[ "$prompt_count" == "$source_count" ]] || fail "expected $source_count installed Copilot prompts, got $prompt_count"

sample="$TARGET_DIR/.github/prompts/UT_convertDemoToTypical.prompt.md"
[[ -f "$sample" ]] || fail "missing installed sample prompt"

grep -Fq '.catdd/slashCommands/commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md' "$sample" || fail "sample prompt does not point to installed slashCommands"
grep -Fq '.catdd/methodPrompts/README.md' "$sample" || fail "sample prompt does not point to installed methodPrompts"
grep -Fq 'thin Copilot adapter' "$sample" || fail "sample prompt missing adapter guard"
grep -Fq 'ONE-MORE-THING: ask developer if something not sure' "$sample" || fail "sample prompt missing uncertainty guard"

instructions="$TARGET_DIR/.github/instructions/catdd.instructions.md"
grep -Fq '.catdd/methodPrompts' "$instructions" || fail "instructions missing methodPrompts location"
grep -Fq '.catdd/slashCommands' "$instructions" || fail "instructions missing slashCommands location"
grep -Fq '.github/prompts/UT_*.prompt.md' "$instructions" || fail "instructions missing Copilot prompt wrapper location"

init_target="$TARGET_DIR/new-project"
"$INSTALLER" --target "$init_target" --init --clean-prompts

[[ -f "$init_target/.catdd/methodPrompts/README.md" ]] || fail "--init target missing installed methodPrompts"
[[ -f "$init_target/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "--init target missing installed slashCommands"
[[ -f "$init_target/.github/prompts/UT_convertDemoToTypical.prompt.md" ]] || fail "--init target missing generated Copilot prompt"

echo "[installCaTDD4Copilot-test] PASSED: installed CaTDD Copilot assets into temporary target"