#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GENERATOR="$REPO_ROOT/scripts/makeSlashCmd4Copilot.sh"
OUT_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$OUT_DIR"
}
trap cleanup EXIT

fail() {
  echo "[makeSlashCmd4Copilot-test] $*" >&2
  exit 1
}

[[ -x "$GENERATOR" ]] || fail "missing executable generator: scripts/makeSlashCmd4Copilot.sh"

git -C "$REPO_ROOT" check-ignore -q .github/prompts/UT_example.prompt.md || fail "generated UT prompt wrappers must be ignored in this source repo"
git -C "$REPO_ROOT" check-ignore -q .github/prompts/SPEC_example.prompt.md || fail "generated SPEC prompt wrappers must be ignored in this source repo"

"$GENERATOR" --output "$OUT_DIR" --clean

source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' \) | wc -l | tr -d '[:space:]')"
prompt_count="$(find "$OUT_DIR" -type f \( -name 'UT_*.prompt.md' -o -name 'SPEC_*.prompt.md' \) | wc -l | tr -d '[:space:]')"

[[ "$source_count" -gt 0 ]] || fail "expected at least one portable slash command source"
[[ "$prompt_count" == "$source_count" ]] || fail "expected $source_count generated prompts, got $prompt_count"

sample="$OUT_DIR/UT_convertDemoToTypical.prompt.md"
[[ -f "$sample" ]] || fail "missing sample prompt: UT_convertDemoToTypical.prompt.md"

grep -Fq 'description: "Run CaTDD slash command UT_convertDemoToTypical"' "$sample" || fail "sample prompt missing Copilot description"
grep -Fq 'agent: "agent"' "$sample" || fail "sample prompt missing Copilot agent mode"
grep -Fq 'slashCommands/commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md' "$sample" || fail "sample prompt missing source command reference"
grep -Fq 'methodPrompts' "$sample" || fail "sample prompt missing methodPrompts source-of-truth reference"
grep -Fq 'ONE-MORE-THING: ask developer if something not sure' "$sample" || fail "sample prompt missing uncertainty guard"

spec_sample="$OUT_DIR/SPEC_openUserStory.prompt.md"
[[ -f "$spec_sample" ]] || fail "missing sample prompt: SPEC_openUserStory.prompt.md"
grep -Fq 'description: "Run CaTDD slash command SPEC_openUserStory"' "$spec_sample" || fail "SPEC sample prompt missing Copilot description"
grep -Fq 'slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md' "$spec_sample" || fail "SPEC sample prompt missing source command reference"
grep -Fq 'methodPrompts' "$spec_sample" || fail "SPEC sample prompt missing methodPrompts source-of-truth reference"

for command_name in SPEC_importIssue SPEC_importFeature SPEC_analyzeIssue SPEC_analyzeFeature SPEC_whatsNextTask; do
  command_prompt="$OUT_DIR/${command_name}.prompt.md"
  [[ -f "$command_prompt" ]] || fail "missing generated prompt: ${command_name}.prompt.md"
  grep -Fq "description: \"Run CaTDD slash command ${command_name}\"" "$command_prompt" || fail "${command_name} prompt missing Copilot description"
  grep -Fq "slashCommands/commands/Px-SpecFlow/${command_name}.md" "$command_prompt" || fail "${command_name} prompt missing source command reference"
done

[[ ! -e "$OUT_DIR/SPEC_importWorkItem.prompt.md" ]] || fail "old SPEC_importWorkItem prompt should not be generated"
[[ ! -e "$OUT_DIR/SPEC_analyzeWorkItem.prompt.md" ]] || fail "old SPEC_analyzeWorkItem prompt should not be generated"

echo "[makeSlashCmd4Copilot-test] PASSED: generated $prompt_count Copilot prompt wrappers"