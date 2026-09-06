#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
METHOD_DIR="$REPO_ROOT/methodPrompts"
GUIDE="$METHOD_DIR/README_UserGuide.md"
GUIDE_ZH="$METHOD_DIR/README_UserGuide_ZH.md"
MAIN_GUIDE="$REPO_ROOT/README_UserGuide.md"
MASTER_PROMPT="$METHOD_DIR/CaTDD_methodPrompt.md"
CXX_TEMPLATE="$METHOD_DIR/CaTDD_designAndImplTemplate.cxx"
TS_TEMPLATE="$METHOD_DIR/CaTDD_designAndImplTemplate.ts"

fail() {
  echo "[methodPrompts-standalone-guide-test] $*" >&2
  exit 1
}

[[ -f "$GUIDE" ]] || fail "missing standalone guide: methodPrompts/README_UserGuide.md"
[[ -f "$GUIDE_ZH" ]] || fail "missing Chinese standalone guide: methodPrompts/README_UserGuide_ZH.md"
[[ ! -f "$METHOD_DIR/CaTDD-UserGuide-PPT.md" ]] || fail "slide-oriented guide should be refactored away from methodPrompts/CaTDD-UserGuide-PPT.md"
[[ ! -f "$METHOD_DIR/CaTDD-UserGuide-PPT-ZH_CN.md" ]] || fail "Chinese slide-oriented guide should be refactored away from methodPrompts/CaTDD-UserGuide-PPT-ZH_CN.md"

grep -Fq '## Who' "$GUIDE" || fail "standalone guide missing Who section"
grep -Fq '## What' "$GUIDE" || fail "standalone guide missing What section"
grep -Fq '## When' "$GUIDE" || fail "standalone guide missing When section"
grep -Fq '## Where' "$GUIDE" || fail "standalone guide missing Where section"
grep -Fq '## Why' "$GUIDE" || fail "standalone guide missing Why section"
grep -Fq '## How' "$GUIDE" || fail "standalone guide missing How section"
grep -Fq '## Usage Example' "$GUIDE" || fail "standalone guide missing copy-exec Usage Example section"

grep -Fq 'methodPrompts/CaTDD_designAndImplTemplate.cxx' "$GUIDE" || fail "standalone guide missing template copy command"
grep -Fq 'Test/test_your_feature_funcValidTypical.cxx' "$GUIDE" || fail "standalone guide missing canonical test filename example"
grep -Fq 'methodPrompts/CaTDD_designAndImplTemplate.ts' "$GUIDE" || fail "standalone guide missing TypeScript template copy command"
grep -Fq 'Test/test_your_feature_funcValidTypical.ts' "$GUIDE" || fail "standalone guide missing TypeScript canonical test filename example"
grep -Fq 'CaTDD_methodPrompt.md' "$GUIDE" || fail "standalone guide missing master method prompt reference"
grep -Fq 'CaTDD_methodPrompt-categorySemantics.md' "$GUIDE" || fail "standalone guide missing category semantics subtopic reference"
grep -Fq 'CaTDD_methodPrompt-testPointDiscovery.md' "$GUIDE" || fail "standalone guide missing test point discovery subtopic reference"
grep -Fq 'CaTDD_methodPrompt-fileNaming.md' "$GUIDE" || fail "standalone guide missing file naming subtopic reference"
grep -Fq 'CaTDD_methodPrompt4Cat-Typical.md' "$GUIDE" || fail "standalone guide missing category prompt reference"
grep -Fq 'P0 Functional' "$GUIDE" || fail "standalone guide missing priority framework"
grep -Fq 'US/AC/TC' "$GUIDE" || fail "standalone guide missing US/AC/TC guidance"

