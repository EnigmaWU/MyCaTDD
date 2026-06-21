#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALLER="$REPO_ROOT/scripts/installCaTDD4Custom.sh"
TARGET_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

fail() {
  echo "[installCaTDD4Custom-test] $*" >&2
  exit 1
}

[[ -x "$INSTALLER" ]] || fail "missing executable installer: scripts/installCaTDD4Custom.sh"

git -C "$REPO_ROOT" check-ignore -q .customCodeAgent/rules/catdd.md || fail "generated default custom rule must be ignored in this source repo"
git -C "$REPO_ROOT" check-ignore -q .customCodeAgent/prompts/UT_example.prompt || fail "generated default custom UT prompt wrappers must be ignored in this source repo"
git -C "$REPO_ROOT" check-ignore -q .customCodeAgent/prompts/SPEC_example.prompt || fail "generated default custom SPEC prompt wrappers must be ignored in this source repo"

"$INSTALLER" --target "$TARGET_DIR" --yes

verbose_output="$("$INSTALLER" --target "$TARGET_DIR" --verbose --yes 2>&1)"
grep -Fq '[installCaTDD4Custom] replace: .catdd/methodPrompts' <<< "$verbose_output" || fail "--verbose output missing replace operation trace"
grep -Fq '[installCaTDD4Custom] patch: .gitignore' <<< "$verbose_output" || fail "--verbose output missing patch operation trace"

[[ -f "$TARGET_DIR/.catdd/methodPrompts/README.md" ]] || fail "missing installed methodPrompts"
[[ -f "$TARGET_DIR/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "missing installed slashCommands"
[[ -f "$TARGET_DIR/README_UbiLang.md" ]] || fail "missing installed project-root README_UbiLang.md"
[[ -f "$TARGET_DIR/README_UbiLang_ZH.md" ]] || fail "missing installed project-root README_UbiLang_ZH.md"
[[ -d "$TARGET_DIR/.catdd/spec/pendingNews" ]] || fail "missing .catdd/spec/pendingNews"
[[ -d "$TARGET_DIR/.catdd/spec/analyzedNews" ]] || fail "missing .catdd/spec/analyzedNews"
[[ -d "$TARGET_DIR/.catdd/spec/todoUS" ]] || fail "missing .catdd/spec/todoUS"
[[ -d "$TARGET_DIR/.catdd/spec/doingUS" ]] || fail "missing .catdd/spec/doingUS"
[[ -d "$TARGET_DIR/.catdd/spec/abortUS" ]] || fail "missing .catdd/spec/abortUS"
[[ -d "$TARGET_DIR/.catdd/spec/doneUS" ]] || fail "missing .catdd/spec/doneUS"

rule="$TARGET_DIR/.customCodeAgent/rules/catdd.md"
[[ -f "$rule" ]] || fail "missing default custom CaTDD rule"
grep -Fq 'custom project rule' "$rule" || fail "custom rule missing adapter identity"
grep -Fq '.catdd/methodPrompts/' "$rule" || fail "custom rule missing methodPrompts location"
grep -Fq '.catdd/slashCommands/' "$rule" || fail "custom rule missing slashCommands location"
grep -Fq '.customCodeAgent/prompts/' "$rule" || fail "custom rule missing custom prompt location"
grep -Fq '.catdd/spec/' "$rule" || fail "custom rule missing spec workspace location"
grep -Fq 'SPEC_importUserStory' "$rule" || fail "custom rule missing user-story import guidance"

source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' \) | wc -l | tr -d '[:space:]')"
prompt_count="$(find "$TARGET_DIR/.customCodeAgent/prompts" -type f \( -name 'UT_*.prompt' -o -name 'SPEC_*.prompt' \) | wc -l | tr -d '[:space:]')"
[[ "$prompt_count" == "$source_count" ]] || fail "expected $source_count custom prompt wrappers, got $prompt_count"

sample_prompt="$TARGET_DIR/.customCodeAgent/prompts/UT_convertDemoToTypical.prompt"
[[ -f "$sample_prompt" ]] || fail "missing custom sample prompt: UT_convertDemoToTypical.prompt"
grep -Fq 'name: UT_convertDemoToTypical' "$sample_prompt" || fail "custom sample prompt missing command name"
grep -Fq 'description: Run CaTDD slash command UT_convertDemoToTypical' "$sample_prompt" || fail "custom sample prompt missing description"
grep -Fq '.catdd/slashCommands/commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md' "$sample_prompt" || fail "custom sample prompt missing installed source command reference"
grep -Fq '.catdd/methodPrompts/README.md' "$sample_prompt" || fail "custom sample prompt missing installed method source reference"

install_marker="$TARGET_DIR/.catdd/CaTDD_INSTALL.md"
[[ -f "$install_marker" ]] || fail "missing install marker"
grep -Fq 'Custom project rule: `.customCodeAgent/rules/catdd.md`' "$install_marker" || fail "install marker missing custom rule location"
grep -Fq 'Continue-format prompt wrappers: `.customCodeAgent/prompts/UT_*.prompt` and `.customCodeAgent/prompts/SPEC_*.prompt`' "$install_marker" || fail "install marker missing custom prompt wrapper location"
grep -Eq '^- Installed version: ([0-9]{8}\.[0-9]{2}|unknown)$' "$install_marker" || fail "install marker missing version line in YYYYMMDD.HH format"

replacement_output="$("$INSTALLER" --target "$TARGET_DIR" --yes 2>&1)"
grep -Fq '] version:' <<< "$replacement_output" || fail "installer missing version action output on reinstall"
grep -Fq '(same version, replacement)' <<< "$replacement_output" || fail "reinstall should report same-version replacement"

custom_target="$TARGET_DIR/custom-dir-target"
"$INSTALLER" --target "$custom_target" --custom-dir .myagent --init --yes
[[ -f "$custom_target/README_UbiLang.md" ]] || fail "--custom-dir target missing installed project-root README_UbiLang.md"
[[ -f "$custom_target/README_UbiLang_ZH.md" ]] || fail "--custom-dir target missing installed project-root README_UbiLang_ZH.md"
[[ -f "$custom_target/.myagent/rules/catdd.md" ]] || fail "--custom-dir target missing custom rule"
[[ -f "$custom_target/.myagent/prompts/UT_convertDemoToTypical.prompt" ]] || fail "--custom-dir target missing custom prompt wrapper"

if "$INSTALLER" --target "$TARGET_DIR" --custom-dir .bad/name --yes >/dev/null 2>&1; then
  fail "--custom-dir with slash should fail"
fi

echo "[installCaTDD4Custom-test] PASSED: installed CaTDD custom assets into temporary target"
