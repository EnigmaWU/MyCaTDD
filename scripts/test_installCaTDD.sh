#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALLER="$REPO_ROOT/scripts/installCaTDD.sh"
WORK="$(mktemp -d)"

cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

fail() {
  echo "[installCaTDD-test] $*" >&2
  exit 1
}

assert_file() {
  [[ -f "$1" ]] || fail "missing file: $1"
}

assert_dir() {
  [[ -d "$1" ]] || fail "missing dir: $1"
}

assert_absent() {
  [[ ! -e "$1" ]] || fail "unexpected file: $1"
}

assert_contains() {
  grep -Fq "$2" "$1" || fail "$1 missing expected content: $2"
}

assert_not_contains() {
  ! grep -Fq "$2" "$1" || fail "$1 should not contain: $2"
}

[[ -x "$INSTALLER" ]] || fail "missing executable installer: scripts/installCaTDD.sh"

echo "[installCaTDD-test] Test: --help"
"$INSTALLER" --help 2>&1 | head -1 | grep -Fq 'installCaTDD.sh' || fail "--help missing script name"

echo "[installCaTDD-test] Test: missing --targetDir exits error"
err_out="$("$INSTALLER" 2>&1)" || true
grep -Fq 'Missing required --targetDir' <<< "$err_out" || fail "missing --targetDir not detected"

echo "[installCaTDD-test] Test: missing --targetCodeAgent exits error"
err_out="$("$INSTALLER" --targetDir "$WORK" 2>&1)" || true
grep -Fq 'Missing required --targetCodeAgent' <<< "$err_out" || fail "missing --targetCodeAgent not detected"

echo "[installCaTDD-test] Test: unknown agent exits error"
err_out="$("$INSTALLER" --targetDir "$WORK" --targetCodeAgent Foo 2>&1)" || true
grep -Fq 'Unknown --targetCodeAgent' <<< "$err_out" || fail "unknown agent not detected"

echo "[installCaTDD-test] Test: dryRunner"
dry_output="$("$INSTALLER" --targetDir "$WORK/dry" --targetCodeAgent dryRunner 2>&1)"
grep -Fq 'dryRunner' <<< "$dry_output" || fail "dryRunner missing dryRunner label"
grep -Fq 'Copilot | Continue | Cline | Antigravity' <<< "$dry_output" || fail "dryRunner missing supported agents"

