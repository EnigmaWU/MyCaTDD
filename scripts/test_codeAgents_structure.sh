#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CODE_AGENTS_DIR="$REPO_ROOT/codeAgents"
README="$CODE_AGENTS_DIR/README.md"

fail() {
  echo "[codeAgents-structure-test] $*" >&2
  exit 1
}

[[ -d "$CODE_AGENTS_DIR" ]] || fail "missing codeAgents directory"
[[ -f "$README" ]] || fail "missing codeAgents/README.md"

grep -Fq 'utCodeAgentCLI' "$README" || fail "codeAgents README must include utCodeAgentCLI"
grep -Fq 'specCodeAgentCLI' "$README" || fail "codeAgents README must include specCodeAgentCLI"
grep -Fq 'based on CaTDD' "$README" || fail "codeAgents README must describe utCodeAgentCLI as based on CaTDD"
grep -Fq 'based on Px-SpecFlow' "$README" || fail "codeAgents README must describe specCodeAgentCLI as based on Px-SpecFlow"

echo "[codeAgents-structure-test] PASSED: codeAgents directory documents ut/spec agent scope"
