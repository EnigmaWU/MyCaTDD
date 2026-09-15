#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMAND_DIR="$REPO_ROOT/slashCommands/commands/Px-SpecFlow"
COMMIT_WORKS="$COMMAND_DIR/SPEC_commitWorks.md"
COMMIT_PRE_STORY="$COMMAND_DIR/SPEC_commitPreStoryWorks.md"
COMMIT_STEP="$COMMAND_DIR/SPEC_commitStepWorks.md"
COMMIT_STORY="$COMMAND_DIR/SPEC_commitStoryWorks.md"
MAKE_PLAN="$COMMAND_DIR/SPEC_makePlan.md"
CLOSE_STORY="$COMMAND_DIR/SPEC_closeUserStory.md"
COMMAND_README="$COMMAND_DIR/README.md"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
FLOW_DOC_ZH="$REPO_ROOT/slashCommands/flows/Px-SpecFlow_ZH.md"
USER_GUIDE="$REPO_ROOT/slashCommands/README_UserGuide.md"
UBILANG="$REPO_ROOT/README_UbiLang.md"
UBILANG_ZH="$REPO_ROOT/README_UbiLang_ZH.md"

fail() {
  echo "[specflow-commit-spans-test] $*" >&2
  exit 1
}

assert_file() {
  [[ -f "$1" ]] || fail "missing file: ${1#$REPO_ROOT/}"
}

assert_contains() {
  local file="$1"
  local text="$2"
  grep -Fq -- "$text" "$file" || fail "${file#$REPO_ROOT/} missing expected text: $text"
}

assert_absent_file() {
  [[ ! -e "$1" ]] || fail "unexpected file: ${1#$REPO_ROOT/}"
}

# 1. The four commit commands exist and keep their span boundaries apart.
for command_file in "$COMMIT_WORKS" "$COMMIT_PRE_STORY" "$COMMIT_STEP" "$COMMIT_STORY"; do
  assert_file "$command_file"
  assert_contains "$command_file" 'ONE-MORE-THING: ask developer if something not sure'
  assert_contains "$command_file" '`execution_mode`: optional `manualMode | autonomousMode`'
done

assert_contains "$COMMIT_WORKS" 'story-agnostic'
assert_contains "$COMMIT_WORKS" 'staged files first, most recently modified files second'
assert_contains "$COMMIT_WORKS" 'Do not advance SpecFlow lifecycle state'
assert_absent_file "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_commitStoryWorks.pre_close.md"

# 2. Pre-story span: before openUserStory, never story-span work.
assert_contains "$COMMIT_PRE_STORY" 'before `SPEC_openUserStory`'
assert_contains "$COMMIT_PRE_STORY" 'still lives in `.catdd/spec/todoUS/`'
assert_contains "$COMMIT_PRE_STORY" 'route to `SPEC_commitStoryWorks`'
assert_contains "$COMMIT_PRE_STORY" 'analysis_mode: AUTONOMOUS'
assert_contains "$COMMIT_PRE_STORY" 'autonomousMode`, this checkpoint is the default'
assert_contains "$COMMIT_PRE_STORY" 'next_command = SPEC_openUserStory'
assert_contains "$COMMIT_PRE_STORY" 'Do not run after the story moved to `.catdd/spec/doingUS/`'

# 3. Step span: only planned boundaries, only after the gate passed.
assert_contains "$COMMIT_STEP" 'inside the `SPEC_openUserStory -> SPEC_closeUserStory` story span'
assert_contains "$COMMIT_STEP" 'commit_step = yes'
assert_contains "$COMMIT_STEP" 'commit_step = no'
assert_contains "$COMMIT_STEP" 'Never commit failed, blocked, partial, or unverified step output.'
assert_contains "$COMMIT_STEP" 'Step: <SPEC command>'
assert_contains "$COMMIT_STEP" 'Do not include story-level lifecycle or meta artifacts'

