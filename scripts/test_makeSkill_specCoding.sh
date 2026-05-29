#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGER="$REPO_ROOT/agentSkills/makeSkill.sh"
SKILL_NAME="user-story-centered-spec-coding"
SOURCE_SKILL_DIR="$REPO_ROOT/agentSkills/$SKILL_NAME"
OUT_ROOT="$(mktemp -d)"

cleanup() {
  rm -rf "$OUT_ROOT"
}
trap cleanup EXIT

fail() {
  echo "[makeSkill-specCoding-test] $*" >&2
  exit 1
}

[[ -x "$PACKAGER" ]] || fail "missing executable packager: agentSkills/makeSkill.sh"
[[ -f "$SOURCE_SKILL_DIR/SKILL.md" ]] || fail "missing authored SpecCoding SKILL.md"
[[ -f "$SOURCE_SKILL_DIR/README.md" ]] || fail "missing authored SpecCoding README.md"
git -C "$REPO_ROOT" check-ignore -q "agentSkills/dist/$SKILL_NAME/SKILL.md" || fail "generated SpecCoding dist package must be ignored in this source repo"

"$PACKAGER" "$SKILL_NAME" --output "$OUT_ROOT"

PACKAGE_DIR="$OUT_ROOT/$SKILL_NAME"

[[ -f "$PACKAGE_DIR/SKILL.md" ]] || fail "missing packaged SpecCoding SKILL.md"
[[ -f "$PACKAGE_DIR/README.md" ]] || fail "missing packaged SpecCoding README.md"
[[ -f "$PACKAGE_DIR/references/README_UserGuide.md" ]] || fail "missing packaged CaTDD method user guide reference"
[[ -f "$PACKAGE_DIR/references/README_UserGuide_ZH.md" ]] || fail "missing packaged Chinese CaTDD method user guide reference"
[[ -f "$PACKAGE_DIR/references/CaTDD_methodPrompt.md" ]] || fail "missing packaged CaTDD method prompt reference"
[[ -f "$PACKAGE_DIR/slashCommands/README_UserGuide.md" ]] || fail "missing packaged slashCommands user guide"
[[ -f "$PACKAGE_DIR/slashCommands/flows/Px-SpecFlow.md" ]] || fail "missing packaged Px-SpecFlow flow"
[[ -f "$PACKAGE_DIR/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md" ]] || fail "missing packaged SPEC_openUserStory command"
[[ -f "$PACKAGE_DIR/slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md" ]] || fail "missing packaged SPEC_closeUserStory command"
[[ -f "$PACKAGE_DIR/slashCommands/templates/README_DetailDesignTemplate.md" ]] || fail "missing packaged detail design README SPEC template"
[[ -f "$PACKAGE_DIR/slashCommands/templates/README_ErrorDesignTemplate.md" ]] || fail "missing packaged error design README SPEC template"
[[ -f "$PACKAGE_DIR/slashCommands/templates/README_ResourceDesignTemplate.md" ]] || fail "missing packaged resource design README SPEC template"
[[ -f "$PACKAGE_DIR/slashCommands/templates/README_StateDesignTemplate.md" ]] || fail "missing packaged state design README SPEC template"
[[ -f "$PACKAGE_DIR/slashCommands/templates/README_PerfDesignTemplate.md" ]] || fail "missing packaged perf design README SPEC template"
[[ -f "$PACKAGE_DIR/slashCommands/templates/README_DiagnosisDesignTemplate.md" ]] || fail "missing packaged diagnosis design README SPEC template"
[[ -f "$PACKAGE_DIR/slashCommands/templates/README_VerifyDesignTemplate.md" ]] || fail "missing packaged verify design README SPEC template"

grep -Fq 'name: user-story-centered-spec-coding' "$PACKAGE_DIR/SKILL.md" || fail "packaged SpecCoding skill has wrong name"
grep -Fq 'Use when: driving a user story through SpecCoding' "$PACKAGE_DIR/SKILL.md" || fail "SpecCoding skill description missing trigger phrase"
grep -Fq 'CaTDD is the default UnitTesting method' "$PACKAGE_DIR/SKILL.md" || fail "SpecCoding skill must state CaTDD default UnitTesting boundary"
grep -Fq 'CaTDD does not depend on this SpecCoding flow' "$PACKAGE_DIR/SKILL.md" || fail "SpecCoding skill must preserve CaTDD independence"
grep -Fq 'user-story-centered SpecCoding' "$PACKAGE_DIR/README.md" || fail "SpecCoding README missing concept name"
grep -Fq 'pendingNews -> todoUS -> doingUS -> doneUS' "$PACKAGE_DIR/README.md" || fail "SpecCoding README missing user story lifecycle"

package_symlink_count="$(find "$PACKAGE_DIR" -type l | wc -l | tr -d '[:space:]')"
[[ "$package_symlink_count" == "0" ]] || fail "packaged SpecCoding skill must be self-contained, found $package_symlink_count symlinks"

[[ ! -e "$SOURCE_SKILL_DIR/slashCommands" ]] || fail "authored SpecCoding skill source must not expose slashCommands symlink"
if [[ -d "$SOURCE_SKILL_DIR/references" ]]; then
  source_reference_symlinks="$(find "$SOURCE_SKILL_DIR/references" -type l | wc -l | tr -d '[:space:]')"
  [[ "$source_reference_symlinks" == "0" ]] || fail "authored SpecCoding skill source must not expose reference symlinks"
fi

echo "[makeSkill-specCoding-test] PASSED: generated self-contained SpecCoding skill package in $OUT_ROOT"
