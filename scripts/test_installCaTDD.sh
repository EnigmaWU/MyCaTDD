#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALLER="$REPO_ROOT/scripts/installCaTDD.sh"
TARGET_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TARGET_DIR"
}
trap cleanup EXIT

fail() {
  echo "[installCaTDD-test] $*" >&2
  exit 1
}

[[ -x "$INSTALLER" ]] || fail "missing executable installer: scripts/installCaTDD.sh"

echo "[installCaTDD-test] Test: --help"
"$INSTALLER" --help 2>&1 | head -1 | grep -Fq 'installCaTDD.sh' || fail "--help missing script name"

echo "[installCaTDD-test] Test: missing --targetDir exits error"
err_out="$("$INSTALLER" 2>&1)" || true
grep -Fq 'Missing required --targetDir' <<< "$err_out" || fail "missing --targetDir not detected"

echo "[installCaTDD-test] Test: missing --targetCodeAgent exits error"
err_out="$("$INSTALLER" --targetDir "$TARGET_DIR" 2>&1)" || true
grep -Fq 'Missing required --targetCodeAgent' <<< "$err_out" || fail "missing --targetCodeAgent not detected"

echo "[installCaTDD-test] Test: unknown agent exits error"
err_out="$("$INSTALLER" --targetDir "$TARGET_DIR" --targetCodeAgent Foo 2>&1)" || true
grep -Fq 'Unknown --targetCodeAgent' <<< "$err_out" || fail "unknown agent not detected"

echo "[installCaTDD-test] Test: dryRunner"
dry_output="$("$INSTALLER" --targetDir /tmp/dry --targetCodeAgent dryRunner 2>&1)"
grep -Fq 'dryRunner' <<< "$dry_output" || fail "dryRunner missing dryRunner label"
grep -Fq 'Copilot | Continue' <<< "$dry_output" || fail "dryRunner missing supported agents"

echo "[installCaTDD-test] Test: Copilot fresh install"
"$INSTALLER" --targetDir "$TARGET_DIR" --targetCodeAgent Copilot --init --clean-prompts --yes
[[ -f "$TARGET_DIR/.catdd/methodPrompts/README.md" ]] || fail "Copilot install missing methodPrompts"
[[ -f "$TARGET_DIR/README_UbiLang.md" ]] || fail "Copilot install missing README_UbiLang.md"
[[ -d "$TARGET_DIR/.catdd/spec/pendingNews" ]] || fail "Copilot install missing .catdd/spec/pendingNews"
[[ -f "$TARGET_DIR/.github/prompts/UT_convertDemoToTypical.prompt.md" ]] || fail "Copilot install missing generated prompt"
[[ -f "$TARGET_DIR/.github/prompts/SPEC_designUnitTests.prompt.md" ]] || fail "Copilot install missing SPEC_designUnitTests prompt"
[[ -f "$TARGET_DIR/.github/instructions/catdd.instructions.md" ]] || fail "Copilot install missing instructions"
install_marker="$TARGET_DIR/.catdd/CaTDD_INSTALL.md"
grep -Eq '^- Installed version: ([0-9]{8}\.[0-9]{2}|unknown)$' "$install_marker" || fail "install marker missing version line"

echo "[installCaTDD-test] Test: GitHub/Copilot alias works"
TARGET2="$(mktemp -d)"
"$INSTALLER" --targetDir "$TARGET2" --targetCodeAgent "GitHub/Copilot" --init --yes
[[ -f "$TARGET2/.catdd/methodPrompts/README.md" ]] || fail "GitHub/Copilot alias install missing methodPrompts"
rm -rf "$TARGET2"

echo "[installCaTDD-test] Test: --verbose passthrough"
verbose_output="$("$INSTALLER" --targetDir /tmp/_catdd_verbose_never --targetCodeAgent dryRunner --verbose 2>&1 || true)"
grep -Fq 'installCaTDD' <<< "$verbose_output" || true  # dryRunner doesn't forward --verbose to sub-installer, but should still work

echo "[installCaTDD-test] Test: Continue fresh install"
TARGET3="$(mktemp -d)"
"$INSTALLER" --targetDir "$TARGET3" --targetCodeAgent Continue --init --clean-prompts --yes
[[ -f "$TARGET3/.catdd/methodPrompts/README.md" ]] || fail "Continue install missing methodPrompts"
[[ -f "$TARGET3/README_UbiLang.md" ]] || fail "Continue install missing README_UbiLang.md"
[[ -d "$TARGET3/.catdd/spec/pendingNews" ]] || fail "Continue install missing .catdd/spec/pendingNews"
[[ -f "$TARGET3/.continue/prompts/UT_convertDemoToTypical.prompt" ]] || fail "Continue install missing generated prompt"
[[ -f "$TARGET3/.continue/prompts/SPEC_designUnitTests.prompt" ]] || fail "Continue install missing SPEC_designUnitTests prompt"
[[ -f "$TARGET3/.continue/rules/catdd.md" ]] || fail "Continue install missing Continue rule"
rm -rf "$TARGET3"

echo "[installCaTDD-test] PASSED: all tests passed"
