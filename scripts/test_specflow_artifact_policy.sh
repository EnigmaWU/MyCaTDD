#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
INSTALLER="$REPO_ROOT/scripts/installCaTDD.sh"
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
grep -Fq '`.catdd/metaspec/projectContext.md` | Team-shared | Commit' "$FLOW_DOC" || fail "projectContext must be documented under .catdd/metaspec as committed team context"
grep -Fq '`.catdd/metaspec/pendingNews/` | Team-shared | Commit' "$FLOW_DOC" || fail "pendingNews must be documented under .catdd/metaspec as committed shared intake"
grep -Fq '`.catdd/metaspec/analyzedNews/` | Team-shared | Commit' "$FLOW_DOC" || fail "analyzedNews must be documented under .catdd/metaspec as committed analyzed raw input archive"
grep -Fq '`.catdd/metaspec/todoUS/` | Team-shared | Commit' "$FLOW_DOC" || fail "todoUS must be documented under .catdd/metaspec as committed shared backlog"
grep -Fq '`.catdd/metaspec/doingUS/` | Team-shared | Commit' "$FLOW_DOC" || fail "doingUS must be documented under .catdd/metaspec as committed team-shared active state"
grep -Fq '`.catdd/metaspec/suspendUS/` | Team-shared | Commit' "$FLOW_DOC" || fail "suspendUS must be documented under .catdd/metaspec as committed suspended story state"
grep -Fq '`.catdd/metaspec/abortUS/` | Team-shared | Commit' "$FLOW_DOC" || fail "abortUS must be documented under .catdd/metaspec as committed aborted story state"
grep -Fq '`.catdd/metaspec/doneUS/` | Team-shared | Commit' "$FLOW_DOC" || fail "doneUS must be documented under .catdd/metaspec as committed shared history"
grep -Fq '`.catdd/metaspec/WorkingProcessLog.md` | Local work state | Gitignore' "$FLOW_DOC" || fail "WorkingProcessLog must be documented under .catdd/metaspec as ignored local work state"
grep -Fq '`README*.md` | Team-shared | Commit' "$FLOW_DOC" || fail "project-root README SPEC docs must be documented as committed shared artifacts"
grep -Fq '## Project-Root README SPEC Docs' "$FLOW_DOC" || fail "Px-SpecFlow missing project-root README SPEC docs section"
grep -Fq '`README_ArchDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include architecture design README"
grep -Fq '`README_UserStories.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include user stories README"
grep -Fq '`README_UserGuide.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include user guide README"
grep -Fq '`README_DetailDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include detail design README"
grep -Fq '`README_ErrorDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include error design README"
grep -Fq '`README_ResourceDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include resource design README"
grep -Fq '`README_StateDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include state design README"
grep -Fq '`README_PerfDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include performance design README"
grep -Fq '`README_CompatDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include compatibility design README"
grep -Fq '`README_DiagnosisDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include diagnosis design README"
grep -Fq '`README_VerifyDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include verify design README"
grep -Fq '`README_ArchVerifyDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include architecture-level verify design README"
grep -Fq '`README_DetailVerifyDesign.md`' "$FLOW_DOC" || fail "project-root SPEC docs must include detail-level verify design README"
grep -Fq 'embedded software and digital video/audio domain work' "$FLOW_DOC" || fail "Px-SpecFlow missing embedded and digital video/audio domain guidance"

grep -Fq 'team-shared persistent artifact' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_initProjectContext.md" || fail "SPEC_initProjectContext must mark projectContext as team-shared persistent output"
grep -Fq 'team-shared active work file' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md" || fail "SPEC_openUserStory must mark doingUS as team-shared active work state"
grep -Fq 'team-shared aborted story artifact' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_abortUserStory.md" || fail "SPEC_abortUserStory must mark abortUS as team-shared aborted output"
grep -Fq 'team-shared completed story artifact' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md" || fail "SPEC_closeUserStory must mark doneUS as team-shared completed output"
grep -Fq 'Project-root README SPEC docs as needed' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_takeDetailDesign.md" || fail "SPEC_takeDetailDesign must create or update project-root README SPEC docs as needed"
grep -Fq 'inherits the strategy from `README_DetailVerifyDesign.md`' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_designTests.md" || fail "SPEC_designTests must inherit the detail verification design instead of redefining it"

# Verification-design ownership contract: each half has exactly one owning command pair.
TAKE_ARCH_DESIGN="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_takeArchDesign.md"
UPDATE_ARCH_DESIGN="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_updateArchDesign.md"
TAKE_DETAIL_DESIGN="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_takeDetailDesign.md"
UPDATE_DETAIL_DESIGN="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_updateDetailDesign.md"
ARCH_VERIFY_TEMPLATE="$REPO_ROOT/slashCommands/templates/README_ArchVerifyDesignTemplate.md"
DETAIL_VERIFY_TEMPLATE="$REPO_ROOT/slashCommands/templates/README_DetailVerifyDesignTemplate.md"

