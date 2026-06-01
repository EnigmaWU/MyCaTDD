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

"$INSTALLER" --target "$TARGET_DIR"

verbose_output="$("$INSTALLER" --target "$TARGET_DIR" --verbose 2>&1)"
grep -Fq '+ mkdir -p ' <<< "$verbose_output" || fail "--verbose output missing detailed action trace"

[[ -f "$TARGET_DIR/.catdd/methodPrompts/README.md" ]] || fail "missing installed methodPrompts"
[[ -f "$TARGET_DIR/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "missing installed slashCommands"
[[ -d "$TARGET_DIR/.catdd/spec/pendingNews" ]] || fail "missing .catdd/spec/pendingNews"
[[ -d "$TARGET_DIR/.catdd/spec/analyzedNews" ]] || fail "missing .catdd/spec/analyzedNews"
[[ -d "$TARGET_DIR/.catdd/spec/todoUS" ]] || fail "missing .catdd/spec/todoUS"
[[ -d "$TARGET_DIR/.catdd/spec/doingUS" ]] || fail "missing .catdd/spec/doingUS"
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
grep -Fq 'UT_* and SPEC_* commands' "$rule" || fail "Cline rule missing command family guidance"

install_marker="$TARGET_DIR/.catdd/CaTDD_INSTALL.md"
[[ -f "$install_marker" ]] || fail "missing install marker"
grep -Fq 'Cline project rule: `.clinerules/catdd.md`' "$install_marker" || fail "install marker missing Cline rule location"
grep -Fq 'analyzedNews/' "$install_marker" || fail "install marker missing analyzedNews shared artifact guidance"

target_gitignore="$TARGET_DIR/.gitignore"
! grep -Fq '/.catdd/spec/doingUS/' "$target_gitignore" || fail "target .gitignore must not ignore doingUS team-shared state"
grep -Fq '/.catdd/spec/WorkingProcessLog.md' "$target_gitignore" || fail "target .gitignore missing WorkingProcessLog local-state rule"

init_target="$TARGET_DIR/new-cline-project"
"$INSTALLER" --target "$init_target" --init

[[ -f "$init_target/.catdd/methodPrompts/README.md" ]] || fail "--init target missing installed methodPrompts"
[[ -d "$init_target/.catdd/spec/analyzedNews" ]] || fail "--init target missing .catdd/spec/analyzedNews"
[[ -f "$init_target/.clinerules/catdd.md" ]] || fail "--init target missing Cline rule"

echo "[installCaTDD4Cline-test] PASSED: installed CaTDD Cline assets into temporary target"