# 4. Story span: open-to-close, both checkpoints, optional squash.
assert_contains "$COMMIT_STORY" 'whole `SPEC_openUserStory -> SPEC_closeUserStory` story span'
assert_contains "$COMMIT_STORY" 'commit_checkpoint = pre_close'
assert_contains "$COMMIT_STORY" 'commit_checkpoint = post_close'
assert_contains "$COMMIT_STORY" 'next_command = SPEC_closeUserStory'
assert_contains "$COMMIT_STORY" 'next_command = SPEC_mergeWorks'
assert_contains "$COMMIT_STORY" 'single_story_commit = yes'
assert_contains "$COMMIT_STORY" 'Do not mark closure complete while post-close lifecycle/meta changes remain uncommitted.'

# 5. Manual mode is optional, autonomous mode is default, for all span commands.
for span_command in "$COMMIT_PRE_STORY" "$COMMIT_STEP" "$COMMIT_STORY"; do
  assert_contains "$span_command" '`manualMode`'
  assert_contains "$span_command" 'autonomousMode'
  grep -Eq 'manualMode`: (option|optional|optional command|Optional)' "$span_command" \
    || fail "${span_command#$REPO_ROOT/} must state that manualMode is optional"
  grep -Eq 'autonomousMode`: (default|default |the default)' "$span_command" \
    || fail "${span_command#$REPO_ROOT/} must state that autonomousMode is the default"
done

# 6. SPEC_makePlan decides the commit plan.
assert_contains "$MAKE_PLAN" 'Commit Plan Decision Rules'
assert_contains "$MAKE_PLAN" 'decide the story'"'"'s commit plan'
assert_contains "$MAKE_PLAN" '`commit_step = yes`'
assert_contains "$MAKE_PLAN" '`commit_step = no`'
assert_contains "$MAKE_PLAN" '`commit_step = optional`'
assert_contains "$MAKE_PLAN" 'single_story_commit = yes'
assert_contains "$MAKE_PLAN" 'pre_story_commit = yes|no'
assert_contains "$MAKE_PLAN" 'SPEC_commitStoryWorks.md'
assert_contains "$MAKE_PLAN" 'Never plan a commit boundary for a step whose pass condition is undefined'

# 7. Close routes its checkpoints to the story-span commit command.
assert_contains "$CLOSE_STORY" 'next_command = /SPEC_commitStoryWorks'
assert_contains "$CLOSE_STORY" 'commit_checkpoint = post_close'

# 8. Flow documents (EN & ZH) describe the commit spans.
for flow_doc in "$FLOW_DOC" "$FLOW_DOC_ZH"; do
  assert_contains "$flow_doc" 'SPEC_commitPreStoryWorks'
  assert_contains "$flow_doc" 'SPEC_commitStepWorks'
  assert_contains "$flow_doc" 'SPEC_commitStoryWorks'
  assert_contains "$flow_doc" 'CommitDesign["SPEC_commitStoryWorks"]'
  assert_contains "$flow_doc" 'Commit["SPEC_commitStoryWorks"]'
  assert_contains "$flow_doc" 'PreStoryCommit["SPEC_commitPreStoryWorks"]'
  assert_contains "$flow_doc" 'StepCommit["SPEC_commitStepWorks"]'
  assert_contains "$flow_doc" 'CommitFinalize["SPEC_commitStoryWorks (post_close)"]'
done

assert_contains "$FLOW_DOC" '## Commit Spans'
assert_contains "$FLOW_DOC" '### Commit Plan Decision Rules'
assert_contains "$FLOW_DOC_ZH" '## 提交区间'
assert_contains "$FLOW_DOC_ZH" '### 提交计划决策规则'

# 9. Command README, user guide, and ubiquitous language name the new commands.
for command_name in SPEC_commitPreStoryWorks SPEC_commitStepWorks SPEC_commitStoryWorks SPEC_commitWorks; do
  assert_contains "$COMMAND_README" "$command_name.md"
  assert_contains "$USER_GUIDE" "$command_name.md"
  assert_contains "$UBILANG" "| $command_name |"
  assert_contains "$UBILANG_ZH" "| $command_name |"
done
assert_contains "$UBILANG" '| commit span |'
assert_contains "$UBILANG_ZH" '| commit span（提交区间） |'

echo "[specflow-commit-spans-test] PASSED: commit spans are split by pre-story, step, story, and general commit commands"
