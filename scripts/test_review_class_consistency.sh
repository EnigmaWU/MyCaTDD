#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
FLOW_DOC_ZH="$REPO_ROOT/slashCommands/flows/Px-SpecFlow_ZH.md"

REVIEW_COMMANDS=(
  "$REPO_ROOT/slashCommands/commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md"
  "$REPO_ROOT/slashCommands/commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md"
  "$REPO_ROOT/slashCommands/commands/P1-DesignTestsFlow/UT_reviewDesignTestsSkeleton.md"
  "$REPO_ROOT/slashCommands/commands/P2-QualityTestsFlow/UT_reviewQualityTestsSkeleton.md"
  "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_reviewUserStory.md"
  "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_reviewArchDesign.md"
  "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_reviewDetailDesign.md"
  "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_reviewImplUnitTests.md"
  "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_reviewProductCodes.md"
  "$REPO_ROOT/slashCommands/commands/Px-HarnessKits/HARNESS_verifyInstallation.md"
)

fail() {
  echo "[review-class-consistency-test] $*" >&2
  exit 1
}

assert_contains() {
  local file="$1"
  local text="$2"
  [[ -f "$file" ]] || fail "missing file: ${file#$REPO_ROOT/}"
  grep -Fq -- "$text" "$file" || fail "${file#$REPO_ROOT/} missing expected text: $text"
}

assert_not_contains() {
  local file="$1"
  local text="$2"
  ! grep -Fq -- "$text" "$file" || fail "${file#$REPO_ROOT/} must not contain: $text"
}

# 1. Every review gate states the same verdict model and the same invariants.
shared_contract_lines=(
  '## Review Gate Contract'
  '- Reviews: '
  '- Does not: '
  '`review_verdict`: exactly one of `PASS`, `REVISE`, `BLOCKED`, or `ASK` per pass.'
  '`severity`: optional `blocking | advisory` (default `blocking`)'
  '`rework_route`: required whenever the verdict is not `PASS`'
  'Read-only by default: report and route.'
  'Every finding cites a file, an ID, or a verification signal'
  'One verdict per pass, stable across passes'
  'Report `next_command = <COMMAND>` whenever the verdict is not `PASS`.'
)

for command in "${REVIEW_COMMANDS[@]}"; do
  for line in "${shared_contract_lines[@]}"; do
    assert_contains "$command" "$line"
  done
done

# 1b. Shared artifacts are split by lens, not by gate ownership.
assert_contains "${REVIEW_COMMANDS[4]}" 'judge acceptance-criteria testability from the design side (that lens belongs to `SPEC_reviewDetailDesign`)'
assert_contains "${REVIEW_COMMANDS[6]}" 'judge requirement content or measurability (that lens belongs to `SPEC_reviewUserStory`)'
assert_contains "${REVIEW_COMMANDS[8]}" 'review the test implementation itself (that lens belongs to `SPEC_reviewImplUnitTests`)'
assert_contains "${REVIEW_COMMANDS[7]}" 'review product code (that lens belongs to `SPEC_reviewProductCodes`)'

# verifyInstallation reads the portable command source rather than an upstream artifact.
assert_contains "$REPO_ROOT/slashCommands/commands/Px-HarnessKits/HARNESS_verifyInstallation.md" 'Source-first: read the portable command source and the expected adapter surface before judging the installed wrappers.'
for command in "${REVIEW_COMMANDS[@]:0:9}"; do
  assert_contains "$command" 'Source-first: read the upstream source artifact before judging the artifact under review.'
done

# 2. Bounded rework is stated in every gate (verification states re-verification instead).
for command in "${REVIEW_COMMANDS[@]:0:9}"; do
  assert_contains "$command" 'Rework is bounded by `max_rework_attempts` (default `3`) and the `Px-SpecFlow` Loop Guard stop conditions.'
done
assert_contains "$REPO_ROOT/slashCommands/commands/Px-HarnessKits/HARNESS_verifyInstallation.md" 'Re-verification after a repair is bounded by the `Px-SpecFlow` Loop Guard stop conditions'

# 3. ONE-MORE-THING is present in every review command.
for command in "${REVIEW_COMMANDS[@]:0:9}"; do
  assert_contains "$command" 'ONE-MORE-THING'
done

# 4. The retired per-command verdict dialects are gone.
assert_not_contains "${REVIEW_COMMANDS[1]}" 'Recommend keep, fix implementation, revise skeleton, or select the next TC.'
assert_not_contains "${REVIEW_COMMANDS[1]}" 'Recommendation: keep, fix implementation, revise skeleton, or select next TC.'
assert_not_contains "${REVIEW_COMMANDS[8]}" 'Review result for committed-scope product/test changes: pass, update design, add tests, abort story, or ask developer.'
assert_not_contains "${REVIEW_COMMANDS[5]}" 'Review finding: `PASS`, `REVISE`, or `ASK`.'
assert_not_contains "${REVIEW_COMMANDS[6]}" 'Review finding: `PASS`, `REVISE`, or `ASK`.'
assert_not_contains "$REPO_ROOT/slashCommands/commands/Px-HarnessKits/HARNESS_verifyInstallation.md" 'Installation verdict: `PASS`, `WARN`, or `FAIL`.'

