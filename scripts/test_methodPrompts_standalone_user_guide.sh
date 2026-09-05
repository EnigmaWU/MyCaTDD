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

# SUT: methodPrompts (P0 command integration included).
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

# [@AC-DISCOVERY-01,US-DISCOVERY-01] TC-DISCOVERY-01: inventory before skeletons.
DISCOVERY="$METHOD_DIR/CaTDD_methodPrompt-testPointDiscovery.md"
for heading in '## Behavior Inventory' '## P0 Discovery Sweep' '## Test-Point Ledger'; do
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
for category in Typical Edge Misuse Fault; do
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

# [@AC-DISCOVERY-05,US-DISCOVERY-01] TC-DISCOVERY-05: standalone EN/ZH adoption.
for guide in "$GUIDE" "$GUIDE_ZH"; do
  assert_discovery_contract "$guide" 'discovery_ledger'
  assert_discovery_contract "$guide" 'ready_for_implementation'
done

echo "[methodPrompts-standalone-guide-test] PASSED: methodPrompts has standalone user guide"