grep -Fq '## 使用者' "$GUIDE_ZH" || fail "Chinese standalone guide missing 使用者 section"
grep -Fq '## Usage Example' "$GUIDE_ZH" || fail "Chinese standalone guide missing copy-exec Usage Example section"
grep -Fq 'methodPrompts/CaTDD_designAndImplTemplate.cxx' "$GUIDE_ZH" || fail "Chinese standalone guide missing template copy command"
grep -Fq 'Test/test_your_feature_funcValidTypical.cxx' "$GUIDE_ZH" || fail "Chinese standalone guide missing canonical test filename example"
grep -Fq 'methodPrompts/CaTDD_designAndImplTemplate.ts' "$GUIDE_ZH" || fail "Chinese standalone guide missing TypeScript template copy command"
grep -Fq 'Test/test_your_feature_funcValidTypical.ts' "$GUIDE_ZH" || fail "Chinese standalone guide missing TypeScript canonical test filename example"
grep -Fq 'CaTDD_methodPrompt-categorySemantics.md' "$GUIDE_ZH" || fail "Chinese standalone guide missing category semantics subtopic reference"
grep -Fq 'CaTDD_methodPrompt-testPointDiscovery.md' "$GUIDE_ZH" || fail "Chinese standalone guide missing test point discovery subtopic reference"
grep -Fq 'CaTDD_methodPrompt-fileNaming.md' "$GUIDE_ZH" || fail "Chinese standalone guide missing file naming subtopic reference"
grep -Fq 'CaTDD_methodPrompt4Cat-Typical.md' "$GUIDE_ZH" || fail "Chinese standalone guide missing category prompt reference"
grep -Fq 'P0 Functional' "$GUIDE_ZH" || fail "Chinese standalone guide missing priority framework"

[[ -f "$METHOD_DIR/CaTDD_methodPrompt-categorySemantics.md" ]] || fail "missing category semantics subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-testPointDiscovery.md" ]] || fail "missing test point discovery subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-workflow.md" ]] || fail "missing workflow subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-testStructure.md" ]] || fail "missing test structure subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-fileNaming.md" ]] || fail "missing file naming subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-agentWorkflow.md" ]] || fail "missing agent workflow subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-troubleshooting.md" ]] || fail "missing troubleshooting subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-examples.md" ]] || fail "missing examples subtopic"
grep -Fq 'CaTDD_methodPrompt-categorySemantics.md' "$MASTER_PROMPT" || fail "master method prompt missing category semantics subtopic link"
grep -Fq 'CaTDD_methodPrompt-testPointDiscovery.md' "$MASTER_PROMPT" || fail "master method prompt missing test point discovery subtopic link"
grep -Fq 'CaTDD_methodPrompt-fileNaming.md' "$MASTER_PROMPT" || fail "master method prompt missing file naming subtopic link"
grep -Fq 'test_{feature}_{category}.<ext>' "$MASTER_PROMPT" || fail "master method prompt missing canonical test filename pattern"
grep -Fq 'funcInvalidMisuse' "$MASTER_PROMPT" || fail "master method prompt missing P0 invalid misuse filename token"
grep -Fq 'designInteraction' "$MASTER_PROMPT" || fail "master method prompt missing P1 interaction filename token"
grep -Fq 'qualityPerformance' "$MASTER_PROMPT" || fail "master method prompt missing P2 quality performance filename token"
grep -Fq 'qualityDiagnosis' "$MASTER_PROMPT" || fail "master method prompt missing P2 diagnosis filename token"
grep -Fq 'qualitySecurity' "$MASTER_PROMPT" || fail "master method prompt missing P2 security filename token"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt4Cat-Interaction.md" ]] || fail "missing P1 interaction category prompt"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt4Cat-Diagnosis.md" ]] || fail "missing P2 diagnosis category prompt"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt4Cat-Security.md" ]] || fail "missing P2 security category prompt"
for category_prompt in "$METHOD_DIR"/CaTDD_methodPrompt4Cat-*.md; do
  grep -Fq '## TestPointsInMind' "$category_prompt" || fail "category prompt missing TestPointsInMind: ${category_prompt#$METHOD_DIR/}"
done
grep -Fq 'test_{feature}_{category}.cxx' "$CXX_TEMPLATE" || fail "C++ template missing canonical test filename guidance"
grep -Fq 'test_{feature}_{category}.ts' "$TS_TEMPLATE" || fail "TypeScript template missing canonical test filename guidance"
grep -Fq 'Test/test_your_feature_funcValidTypical.cxx' "$MAIN_GUIDE" || fail "main user guide missing canonical test filename example"
grep -Fq 'Test/test_your_feature_funcValidTypical.ts' "$MAIN_GUIDE" || fail "main user guide missing TypeScript canonical test filename example"

