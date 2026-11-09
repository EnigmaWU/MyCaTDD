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
  grep -Fq -- "$2" "$1" || fail "$1 missing expected content: $2"
}

assert_not_contains() {
  ! grep -Fq -- "$2" "$1" || fail "$1 should not contain: $2"
}

[[ -x "$INSTALLER" ]] || fail "missing executable installer: scripts/installCaTDD.sh"

echo "[installCaTDD-test] Test: renamed commands migrate local edits and overlays"
OLD_SOURCE="$WORK/old-source"
mkdir -p "$OLD_SOURCE"
cp -R "$REPO_ROOT/methodPrompts" "$OLD_SOURCE/"
cp -R "$REPO_ROOT/slashCommands" "$OLD_SOURCE/"
rm -f \
  "$OLD_SOURCE/slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md" \
  "$OLD_SOURCE/slashCommands/commands/Px-SpecFlow/SPEC_implUnitTests.md"
for name in design impl refact reviewImpl; do
  mv "$OLD_SOURCE/slashCommands/commands/Px-SpecFlow/SPEC_${name}Tests.md" \
    "$OLD_SOURCE/slashCommands/commands/Px-SpecFlow/SPEC_${name}UnitTests.md"
done
mv "$OLD_SOURCE/slashCommands/commands/P0-FuncTestsFlow/TEST_implTestCase.md" \
  "$OLD_SOURCE/slashCommands/commands/P0-FuncTestsFlow/UT_implTestCase.md"
mv "$OLD_SOURCE/slashCommands/TEST_slashCommandTemplate.md" \
  "$OLD_SOURCE/slashCommands/UT_slashCommandTemplate.md"
MIG="$WORK/rename-migration"
CATDD_SOURCE_ROOT="$OLD_SOURCE" "$INSTALLER" --targetDir "$MIG" --targetCodeAgent Copilot --init --yes >/dev/null
printf '\n<!-- LOCAL-RENAME-EDIT: UT_Gateway.ts -->\n' >> "$MIG/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_implUnitTests.md"
printf '# SPEC_implUnitTestsEvolved\n<!-- LOCAL-OVERLAY -->\n' > "$MIG/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_implUnitTestsEvolved.md"
"$INSTALLER" --targetDir "$MIG" --targetCodeAgent Copilot --clean-prompts --yes >/dev/null
for name in design impl refact reviewImpl; do
  assert_absent "$MIG/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_${name}UnitTests.md"
  assert_absent "$MIG/.github/prompts/SPEC_${name}UnitTests.prompt.md"
  assert_file "$MIG/.github/prompts/SPEC_${name}Tests.prompt.md"
done
assert_contains "$MIG/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_implTests.md" 'LOCAL-RENAME-EDIT'
assert_contains "$MIG/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_implTests.md" 'UT_Gateway.ts'
assert_absent "$MIG/.catdd/slashCommands/commands/P0-FuncTestsFlow/UT_implTestCase.md"
assert_absent "$MIG/.github/prompts/UT_implTestCase.prompt.md"
assert_file "$MIG/.github/prompts/TEST_implTestCase.prompt.md"
assert_absent "$MIG/.catdd/slashCommands/UT_slashCommandTemplate.md"
assert_absent "$MIG/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_implUnitTestsEvolved.md"
assert_contains "$MIG/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_implTestsEvolved.md" 'LOCAL-OVERLAY'
assert_contains "$MIG/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_implTestsEvolved.md" '# SPEC_implTestsEvolved'

echo "[installCaTDD-test] Test: --help"
"$INSTALLER" --help 2>&1 | head -1 | grep -Fq 'installCaTDD.sh' || fail "--help missing script name"

echo "[installCaTDD-test] Test: missing --targetDir exits error"
err_out="$("$INSTALLER" 2>&1)" || true
grep -Fq 'Missing required --targetDir' <<< "$err_out" || fail "missing --targetDir not detected"

echo "[installCaTDD-test] Test: missing --targetCodeAgent exits error"
err_out="$("$INSTALLER" --targetDir "$WORK" 2>&1)" || true
grep -Fq 'Missing required --targetCodeAgent' <<< "$err_out" || fail "missing --targetCodeAgent not detected"

echo "[installCaTDD-test] Test: unknown agent exits error"
for unsupported_agent in Continue Cline Antigravity; do
  err_out="$("$INSTALLER" --targetDir "$WORK" --targetCodeAgent "$unsupported_agent" 2>&1)" || true
  grep -Fq 'Unknown --targetCodeAgent' <<< "$err_out" || fail "unsupported agent not rejected: $unsupported_agent"
done

echo "[installCaTDD-test] Test: removed Codex-only option is rejected"
err_out="$("$INSTALLER" --targetDir "$WORK" --targetCodeAgent Copilot --codex-prompts-dir "$WORK/prompts" 2>&1)" || true
grep -Fq 'Unknown argument: --codex-prompts-dir' <<< "$err_out" || fail "removed Codex option not rejected"