echo "[installCaTDD-test] Test: per-agent fresh installs"
install_fresh() {
  local agent="$1"
  local dir="$WORK/fresh-$agent"
  local marker
  echo "[installCaTDD-test]   agent: $agent"
  "$INSTALLER" --targetDir "$dir" --targetCodeAgent "$agent" --init --clean-prompts --yes >/dev/null 2>&1
  assert_file "$dir/.catdd/methodPrompts/README.md"
  assert_file "$dir/.catdd/slashCommands/UT_slashCommandTemplate.md"
  assert_dir "$dir/.catdd/spec/pendingNews"
  assert_absent "$dir/README_UbiLang.md"
  assert_file "$dir/.catdd/CaTDD_INSTALL.manifest"
  assert_dir "$dir/.catdd/.install-baseline/methodPrompts"
  assert_dir "$dir/.catdd/.install-baseline/slashCommands"
  marker="$dir/.catdd/CaTDD_INSTALL.md"
  grep -Eq '^- Installed version: ([0-9]{8}\.[0-9]{2}|unknown)$' "$marker" || fail "install marker missing version line"

  case "$agent" in
    Copilot)
      assert_file "$dir/.github/instructions/catdd.instructions.md"
      assert_contains "$dir/.github/instructions/catdd.instructions.md" '/HARNESS_evolveHarness'
      assert_file "$dir/.github/prompts/UT_convertDemoToTypical.prompt.md"
      assert_file "$dir/.github/prompts/SPEC_openUserStory.prompt.md"
      assert_file "$dir/.github/prompts/HARNESS_patchCaTDDSource.prompt.md"
      assert_file "$dir/.github/prompts/HARNESS_verifyInstallation.prompt.md"
      assert_file "$dir/.github/prompts/HARNESS_diagnoseInstallation.prompt.md"
      assert_contains "$dir/.github/prompts/UT_convertDemoToTypical.prompt.md" 'thin Copilot adapter'
      source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | wc -l | tr -d '[:space:]')"
      prompt_count="$(find "$dir/.github/prompts" -type f \( -name 'UT_*.prompt.md' -o -name 'SPEC_*.prompt.md' -o -name 'HARNESS_*.prompt.md' \) | wc -l | tr -d '[:space:]')"
      [[ "$prompt_count" == "$source_count" ]] || fail "expected $source_count installed Copilot prompts, got $prompt_count"
      ;;
    Continue)
      assert_file "$dir/.continue/rules/catdd.md"
      assert_contains "$dir/.continue/rules/catdd.md" '.continue/prompts/UT_*.prompt'
      assert_contains "$dir/.continue/rules/catdd.md" '/HARNESS_evolveHarness'
      assert_file "$dir/.continue/prompts/UT_convertDemoToTypical.prompt"
      assert_file "$dir/.continue/prompts/SPEC_openUserStory.prompt"
      ;;
    Cline)
      assert_file "$dir/.clinerules/catdd.md"
      assert_contains "$dir/.clinerules/catdd.md" '/HARNESS_evolveHarness'
      assert_dir "$dir/.cline/skills"
      ;;
    Antigravity)
      assert_file "$dir/.antigravityrules/catdd.md"
      assert_contains "$dir/.antigravityrules/catdd.md" '/HARNESS_evolveHarness'
      ;;
  esac

  replacement_output="$("$INSTALLER" --targetDir "$dir" --targetCodeAgent "$agent" --clean-prompts --yes 2>&1)"
  grep -Fq '] version:' <<< "$replacement_output" || fail "installer missing version action output on reinstall"
  grep -Fq '(same version, replacement)' <<< "$replacement_output" || fail "reinstall should report same-version replacement"
  rm -rf "$dir"
}

for agent in Copilot Continue Cline Antigravity; do
  install_fresh "$agent"
done

echo "[installCaTDD-test] Test: GitHub/Copilot alias works"
TARGET2="$WORK/alias"
"$INSTALLER" --targetDir "$TARGET2" --targetCodeAgent "GitHub/Copilot" --init --yes >/dev/null 2>&1
assert_file "$TARGET2/.catdd/methodPrompts/README.md"

echo "[installCaTDD-test] Test: evolved file survives refresh, --force-overwrite restores canonical"
S1="$WORK/sync-keep"
"$INSTALLER" --targetDir "$S1" --targetCodeAgent Copilot --init --clean-prompts --yes >/dev/null 2>&1
EV1="$S1/.catdd/slashCommands/commands/Px-HarnessKits/HARNESS_evolveHarness.md"
printf '\n<!-- EVOLVED-LINE-TEST -->\n' >> "$EV1"
keep_output="$("$INSTALLER" --targetDir "$S1" --targetCodeAgent Copilot --clean-prompts --yes 2>&1)"
grep -Fq 'kept-local' <<< "$keep_output" || fail "evolved file not reported as kept-local"
grep -Fq 'same version, replacement' <<< "$keep_output" || fail "same-version refresh did not report replacement"
assert_contains "$EV1" 'EVOLVED-LINE-TEST'
"$INSTALLER" --targetDir "$S1" --targetCodeAgent Copilot --clean-prompts --yes --force-overwrite >/dev/null 2>&1
assert_not_contains "$EV1" 'EVOLVED-LINE-TEST'

echo "[installCaTDD-test] Test: three-way merge, conflict keep, and upstream propagation"
FIX="$WORK/fixture"
mkdir -p "$FIX"
cp -R "$REPO_ROOT/methodPrompts" "$FIX/methodPrompts"
cp -R "$REPO_ROOT/slashCommands" "$FIX/slashCommands"
S2="$WORK/sync-merge"
CATDD_SOURCE_ROOT="$FIX" "$INSTALLER" --targetDir "$S2" --targetCodeAgent Copilot --init --yes >/dev/null 2>&1

