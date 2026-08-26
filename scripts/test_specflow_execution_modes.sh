#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
FLOW_DOC_ZH="$REPO_ROOT/slashCommands/flows/Px-SpecFlow_ZH.md"
SPEC_TEMPLATE="$REPO_ROOT/slashCommands/SPEC_slashCommandTemplate.md"
COMMAND_README="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/README.md"
USER_GUIDE="$REPO_ROOT/slashCommands/README_UserGuide.md"
USER_GUIDE_ZH="$REPO_ROOT/slashCommands/README_UserGuide_ZH.md"
NEXT_TASK="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_whatsNextTask.md"
MAKE_PLAN="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_makePlan.md"
ANALYZE_FEATURE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeFeature.md"
ANALYZE_ISSUE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeIssue.md"

fail() {
  echo "[specflow-execution-modes-test] $*" >&2
  exit 1
}

grep -Fq '## Execution Mode Guidance' "$FLOW_DOC" || fail "Px-SpecFlow must define execution mode guidance"
grep -Fq '`manualMode` is the default for Px-SpecFlow' "$FLOW_DOC" || fail "Px-SpecFlow must default to manualMode"
grep -Fq 'ask the developer whether the flow should remain in `manualMode` or explicitly switch to `autonomousMode`' "$FLOW_DOC" || fail "Px-SpecFlow must ask the developer before switching to autonomousMode"
grep -Fq '`autonomousMode` is the final evolving goal of Px-SpecFlow' "$FLOW_DOC" || fail "Px-SpecFlow must describe autonomousMode as the final evolving goal"

grep -Fq '## 执行模式指南' "$FLOW_DOC_ZH" || fail "Chinese Px-SpecFlow must define execution mode guidance"
grep -Fq '`manualMode` 是 Px-SpecFlow 的默认模式' "$FLOW_DOC_ZH" || fail "Chinese Px-SpecFlow must default to manualMode"
grep -Fq '先询问开发者本次流程应继续保持 `manualMode`，还是显式切换到 `autonomousMode`' "$FLOW_DOC_ZH" || fail "Chinese Px-SpecFlow must ask before switching to autonomousMode"

grep -Fq '`{{execution_mode}}`: optional `manualMode | autonomousMode`' "$SPEC_TEMPLATE" || fail "SPEC template must define execution_mode input"
grep -Fq 'commands must preserve the safer `manualMode` default until the developer opts in' "$SPEC_TEMPLATE" || fail "SPEC template must preserve manualMode default"
grep -Fq 'Execution mode applied, why it was selected' "$SPEC_TEMPLATE" || fail "SPEC template must require reporting mode decisions"

grep -Fq 'Px-SpecFlow runs in `manualMode` by default' "$COMMAND_README" || fail "Px-SpecFlow command README must document manualMode default"
grep -Fq 'explicitly switch this flow run to `autonomousMode`' "$COMMAND_README" || fail "Px-SpecFlow command README must document autonomousMode opt-in"

grep -Fq '### Execution modes' "$USER_GUIDE" || fail "slashCommands user guide must explain execution modes"
grep -Fq 'Px-SpecFlow defaults to `manualMode`' "$USER_GUIDE" || fail "slashCommands user guide must document manualMode default"
grep -Fq 'switch to `autonomousMode` before the next material flow advance' "$USER_GUIDE" || fail "slashCommands user guide must ask before switching to autonomousMode"
grep -Fq '### 执行模式' "$USER_GUIDE_ZH" || fail "Chinese slashCommands user guide must explain execution modes"

grep -Fq '`execution_mode`: optional `manualMode | autonomousMode`' "$NEXT_TASK" || fail "SPEC_whatsNextTask must accept execution_mode"
grep -Fq 'default to `manualMode` unless the developer explicitly requests `autonomousMode`.' "$NEXT_TASK" || fail "SPEC_whatsNextTask must default to manualMode"
grep -Fq 'ask whether the developer wants the next flow advance to remain in `manualMode` or switch to `autonomousMode`' "$NEXT_TASK" || fail "SPEC_whatsNextTask must ask before switching"
grep -Fq 'Do not assume `autonomousMode`' "$NEXT_TASK" || fail "SPEC_whatsNextTask must guard autonomousMode"

grep -Fq '`execution_mode`: optional `manualMode | autonomousMode`' "$MAKE_PLAN" || fail "SPEC_makePlan must accept execution_mode"
grep -Fq 'record that mode decision in the task artifact' "$MAKE_PLAN" || fail "SPEC_makePlan must record the mode decision"
grep -Fq 'Do not assume `autonomousMode`' "$MAKE_PLAN" || fail "SPEC_makePlan must guard autonomousMode"

grep -Fq '`analysis_mode`: optional `manualMode | autonomousMode`' "$ANALYZE_FEATURE" || fail "SPEC_analyzeFeature must accept manual/autonomous analysis mode"
grep -Fq 'Do not run `autonomousMode` unless the developer explicitly requested it.' "$ANALYZE_FEATURE" || fail "SPEC_analyzeFeature must guard autonomousMode"
grep -Fq '`analysis_mode`: optional `manualMode | autonomousMode`' "$ANALYZE_ISSUE" || fail "SPEC_analyzeIssue must use manual/autonomous analysis mode naming"

echo "[specflow-execution-modes-test] PASSED: SpecFlow documents manual/autonomous execution modes"