grep -Fq '`README_ArchVerifyDesign.md`' "$TAKE_ARCH_DESIGN" || fail "SPEC_takeArchDesign must own README_ArchVerifyDesign.md creation"
grep -Fq '`README_ArchVerifyDesignTemplate.md`' "$TAKE_ARCH_DESIGN" || fail "SPEC_takeArchDesign must seed README_ArchVerifyDesign.md from its template"
grep -Fq '`README_ArchVerifyDesign.md`' "$UPDATE_ARCH_DESIGN" || fail "SPEC_updateArchDesign must revise README_ArchVerifyDesign.md"
grep -Fq '`README_DetailVerifyDesign.md`' "$TAKE_DETAIL_DESIGN" || fail "SPEC_takeDetailDesign must own README_DetailVerifyDesign.md creation"
grep -Fq '`README_DetailVerifyDesignTemplate.md`' "$TAKE_DETAIL_DESIGN" || fail "SPEC_takeDetailDesign must seed README_DetailVerifyDesign.md from its template"
grep -Fq '`README_DetailVerifyDesign.md`' "$UPDATE_DETAIL_DESIGN" || fail "SPEC_updateDetailDesign must revise README_DetailVerifyDesign.md"
grep -Fq 'README_DetailVerifyDesign.md` exists for the reviewed scope' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_reviewDetailDesign.md" || fail "SPEC_reviewDetailDesign must gate the detail verification design"

# Quadrant placement: row coverage in detail design, balance across levels/evidence in architecture design.
grep -Fq '## CaTDD x Agile Testing Quadrants Coverage' "$DETAIL_VERIFY_TEMPLATE" || fail "detail verification template must carry row-level category x quadrant coverage"
grep -Fq '## Quadrant Balance and Evidence Ownership' "$ARCH_VERIFY_TEMPLATE" || fail "architecture verification template must carry quadrant balance across levels and evidence"
grep -Fq 'Quadrant Balance and Evidence Ownership' "$FLOW_DOC" || grep -Fq 'quadrant balance across levels and evidence' "$FLOW_DOC" || fail "Px-SpecFlow must state the quadrant placement rule"
grep -Fq 'README_VerifyStatusTraces.md` is the optional dynamic companion' "$FLOW_DOC" || fail "Px-SpecFlow must declare the dynamic status companion as optional"
grep -Fq '<metaspec_root>/analyzedNews/' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeIssue.md" || fail "SPEC_analyzeIssue must archive analyzed raw input"
grep -Fq '<metaspec_root>/analyzedNews/' "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeFeature.md" || fail "SPEC_analyzeFeature must archive analyzed raw input"

if git -C "$REPO_ROOT" check-ignore -q .catdd/metaspec/projectContext.md; then
  fail "source .gitignore must allow committed .catdd/metaspec/projectContext.md"
fi
if git -C "$REPO_ROOT" check-ignore -q .catdd/metaspec/pendingNews/example.md; then
  fail "source .gitignore must allow committed .catdd/metaspec/pendingNews artifacts"
fi
if git -C "$REPO_ROOT" check-ignore -q .catdd/metaspec/analyzedNews/example.md; then
  fail "source .gitignore must allow committed .catdd/metaspec/analyzedNews artifacts"
fi
if git -C "$REPO_ROOT" check-ignore -q README_DetailDesign.md; then
  fail "source .gitignore must allow committed project-root README_DetailDesign.md"
fi
if git -C "$REPO_ROOT" check-ignore -q .catdd/metaspec/doingUS/example.md; then
  fail "source .gitignore must allow committed .catdd/metaspec/doingUS artifacts"
fi
if git -C "$REPO_ROOT" check-ignore -q .catdd/metaspec/abortUS/example.md; then
  fail "source .gitignore must allow committed .catdd/metaspec/abortUS artifacts"
fi
git -C "$REPO_ROOT" check-ignore -q .catdd/metaspec/WorkingProcessLog.md || fail "source .gitignore must ignore local .catdd/metaspec/WorkingProcessLog.md"

printf '/dist/\n' > "$TARGET_DIR/.gitignore"
"$INSTALLER" --targetDir "$TARGET_DIR" --targetCodeAgent Copilot --clean-prompts --yes >/dev/null
"$INSTALLER" --targetDir "$TARGET_DIR" --targetCodeAgent Copilot --clean-prompts --yes >/dev/null