# 5. The P0 review carries the sub-gate list; P1 and P2 keep their two-axis wording.
assert_contains "${REVIEW_COMMANDS[0]}" '`cardinality_gate`, `discovery_status`, `ready_for_implementation`'
assert_contains "${REVIEW_COMMANDS[2]}" 'Any non-PASS sub-gate means no'
assert_contains "${REVIEW_COMMANDS[3]}" 'Any non-PASS sub-gate means no'

# 6. The scope pair cross-references both ways.
assert_contains "${REVIEW_COMMANDS[1]}" 'Story-scoped review across all selected unit-test slices belongs to [SPEC_reviewImplUnitTests](../Px-SpecFlow/SPEC_reviewImplUnitTests.md)'
assert_contains "${REVIEW_COMMANDS[7]}" '`UT_reviewImplTestCase` owns TC-level alignment mechanics.'

# 7. The flow documents the canonical contract and the migration mapping (EN + ZH).
assert_contains "$FLOW_DOC" '`PASS`, `REVISE`, `BLOCKED`, `ASK`'
assert_contains "$FLOW_DOC_ZH" '`PASS`、`REVISE`、`BLOCKED`、`ASK`'
for flow in "$FLOW_DOC" "$FLOW_DOC_ZH"; do
  assert_contains "$flow" 'rework_route'
  assert_contains "$flow" 'severity'
done
assert_contains "$FLOW_DOC" '### Review Gate Contract'
assert_contains "$FLOW_DOC_ZH" '### 评审门禁契约（Review Gate Contract）'
assert_contains "$FLOW_DOC" "Keep the command's own diagnosis taxonomy unchanged and report the mapped \`review_verdict\` alongside it"
assert_contains "$FLOW_DOC_ZH" '保留命令自身的诊断分类不变，并在旁补齐映射后的 `review_verdict`'
assert_contains "$FLOW_DOC" '`GAPS`, `cardinality_gate: FAIL`, `REVISE`, `WARN`, `RISKY`, installation `FAIL`'
assert_contains "$FLOW_DOC" '`ASK`, `INSUFFICIENT_EVIDENCE`, an unresolved `ONE-MORE-THING` halt'

en_headings="$(grep -c '^##* ' "$FLOW_DOC")"
zh_headings="$(grep -c '^##* ' "$FLOW_DOC_ZH")"
[[ "$en_headings" -eq "$zh_headings" ]] || fail "flow heading mismatch after the review-gate section: EN=$en_headings, ZH=$zh_headings"

# 8. The diagnosis commands keep their taxonomy and are mapped in the flow.
assert_contains "$REPO_ROOT/slashCommands/commands/Px-HarnessKits/HARNESS_diagnoseProject.md" 'HEALTHY'
assert_contains "$REPO_ROOT/slashCommands/commands/Px-HarnessKits/HARNESS_diagnoseProject.md" 'INSUFFICIENT_EVIDENCE'
assert_contains "$REPO_ROOT/slashCommands/commands/Px-HarnessKits/HARNESS_diagnoseInstallation.md" 'CONFIRMED_INSTALLATION_FAILURE'

# 9. Artifacts without a dedicated gate name their owner, and P3 declares its intent.
assert_contains "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md" 'when the story was planned through `SPEC_makePlan` — the paired `*-UserStory-Tasks.md` is truthful'
assert_contains "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md" 'A story without a tasks artifact skips only this clause.'
assert_contains "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md" '`plan_drift`'
assert_contains "$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_whatsWrong.md" 'Plan drift: a `*-UserStory-Tasks.md` artifact whose checked tasks have no gate evidence behind them'
assert_contains "$FLOW_DOC" 'Not every artifact carries a dedicated gate, and the flow names the owner'
assert_contains "$FLOW_DOC" 'The paired `*-UserStory-Tasks.md` artifact is owned by `SPEC_makePlan` at authoring time'
assert_contains "$FLOW_DOC" 'is gated internally by the Lossless Compaction Gate in `SPEC_updateProjectContext`'
assert_contains "$FLOW_DOC" '`P3 Addons / Demo-Example` has no design or review gate by intent'
assert_contains "$FLOW_DOC_ZH" '并非每个制品都有专属门禁，因此流程显式指明归属'
assert_contains "$FLOW_DOC_ZH" '`P3 Addons / Demo-Example` 按设计意图不设设计与评审门禁'
assert_contains "$REPO_ROOT/slashCommands/commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md" 'no design or review gate of its own'

echo "[review-class-consistency-test] PASSED: all review gates report PASS/REVISE/BLOCKED/ASK with the same invariants, and the older vocabularies map in the flow"