grep -Fq 'This README is the WHAT / WHY entry point' "$METHOD_DIR/README.md" || fail "methodPrompts README must own WHAT/WHY"
grep -Fq 'HOW, WHO, WHEN, and WHERE' "$METHOD_DIR/README.md" || fail "methodPrompts README must delegate HOW/WHO/WHEN/WHERE to UserGuide"
grep -Fq 'Standalone user guides (`README_UserGuide.md`, `README_UserGuide_ZH.md`)' "$METHOD_DIR/README.md" || fail "methodPrompts README missing standalone guide entries"
grep -Fq '本 README 是方法层的 WHAT / WHY 入口' "$METHOD_DIR/README_ZH.md" || fail "methodPrompts Chinese README must own WHAT/WHY"
grep -Fq 'HOW、WHO、WHEN、WHERE' "$METHOD_DIR/README_ZH.md" || fail "methodPrompts Chinese README must delegate HOW/WHO/WHEN/WHERE to UserGuide"
grep -Fq '独立用户指南（`README_UserGuide.md`、`README_UserGuide_ZH.md`）' "$METHOD_DIR/README_ZH.md" || fail "methodPrompts Chinese README missing standalone guide entries"
grep -Fq '[methodPrompts/README_UserGuide.md](methodPrompts/README_UserGuide.md)' "$MAIN_GUIDE" || fail "main user guide missing methodPrompts sub-user-guide link"
grep -Fq '[methodPrompts/README_UserGuide_ZH.md](methodPrompts/README_UserGuide_ZH.md)' "$MAIN_GUIDE" || fail "main user guide missing ZH methodPrompts sub-user-guide link"

# SUT: methodPrompts (P0/P1/P2 command integration included).
# @[Class]: P0 Functional / ValidFunc
# @[Category]: Typical
# @[US]: US-DISCOVERY-01 — source-first discovery exposes missing behavior,
# not merely dangling US/AC/TC links. Source: developer-requested method contract.
# @[AC]: AC-DISCOVERY-01..05 — GIVEN the standalone method and P0 commands,
# WHEN their contracts are checked, THEN discovery, readiness, and routing
# remain explicit. These checks verify text contracts, not semantic completeness.
assert_discovery_contract() {
  local path="$1"
  local text="$2"
  grep -Fq "$text" "$path" || fail "${path#$REPO_ROOT/} missing discovery contract: $text"
}

assert_discovery_section() {
  local path="$1"
  local heading="$2"
  local text="$3"
  awk -v heading="$heading" '
    $0 == heading { selected = 1; next }
    selected && /^## / { exit }
    selected { print }
  ' "$path" | grep -F "$text" > /dev/null \
    || fail "${path#$REPO_ROOT/} missing contract in $heading: $text"
}

assert_discovery_absent() {
  local path="$1"
  local text="$2"
  if grep -Fq "$text" "$path"; then
    fail "${path#$REPO_ROOT/} retains conflicting discovery contract: $text"
  fi
}

assert_discovery_order() {
  local path="$1"
  local first="$2"
  local second="$3"
  awk -v first="$first" -v second="$second" '
    index($0, first) && !first_line { first_line = NR }
    index($0, second) && !second_line { second_line = NR }
    END { exit !(first_line && second_line && first_line < second_line) }
  ' "$path" || fail "${path#$REPO_ROOT/} must place '$first' before '$second'"
}

# [@AC-DISCOVERY-01,US-DISCOVERY-01] TC-DISCOVERY-01: inventory before skeletons.
DISCOVERY="$METHOD_DIR/CaTDD_methodPrompt-testPointDiscovery.md"
for heading in '## Behavior Inventory' '## Stage-0 Elicitation Toolkit' \
  '## P0 Discovery Sweep' '## P1 Design Discovery Sweep' '## P2 Quality Discovery Sweep' \
  '## P3 Addons Discovery Sweep' '## Domain Archetype Discovery (Embedded, Microservice, LLM Agent)' \
  '## Test-Point Ledger'; do
  assert_discovery_contract "$DISCOVERY" "$heading"
done
for disposition in DESIGNED QUESTION EXCLUDED REFERRED GAP; do
  assert_discovery_contract "$DISCOVERY" "$disposition"
done

# [@AC-DISCOVERY-02,US-DISCOVERY-01] TC-DISCOVERY-02: honest readiness and feedback.
for contract in '## Discovery Gate' '## Escaped-Bug Feedback' '## Usage Example' \
  'discovery_status' 'ready_for_implementation' 'accounted for does not mean covered' \
  'does not guarantee' 'pairwise' 'TP-05' '### Report Consistency Audit'; do
  assert_discovery_contract "$DISCOVERY" "$contract"
done

