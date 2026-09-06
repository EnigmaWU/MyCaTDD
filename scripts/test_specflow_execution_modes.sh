#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
FLOW_DOC_ZH="$REPO_ROOT/slashCommands/flows/Px-SpecFlow_ZH.md"
SPEC_TEMPLATE="$REPO_ROOT/slashCommands/SPEC_slashCommandTemplate.md"
COMMAND_README="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/README.md"
USER_GUIDE="$REPO_ROOT/slashCommands/README_UserGuide.md"
USER_GUIDE_ZH="$REPO_ROOT/slashCommands/README_UserGuide_ZH.md"
UBILANG="$REPO_ROOT/README_UbiLang.md"
UBILANG_ZH="$REPO_ROOT/README_UbiLang_ZH.md"

NEXT_TASK="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_whatsNextTask.md"
MAKE_PLAN="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_makePlan.md"
IMPORT_ISSUE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_importIssue.md"
IMPORT_FEATURE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_importFeature.md"
IMPORT_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_importUserStory.md"
OPEN_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md"
CLOSE_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md"
ABORT_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_abortUserStory.md"
SUSPEND_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_suspendUserStory.md"

fail() {
  echo "[specflow-execution-modes-test] $*" >&2
  exit 1
}

assert_contains() {
  local file="$1"
  local text="$2"
  grep -Fq "$text" "$file" || fail "${file#$REPO_ROOT/} missing expected text: $text"
}

# 1. Flow documents (EN & ZH)
assert_contains "$FLOW_DOC" '## Execution Mode Guidance'
assert_contains "$FLOW_DOC" '`manualMode` (default)'
assert_contains "$FLOW_DOC" '`autonomousMode` (opt-in)'
assert_contains "$FLOW_DOC" 'ONLY Implementation-Oriented Supports Autonomous Mode'
assert_contains "$FLOW_DOC" '### Analysis Mode vs. Flow Execution Mode'
assert_contains "$FLOW_DOC" '### The ONE-MORE-THING Universal Stop Rule'
assert_contains "$FLOW_DOC" 'Do not execute `autonomousMode` on `intent-clearing`, `requirement-oriented`, or `design-oriented` stories'

assert_contains "$FLOW_DOC_ZH" '## 执行模式指南'
assert_contains "$FLOW_DOC_ZH" '`manualMode`（默认模式）'
assert_contains "$FLOW_DOC_ZH" '`autonomousMode`（自主模式，需显式选择）'
assert_contains "$FLOW_DOC_ZH" '仅实现导向（Implementation-Oriented）支持自主模式'
assert_contains "$FLOW_DOC_ZH" '### 分析模式与流程执行模式'
assert_contains "$FLOW_DOC_ZH" '### ONE-MORE-THING 通用暂停规则'
assert_contains "$FLOW_DOC_ZH" '不得在意图澄清型、需求导向型或设计导向型故事上执行 `autonomousMode`'

# Flow mirror heading parity (EN vs ZH)
en_headings="$(grep -c '^##* ' "$FLOW_DOC")"
zh_headings="$(grep -c '^##* ' "$FLOW_DOC_ZH")"
[[ "$en_headings" -eq "$zh_headings" ]] || fail "Px-SpecFlow heading mismatch: EN=$en_headings, ZH=$zh_headings"

# 2. Ubiquitous Language (EN & ZH)
assert_contains "$UBILANG" '| manualMode |'
assert_contains "$UBILANG" '| autonomousMode |'
assert_contains "$UBILANG" '| analysis_mode |'
assert_contains "$UBILANG" '| ONE-MORE-THING |'
assert_contains "$UBILANG" 'Strictly supported ONLY for `implementation-oriented` stories'

assert_contains "$UBILANG_ZH" '| manualMode |'
assert_contains "$UBILANG_ZH" '| autonomousMode |'
assert_contains "$UBILANG_ZH" '| analysis_mode |'
assert_contains "$UBILANG_ZH" '| ONE-MORE-THING |'
assert_contains "$UBILANG_ZH" '严格仅支持实现导向（implementation-oriented）的用户故事'

# 3. SPEC slash command template
assert_contains "$SPEC_TEMPLATE" '`{{execution_mode}}`: optional `manualMode | autonomousMode`'
assert_contains "$SPEC_TEMPLATE" 'ONLY `implementation-oriented` stories support `autonomousMode`'
assert_contains "$SPEC_TEMPLATE" 'The ONE-MORE-THING Universal Stop Rule'
assert_contains "$SPEC_TEMPLATE" 'ONE-MORE-THING: ask developer if something not sure (Universal Stop Rule: MUST halt and ask developer in both manualMode and autonomousMode)'

UT_TEMPLATE="$REPO_ROOT/slashCommands/UT_slashCommandTemplate.md"
assert_contains "$UT_TEMPLATE" 'ONE-MORE-THING: ask developer if something not sure (Universal Stop Rule: MUST halt and ask developer in both manualMode and autonomousMode)'

# 4. Command README
assert_contains "$COMMAND_README" 'Px-SpecFlow runs in `manualMode` by default'
assert_contains "$COMMAND_README" 'autonomous execution is supported strictly and ONLY for `implementation-oriented` stories'

# 5. User Guides (EN & ZH)
assert_contains "$USER_GUIDE" '### Execution modes'
assert_contains "$USER_GUIDE" '`manualMode` (default)'
assert_contains "$USER_GUIDE" 'ONLY for `implementation-oriented` stories'
assert_contains "$USER_GUIDE" 'Universal Stop Rule (ONE-MORE-THING)'

assert_contains "$USER_GUIDE_ZH" '### 执行模式'
assert_contains "$USER_GUIDE_ZH" '`manualMode`（默认模式）'
assert_contains "$USER_GUIDE_ZH" '严格仅支持实现导向（implementation-oriented）的用户故事'
assert_contains "$USER_GUIDE_ZH" '通用暂停规则（ONE-MORE-THING）'

# 6. Entry, planning, analysis, and terminal commands
for cmd_file in "$IMPORT_ISSUE" "$IMPORT_FEATURE" "$IMPORT_STORY" "$OPEN_STORY" "$MAKE_PLAN" "$NEXT_TASK" "$CLOSE_STORY" "$ABORT_STORY" "$SUSPEND_STORY"; do
  assert_contains "$cmd_file" '`execution_mode`: optional `manualMode | autonomousMode`'
done

ANALYZE_ISSUE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeIssue.md"
ANALYZE_FEATURE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeFeature.md"
assert_contains "$ANALYZE_ISSUE" '`analysis_mode`: optional `BRAINSTORM | AUTONOMOUS`'
assert_contains "$ANALYZE_FEATURE" '`analysis_mode`: optional `BRAINSTORM | AUTONOMOUS`'
assert_contains "$ANALYZE_ISSUE" 'ONE-MORE-THING: ask developer if something not sure (Universal Stop Rule'
assert_contains "$ANALYZE_FEATURE" 'ONE-MORE-THING: ask developer if something not sure (Universal Stop Rule'

assert_contains "$MAKE_PLAN" 'Orientation Boundary for Autonomous Mode'
assert_contains "$MAKE_PLAN" 'Do not execute `autonomousMode` on `intent-clearing`, `requirement-oriented`, or `design-oriented` stories'

echo "[specflow-execution-modes-test] PASSED: SpecFlow documents manual/autonomous execution modes with implementation-oriented guard and ONE-MORE-THING stop rule"