HB="$S2/.catdd/slashCommands/commands/Px-HarnessKits/HARNESS_evolveHarness.md"
SC="$S2/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_commitWorks.md"
OU="$S2/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md"

# Local evolution in the target.
perl -0pi -e 's/(^# HARNESS_evolveHarness$)/$1\n> LOCAL-EVOLVED-TEST/m' "$HB"
perl -0pi -e 's/^# SPEC_commitWorks$/# SPEC_commitWorks LOCAL-CONFLICT-TEST/m' "$SC"

# Upstream changes in the fixture source.
printf '\n<!-- UPSTREAM-LINE-A -->\n' >> "$FIX/slashCommands/commands/Px-HarnessKits/HARNESS_evolveHarness.md"
perl -0pi -e 's/^# SPEC_commitWorks$/# SPEC_commitWorks UPSTREAM-CONFLICT-TEST/m' "$FIX/slashCommands/commands/Px-SpecFlow/SPEC_commitWorks.md"
printf '\n<!-- UPSTREAM-LINE-B -->\n' >> "$FIX/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md"

merge_output="$(CATDD_SOURCE_ROOT="$FIX" "$INSTALLER" --targetDir "$S2" --targetCodeAgent Copilot --yes 2>&1)"
grep -Fq 'sync: merged (kept target-evolved lines)' <<< "$merge_output" || fail "disjoint edits were not merged"
grep -Fq 'sync: conflict (kept target; upstream not applied)' <<< "$merge_output" || fail "overlapping edits were not reported as conflict"
grep -Fq 'sync slashCommands: new=0' <<< "$merge_output" || fail "merge run reported unexpected new files"
assert_contains "$HB" 'LOCAL-EVOLVED-TEST'
assert_contains "$HB" 'UPSTREAM-LINE-A'
head -1 "$SC" | grep -Fq '# SPEC_commitWorks LOCAL-CONFLICT-TEST' || fail "conflict file was overwritten instead of kept"
assert_contains "$OU" 'UPSTREAM-LINE-B'
assert_not_contains "$S2/.catdd/.install-baseline/slashCommands/commands/Px-HarnessKits/HARNESS_evolveHarness.md" 'LOCAL-EVOLVED-TEST'

echo "[installCaTDD-test] Test: local-only command file is kept"
S3="$WORK/sync-local-only"
"$INSTALLER" --targetDir "$S3" --targetCodeAgent Copilot --init --yes >/dev/null 2>&1
LOCAL_CMD="$S3/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_myLocalCommand.md"
printf '# SPEC_myLocalCommand\n' > "$LOCAL_CMD"
local_only_output="$("$INSTALLER" --targetDir "$S3" --targetCodeAgent Copilot --yes 2>&1)"
grep -Fq 'local-only (kept)' <<< "$local_only_output" || fail "target-only file not reported as local-only"
assert_file "$LOCAL_CMD"

echo "[installCaTDD-test] Test: legacy target without baseline is conservatively kept"
S4="$WORK/legacy"
"$INSTALLER" --targetDir "$S4" --targetCodeAgent Copilot --init --yes >/dev/null 2>&1
rm -rf "$S4/.catdd/CaTDD_INSTALL.manifest" "$S4/.catdd/.install-baseline"
EV4="$S4/.catdd/slashCommands/commands/Px-HarnessKits/HARNESS_evolveHarness.md"
printf '\n<!-- LEGACY-EVOLVED-TEST -->\n' >> "$EV4"
legacy_output="$("$INSTALLER" --targetDir "$S4" --targetCodeAgent Copilot --yes 2>&1)"
grep -Fq 'no baseline, assume evolved' <<< "$legacy_output" || fail "legacy divergent file not reported"
assert_contains "$EV4" 'LEGACY-EVOLVED-TEST'
"$INSTALLER" --targetDir "$S4" --targetCodeAgent Copilot --yes --force-overwrite >/dev/null 2>&1
assert_not_contains "$EV4" 'LEGACY-EVOLVED-TEST'

echo "[installCaTDD-test] PASSED: unified installer, per-agent assets, and patch-aware sync verified"
