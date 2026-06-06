#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
COMMAND_README="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/README.md"
OPEN_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md"
CLEAR_INTENT="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_clearStoryIntent.md"
TAKE_PLAN="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_takePlan.md"
CLOSE_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md"
USER_GUIDE="$REPO_ROOT/slashCommands/README_UserGuide.md"

fail() {
  echo "[specflow-take-plan-test] $*" >&2
  exit 1
}

[[ -f "$TAKE_PLAN" ]] || fail "missing SPEC_takePlan command"

grep -Fq '# SPEC_takePlan' "$TAKE_PLAN" || fail "SPEC_takePlan command must declare its heading"
grep -Fq '.catdd/spec/doingUS/*-TASKs.md' "$TAKE_PLAN" || fail "SPEC_takePlan must create a paired TASKs artifact in doingUS"
grep -Fq 'Markdown checkbox tasks: `[ ]` for pending work, `[x]` for satisfied or completed work.' "$TAKE_PLAN" || fail "SPEC_takePlan must require Markdown checkbox task style"
grep -Fq 'selected next command should be one of `SPEC_clearStoryIntent`, `SPEC_takeArchDesign`, `SPEC_takeDetailDesign`, `SPEC_reviewUserStory`, or `SPEC_designUnitTests`' "$TAKE_PLAN" || fail "SPEC_takePlan must enumerate valid next-step commands"

grep -Fq 'Initial next-step recommendation, usually `SPEC_takePlan`.' "$OPEN_STORY" || fail "SPEC_openUserStory must route opened stories to SPEC_takePlan"
grep -Fq 'next recommended command is `SPEC_takePlan`' "$CLEAR_INTENT" || fail "SPEC_clearStoryIntent must hand off to SPEC_takePlan"
grep -Fq '.catdd/spec/doneUS/*-TASKs.md' "$CLOSE_STORY" || fail "SPEC_closeUserStory must preserve the paired TASKs artifact in doneUS"

grep -Fq '[SPEC_takePlan.md](SPEC_takePlan.md)' "$COMMAND_README" || fail "Px-SpecFlow command README must list SPEC_takePlan"
grep -Fq 'Create checkbox TASKs and choose the next SPEC step for an opened user story' "$USER_GUIDE" || fail "slashCommands user guide must map the TASKs command"

grep -Fq 'SPEC_takePlan' "$FLOW_DOC" || fail "Px-SpecFlow must include SPEC_takePlan"
grep -Fq '.catdd/spec/doingUS/*-TASKs.md' "$FLOW_DOC" || fail "Px-SpecFlow must document the active TASKs artifact"
grep -Fq '.catdd/spec/doneUS/*-TASKs.md' "$FLOW_DOC" || fail "Px-SpecFlow must document the completed TASKs artifact"
grep -Fq 'PlanChoice -- "need arch" --> Arch["SPEC_takeArchDesign"]' "$FLOW_DOC" || fail "Px-SpecFlow must route planning to architecture design when needed"
grep -Fq 'PlanChoice -- "story is test-ready" --> DesignTests["SPEC_designUnitTests"]' "$FLOW_DOC" || fail "Px-SpecFlow must allow planning to route directly to unit-test design"

echo "[specflow-take-plan-test] PASSED: SPEC_takePlan is wired into SpecFlow"
