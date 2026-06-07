#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALLER="$REPO_ROOT/scripts/installCaTDD4Continue.sh"
TARGET_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

fail() {
  echo "[installCaTDD4Continue-test] $*" >&2
  exit 1
}

[[ -x "$INSTALLER" ]] || fail "missing executable installer: scripts/installCaTDD4Continue.sh"

git -C "$REPO_ROOT" check-ignore -q .continue/rules/catdd.md || fail "generated Continue rule must be ignored in this source repo"
git -C "$REPO_ROOT" check-ignore -q .continue/prompts/UT_example.prompt || fail "generated Continue UT prompt wrappers must be ignored in this source repo"
git -C "$REPO_ROOT" check-ignore -q .continue/prompts/SPEC_example.prompt || fail "generated Continue SPEC prompt wrappers must be ignored in this source repo"

"$INSTALLER" --target "$TARGET_DIR" --yes

verbose_output="$("$INSTALLER" --target "$TARGET_DIR" --verbose --yes 2>&1)"
grep -Fq '[installCaTDD4Continue] replace: .catdd/methodPrompts' <<< "$verbose_output" || fail "--verbose output missing replace operation trace"
grep -Fq '[installCaTDD4Continue] patch: .gitignore' <<< "$verbose_output" || fail "--verbose output missing patch operation trace"

