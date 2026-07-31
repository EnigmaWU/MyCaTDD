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
grep -Fq 'CaTDD_methodPrompt-fileNaming.md' "$GUIDE_ZH" || fail "Chinese standalone guide missing file naming subtopic reference"
grep -Fq 'CaTDD_methodPrompt4Cat-Typical.md' "$GUIDE_ZH" || fail "Chinese standalone guide missing category prompt reference"
grep -Fq 'P0 Functional' "$GUIDE_ZH" || fail "Chinese standalone guide missing priority framework"

[[ -f "$METHOD_DIR/CaTDD_methodPrompt-categorySemantics.md" ]] || fail "missing category semantics subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-workflow.md" ]] || fail "missing workflow subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-testStructure.md" ]] || fail "missing test structure subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-fileNaming.md" ]] || fail "missing file naming subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-agentWorkflow.md" ]] || fail "missing agent workflow subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-troubleshooting.md" ]] || fail "missing troubleshooting subtopic"
[[ -f "$METHOD_DIR/CaTDD_methodPrompt-examples.md" ]] || fail "missing examples subtopic"
grep -Fq 'CaTDD_methodPrompt-categorySemantics.md' "$MASTER_PROMPT" || fail "master method prompt missing category semantics subtopic link"
grep -Fq 'CaTDD_methodPrompt-fileNaming.md' "$MASTER_PROMPT" || fail "master method prompt missing file naming subtopic link"
grep -Fq 'test_{feature}_{category}.<ext>' "$MASTER_PROMPT" || fail "master method prompt missing canonical test filename pattern"
grep -Fq 'funcInvalidMisuse' "$MASTER_PROMPT" || fail "master method prompt missing P0 invalid misuse filename token"
grep -Fq 'qualityPerformance' "$MASTER_PROMPT" || fail "master method prompt missing P2 quality performance filename token"
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

echo "[methodPrompts-standalone-guide-test] PASSED: methodPrompts has standalone user guide"