echo "[installCaTDD-test] Test: Copilot fresh install"
install_fresh() {
  local dir="$WORK/fresh-Copilot"
  local marker
  "$INSTALLER" --targetDir "$dir" --targetCodeAgent Copilot --init --clean-prompts --yes >/dev/null 2>&1
  assert_file "$dir/.catdd/methodPrompts/README.md"
  assert_file "$dir/.catdd/slashCommands/TEST_slashCommandTemplate.md"
  assert_contains "$dir/.catdd/methodPrompts/CaTDD_methodPrompt-testStructure.md" '## Project-Wide Traceability IDs'
  assert_contains "$dir/.catdd/methodPrompts/CaTDD_methodPrompt4Cat-Typical.md" 'project-wide-traceability-ids'
  assert_contains "$dir/.catdd/slashCommands/templates/SpecTodoUserStoryTemplate.md" '{{StoryIdAlias}}-AC-Typical-{{n}}'
  assert_contains "$dir/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_analyzeIssue.md" 'project-wide-traceability-ids'
  assert_dir "$dir/.catdd/spec/pendingNews"
  assert_absent "$dir/README_UbiLang.md"
  assert_file "$dir/.catdd/CaTDD_INSTALL.manifest"
  assert_dir "$dir/.catdd/.install-baseline/methodPrompts"
  assert_dir "$dir/.catdd/.install-baseline/slashCommands"
  marker="$dir/.catdd/CaTDD_INSTALL.md"
  grep -Eq '^- Installed version: ([0-9]{8}\.[0-9]{2}|unknown)$' "$marker" || fail "install marker missing version line"

  assert_file "$dir/.github/instructions/catdd.instructions.md"
  assert_contains "$dir/.github/instructions/catdd.instructions.md" '/HARNESS_evolveHarness'
  assert_file "$dir/.github/prompts/TEST_convertDemoToTypical.prompt.md"
  assert_file "$dir/.github/prompts/SPEC_openUserStory.prompt.md"
  assert_file "$dir/.github/prompts/HARNESS_patchCaTDDSource.prompt.md"
  assert_file "$dir/.github/prompts/HARNESS_verifyInstallation.prompt.md"
  assert_file "$dir/.github/prompts/HARNESS_diagnoseInstallation.prompt.md"
  assert_contains "$dir/.github/prompts/TEST_convertDemoToTypical.prompt.md" 'thin Copilot adapter'
  assert_contains "$dir/.github/prompts/TEST_convertDemoToTypical.prompt.md" 'agent: "agent"'
  assert_contains "$dir/.github/prompts/TEST_convertDemoToTypical.prompt.md" 'slashCommands/commands/P0-FuncTestsFlow/TEST_convertDemoToTypical.md'
  assert_contains "$dir/.github/prompts/TEST_convertDemoToTypical.prompt.md" 'methodPrompts/README.md'
  source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'TEST_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | wc -l | tr -d '[:space:]')"
  prompt_count="$(find "$dir/.github/prompts" -type f \( -name 'TEST_*.prompt.md' -o -name 'SPEC_*.prompt.md' -o -name 'HARNESS_*.prompt.md' \) | wc -l | tr -d '[:space:]')"
  [[ "$prompt_count" == "$source_count" ]] || fail "expected $source_count installed Copilot prompts, got $prompt_count"

  replacement_output="$("$INSTALLER" --targetDir "$dir" --targetCodeAgent Copilot --clean-prompts --yes 2>&1)"
  grep -Fq '] version:' <<< "$replacement_output" || fail "installer missing version action output on reinstall"
  grep -Fq '(same version, replacement)' <<< "$replacement_output" || fail "reinstall should report same-version replacement"
  rm -rf "$dir"
}

install_fresh

echo "[installCaTDD-test] Test: ChatCopilotLocal and Copilot alias work"
TARGET2="$WORK/alias"
"$INSTALLER" --targetDir "$TARGET2" --targetCodeAgent "GitHub/Copilot" --init --yes >/dev/null 2>&1
assert_file "$TARGET2/.catdd/methodPrompts/README.md"
assert_contains "$TARGET2/.catdd/CaTDD_INSTALL.md" '- Target agent: ChatCopilotLocal'
TARGET_LOCAL="$WORK/explicit-local"
"$INSTALLER" --targetDir "$TARGET_LOCAL" --targetCodeAgent "ChatCopilotLocal" --init --yes >/dev/null 2>&1
assert_file "$TARGET_LOCAL/.github/prompts/TEST_convertDemoToTypical.prompt.md"
assert_contains "$TARGET_LOCAL/.catdd/CaTDD_INSTALL.md" '- Target agent: ChatCopilotLocal'