# [@AC-DISCOVERY-03,US-DISCOVERY-01] TC-DISCOVERY-03: all method entry routes.
for method_entry in "$MASTER_PROMPT" \
  "$METHOD_DIR/CaTDD_methodPrompt-workflow.md" \
  "$METHOD_DIR/CaTDD_methodPrompt-testStructure.md" \
  "$METHOD_DIR/CaTDD_methodPrompt-agentWorkflow.md"; do
  assert_discovery_contract "$method_entry" 'CaTDD_methodPrompt-testPointDiscovery.md'
  assert_discovery_contract "$method_entry" 'Discovery Gate'
done
for category in Typical Edge Misuse Fault State Capability Interaction Concurrency \
  Performance Robust Compatibility Configuration Diagnosis Security DemoExample; do
  assert_discovery_contract "$METHOD_DIR/CaTDD_methodPrompt4Cat-$category.md" 'CaTDD_methodPrompt-testPointDiscovery.md'
done

# [@AC-DISCOVERY-04,US-DISCOVERY-01] TC-DISCOVERY-04: command handoff and blind spots.
P0_COMMANDS="$REPO_ROOT/slashCommands/commands/P0-FuncTestsFlow"
for command in UT_designFuncTestsSkeleton UT_reviewFuncTestsSkeleton; do
  assert_discovery_contract "$P0_COMMANDS/$command.md" 'CaTDD_methodPrompt-testPointDiscovery.md'
  assert_discovery_contract "$P0_COMMANDS/$command.md" 'discovery_ledger'
  assert_discovery_contract "$P0_COMMANDS/$command.md" 'ready_for_implementation'
done
assert_discovery_contract "$P0_COMMANDS/UT_reviewFuncTestsSkeleton.md" 'no existing US/AC/TC ID'
assert_discovery_contract "$P0_COMMANDS/UT_tellMeNextImplTest.md" 'review_evidence'
assert_discovery_contract "$P0_COMMANDS/UT_tellMeNextImplTest.md" 'ready_for_implementation'

P1_REVIEW="$REPO_ROOT/slashCommands/commands/P1-DesignTestsFlow/UT_reviewDesignTestsSkeleton.md"
assert_discovery_contract "$P1_REVIEW" 'CaTDD_methodPrompt-testPointDiscovery.md'
assert_discovery_contract "$P1_REVIEW" 'P1 Discovery Gate'

P2_REVIEW="$REPO_ROOT/slashCommands/commands/P2-QualityTestsFlow/UT_reviewQualityTestsSkeleton.md"
assert_discovery_contract "$P2_REVIEW" 'CaTDD_methodPrompt-testPointDiscovery.md'
assert_discovery_contract "$P2_REVIEW" 'P2 Discovery Gate'

# [@AC-DISCOVERY-05,US-DISCOVERY-01] TC-DISCOVERY-05: standalone EN/ZH adoption.
for guide in "$GUIDE" "$GUIDE_ZH"; do
  assert_discovery_contract "$guide" 'discovery_ledger'
  assert_discovery_contract "$guide" 'ready_for_implementation'
done

# @[US]: US-DISCOVERY-02 — as a method user, I want comprehensive sweeps
# to preserve source-defined meaning rather than invent requirements.
# Source: accepted correctness/consistency review; staged-file-only scope.
# Purpose/Covered: AC-DISCOVERY-06..11 cover oracle validity, lens-based
# routing, optional domain prompts, bounded reviews, direct design routes,
# and the distinction between handoff acceptance and scope exclusion.
# Status: TC-DISCOVERY-06..11 each exposed the intended missing contract
# before its correction and then passed. Rerun to verify the current files.
# Manual: bash scripts/test_methodPrompts_standalone_user_guide.sh
# These are text-contract regressions, not a semantic discovery benchmark.

# [@AC-DISCOVERY-06,US-DISCOVERY-02] TC-DISCOVERY-06:
# GIVEN source-defined symbolic or manually observed outcomes, WHEN the
# discovery contract is read, THEN it does not demand invented numeric targets
# or automation as a prerequisite for a valid oracle.
assert_discovery_section "$DISCOVERY" '## P2 Quality Discovery Sweep' 'numeric thresholds or exact predicates'
assert_discovery_section "$DISCOVERY" '## Stage-0 Elicitation Toolkit' 'Manual or hybrid verification is valid'
assert_discovery_absent "$DISCOVERY" 'A quality scenario lacking a quantitative Response Measure cannot be tested'