[[ -d "$TARGET_DIR/.catdd/metaspec" ]] || fail "installer must create .catdd/metaspec workspace"
[[ -d "$TARGET_DIR/.catdd/metaspec/pendingNews" ]] || fail "installer must create .catdd/metaspec/pendingNews"
[[ -d "$TARGET_DIR/.catdd/metaspec/analyzedNews" ]] || fail "installer must create .catdd/metaspec/analyzedNews"
[[ -d "$TARGET_DIR/.catdd/metaspec/todoUS" ]] || fail "installer must create .catdd/metaspec/todoUS"
[[ -d "$TARGET_DIR/.catdd/metaspec/doingUS" ]] || fail "installer must create .catdd/metaspec/doingUS"
[[ -d "$TARGET_DIR/.catdd/metaspec/suspendUS" ]] || fail "installer must create .catdd/metaspec/suspendUS"
[[ -d "$TARGET_DIR/.catdd/metaspec/abortUS" ]] || fail "installer must create .catdd/metaspec/abortUS"
[[ -d "$TARGET_DIR/.catdd/metaspec/doneUS" ]] || fail "installer must create .catdd/metaspec/doneUS"
[[ ! -d "$TARGET_DIR/.catdd/metaspec/modules" ]] || fail "installer must not create .catdd/metaspec/modules because README SPEC docs belong in project root"
[[ -f "$TARGET_DIR/.catdd/slashCommands/templates/README_DetailDesignTemplate.md" ]] || fail "installer must install detail design README SPEC template"
[[ -f "$TARGET_DIR/.catdd/slashCommands/templates/README_ErrorDesignTemplate.md" ]] || fail "installer must install error design README SPEC template"
[[ -f "$TARGET_DIR/.catdd/slashCommands/templates/README_ResourceDesignTemplate.md" ]] || fail "installer must install resource design README SPEC template"
[[ -f "$TARGET_DIR/.catdd/slashCommands/templates/README_StateDesignTemplate.md" ]] || fail "installer must install state design README SPEC template"
[[ -f "$TARGET_DIR/.catdd/slashCommands/templates/README_PerfDesignTemplate.md" ]] || fail "installer must install perf design README SPEC template"
[[ -f "$TARGET_DIR/.catdd/slashCommands/templates/README_CompatDesignTemplate.md" ]] || fail "installer must install compatibility design README SPEC template"
[[ -f "$TARGET_DIR/.catdd/slashCommands/templates/README_DiagnosisDesignTemplate.md" ]] || fail "installer must install diagnosis design README SPEC template"
[[ -f "$TARGET_DIR/.catdd/slashCommands/templates/README_VerifyDesignTemplate.md" ]] || fail "installer must install verify design README SPEC template"

TARGET_GITIGNORE="$TARGET_DIR/.gitignore"
[[ -f "$TARGET_GITIGNORE" ]] || fail "installer must create or update target .gitignore"
grep -Fq '/dist/' "$TARGET_GITIGNORE" || fail "installer must preserve existing target .gitignore rules"
grep -Fq '# BEGIN CaTDD SpecCoding local state' "$TARGET_GITIGNORE" || fail "target .gitignore missing CaTDD managed block start"
! grep -Fq '/.catdd/metaspec/doingUS/' "$TARGET_GITIGNORE" || fail "target .gitignore must not ignore active doingUS work state under .catdd/metaspec"
grep -Fq '/.catdd/metaspec/WorkingProcessLog.md' "$TARGET_GITIGNORE" || fail "target .gitignore must ignore local working process log under .catdd/metaspec"
grep -Fq '# END CaTDD SpecCoding local state' "$TARGET_GITIGNORE" || fail "target .gitignore missing CaTDD managed block end"
[[ "$(grep -Fc '# BEGIN CaTDD SpecCoding local state' "$TARGET_GITIGNORE")" == "1" ]] || fail "target .gitignore must contain exactly one managed block start"
[[ "$(grep -Fc '/.catdd/metaspec/doingUS/' "$TARGET_GITIGNORE")" == "0" ]] || fail "target .gitignore must not contain a doingUS ignore rule"
[[ "$(grep -Fc '/.catdd/metaspec/WorkingProcessLog.md' "$TARGET_GITIGNORE")" == "1" ]] || fail "target .gitignore must contain exactly one WorkingProcessLog rule"

instructions="$TARGET_DIR/.github/instructions/catdd.instructions.md"
grep -Fq 'Commit team-shared SpecCoding artifacts under the resolved `metaspec_root`, such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, and `doneUS/`.' "$instructions" || fail "instructions missing commit guidance for shared SpecCoding artifacts"
grep -Fq 'Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_ArchVerifyDesign.md`, and `README_VerifyDesign.md` as needed.' "$instructions" || fail "instructions missing project-root README SPEC docs guidance"
grep -Fq 'Keep local SpecCoding work state such as `WorkingProcessLog.md` gitignored in every supported workspace.' "$instructions" || fail "instructions missing gitignore guidance for local SpecCoding state"
grep -Fq 'MetaspecWorkspaceResolution.md' "$instructions" || fail "instructions missing metaspec workspace resolution guidance"

echo "[specflow-artifact-policy-test] PASSED: SpecFlow artifact persistence policy is documented and installed"
