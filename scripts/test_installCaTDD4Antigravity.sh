#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALLER="$REPO_ROOT/scripts/installCaTDD4Antigravity.sh"
TARGET_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

fail() {
  echo "[installCaTDD4Antigravity-test] $*" >&2
  exit 1
}

[[ -x "$INSTALLER" ]] || fail "missing executable installer: scripts/installCaTDD4Antigravity.sh"

git -C "$REPO_ROOT" check-ignore -q .antigravityrules/catdd.md || fail "generated Antigravity rule must be ignored in this source repo"

"$INSTALLER" --target "$TARGET_DIR"

verbose_output="$("$INSTALLER" --target "$TARGET_DIR" --verbose 2>&1)"
grep -Fq '[installCaTDD4Antigravity] replace: .catdd/methodPrompts' <<< "$verbose_output" || fail "--verbose output missing replace operation trace"
grep -Fq '[installCaTDD4Antigravity] patch: .gitignore' <<< "$verbose_output" || fail "--verbose output missing patch operation trace"

[[ -f "$TARGET_DIR/.catdd/methodPrompts/README.md" ]] || fail "missing installed methodPrompts"
[[ -f "$TARGET_DIR/.catdd/slashCommands/UT_slashCommandTemplate.md" ]] || fail "missing installed slashCommands"
[[ -d "$TARGET_DIR/.catdd/spec/pendingNews" ]] || fail "missing .catdd/spec/pendingNews"
[[ -d "$TARGET_DIR/.catdd/spec/analyzedNews" ]] || fail "missing .catdd/spec/analyzedNews"
[[ -d "$TARGET_DIR/.catdd/spec/todoUS" ]] || fail "missing .catdd/spec/todoUS"
[[ -d "$TARGET_DIR/.catdd/spec/doingUS" ]] || fail "missing .catdd/spec/doingUS"
[[ -d "$TARGET_DIR/.catdd/spec/doneUS" ]] || fail "missing .catdd/spec/doneUS"

# Verify Antigravity rule
rule="$TARGET_DIR/.antigravityrules/catdd.md"
[[ -f "$rule" ]] || fail "missing Antigravity CaTDD rule"
grep -Fq 'Antigravity project rule' "$rule" || fail "Antigravity rule missing adapter identity"
grep -Fq '.catdd/methodPrompts/' "$rule" || fail "Antigravity rule missing methodPrompts location"
grep -Fq '.catdd/slashCommands/' "$rule" || fail "Antigravity rule missing slashCommands location"
grep -Fq '.catdd/spec/' "$rule" || fail "Antigravity rule missing spec workspace location"
grep -Fq 'README_ArchDesign.md' "$rule" || fail "Antigravity rule missing project-root README SPEC docs"

install_marker="$TARGET_DIR/.catdd/CaTDD_INSTALL.md"
[[ -f "$install_marker" ]] || fail "missing install marker"
grep -Fq 'Antigravity project rule: `.antigravityrules/catdd.md`' "$install_marker" || fail "install marker missing Antigravity rule location"
grep -Fq 'analyzedNews/' "$install_marker" || fail "install marker missing analyzedNews shared artifact guidance"
grep -Eq '^- Installed version: ([0-9]{8}\.[0-9]{2}|unknown)$' "$install_marker" || fail "install marker missing version line in YYYYMMDD.HH format"

# Verify replacement detection: re-running installer on same target reports same-version replacement
replacement_output="$("$INSTALLER" --target "$TARGET_DIR" 2>&1)"
grep -Fq '] version:' <<< "$replacement_output" || fail "installer missing version action output on reinstall"
grep -Fq '(same version, replacement)' <<< "$replacement_output" || fail "reinstall should report same-version replacement"

target_gitignore="$TARGET_DIR/.gitignore"
! grep -Fq '/.catdd/spec/doingUS/' "$target_gitignore" || fail "target .gitignore must not ignore doingUS team-shared state"
grep -Fq '/.catdd/spec/WorkingProcessLog.md' "$target_gitignore" || fail "target .gitignore missing WorkingProcessLog local-state rule"

init_target="$TARGET_DIR/new-antigravity-project"
"$INSTALLER" --target "$init_target" --init

[[ -f "$init_target/.catdd/methodPrompts/README.md" ]] || fail "--init target missing installed methodPrompts"
[[ -d "$init_target/.catdd/spec/analyzedNews" ]] || fail "--init target missing .catdd/spec/analyzedNews"
[[ -f "$init_target/.antigravityrules/catdd.md" ]] || fail "--init target missing Antigravity rule"

echo "[installCaTDD4Antigravity-test] PASSED: installed CaTDD Antigravity assets into temporary target"
