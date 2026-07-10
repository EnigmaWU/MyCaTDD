#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALLER="$REPO_ROOT/scripts/installCaTDD4Cline.sh"
TARGET_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

fail() {
  echo "[installCaTDD4Cline-test] $*" >&2
  exit 1
}

[[ -x "$INSTALLER" ]] || fail "missing executable installer: scripts/installCaTDD4Cline.sh"

git -C "$REPO_ROOT" check-ignore -q .clinerules/catdd.md || fail "generated Cline rule must be ignored in this source repo"

"$INSTALLER" --target "$TARGET_DIR" --yes

verbose_output="$("$INSTALLER" --target "$TARGET_DIR" --verbose --yes 2>&1)"
grep -Fq '[installCaTDD4Cline] replace: .catdd/methodPrompts' <<< "$verbose_output" || fail "--verbose output missing replace operation trace"
grep -Fq '[installCaTDD4Cline] patch: .gitignore' <<< "$verbose_output" || fail "--verbose output missing patch operation trace"

[[ -f "$TARGET_DIR/.catdd/methodPrompts/README.md" ]] || fail "missing installed methodPrompts"
[[ -f "$TARGET_DIR/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "missing installed slashCommands"
[[ ! -f "$TARGET_DIR/README_UbiLang.md" ]] || fail "README_UbiLang.md should not be installed at project root"
[[ ! -f "$TARGET_DIR/README_UbiLang_ZH.md" ]] || fail "README_UbiLang_ZH.md should not be installed at project root"
[[ -d "$TARGET_DIR/.catdd/spec/pendingNews" ]] || fail "missing .catdd/spec/pendingNews"
[[ -d "$TARGET_DIR/.catdd/spec/analyzedNews" ]] || fail "missing .catdd/spec/analyzedNews"
[[ -d "$TARGET_DIR/.catdd/spec/todoUS" ]] || fail "missing .catdd/spec/todoUS"
[[ -d "$TARGET_DIR/.catdd/spec/doingUS" ]] || fail "missing .catdd/spec/doingUS"
[[ -d "$TARGET_DIR/.catdd/spec/suspendUS" ]] || fail "missing .catdd/spec/suspendUS"
[[ -d "$TARGET_DIR/.catdd/spec/abortUS" ]] || fail "missing .catdd/spec/abortUS"
[[ -d "$TARGET_DIR/.catdd/spec/doneUS" ]] || fail "missing .catdd/spec/doneUS"

rule="$TARGET_DIR/.clinerules/catdd.md"
[[ -f "$rule" ]] || fail "missing Cline CaTDD rule"
grep -Fq 'Cline project rule' "$rule" || fail "Cline rule missing adapter identity"
grep -Fq '.catdd/methodPrompts/' "$rule" || fail "Cline rule missing methodPrompts location"
grep -Fq '.catdd/slashCommands/' "$rule" || fail "Cline rule missing slashCommands location"
grep -Fq '.catdd/spec/' "$rule" || fail "Cline rule missing spec workspace location"
grep -Fq 'README_ArchDesign.md' "$rule" || fail "Cline rule missing project-root README SPEC docs"
grep -Fq 'README_ErrorDesign.md' "$rule" || fail "Cline rule missing error design README SPEC doc"
grep -Fq 'README_ResourceDesign.md' "$rule" || fail "Cline rule missing resource design README SPEC doc"
grep -Fq 'README_StateDesign.md' "$rule" || fail "Cline rule missing state design README SPEC doc"
grep -Fq 'README_PerfDesign.md' "$rule" || fail "Cline rule missing performance design README SPEC doc"
grep -Fq 'README_CompatDesign.md' "$rule" || fail "Cline rule missing compatibility design README SPEC doc"
grep -Fq 'README_DiagnosisDesign.md' "$rule" || fail "Cline rule missing diagnosis design README SPEC doc"
grep -Fq 'SPEC_importIssue' "$rule" || fail "Cline rule missing SPEC command guidance"
grep -Fq 'SPEC_importUserStory' "$rule" || fail "Cline rule missing user-story import guidance"
grep -Fq 'UT_*, SPEC_*, and HARNESS_* commands' "$rule" || fail "Cline rule missing command family guidance"

install_marker="$TARGET_DIR/.catdd/CaTDD_INSTALL.md"
[[ -f "$install_marker" ]] || fail "missing install marker"
grep -Fq 'Cline project rule: `.clinerules/catdd.md`' "$install_marker" || fail "install marker missing Cline rule location"
grep -Fq 'analyzedNews/' "$install_marker" || fail "install marker missing analyzedNews shared artifact guidance"
grep -Eq '^- Installed version: ([0-9]{8}\.[0-9]{2}|unknown)$' "$install_marker" || fail "install marker missing version line in YYYYMMDD.HH format"

# Verify replacement detection: re-running installer on same target reports same-version replacement
replacement_output="$("$INSTALLER" --target "$TARGET_DIR" --yes 2>&1)"
grep -Fq '] version:' <<< "$replacement_output" || fail "installer missing version action output on reinstall"
grep -Fq '(same version, replacement)' <<< "$replacement_output" || fail "reinstall should report same-version replacement"

target_gitignore="$TARGET_DIR/.gitignore"
! grep -Fq '/.catdd/spec/doingUS/' "$target_gitignore" || fail "target .gitignore must not ignore doingUS team-shared state"
grep -Fq '/.catdd/spec/WorkingProcessLog.md' "$target_gitignore" || fail "target .gitignore missing WorkingProcessLog local-state rule"

init_target="$TARGET_DIR/new-cline-project"
"$INSTALLER" --target "$init_target" --init --yes

[[ -f "$init_target/.catdd/methodPrompts/README.md" ]] || fail "--init target missing installed methodPrompts"
[[ ! -f "$init_target/README_UbiLang.md" ]] || fail "--init target should not install project-root README_UbiLang.md"
[[ ! -f "$init_target/README_UbiLang_ZH.md" ]] || fail "--init target should not install project-root README_UbiLang_ZH.md"
[[ -d "$init_target/.catdd/spec/analyzedNews" ]] || fail "--init target missing .catdd/spec/analyzedNews"
[[ -d "$init_target/.catdd/spec/suspendUS" ]] || fail "--init target missing .catdd/spec/suspendUS"
[[ -f "$init_target/.clinerules/catdd.md" ]] || fail "--init target missing Cline rule"

# Verify generated Cline Skills
skills_dir="$TARGET_DIR/.cline/skills"
[[ -d "$skills_dir" ]] || fail "missing .cline/skills directory"
[[ -d "$skills_dir/spec-import-issue" ]] || fail "missing spec-import-issue skill"
[[ -d "$skills_dir/ut-design-typical-skeleton" ]] || fail "missing ut-design-typical-skeleton skill"
[[ -d "$skills_dir/harness-patch-ca-tdd-source" ]] || fail "missing harness-patch-ca-tdd-source skill"
[[ -f "$skills_dir/spec-import-issue/SKILL.md" ]] || fail "missing SKILL.md in spec-import-issue skill"
grep -Fq 'name: spec-import-issue' "$skills_dir/spec-import-issue/SKILL.md" || fail "SKILL.md missing command name"
grep -Fq 'description: Import an issue' "$skills_dir/spec-import-issue/SKILL.md" || fail "SKILL.md missing meaningful description"
grep -Fq 'slashCommands/commands/Px-SpecFlow/SPEC_importIssue.md' "$skills_dir/spec-import-issue/SKILL.md" || fail "SKILL.md missing source command reference"
grep -Fq '.catdd/slashCommands/commands/' "$skills_dir/spec-import-issue/SKILL.md" || fail "SKILL.md missing .catdd path reference"
grep -Fq 'slashCommands/commands/Px-HarnessKits/HARNESS_patchCaTDDSource.md' "$skills_dir/harness-patch-ca-tdd-source/SKILL.md" || fail "HARNESS SKILL.md missing source command reference"
# Count skill directories (one per portable command) - top-level dirs minus 1 for . entry
skill_count=$(find "$skills_dir" -maxdepth 1 -mindepth 1 -type d | wc -l)
[[ "$skill_count" -ge 40 ]] || fail "expected at least 40 skill directories, got $skill_count"

# Verify --clean-prompts works (triggers generator with --clean)
clean_output="$("$INSTALLER" --target "$TARGET_DIR" --clean-prompts --yes 2>&1)"
source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | wc -l | tr -d '[:space:]')"
expected_wrappers="Generated ${source_count} Cline Skill wrappers"
grep -Fq "$expected_wrappers" <<< "$clean_output" || fail "--clean-prompts did not trigger skills generation"

echo "[installCaTDD4Cline-test] PASSED: installed CaTDD Cline assets into temporary target"
