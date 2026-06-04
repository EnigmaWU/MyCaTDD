#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GENERATOR="$REPO_ROOT/scripts/makeSlashCmd4Continue.sh"
OUT_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$OUT_DIR"
}
trap cleanup EXIT

fail() {
  echo "[makeSlashCmd4Continue-test] $*" >&2
  exit 1
}

[[ -x "$GENERATOR" ]] || fail "missing executable generator: scripts/makeSlashCmd4Continue.sh"

git -C "$REPO_ROOT" check-ignore -q .continue/prompts/UT_example.prompt || fail "generated UT prompt wrappers must be ignored in this source repo"
git -C "$REPO_ROOT" check-ignore -q .continue/prompts/SPEC_example.prompt || fail "generated SPEC prompt wrappers must be ignored in this source repo"

"$GENERATOR" --output "$OUT_DIR" --clean

source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' \) | wc -l | tr -d '[:space:]')"
prompt_count="$(find "$OUT_DIR" -type f \( -name 'UT_*.prompt' -o -name 'SPEC_*.prompt' \) | wc -l | tr -d '[:space:]')"

[[ "$source_count" -gt 0 ]] || fail "expected at least one portable slash command source"
[[ "$prompt_count" == "$source_count" ]] || fail "expected $source_count generated prompts, got $prompt_count"

sample="$OUT_DIR/UT_convertDemoToTypical.prompt"
[[ -f "$sample" ]] || fail "missing sample prompt: UT_convertDemoToTypical.prompt"

grep -Fq 'name: UT_convertDemoToTypical' "$sample" || fail "sample prompt missing Continue name"
grep -Fq 'description: Run CaTDD slash command UT_convertDemoToTypical' "$sample" || fail "sample prompt missing Continue description"
grep -Fq 'slashCommands/commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md' "$sample" || fail "sample prompt missing source command reference"
grep -Fq 'methodPrompts' "$sample" || fail "sample prompt missing methodPrompts source-of-truth reference"
grep -Fq 'ONE-MORE-THING: ask developer if something not sure' "$sample" || fail "sample prompt missing uncertainty guard"

spec_sample="$OUT_DIR/SPEC_openUserStory.prompt"
[[ -f "$spec_sample" ]] || fail "missing sample prompt: SPEC_openUserStory.prompt"
grep -Fq 'name: SPEC_openUserStory' "$spec_sample" || fail "SPEC sample prompt missing Continue name"
grep -Fq 'slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md' "$spec_sample" || fail "SPEC sample missing source command reference"
grep -Fq 'methodPrompts' "$spec_sample" || fail "SPEC sample prompt missing methodPrompts source-of-truth reference"

for command_name in SPEC_importIssue SPEC_importFeature SPEC_analyzeIssue SPEC_analyzeFeature SPEC_whatsNextTask SPEC_takePlan; do
  command_prompt="$OUT_DIR/${command_name}.prompt"
  [[ -f "$command_prompt" ]] || fail "missing generated prompt: ${command_name}.prompt"
  grep -Fq "name: ${command_name}" "$command_prompt" || fail "${command_name} prompt missing Continue name"
  grep -Fq "slashCommands/commands/Px-SpecFlow/${command_name}.md" "$command_prompt" || fail "${command_name} prompt missing source command reference"
done

[[ ! -e "$OUT_DIR/SPEC_importWorkItem.prompt" ]] || fail "old SPEC_importWorkItem prompt should not be generated"
[[ ! -e "$OUT_DIR/SPEC_analyzeWorkItem.prompt" ]] || fail "old SPEC_analyzeWorkItem prompt should not be generated"

echo "[makeSlashCmd4Continue-test] PASSED: generated $prompt_count Continue prompt wrappers"