# [@AC-DISCOVERY-07,US-DISCOVERY-02] TC-DISCOVERY-07:
# GIVEN a source-backed obligation, WHEN rule tags or handoff destinations
# change, THEN category identity and in-scope readiness cannot be bypassed.
assert_discovery_section "$DISCOVERY" '## Stage-0 Elicitation Toolkit' 'Rule type does not determine CaTDD category'
assert_discovery_section "$DISCOVERY" '## Test-Point Ledger' 'Routing is independent of disposition'
assert_discovery_section "$DISCOVERY" '## Discovery Gate' 'An in-scope obligation in any class remains GAP'

# [@AC-DISCOVERY-08,US-DISCOVERY-02] TC-DISCOVERY-08:
# GIVEN the embedded-first usage priority, WHEN a domain prompt is selected,
# THEN it remains optional source-backed guidance, not an invented threshold,
# a historical claim, or an assumption about MMIO atomics.
assert_discovery_contract "$MASTER_PROMPT" 'primarily Embedded Linux, secondarily Microservices, and thirdly LLM Agents'
assert_discovery_section "$DISCOVERY" '## Domain Archetype Discovery (Embedded, Microservice, LLM Agent)' 'not a historical lineage'
for category in Typical Edge Misuse Fault State Capability Interaction Concurrency \
  Performance Robust Compatibility Configuration Diagnosis Security DemoExample; do
  category_prompt="$METHOD_DIR/CaTDD_methodPrompt4Cat-$category.md"
  assert_discovery_section "$category_prompt" '## TestPointsInMind' 'optional prompts, not requirements'
  assert_discovery_section "$category_prompt" '## TestPointsInMind' 'discovery_ledger'
done
assert_discovery_absent "$METHOD_DIR/CaTDD_methodPrompt4Cat-Edge.md" '($95\%$ token capacity)'
assert_discovery_absent "$METHOD_DIR/CaTDD_methodPrompt4Cat-Performance.md" '50\text{ms}'
assert_discovery_absent "$METHOD_DIR/CaTDD_methodPrompt4Cat-Concurrency.md" 'atomic compare-and-swap on shared device memory'

# [@AC-DISCOVERY-09,US-DISCOVERY-02] TC-DISCOVERY-09:
# GIVEN a P1/P2 review request, WHEN its execution and output contracts are
# followed, THEN source-first evidence, a bounded stop, and explicit readiness
# are required even for omissions without an existing TC.
for review in "$P1_REVIEW" "$P2_REVIEW"; do
  assert_discovery_order "$review" 'Read source artifacts first' 'Read the discovery_ledger and skeletons'
  assert_discovery_section "$review" '## CoT Pattern' 'at most two repair/recheck rounds'
  assert_discovery_absent "$review" 'Repeat until every'
  assert_discovery_contract "$review" 'no existing US/AC/TC ID'
  for field in discovery_ledger review_evidence cardinality_gate discovery_status ready_for_implementation; do
    assert_discovery_section "$review" '## Output Contract' "$field"
  done
done
assert_discovery_section "$P1_REVIEW" '## Preconditions' 'every State, Capability, Interaction, or Concurrency skeleton'
assert_discovery_section "$P2_REVIEW" '## Preconditions' 'numeric budgets or exact predicates'

# [@AC-DISCOVERY-10,US-DISCOVERY-02] TC-DISCOVERY-10:
# GIVEN categories without dedicated design commands, WHEN following the flow
# or standalone guide, THEN an explicit source-gated direct method route exists
# and verification methods/readiness remain visible.
P1_FLOW="$REPO_ROOT/slashCommands/flows/P1-DesignTestsFlow.md"
P2_FLOW="$REPO_ROOT/slashCommands/flows/P2-QualityTestsFlow.md"
assert_discovery_section "$P1_FLOW" '## Command Sequence' 'CaTDD_methodPrompt4Cat-Interaction.md'
assert_discovery_section "$P1_FLOW" '## Flow Diagram' 'Interaction --> Review'
for category in Diagnosis Security; do
  assert_discovery_section "$P2_FLOW" '## Command Sequence' "CaTDD_methodPrompt4Cat-$category.md"
  assert_discovery_section "$P2_FLOW" '## Flow Diagram' "$category --> Review"
done
for flow in "$P1_FLOW" "$P2_FLOW"; do
  assert_discovery_section "$flow" '## Discovery Handoff' 'discovery_ledger'
  assert_discovery_section "$flow" '## Command Sequence' 'ready_for_implementation: yes'
