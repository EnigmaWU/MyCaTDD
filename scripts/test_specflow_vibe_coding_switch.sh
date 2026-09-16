#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMAND_DIR="$REPO_ROOT/slashCommands/commands/Px-SpecFlow"
WHATS_WRONG="$COMMAND_DIR/SPEC_whatsWrong.md"
WHATS_NEXT="$COMMAND_DIR/SPEC_whatsNextTask.md"
COMMAND_README="$COMMAND_DIR/README.md"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
FLOW_DOC_ZH="$REPO_ROOT/slashCommands/flows/Px-SpecFlow_ZH.md"
USER_GUIDE="$REPO_ROOT/slashCommands/README_UserGuide.md"
USER_GUIDE_ZH="$REPO_ROOT/slashCommands/README_UserGuide_ZH.md"
SLASH_README="$REPO_ROOT/slashCommands/README.md"
SLASH_README_ZH="$REPO_ROOT/slashCommands/README_ZH.md"
UBILANG="$REPO_ROOT/README_UbiLang.md"
UBILANG_ZH="$REPO_ROOT/README_UbiLang_ZH.md"

fail() {
  echo "[specflow-vibe-coding-switch-test] $*" >&2
  exit 1
}

assert_contains() {
  local file="$1"
  local text="$2"
  [[ -f "$file" ]] || fail "missing file: ${file#$REPO_ROOT/}"
  grep -Fq -- "$text" "$file" || fail "${file#$REPO_ROOT/} missing expected text: $text"
}

# 1. The switch command exists and keeps the shared command contract shape.
[[ -f "$WHATS_WRONG" ]] || fail "missing SPEC_whatsWrong command"
for section in '## Purpose' '## Command Type' '## CoT Pattern' '### Linear Execution' '### Worked Example' '## Inputs' '## Method References' '## Output Contract' '## Conflict Guard'; do
  assert_contains "$WHATS_WRONG" "$section"
done
assert_contains "$WHATS_WRONG" 'ONE-MORE-THING: ask developer if something not sure'
assert_contains "$WHATS_WRONG" '**Linear**'

# 2. Escalation ladder and trigger classification.
assert_contains "$WHATS_WRONG" 'escalation ladder'
assert_contains "$WHATS_WRONG" 'Bounded rework inside the failing gate'
assert_contains "$WHATS_WRONG" '`ONE-MORE-THING` stop rule, when the problem can be stated as a question'
assert_contains "$WHATS_WRONG" 'when the problem cannot yet be stated as a question'
assert_contains "$WHATS_WRONG" 'Contradictory evidence between artifacts and observed reality'
assert_contains "$WHATS_WRONG" 'exhausted `maxStepRetry` or `maxRunCorrectionLoop` with no observable progress'
assert_contains "$WHATS_WRONG" 'no owning `SPEC_*` or `UT_*` command can be named'
assert_contains "$WHATS_WRONG" 'Escalation after a `ONE-MORE-THING` halt'
assert_contains "$WHATS_WRONG" 'If an owning command plainly exists, stop and route there.'

# 3. VibeCoding is manualMode-only.
assert_contains "$WHATS_WRONG" 'Verify `execution_mode = manualMode`. VibeCoding is manual-only.'
assert_contains "$WHATS_WRONG" 'discipline_switch = forbidden_autonomous'
assert_contains "$WHATS_WRONG" 'the agent may propose the switch, but it can never perform it headlessly'

# 4. The Flow is frozen and the excursion is recorded in local work state.
assert_contains "$WHATS_WRONG" 'Freeze SpecCoding state'
assert_contains "$WHATS_WRONG" 'assert the frozen classes stay untouched'
assert_contains "$WHATS_WRONG" '.catdd/spec/WorkingProcessLog.md'
assert_contains "$WHATS_WRONG" 'adoption_status = unadopted'

# 5. ONE-MORE-THING stays binding, exploration stays unadopted.
assert_contains "$WHATS_WRONG" '`ONE-MORE-THING` remains binding inside VibeCoding'
assert_contains "$WHATS_WRONG" 'Exploratory writes are allowed'
assert_contains "$WHATS_WRONG" 'until a `SPEC_*` step re-adopts it'
assert_contains "$WHATS_WRONG" 'never treat the excursion as a story-span commit'
assert_contains "$WHATS_WRONG" 'Do not suspend `ONE-MORE-THING` inside VibeCoding'
assert_contains "$WHATS_WRONG" 'Do not let the agent switch discipline on its own'

# 6. Learning and resume contract.
assert_contains "$WHATS_WRONG" 'learning_command = /HARNESS_evolveHarness'
assert_contains "$WHATS_WRONG" 'evolution_mode=auto'
assert_contains "$WHATS_WRONG" 'resume_command` may be any `SPEC_doXYZ` the developer chooses, including `SPEC_whatsNextTask`'
assert_contains "$WHATS_WRONG" 'defaulting to `SPEC_whatsNextTask`'
assert_contains "$WHATS_WRONG" 'no_findings'
assert_contains "$WHATS_WRONG" 'Do not use `SPEC_whatsWrong` to avoid a gate'

