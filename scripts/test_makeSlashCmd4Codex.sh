#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GENERATOR="$REPO_ROOT/scripts/makeSlashCmd4Codex.sh"
OUT_DIR="$(mktemp -d)"
PROMPTS_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$OUT_DIR" "$PROMPTS_DIR"
}
trap cleanup EXIT

fail() {
  echo "[makeSlashCmd4Codex-test] $*" >&2
  exit 1
}

[[ -x "$GENERATOR" ]] || fail "missing executable generator: scripts/makeSlashCmd4Codex.sh"

git -C "$REPO_ROOT" check-ignore -q .agents/skills/ut-example/SKILL.md || fail "generated Codex skill wrappers must be ignored in this source repo"

"$GENERATOR" --output "$OUT_DIR" --prompts-output "$PROMPTS_DIR" --clean

source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | wc -l | tr -d '[:space:]')"
skill_count="$(find "$OUT_DIR" -mindepth 1 -maxdepth 1 -type d \( -name 'ut-*' -o -name 'spec-*' -o -name 'harness-*' \) | wc -l | tr -d '[:space:]')"
prompt_count="$(find "$PROMPTS_DIR" -maxdepth 1 -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | wc -l | tr -d '[:space:]')"

[[ "$source_count" -gt 0 ]] || fail "expected at least one portable slash command source"
[[ "$skill_count" == "$source_count" ]] || fail "expected $source_count generated Codex skills, got $skill_count"
[[ "$prompt_count" == "$source_count" ]] || fail "expected $source_count generated Codex custom prompts, got $prompt_count"

skill_sample="$OUT_DIR/ut-convert-demo-to-typical/SKILL.md"
[[ -f "$skill_sample" ]] || fail "missing sample skill: ut-convert-demo-to-typical/SKILL.md"
grep -Fq 'name: ut-convert-demo-to-typical' "$skill_sample" || fail "sample skill missing Codex-compatible name"
grep -Fq 'Run CaTDD slash command UT_convertDemoToTypical' "$skill_sample" || fail "sample skill description missing canonical command name"
grep -Fq 'slashCommands/commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md' "$skill_sample" || fail "sample skill missing source command reference"
grep -Fq 'methodPrompts' "$skill_sample" || fail "sample skill missing methodPrompts source-of-truth reference"
grep -Fq 'thin Codex Skill adapter' "$skill_sample" || fail "sample skill missing thin-adapter declaration"
grep -Fq 'ONE-MORE-THING: ask developer if something not sure' "$skill_sample" || fail "sample skill missing uncertainty guard"

skill_spec_sample="$OUT_DIR/spec-open-user-story/SKILL.md"
[[ -f "$skill_spec_sample" ]] || fail "missing sample skill: spec-open-user-story/SKILL.md"
grep -Fq 'Run CaTDD slash command SPEC_openUserStory' "$skill_spec_sample" || fail "SPEC sample skill description missing canonical command name"
grep -Fq 'slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md' "$skill_spec_sample" || fail "SPEC sample skill missing source command reference"

skill_harness_sample="$OUT_DIR/harness-patch-ca-tdd-source/SKILL.md"
[[ -f "$skill_harness_sample" ]] || fail "missing sample skill: harness-patch-ca-tdd-source/SKILL.md"
grep -Fq 'Run CaTDD slash command HARNESS_patchCaTDDSource' "$skill_harness_sample" || fail "HARNESS sample skill description missing canonical command name"
grep -Fq 'slashCommands/commands/Px-HarnessKits/HARNESS_patchCaTDDSource.md' "$skill_harness_sample" || fail "HARNESS sample skill missing source command reference"

prompt_sample="$PROMPTS_DIR/UT_convertDemoToTypical.md"
[[ -f "$prompt_sample" ]] || fail "missing sample custom prompt: UT_convertDemoToTypical.md"
grep -Fq 'description: "Run CaTDD slash command UT_convertDemoToTypical' "$prompt_sample" || fail "sample custom prompt missing description front matter"
grep -Fq 'argument-hint: "[INPUT=<task intent>] [SOURCE=<paths>] [TARGET=<paths>]"' "$prompt_sample" || fail "sample custom prompt missing argument-hint front matter"
grep -Fq '$ARGUMENTS' "$prompt_sample" || fail "sample custom prompt missing \$ARGUMENTS expansion"
grep -Fq 'slashCommands/commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md' "$prompt_sample" || fail "sample custom prompt missing source command reference"
grep -Fq 'methodPrompts' "$prompt_sample" || fail "sample custom prompt missing methodPrompts source-of-truth reference"
grep -Fq 'thin Codex custom-prompt adapter' "$prompt_sample" || fail "sample custom prompt missing thin-adapter declaration"
grep -Fq 'ONE-MORE-THING: ask developer if something not sure' "$prompt_sample" || fail "sample custom prompt missing uncertainty guard"

prompt_harness_sample="$PROMPTS_DIR/HARNESS_diagnoseInstallation.md"
[[ -f "$prompt_harness_sample" ]] || fail "missing sample custom prompt: HARNESS_diagnoseInstallation.md"
grep -Fq 'slashCommands/commands/Px-HarnessKits/HARNESS_diagnoseInstallation.md' "$prompt_harness_sample" || fail "HARNESS sample custom prompt missing source command reference"

# Every skill name must satisfy the Codex / agent-skills naming rules.
while IFS= read -r skill_dir; do
  skill_name="$(basename "$skill_dir")"
  [[ "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid Codex skill name: $skill_name"
  [[ "${#skill_name}" -le 64 ]] || fail "Codex skill name too long: $skill_name"
  grep -Fq "name: $skill_name" "$skill_dir/SKILL.md" || fail "skill front matter name mismatch: $skill_name"
done < <(find "$OUT_DIR" -mindepth 1 -maxdepth 1 -type d | sort)

# Clean mode must remove previously generated wrappers.
"$GENERATOR" --output "$OUT_DIR" --prompts-output "$PROMPTS_DIR" --clean >/dev/null

echo "[makeSlashCmd4Codex-test] PASSED: generated $skill_count Codex skills and $prompt_count Codex custom prompts"