done
for guide in "$GUIDE" "$GUIDE_ZH"; do
  assert_discovery_section "$guide" '## Usage Example' 'verification_method'
  assert_discovery_absent "$guide" 'Apply Stage-0 elicitation (OOPSI, Business Rules, Ambiguity hunting) and identify domain archetype risks'
done

# [@AC-DISCOVERY-11,US-DISCOVERY-02] TC-DISCOVERY-11:
# GIVEN an accepted owner/destination but no adequate TC, WHEN the obligation
# stays in scope, THEN its disposition is GAP, not REFERRED. An illustrative
# agent check still conflated acceptance with a scope change; lock in explicit
# contrasting cases rather than treating that check's overall PASS as proof.
# A narrow replay matched GAP/no readiness after the clarification; this does
# not establish general agent compliance or measured omission reduction.
assert_discovery_section "$DISCOVERY" '## Test-Point Ledger' 'In scope; destination/owner accepted; no adequate TC | GAP'
assert_discovery_section "$DISCOVERY" '## Test-Point Ledger' 'Explicitly out of scope; destination/owner accepted | REFERRED'
assert_discovery_section "$DISCOVERY" '## Test-Point Ledger' 'Handoff acceptance never changes scope'

# [@AC-DISCOVERY-12,US-DISCOVERY-02] TC-DISCOVERY-12:
# GIVEN UbiLang and method contracts, WHEN SUT, UT, TP, TC, and TestEvidenceChain are checked,
# THEN SUT defines the Misuse vs Fault boundary, UT adheres to sut_unit_convention,
# AC vs TP (User vs Developer perspective) and TP vs TC cardinality are explicit,
# and TestEvidenceChain answers WHY and HOW.
assert_discovery_contract "$REPO_ROOT/README_UbiLang.md" 'System Under Test'
assert_discovery_contract "$REPO_ROOT/README_UbiLang.md" 'Unit Testing'
assert_discovery_contract "$REPO_ROOT/README_UbiLang.md" 'Test Point'
assert_discovery_contract "$REPO_ROOT/README_UbiLang.md" 'Test Case'
assert_discovery_contract "$REPO_ROOT/README_UbiLang.md" 'TestEvidenceChain'
assert_discovery_contract "$REPO_ROOT/README_UbiLang.md" 'AC vs TP'
assert_discovery_contract "$REPO_ROOT/README_UbiLang.md" 'Discovery to Categorization'
assert_discovery_contract "$REPO_ROOT/README_UbiLang_ZH.md" '被测系统'
assert_discovery_contract "$REPO_ROOT/README_UbiLang_ZH.md" '单元测试'
assert_discovery_contract "$REPO_ROOT/README_UbiLang_ZH.md" '测试点'
assert_discovery_contract "$REPO_ROOT/README_UbiLang_ZH.md" '测试用例'
assert_discovery_contract "$REPO_ROOT/README_UbiLang_ZH.md" '测试证据链'
assert_discovery_contract "$REPO_ROOT/README_UbiLang_ZH.md" 'AC vs TP'
assert_discovery_contract "$REPO_ROOT/README_UbiLang_ZH.md" 'Discovery to Categorization'
assert_discovery_section "$MASTER_PROMPT" '## Mandatory Traceability Constraints' 'SUT (System Under Test)'
assert_discovery_section "$MASTER_PROMPT" '## Mandatory Traceability Constraints' 'sut_unit_convention'
assert_discovery_section "$MASTER_PROMPT" '## Test-Point Discovery Contract' 'TestEvidenceChain'
assert_discovery_section "$MASTER_PROMPT" '## Test-Point Discovery Contract' 'Distinguish Acceptance Criteria (AC) from Test Point (TP)'
assert_discovery_section "$MASTER_PROMPT" '## Test-Point Discovery Contract' 'Distinguish Test Point (TP) from Test Case (TC)'
assert_discovery_section "$DISCOVERY" '## Test-Point Ledger' '### Acceptance Criteria (AC) vs. Test Point (TP)'
assert_discovery_section "$DISCOVERY" '## Test-Point Ledger' '### Test Point (TP) vs. Test Case (TC)'
assert_discovery_contract "$DISCOVERY" 'TestEvidenceChain'
assert_discovery_absent "$DISCOVERY" 'TestPointEvidenceChain'
assert_discovery_section "$METHOD_DIR/CaTDD_methodPrompt-categorySemantics.md" '## P0 Functional Split' 'declared SUT boundary'

echo "[methodPrompts-standalone-guide-test] PASSED: methodPrompts has standalone user guide"