#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CODE_AGENTS_DIR="$REPO_ROOT/codeAgents"
README="$CODE_AGENTS_DIR/README.md"
UT_AGENT_DIR="$CODE_AGENTS_DIR/utCodeAgentCLI"
LEGACY_UT_AGENT_DIR="$REPO_ROOT/utCodeAgentCLI"
SPEC_AGENT_README="$CODE_AGENTS_DIR/specCodeAgentCLI/README.md"
SPEC_AGENT_USAGE_DESIGN="$CODE_AGENTS_DIR/specCodeAgentCLI/README_UsageDesign.md"

fail() {
  echo "[codeAgents-structure-test] $*" >&2
  exit 1
}

[[ -d "$CODE_AGENTS_DIR" ]] || fail "missing codeAgents directory"
[[ -f "$README" ]] || fail "missing codeAgents/README.md"
[[ -d "$UT_AGENT_DIR" ]] || fail "missing moved codeAgents/utCodeAgentCLI directory"
[[ -f "$UT_AGENT_DIR/README.md" ]] || fail "missing moved codeAgents/utCodeAgentCLI/README.md"
[[ -f "$UT_AGENT_DIR/README_UsageDesign.md" ]] || fail "missing moved codeAgents/utCodeAgentCLI/README_UsageDesign.md"
[[ ! -e "$LEGACY_UT_AGENT_DIR" ]] || fail "legacy top-level utCodeAgentCLI directory should be removed"
[[ -f "$SPEC_AGENT_README" ]] || fail "missing codeAgents/specCodeAgentCLI/README.md"
[[ -f "$SPEC_AGENT_USAGE_DESIGN" ]] || fail "missing codeAgents/specCodeAgentCLI/README_UsageDesign.md"

grep -Fq 'utCodeAgentCLI' "$README" || fail "codeAgents README must include utCodeAgentCLI"
grep -Fq 'deprecated' "$README" || fail "codeAgents README must mark utCodeAgentCLI as deprecated"
grep -Fq 'specCodeAgentCLI' "$README" || fail "codeAgents README must include specCodeAgentCLI"
grep -Fq 'based on CaTDD' "$README" || fail "codeAgents README must describe utCodeAgentCLI as based on CaTDD"
grep -Fq 'based on Px-SpecFlow' "$README" || fail "codeAgents README must describe specCodeAgentCLI as based on Px-SpecFlow"

grep -Fq 'autonomousMode' "$SPEC_AGENT_USAGE_DESIGN" || fail "specCodeAgentCLI UsageDesign must document autonomousMode"
grep -Fq 'manualMode' "$SPEC_AGENT_USAGE_DESIGN" || fail "specCodeAgentCLI UsageDesign must document manualMode"
grep -Fq -- '--goal' "$SPEC_AGENT_USAGE_DESIGN" || fail "specCodeAgentCLI UsageDesign must document --goal"
grep -Fq -- '--command' "$SPEC_AGENT_USAGE_DESIGN" || fail "specCodeAgentCLI UsageDesign must document --command"
grep -Fq -- '--config-file' "$SPEC_AGENT_USAGE_DESIGN" || fail "specCodeAgentCLI UsageDesign must document --config-file"
grep -Fq 'MANUAL_REQUIRED' "$SPEC_AGENT_USAGE_DESIGN" || fail "specCodeAgentCLI UsageDesign must document MANUAL_REQUIRED exit code"
grep -Fq 'zero dependency on `utCodeAgentCLI`' "$SPEC_AGENT_USAGE_DESIGN" || fail "specCodeAgentCLI UsageDesign must state zero dependency on deprecated utCodeAgentCLI"

echo "[codeAgents-structure-test] PASSED: codeAgents directory documents ut/spec agent scope and specCodeAgentCLI UsageDesign"