echo "[installCaTDD-test] Test: ChatCopilotAgentHost fresh install and skill generation"
install_agent_host() {
  local dir="$WORK/fresh-ChatCopilotAgentHost"
  local marker
  "$INSTALLER" --targetDir "$dir" --targetCodeAgent ChatCopilotAgentHost --init --clean-prompts --yes >/dev/null 2>&1
  assert_file "$dir/.catdd/methodPrompts/README.md"
  assert_file "$dir/.catdd/slashCommands/TEST_slashCommandTemplate.md"
  assert_dir "$dir/.catdd/spec/pendingNews"
  assert_file "$dir/.catdd/CaTDD_INSTALL.manifest"
  marker="$dir/.catdd/CaTDD_INSTALL.md"
  assert_contains "$marker" '- Target agent: ChatCopilotAgentHost'

  assert_file "$dir/.github/instructions/catdd.instructions.md"
  assert_contains "$dir/.github/instructions/catdd.instructions.md" '.github/skills/test-*/SKILL.md'
  assert_contains "$dir/.github/instructions/catdd.instructions.md" '/HARNESS_evolveHarness'
  assert_absent "$dir/.github/prompts/TEST_convertDemoToTypical.prompt.md"

  assert_file "$dir/.github/skills/test-convert-demo-to-typical/SKILL.md"
  assert_file "$dir/.github/skills/spec-open-user-story/SKILL.md"
  assert_file "$dir/.github/skills/harness-patch-ca-tdd-source/SKILL.md"
  assert_file "$dir/.github/skills/harness-verify-installation/SKILL.md"
  assert_file "$dir/.github/skills/harness-diagnose-installation/SKILL.md"
  assert_contains "$dir/.github/skills/test-convert-demo-to-typical/SKILL.md" 'name: test-convert-demo-to-typical'
  assert_contains "$dir/.github/skills/test-convert-demo-to-typical/SKILL.md" 'disable-model-invocation: true'
  assert_contains "$dir/.github/skills/test-convert-demo-to-typical/SKILL.md" 'thin Copilot adapter'
  assert_contains "$dir/.github/skills/test-convert-demo-to-typical/SKILL.md" '../../../.catdd/slashCommands/commands/P0-FuncTestsFlow/TEST_convertDemoToTypical.md'
  assert_contains "$dir/.github/skills/test-convert-demo-to-typical/SKILL.md" '../../../.catdd/methodPrompts/README.md'

  source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'TEST_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | wc -l | tr -d '[:space:]')"
  skill_count="$(find "$dir/.github/skills" -mindepth 2 -maxdepth 2 -type f -name 'SKILL.md' | wc -l | tr -d '[:space:]')"
  [[ "$skill_count" == "$source_count" ]] || fail "expected $source_count installed Copilot skills, got $skill_count"

  # Ensure non-wrapper user skills in .github/skills survive --clean-prompts
  mkdir -p "$dir/.github/skills/test-driven-development"
  printf '# Hand-authored skill\n' > "$dir/.github/skills/test-driven-development/SKILL.md"
  mkdir -p "$dir/.github/skills/spec-stale-wrapper"
  printf 'You are running a Copilot-native skill wrapper around a portable CaTDD slash command.\n' > "$dir/.github/skills/spec-stale-wrapper/SKILL.md"
  "$INSTALLER" --targetDir "$dir" --targetCodeAgent ChatCopilotAgentHost --clean-prompts --yes >/dev/null 2>&1
  assert_file "$dir/.github/skills/test-driven-development/SKILL.md"
  assert_absent "$dir/.github/skills/spec-stale-wrapper/SKILL.md"
  rm -rf "$dir"
}

install_agent_host