[[ -f "$TARGET_DIR/.catdd/methodPrompts/README.md" ]] || fail "missing installed methodPrompts"
[[ -f "$TARGET_DIR/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "missing installed slashCommands"
[[ -d "$TARGET_DIR/.catdd/spec/pendingNews" ]] || fail "missing .catdd/spec/pendingNews"
[[ -d "$TARGET_DIR/.catdd/spec/analyzedNews" ]] || fail "missing .catdd/spec/analyzedNews"
[[ -d "$TARGET_DIR/.catdd/spec/todoUS" ]] || fail "missing .catdd/spec/todoUS"
[[ -d "$TARGET_DIR/.catdd/spec/doingUS" ]] || fail "missing .catdd/spec/doingUS"
[[ -d "$TARGET_DIR/.catdd/spec/doneUS" ]] || fail "missing .catdd/spec/doneUS"

rule="$TARGET_DIR/.continue/rules/catdd.md"
[[ -f "$rule" ]] || fail "missing Continue CaTDD rule"
grep -Fq 'Continue project rule' "$rule" || fail "Continue rule missing adapter identity"
grep -Fq '.catdd/methodPrompts/' "$rule" || fail "Continue rule missing methodPrompts location"
grep -Fq '.catdd/slashCommands/' "$rule" || fail "Continue rule missing slashCommands location"
grep -Fq '.catdd/spec/' "$rule" || fail "Continue rule missing spec workspace location"
grep -Fq 'README_ArchDesign.md' "$rule" || fail "Continue rule missing project-root README SPEC docs"
grep -Fq 'README_ErrorDesign.md' "$rule" || fail "Continue rule missing error design README SPEC doc"
grep -Fq 'README_ResourceDesign.md' "$rule" || fail "Continue rule missing resource design README SPEC doc"
grep -Fq 'README_StateDesign.md' "$rule" || fail "Continue rule missing state design README SPEC doc"
grep -Fq 'README_PerfDesign.md' "$rule" || fail "Continue rule missing performance design README SPEC doc"
grep -Fq 'README_CompatDesign.md' "$rule" || fail "Continue rule missing compatibility design README SPEC doc"
grep -Fq 'README_DiagnosisDesign.md' "$rule" || fail "Continue rule missing diagnosis design README SPEC doc"
grep -Fq 'SPEC_importIssue' "$rule" || fail "Continue rule missing SPEC command guidance"
grep -Fq 'SPEC_importUserStory' "$rule" || fail "Continue rule missing user-story import guidance"
grep -Fq 'UT_* and SPEC_* commands' "$rule" || fail "Continue rule missing command family guidance"

source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' \) | wc -l | tr -d '[:space:]')"
prompt_count="$(find "$TARGET_DIR/.continue/prompts" -type f \( -name 'UT_*.prompt' -o -name 'SPEC_*.prompt' \) | wc -l | tr -d '[:space:]')"
[[ "$prompt_count" == "$source_count" ]] || fail "expected $source_count Continue prompt wrappers, got $prompt_count"

sample_prompt="$TARGET_DIR/.continue/prompts/UT_convertDemoToTypical.prompt"
[[ -f "$sample_prompt" ]] || fail "missing Continue sample prompt: UT_convertDemoToTypical.prompt"
grep -Fq 'name: UT_convertDemoToTypical' "$sample_prompt" || fail "Continue sample prompt missing command name"
grep -Fq 'description: Run CaTDD slash command UT_convertDemoToTypical' "$sample_prompt" || fail "Continue sample prompt missing description"
grep -Fq '.catdd/slashCommands/commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md' "$sample_prompt" || fail "Continue sample prompt missing installed source command reference"
grep -Fq '.catdd/methodPrompts/README.md' "$sample_prompt" || fail "Continue sample prompt missing installed method source reference"
grep -Fq 'ONE-MORE-THING: ask developer if something not sure' "$sample_prompt" || fail "Continue sample prompt missing uncertainty guard"

spec_prompt="$TARGET_DIR/.continue/prompts/SPEC_openUserStory.prompt"
[[ -f "$spec_prompt" ]] || fail "missing Continue SPEC prompt: SPEC_openUserStory.prompt"
grep -Fq 'name: SPEC_openUserStory' "$spec_prompt" || fail "Continue SPEC prompt missing command name"
grep -Fq '.catdd/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md' "$spec_prompt" || fail "Continue SPEC prompt missing installed source command reference"

install_marker="$TARGET_DIR/.catdd/CaTDD_INSTALL.md"
[[ -f "$install_marker" ]] || fail "missing install marker"
grep -Fq 'Continue project rule: `.continue/rules/catdd.md`' "$install_marker" || fail "install marker missing Continue rule location"
grep -Fq 'Continue prompt wrappers: `.continue/prompts/UT_*.prompt` and `.continue/prompts/SPEC_*.prompt`' "$install_marker" || fail "install marker missing Continue prompt wrapper location"
grep -Fq 'analyzedNews/' "$install_marker" || fail "install marker missing analyzedNews shared artifact guidance"
grep -Eq '^- Installed version: ([0-9]{8}\.[0-9]{2}|unknown)$' "$install_marker" || fail "install marker missing version line in YYYYMMDD.HH format"

# Verify replacement detection: re-running installer on same target reports same-version replacement
replacement_output="$("$INSTALLER" --target "$TARGET_DIR" --yes 2>&1)"
grep -Fq '] version:' <<< "$replacement_output" || fail "installer missing version action output on reinstall"
grep -Fq '(same version, replacement)' <<< "$replacement_output" || fail "reinstall should report same-version replacement"

target_gitignore="$TARGET_DIR/.gitignore"
! grep -Fq '/.catdd/spec/doingUS/' "$target_gitignore" || fail "target .gitignore must not ignore doingUS team-shared state"
grep -Fq '/.catdd/spec/WorkingProcessLog.md' "$target_gitignore" || fail "target .gitignore missing WorkingProcessLog local-state rule"

init_target="$TARGET_DIR/new-continue-project"
"$INSTALLER" --target "$init_target" --init --yes

[[ -f "$init_target/.catdd/methodPrompts/README.md" ]] || fail "--init target missing installed methodPrompts"
[[ -d "$init_target/.catdd/spec/analyzedNews" ]] || fail "--init target missing .catdd/spec/analyzedNews"
[[ -f "$init_target/.continue/rules/catdd.md" ]] || fail "--init target missing Continue rule"
[[ -f "$init_target/.continue/prompts/UT_convertDemoToTypical.prompt" ]] || fail "--init target missing Continue prompt wrapper"

echo "[installCaTDD4Continue-test] PASSED: installed CaTDD Continue assets into temporary target"