# 7. The switch is wired into the flow documents (EN + ZH).
assert_contains "$FLOW_DOC" '### Discipline Mode: SpecCoding vs VibeCoding'
assert_contains "$FLOW_DOC_ZH" '### 纪律模式：SpecCoding 与 VibeCoding'
assert_contains "$FLOW_DOC" 'Escalation ladder: bounded rework inside the failing gate'
assert_contains "$FLOW_DOC" 'While VibeCoding runs, the Flow is frozen'
assert_contains "$FLOW_DOC" 'VibeCoding is never available in `autonomousMode`'
assert_contains "$FLOW_DOC_ZH" '升级阶梯'
assert_contains "$FLOW_DOC_ZH" '在 `autonomousMode` 下绝不提供 VibeCoding'
assert_contains "$FLOW_DOC" '12. Use [SPEC_whatsWrong](../commands/Px-SpecFlow/SPEC_whatsWrong.md)'
assert_contains "$FLOW_DOC_ZH" '12. 当'
assert_contains "$FLOW_DOC_ZH" '[SPEC_whatsWrong](../commands/Px-SpecFlow/SPEC_whatsWrong.md)'
assert_contains "$FLOW_DOC" '`SPEC_whatsNextTask`, `SPEC_whatsWrong`, `SPEC_takeArchDesign`'
assert_contains "$FLOW_DOC_ZH" '`SPEC_whatsNextTask`、`SPEC_whatsWrong`、`SPEC_takeArchDesign`'
assert_contains "$FLOW_DOC" 'Do not run `SPEC_whatsWrong` in `autonomousMode`'
assert_contains "$FLOW_DOC_ZH" '不得在 `autonomousMode` 下运行 `SPEC_whatsWrong`'

en_headings="$(grep -c '^##* ' "$FLOW_DOC")"
zh_headings="$(grep -c '^##* ' "$FLOW_DOC_ZH")"
[[ "$en_headings" -eq "$zh_headings" ]] || fail "flow heading mismatch after the discipline-mode section: EN=$en_headings, ZH=$zh_headings"

# 8. Registries and term owners carry the switch.
assert_contains "$COMMAND_README" '[SPEC_whatsWrong.md](SPEC_whatsWrong.md)'
assert_contains "$USER_GUIDE" 'Discipline mode (SpecCoding vs VibeCoding)'
assert_contains "$USER_GUIDE_ZH" '纪律模式（SpecCoding 与 VibeCoding）'
assert_contains "$USER_GUIDE" '[SPEC_whatsWrong](commands/Px-SpecFlow/SPEC_whatsWrong.md)'
assert_contains "$USER_GUIDE_ZH" '[commands/Px-SpecFlow/SPEC_whatsWrong.md](commands/Px-SpecFlow/SPEC_whatsWrong.md)'
assert_contains "$SLASH_README" '`SPEC_whatsWrong` is the sanctioned bridge between the two'
assert_contains "$SLASH_README_ZH" '`SPEC_whatsWrong` 是两者之间被正式认可的桥梁'
assert_contains "$UBILANG" '| SPEC_whatsWrong |'
assert_contains "$UBILANG_ZH" '| SPEC_whatsWrong |'
assert_contains "$UBILANG" 'available only in `manualMode`'
assert_contains "$UBILANG_ZH" '仅在 `manualMode` 下可用'

# 9. The sibling orientation command still points only at next-step recommendation.
assert_contains "$WHATS_NEXT" 'Recommend the next SpecCoding task'

# 10. Freeze scope is defined by artifact class, not by a blanket "no writes" claim.
assert_contains "$WHATS_WRONG" 'Frozen during VibeCoding: `.catdd/spec/**` except `WorkingProcessLog.md`, `README_UserStories.md`, `projectContext.md`, and the paired `*-UserStory-Tasks.md`'
assert_contains "$WHATS_WRONG" 'Allowed but unadopted: product code, tests, and design docs'
assert_contains "$WHATS_WRONG" 'Local always: `.catdd/spec/WorkingProcessLog.md`'
assert_contains "$FLOW_DOC" 'Frozen: `.catdd/spec/**` except `WorkingProcessLog.md`'
assert_contains "$FLOW_DOC_ZH" '冻结：除 `WorkingProcessLog.md` 之外的 `.catdd/spec/**`'

# 11. The exhausted-loop response is reconciled between the ladder and the Loop Guard.
assert_contains "$FLOW_DOC" 'a `manualMode` session may escalate to `SPEC_whatsWrong` while the problem is still unproven'
assert_contains "$FLOW_DOC" 'an `autonomousMode` run must halt and hand the choice to the developer because it cannot switch discipline'
assert_contains "$FLOW_DOC_ZH" '`autonomousMode` 运行无法切换纪律，必须暂停并把选择交给开发者'

# 12. Unadopted excursions cannot enter a commit.
for commit_command in SPEC_commitStoryWorks SPEC_commitStepWorks SPEC_commitWorks; do
  assert_contains "$COMMAND_DIR/$commit_command.md" 'unadopted VibeCoding excursion edits'
done

# 13. Deadloop diagnosis can route to the switch.
assert_contains "$REPO_ROOT/slashCommands/commands/Px-HarnessKits/HARNESS_diagnoseProject.md" '`SPEC_abortUserStory`, `SPEC_whatsWrong` in `manualMode`, `SPEC_whatsNextTask`, or `ASK`'

echo "[specflow-vibe-coding-switch-test] PASSED: SPEC_whatsWrong switches SpecCoding into manualMode-only VibeCoding, freezes the Flow, and reconciles back"
