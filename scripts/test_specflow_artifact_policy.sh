#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
INSTALLER="$REPO_ROOT/scripts/installCaTDD4Copilot.sh"
TARGET_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

fail() {
  echo "[specflow-artifact-policy-test] $*" >&2
  exit 1
}

grep -Fq '## Artifact Persistence Policy' "$FLOW_DOC" || fail "Px-SpecFlow missing artifact persistence policy section"
grep -Fq '`.catdd/spec/projectContext.md` | Team-shared | Commit' "$FLOW_DOC" || fail "projectContext must be documented under .catdd/spec as committed team context"
grep -Fq '`.catdd/spec/pendingNews/` | Team-shared | Commit' "$FLOW_DOC" || fail "pendingNews must be documented under .catdd/spec as committed shared intake"
grep -Fq '`.catdd/spec/todoUS/` | Team-shared | Commit' "$FLOW_DOC" || fail "todoUS must be documented under .catdd/spec as committed shared backlog"
grep -Fq '`.catdd/spec/doingUS/` | Local work state | Gitignore' "$FLOW_DOC" || fail "doingUS must be documented under .catdd/spec as ignored local work state"
grep -Fq '`.catdd/spec/doneUS/` | Team-shared | Commit' "$FLOW_DOC" || fail "doneUS must be documented under .catdd/spec as committed shared history"
grep -Fq '`.catdd/spec/WorkingProcessLog.md` | Local work state | Gitignore' "$FLOW_DOC" || fail "WorkingProcessLog must be documented under .catdd/spec as ignored local work state"

grep -Fq 'team-shared persistent artifact' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_initProjectContext.md" || fail "SPEC_initProjectContext must mark projectContext as team-shared persistent output"
grep -Fq 'local gitignored work state' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md" || fail "SPEC_openUserStory must mark doingUS as local gitignored work state"
grep -Fq 'team-shared completed story artifact' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md" || fail "SPEC_closeUserStory must mark doneUS as team-shared completed output"

if git -C "$REPO_ROOT" check-ignore -q .catdd/spec/projectContext.md; then
  fail "source .gitignore must allow committed .catdd/spec/projectContext.md"
fi
if git -C "$REPO_ROOT" check-ignore -q .catdd/spec/pendingNews/example.md; then
  fail "source .gitignore must allow committed .catdd/spec/pendingNews artifacts"
fi
git -C "$REPO_ROOT" check-ignore -q .catdd/spec/doingUS/example.md || fail "source .gitignore must ignore local .catdd/spec/doingUS state"
git -C "$REPO_ROOT" check-ignore -q .catdd/spec/WorkingProcessLog.md || fail "source .gitignore must ignore local .catdd/spec/WorkingProcessLog.md"

printf '/dist/\n' > "$TARGET_DIR/.gitignore"
"$INSTALLER" --target "$TARGET_DIR" --clean-prompts >/dev/null
"$INSTALLER" --target "$TARGET_DIR" --clean-prompts >/dev/null

[[ -d "$TARGET_DIR/.catdd/spec" ]] || fail "installer must create .catdd/spec workspace"
[[ -d "$TARGET_DIR/.catdd/spec/pendingNews" ]] || fail "installer must create .catdd/spec/pendingNews"
[[ -d "$TARGET_DIR/.catdd/spec/todoUS" ]] || fail "installer must create .catdd/spec/todoUS"
[[ -d "$TARGET_DIR/.catdd/spec/doingUS" ]] || fail "installer must create .catdd/spec/doingUS"
[[ -d "$TARGET_DIR/.catdd/spec/doneUS" ]] || fail "installer must create .catdd/spec/doneUS"

TARGET_GITIGNORE="$TARGET_DIR/.gitignore"
[[ -f "$TARGET_GITIGNORE" ]] || fail "installer must create or update target .gitignore"
grep -Fq '/dist/' "$TARGET_GITIGNORE" || fail "installer must preserve existing target .gitignore rules"
grep -Fq '# BEGIN CaTDD SpecCoding local state' "$TARGET_GITIGNORE" || fail "target .gitignore missing CaTDD managed block start"
grep -Fq '/.catdd/spec/doingUS/' "$TARGET_GITIGNORE" || fail "target .gitignore must ignore active doingUS work state under .catdd/spec"
grep -Fq '/.catdd/spec/WorkingProcessLog.md' "$TARGET_GITIGNORE" || fail "target .gitignore must ignore local working process log under .catdd/spec"
grep -Fq '# END CaTDD SpecCoding local state' "$TARGET_GITIGNORE" || fail "target .gitignore missing CaTDD managed block end"
[[ "$(grep -Fc '# BEGIN CaTDD SpecCoding local state' "$TARGET_GITIGNORE")" == "1" ]] || fail "target .gitignore must contain exactly one managed block start"
[[ "$(grep -Fc '/.catdd/spec/doingUS/' "$TARGET_GITIGNORE")" == "1" ]] || fail "target .gitignore must contain exactly one doingUS rule"
[[ "$(grep -Fc '/.catdd/spec/WorkingProcessLog.md' "$TARGET_GITIGNORE")" == "1" ]] || fail "target .gitignore must contain exactly one WorkingProcessLog rule"

instructions="$TARGET_DIR/.github/instructions/catdd.instructions.md"
grep -Fq 'Commit team-shared SpecCoding artifacts under `.catdd/spec/`, such as `projectContext.md`, `pendingNews/`, `todoUS/`, and `doneUS/`.' "$instructions" || fail "instructions missing commit guidance for shared SpecCoding artifacts"
grep -Fq 'Keep local SpecCoding work state such as `.catdd/spec/doingUS/` and `.catdd/spec/WorkingProcessLog.md` gitignored.' "$instructions" || fail "instructions missing gitignore guidance for local SpecCoding state"

echo "[specflow-artifact-policy-test] PASSED: SpecFlow artifact persistence policy is documented and installed"