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

verbose_output="$("$INSTALLER" --target "$TARGET_DIR" --clean-prompts --verbose 2>&1)"
grep -Fq '+ mkdir -p ' <<< "$verbose_output" || fail "--verbose output missing detailed action trace"

[[ -f "$TARGET_DIR/.catdd/methodPrompts/README.md" ]] || fail "missing installed methodPrompts"
[[ -f "$TARGET_DIR/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "missing installed slashCommands"
[[ -d "$TARGET_DIR/.catdd/spec/analyzedNews" ]] || fail "missing .catdd/spec/analyzedNews"
[[ -f "$TARGET_DIR/.github/instructions/catdd.instructions.md" ]] || fail "missing Copilot CaTDD instruction file"

source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' \) | wc -l | tr -d '[:space:]')"
prompt_count="$(find "$TARGET_DIR/.github/prompts" -type f \( -name 'UT_*.prompt.md' -o -name 'SPEC_*.prompt.md' \) | wc -l | tr -d '[:space:]')"

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
grep -Fq '.github/prompts/UT_*.prompt.md' "$instructions" || fail "instructions missing UT prompt wrapper location"
grep -Fq '.github/prompts/SPEC_*.prompt.md' "$instructions" || fail "instructions missing SPEC prompt wrapper location"

spec_sample="$TARGET_DIR/.github/prompts/SPEC_openUserStory.prompt.md"
[[ -f "$spec_sample" ]] || fail "missing installed SPEC sample prompt"
grep -Fq '.catdd/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md' "$spec_sample" || fail "SPEC sample prompt does not point to installed slashCommands"

for command_name in SPEC_importIssue SPEC_importFeature SPEC_analyzeIssue SPEC_analyzeFeature; do
  command_prompt="$TARGET_DIR/.github/prompts/${command_name}.prompt.md"
  [[ -f "$command_prompt" ]] || fail "missing installed prompt: ${command_name}.prompt.md"
  grep -Fq ".catdd/slashCommands/commands/Px-SpecFlow/${command_name}.md" "$command_prompt" || fail "${command_name} prompt does not point to installed slashCommands"
done

[[ ! -e "$TARGET_DIR/.github/prompts/SPEC_importWorkItem.prompt.md" ]] || fail "old SPEC_importWorkItem prompt should not be installed"
[[ ! -e "$TARGET_DIR/.github/prompts/SPEC_analyzeWorkItem.prompt.md" ]] || fail "old SPEC_analyzeWorkItem prompt should not be installed"

init_target="$TARGET_DIR/new-project"
"$INSTALLER" --target "$init_target" --init --clean-prompts

[[ -f "$init_target/.catdd/methodPrompts/README.md" ]] || fail "--init target missing installed methodPrompts"
[[ -f "$init_target/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "--init target missing installed slashCommands"
[[ -d "$init_target/.catdd/spec/analyzedNews" ]] || fail "--init target missing .catdd/spec/analyzedNews"
[[ -f "$init_target/.github/prompts/UT_convertDemoToTypical.prompt.md" ]] || fail "--init target missing generated Copilot prompt"
[[ -f "$init_target/.github/prompts/SPEC_openUserStory.prompt.md" ]] || fail "--init target missing generated SPEC Copilot prompt"
[[ -f "$init_target/.github/prompts/SPEC_importIssue.prompt.md" ]] || fail "--init target missing generated SPEC import issue prompt"

echo "[installCaTDD4Copilot-test] PASSED: installed CaTDD Copilot assets into temporary target"