echo "[installCaTDD-test] Test: Codex fresh install, AGENTS.md patch, and skill generation"
install_codex() {
  local dir="$WORK/fresh-Codex"
  local marker
  mkdir -p "$dir"
  printf '# Existing Project Agents Guide\n\nKeep custom repo notes.\n' > "$dir/AGENTS.md"
  "$INSTALLER" --targetDir "$dir" --targetCodeAgent Codex --init --clean-prompts --yes >/dev/null 2>&1
  assert_file "$dir/.catdd/methodPrompts/README.md"
  assert_file "$dir/.catdd/slashCommands/TEST_slashCommandTemplate.md"
  assert_dir "$dir/.catdd/spec/pendingNews"
  assert_file "$dir/.catdd/CaTDD_INSTALL.manifest"
  marker="$dir/.catdd/CaTDD_INSTALL.md"
  assert_contains "$marker" '- Target agent: Codex'

  assert_file "$dir/AGENTS.md"
  assert_contains "$dir/AGENTS.md" '# Existing Project Agents Guide'
  assert_contains "$dir/AGENTS.md" 'Keep custom repo notes.'
  assert_contains "$dir/AGENTS.md" 'BEGIN CaTDD Codex instructions'
  assert_contains "$dir/AGENTS.md" '.agents/skills'
  assert_contains "$dir/AGENTS.md" '/HARNESS_evolveHarness'

  assert_file "$dir/.agents/skills/test-convert-demo-to-typical/SKILL.md"
  assert_file "$dir/.agents/skills/test-convert-demo-to-typical/agents/openai.yaml"
  assert_file "$dir/.agents/skills/spec-open-user-story/SKILL.md"
  assert_file "$dir/.agents/skills/harness-patch-ca-tdd-source/SKILL.md"
  assert_file "$dir/.agents/skills/harness-verify-installation/SKILL.md"
  assert_file "$dir/.agents/skills/harness-diagnose-installation/SKILL.md"
  assert_contains "$dir/.agents/skills/test-convert-demo-to-typical/SKILL.md" 'TEST_convertDemoToTypical'
  assert_contains "$dir/.agents/skills/test-convert-demo-to-typical/SKILL.md" 'thin Codex Skill adapter'
  assert_contains "$dir/.agents/skills/test-convert-demo-to-typical/agents/openai.yaml" 'display_name: "TEST_convertDemoToTypical"'
  assert_contains "$dir/.agents/skills/test-convert-demo-to-typical/agents/openai.yaml" 'allow_implicit_invocation: false'

  source_count="$(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'TEST_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | wc -l | tr -d '[:space:]')"
  skill_count="$(find "$dir/.agents/skills" -mindepth 2 -maxdepth 2 -type f -name 'SKILL.md' | wc -l | tr -d '[:space:]')"
  [[ "$skill_count" == "$source_count" ]] || fail "expected $source_count installed Codex skills, got $skill_count"
  assert_absent "$dir/.codex/prompts"

  # Ensure non-wrapper user skills in .agents/skills survive --clean-prompts
  mkdir -p "$dir/.agents/skills/test-custom-codex-skill"
  printf '# Hand-authored Codex skill\n' > "$dir/.agents/skills/test-custom-codex-skill/SKILL.md"
  mkdir -p "$dir/.agents/skills/spec-stale-wrapper"
  printf 'You are running a Codex Skill wrapper around a portable CaTDD slash command.\n' > "$dir/.agents/skills/spec-stale-wrapper/SKILL.md"
  "$INSTALLER" --targetDir "$dir" --targetCodeAgent "OpenAI/Codex" --clean-prompts --yes >/dev/null 2>&1
  assert_file "$dir/.agents/skills/test-custom-codex-skill/SKILL.md"
  assert_absent "$dir/.agents/skills/spec-stale-wrapper/SKILL.md"
  rm -rf "$dir"
}

install_codex

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

echo "[installCaTDD-test] Test: evolved overlays survive refresh and --force-overwrite"
S5="$WORK/sync-evolved-overlay"
"$INSTALLER" --targetDir "$S5" --targetCodeAgent Copilot --init --yes >/dev/null 2>&1
OV="$S5/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_implTestsEvolved.md"
NEW_OV="$S5/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_doNewXyzEvolved.md"
printf '# SPEC_implTestsEvolved\n> supersedes the canonical command locally\n' > "$OV"
printf '# SPEC_doNewXyzEvolved\n' > "$NEW_OV"
overlay_output="$("$INSTALLER" --targetDir "$S5" --targetCodeAgent Copilot --yes 2>&1)"
grep -Fq 'evolved overlay (local-only, kept)' <<< "$overlay_output" || fail "evolved overlay not reported as kept"
assert_file "$OV"
assert_file "$NEW_OV"
assert_contains "$S5/.catdd/slashCommands/commands/Px-SpecFlow/SPEC_implTests.md" '# SPEC_implTests'
assert_file "$S5/.github/prompts/SPEC_implTestsEvolved.prompt.md"
assert_file "$S5/.github/prompts/SPEC_doNewXyzEvolved.prompt.md"
assert_contains "$S5/.github/prompts/SPEC_implTestsEvolved.prompt.md" '.catdd/slashCommands/commands/Px-SpecFlow/SPEC_implTestsEvolved.md'
assert_contains "$S5/.github/instructions/catdd.instructions.md" '<Name>Evolved.md'
force_output="$("$INSTALLER" --targetDir "$S5" --targetCodeAgent Copilot --yes --force-overwrite 2>&1)"
grep -Fq 'preserve evolved overlay (force-overwrite)' <<< "$force_output" || fail "force-overwrite did not report preserving evolved overlay"
assert_file "$OV"
assert_file "$NEW_OV"
assert_contains "$OV" 'supersedes the canonical command locally'

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

echo "[installCaTDD-test] PASSED: Copilot installer and patch-aware sync verified"
