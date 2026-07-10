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

"$INSTALLER" --target "$TARGET_DIR" --clean-prompts --yes

verbose_output="$("$INSTALLER" --target "$TARGET_DIR" --clean-prompts --verbose --yes 2>&1)"
grep -Fq '[installCaTDD4Copilot] replace: .catdd/methodPrompts' <<< "$verbose_output" || fail "--verbose output missing replace operation trace"
grep -Fq '[installCaTDD4Copilot] patch: .gitignore' <<< "$verbose_output" || fail "--verbose output missing patch operation trace"

[[ -f "$TARGET_DIR/.catdd/methodPrompts/README.md" ]] || fail "missing installed methodPrompts"
[[ -f "$TARGET_DIR/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "missing installed slashCommands"
[[ ! -f "$TARGET_DIR/README_UbiLang.md" ]] || fail "README_UbiLang.md should not be installed at project root"
[[ ! -f "$TARGET_DIR/README_UbiLang_ZH.md" ]] || fail "README_UbiLang_ZH.md should not be installed at project root"
[[ -d "$TARGET_DIR/.catdd/spec/analyzedNews" ]] || fail "missing .catdd/spec/analyzedNews"
[[ -d "$TARGET_DIR/.catdd/spec/suspendUS" ]] || fail "missing .catdd/spec/suspendUS"
[[ -d "$TARGET_DIR/.catdd/spec/abortUS" ]] || fail "missing .catdd/spec/abortUS"
[[ -f "$TARGET_DIR/.github/instructions/catdd.instructions.md" ]] || fail "missing Copilot CaTDD instruction file"

source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | wc -l | tr -d '[:space:]')"
prompt_count="$(find "$TARGET_DIR/.github/prompts" -type f \( -name 'UT_*.prompt.md' -o -name 'SPEC_*.prompt.md' -o -name 'HARNESS_*.prompt.md' \) | wc -l | tr -d '[:space:]')"

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
grep -Fq '.github/prompts/HARNESS_*.prompt.md' "$instructions" || fail "instructions missing HARNESS prompt wrapper location"

spec_sample="$TARGET_DIR/.github/prompts/SPEC_openUserStory.prompt.md"
[[ -f "$spec_sample" ]] || fail "missing installed SPEC sample prompt"
grep -Fq '.catdd/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md' "$spec_sample" || fail "SPEC sample prompt does not point to installed slashCommands"

harness_sample="$TARGET_DIR/.github/prompts/HARNESS_patchCaTDDSource.prompt.md"
[[ -f "$harness_sample" ]] || fail "missing installed HARNESS sample prompt"
grep -Fq '.catdd/slashCommands/commands/Px-HarnessKits/HARNESS_patchCaTDDSource.md' "$harness_sample" || fail "HARNESS sample prompt does not point to installed slashCommands"
grep -Fq '.catdd/methodPrompts/README.md' "$harness_sample" || fail "HARNESS sample prompt does not point to installed methodPrompts"

for command_name in SPEC_importIssue SPEC_importFeature SPEC_importUserStory SPEC_analyzeIssue SPEC_analyzeFeature; do
  command_prompt="$TARGET_DIR/.github/prompts/${command_name}.prompt.md"
  [[ -f "$command_prompt" ]] || fail "missing installed prompt: ${command_name}.prompt.md"
  grep -Fq ".catdd/slashCommands/commands/Px-SpecFlow/${command_name}.md" "$command_prompt" || fail "${command_name} prompt does not point to installed slashCommands"
done

[[ ! -e "$TARGET_DIR/.github/prompts/SPEC_importWorkItem.prompt.md" ]] || fail "old SPEC_importWorkItem prompt should not be installed"
[[ ! -e "$TARGET_DIR/.github/prompts/SPEC_analyzeWorkItem.prompt.md" ]] || fail "old SPEC_analyzeWorkItem prompt should not be installed"

install_marker="$TARGET_DIR/.catdd/CaTDD_INSTALL.md"
grep -Eq '^- Installed version: ([0-9]{8}\.[0-9]{2}|unknown)$' "$install_marker" || fail "install marker missing version line in YYYYMMDD.HH format"

# Verify replacement detection: re-running installer on same target reports same-version replacement
replacement_output="$("$INSTALLER" --target "$TARGET_DIR" --clean-prompts --yes 2>&1)"
grep -Fq '] version:' <<< "$replacement_output" || fail "installer missing version action output on reinstall"
grep -Fq '(same version, replacement)' <<< "$replacement_output" || fail "reinstall should report same-version replacement"

init_target="$TARGET_DIR/new-project"
"$INSTALLER" --target "$init_target" --init --clean-prompts --yes

[[ -f "$init_target/.catdd/methodPrompts/README.md" ]] || fail "--init target missing installed methodPrompts"
[[ -f "$init_target/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "--init target missing installed slashCommands"
[[ ! -f "$init_target/README_UbiLang.md" ]] || fail "--init target should not install project-root README_UbiLang.md"
[[ ! -f "$init_target/README_UbiLang_ZH.md" ]] || fail "--init target should not install project-root README_UbiLang_ZH.md"
[[ -d "$init_target/.catdd/spec/analyzedNews" ]] || fail "--init target missing .catdd/spec/analyzedNews"
[[ -d "$init_target/.catdd/spec/suspendUS" ]] || fail "--init target missing .catdd/spec/suspendUS"
[[ -f "$init_target/.github/prompts/UT_convertDemoToTypical.prompt.md" ]] || fail "--init target missing generated Copilot prompt"
[[ -f "$init_target/.github/prompts/SPEC_openUserStory.prompt.md" ]] || fail "--init target missing generated SPEC Copilot prompt"
[[ -f "$init_target/.github/prompts/HARNESS_patchCaTDDSource.prompt.md" ]] || fail "--init target missing generated HARNESS Copilot prompt"
[[ -f "$init_target/.github/prompts/SPEC_importIssue.prompt.md" ]] || fail "--init target missing generated SPEC import issue prompt"
[[ -f "$init_target/.github/prompts/SPEC_importUserStory.prompt.md" ]] || fail "--init target missing generated SPEC import user story prompt"

echo "[installCaTDD4Copilot-test] PASSED: installed CaTDD Copilot assets into temporary target"
