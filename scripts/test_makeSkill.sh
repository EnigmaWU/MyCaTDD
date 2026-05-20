#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGER="$REPO_ROOT/agentSkill/makeSkill.sh"
SKILL_NAME="comment-alive-test-driven-development"
SOURCE_SKILL_DIR="$REPO_ROOT/agentSkill/$SKILL_NAME"
OUT_ROOT="$(mktemp -d)"

cleanup() {
  rm -rf "$OUT_ROOT"
}
trap cleanup EXIT

fail() {
  echo "[makeSkill-test] $*" >&2
  exit 1
}

[[ -x "$PACKAGER" ]] || fail "missing executable packager: agentSkill/makeSkill.sh"
git -C "$REPO_ROOT" check-ignore -q "agentSkill/dist/$SKILL_NAME/SKILL.md" || fail "generated agentSkill/dist package must be ignored in this source repo"

"$PACKAGER" --output "$OUT_ROOT"

PACKAGE_DIR="$OUT_ROOT/$SKILL_NAME"

[[ -f "$PACKAGE_DIR/SKILL.md" ]] || fail "missing packaged SKILL.md"
[[ -f "$PACKAGE_DIR/README.md" ]] || fail "missing packaged README.md"
[[ -f "$PACKAGE_DIR/references/README_UserGuide.md" ]] || fail "missing packaged user guide reference"
[[ -f "$PACKAGE_DIR/references/README_UserGuide_ZH.md" ]] || fail "missing packaged Chinese user guide reference"
[[ -f "$PACKAGE_DIR/references/CaTDD_methodPrompt.md" ]] || fail "missing packaged method prompt reference"
[[ -f "$PACKAGE_DIR/references/CaTDD_ImplTemplate.cxx" ]] || fail "missing packaged implementation template reference"
[[ ! -e "$PACKAGE_DIR/references/CaTDD-UserGuide-PPT.md" ]] || fail "packaged skill should use README_UserGuide.md instead of presentation reference"
[[ ! -e "$PACKAGE_DIR/references/CaTDD-UserGuide-PPT-ZH_CN.md" ]] || fail "packaged skill should use README_UserGuide_ZH.md instead of Chinese presentation reference"
grep -Fq 'CaTDD Standalone User Guide' "$PACKAGE_DIR/references/README_UserGuide.md" || fail "packaged user guide must come from methodPrompts standalone guide"
grep -Fq 'CaTDD 独立用户指南' "$PACKAGE_DIR/references/README_UserGuide_ZH.md" || fail "packaged Chinese user guide must come from methodPrompts standalone guide"
[[ -f "$PACKAGE_DIR/slashCommands/README.md" ]] || fail "missing packaged slashCommands README"
[[ -f "$PACKAGE_DIR/slashCommands/commands/P0-FuncTestsFlow/UT_designCatSkeleton.md" ]] || fail "missing packaged P0 slash command"

package_symlink_count="$(find "$PACKAGE_DIR" -type l | wc -l | tr -d '[:space:]')"
[[ "$package_symlink_count" == "0" ]] || fail "packaged skill must be self-contained, found $package_symlink_count symlinks"

[[ ! -e "$SOURCE_SKILL_DIR/slashCommands" ]] || fail "authored skill source must not expose slashCommands symlink"
if [[ -d "$SOURCE_SKILL_DIR/references" ]]; then
  source_reference_symlinks="$(find "$SOURCE_SKILL_DIR/references" -type l | wc -l | tr -d '[:space:]')"
  [[ "$source_reference_symlinks" == "0" ]] || fail "authored skill source must not expose reference symlinks"
fi

echo "[makeSkill-test] PASSED: generated self-contained skill package in $OUT_ROOT"