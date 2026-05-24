#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
INIT_CONTEXT="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_initProjectContext.md"
ANALYZE_ISSUE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeIssue.md"
ANALYZE_FEATURE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeFeature.md"
TAKE_DETAIL_DESIGN="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_takeDetailDesign.md"
REVIEW_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_reviewUserStory.md"
DESIGN_TESTS="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md"

fail() {
  echo "[specflow-openspec-refinements-test] $*" >&2
  exit 1
}

grep -Fq '## Refinements from OpenSpec' "$FLOW_DOC" || fail "Px-SpecFlow missing OpenSpec refinements section"
grep -Fq 'Govern work with constitution-level project context.' "$FLOW_DOC" || fail "Px-SpecFlow missing constitution-level project context refinement"
grep -Fq 'Analyze work into independently testable story slices.' "$FLOW_DOC" || fail "Px-SpecFlow missing independently testable story-slice refinement"
grep -Fq 'Separate `WHAT`/`WHY` from `HOW` with a lightweight plan step.' "$FLOW_DOC" || fail "Px-SpecFlow missing lightweight plan-step refinement"
grep -Fq 'Run a clarify/analyze/checklist gate before implementation.' "$FLOW_DOC" || fail "Px-SpecFlow missing clarify/analyze/checklist refinement"
grep -Fq 'Make execution slices explicit, ordered, and parallel-aware.' "$FLOW_DOC" || fail "Px-SpecFlow missing task-slice refinement"

grep -Fq 'constitution-level guardrails' "$INIT_CONTEXT" || fail "SPEC_initProjectContext must mention constitution-level guardrails"
grep -Fq 'independently testable' "$ANALYZE_ISSUE" || fail "SPEC_analyzeIssue must require independently testable story output"
grep -Fq 'independently testable' "$ANALYZE_FEATURE" || fail "SPEC_analyzeFeature must require independently testable story output"
grep -Fq 'lightweight implementation plan' "$TAKE_DETAIL_DESIGN" || fail "SPEC_takeDetailDesign must mention lightweight implementation plan output"
grep -Fq 'clarify/analyze/checklist-style review gate' "$REVIEW_STORY" || fail "SPEC_reviewUserStory must mention clarify/analyze/checklist gate"
grep -Fq 'parallel-ready implementation checklist' "$DESIGN_TESTS" || fail "SPEC_designUnitTests must mention parallel-ready implementation checklist"

echo "[specflow-openspec-refinements-test] PASSED: SpecFlow documents OpenSpec-inspired refinements"
