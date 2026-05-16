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

"$GENERATOR" --output "$OUT_DIR" --clean

source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f -name 'UT_*.md' | wc -l | tr -d '[:space:]')"
prompt_count="$(find "$OUT_DIR" -type f -name 'UT_*.prompt.md' | wc -l | tr -d '[:space:]')"

[[ "$source_count" -gt 0 ]] || fail "expected at least one portable slash command source"
[[ "$prompt_count" == "$source_count" ]] || fail "expected $source_count generated prompts, got $prompt_count"

sample="$OUT_DIR/UT_convertDemoToTypical.prompt.md"
[[ -f "$sample" ]] || fail "missing sample prompt: UT_convertDemoToTypical.prompt.md"

grep -Fq 'description: "Run CaTDD slash command UT_convertDemoToTypical"' "$sample" || fail "sample prompt missing Copilot description"
grep -Fq 'agent: "agent"' "$sample" || fail "sample prompt missing Copilot agent mode"
grep -Fq 'slashCommands/commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md' "$sample" || fail "sample prompt missing source command reference"
grep -Fq 'methodPrompts' "$sample" || fail "sample prompt missing methodPrompts source-of-truth reference"
grep -Fq 'ONE-MORE-THING: ask developer if something not sure' "$sample" || fail "sample prompt missing uncertainty guard"

echo "[makeSlashCmd4Copilot-test] PASSED: generated $prompt_count Copilot prompt wrappers"