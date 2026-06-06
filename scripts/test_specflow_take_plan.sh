#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
COMMAND_README="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/README.md"
OPEN_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md"
CLEAR_INTENT="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_clearStoryIntent.md"
TAKE_PLAN="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_makePlan.md"
CLOSE_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md"
USER_GUIDE="$REPO_ROOT/slashCommands/README_UserGuide.md"

fail() {
  echo "[specflow-take-plan-test] $*" >&2
  exit 1
}

[[ -f "$TAKE_PLAN" ]] || fail "missing SPEC_makePlan command"

grep -Fq '# SPEC_makePlan' "$TAKE_PLAN" || fail "SPEC_makePlan command must declare its heading"
grep -Fq '.catdd/spec/doingUS/*-TASKs.md' "$TAKE_PLAN" || fail "SPEC_makePlan must create a paired TASKs artifact in doingUS"
grep -Fq 'Markdown checkbox tasks: `[ ]` for pending work, `[x]` for satisfied or completed work.' "$TAKE_PLAN" || fail "SPEC_makePlan must require Markdown checkbox task style"
grep -Fq 'print the current TASKs checklist in the command response' "$TAKE_PLAN" || fail "SPEC_makePlan must print TASKs checklist after planning"
grep -Fq 'selected next command should be one of `SPEC_clearStoryIntent`, `SPEC_takeArchDesign`, `SPEC_takeDetailDesign`, `SPEC_reviewUserStory`, or `SPEC_designUnitTests`' "$TAKE_PLAN" || fail "SPEC_makePlan must enumerate valid next-step commands"

grep -Fq 'Initial next-step recommendation, usually `SPEC_makePlan`.' "$OPEN_STORY" || fail "SPEC_openUserStory must route opened stories to SPEC_makePlan"
grep -Fq 'next recommended command is `SPEC_makePlan`' "$CLEAR_INTENT" || fail "SPEC_clearStoryIntent must hand off to SPEC_makePlan"
grep -Fq '.catdd/spec/doneUS/*-TASKs.md' "$CLOSE_STORY" || fail "SPEC_closeUserStory must preserve the paired TASKs artifact in doneUS"

grep -Fq '[SPEC_makePlan.md](SPEC_makePlan.md)' "$COMMAND_README" || fail "Px-SpecFlow command README must list SPEC_makePlan"
grep -Fq 'Create checkbox TASKs and choose the next SPEC step for an opened user story' "$USER_GUIDE" || fail "slashCommands user guide must map the TASKs command"

grep -Fq 'SPEC_makePlan' "$FLOW_DOC" || fail "Px-SpecFlow must include SPEC_makePlan"
grep -Fq '.catdd/spec/doingUS/*-TASKs.md' "$FLOW_DOC" || fail "Px-SpecFlow must document the active TASKs artifact"
grep -Fq '.catdd/spec/doneUS/*-TASKs.md' "$FLOW_DOC" || fail "Px-SpecFlow must document the completed TASKs artifact"
grep -Fq 'PlanChoice -- "need arch" --> Arch["SPEC_takeArchDesign"]' "$FLOW_DOC" || fail "Px-SpecFlow must route planning to architecture design when needed"
grep -Fq 'PlanChoice -- "story is test-ready" --> DesignTests["SPEC_designUnitTests"]' "$FLOW_DOC" || fail "Px-SpecFlow must allow planning to route directly to unit-test design"

echo "[specflow-take-plan-test] PASSED: SPEC_makePlan is wired into SpecFlow"
