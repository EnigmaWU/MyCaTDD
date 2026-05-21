#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

fail() {
  echo "[slashcommands-complete-test] $*" >&2
  exit 1
}

assert_file() {
  local path="$1"
  [[ -f "$REPO_ROOT/$path" ]] || fail "missing $path"
}

assert_contains() {
  local path="$1"
  local text="$2"
  grep -Fq "$text" "$REPO_ROOT/$path" || fail "$path missing: $text"
}

p1_commands=(
  UT_designStateSkeleton
  UT_designCapabilitySkeleton
  UT_designConcurrencySkeleton
  UT_reviewDesignTestsSkeleton
)

p2_commands=(
  UT_designPerformanceSkeleton
  UT_designRobustSkeleton
  UT_designCompatibilitySkeleton
  UT_designConfigurationSkeleton
  UT_reviewQualityTestsSkeleton
)

for command_name in "${p1_commands[@]}"; do
  command_path="slashCommands/commands/P1-DesignTestsFlow/${command_name}.md"
  readme_command_path="${command_path#slashCommands/}"
  assert_file "$command_path"
  assert_contains "$command_path" "# ${command_name}"
  assert_contains "$command_path" "../../flows/P1-DesignTestsFlow.md"
  assert_contains "$command_path" "../../../methodPrompts/CaTDD_methodPrompt.md"
  assert_contains "$command_path" "ONE-MORE-THING: ask developer if something not sure"
  assert_contains "slashCommands/README_UserGuide.md" "$readme_command_path"
done

for command_name in "${p2_commands[@]}"; do
  command_path="slashCommands/commands/P2-QualityTestsFlow/${command_name}.md"
  readme_command_path="${command_path#slashCommands/}"
  assert_file "$command_path"
  assert_contains "$command_path" "# ${command_name}"
  assert_contains "$command_path" "../../flows/P2-QualityTestsFlow.md"
  assert_contains "$command_path" "../../../methodPrompts/CaTDD_methodPrompt.md"
  assert_contains "$command_path" "ONE-MORE-THING: ask developer if something not sure"
  assert_contains "slashCommands/README_UserGuide.md" "$readme_command_path"
done

assert_contains "slashCommands/commands/README.md" "P1-DesignTestsFlow"
assert_contains "slashCommands/commands/README.md" "P2-QualityTestsFlow"

if grep -Fq "Future Command Candidates" "$REPO_ROOT/slashCommands/flows/P1-DesignTestsFlow.md"; then
  fail "P1 flow still describes completed commands as future candidates"
fi

if grep -Fq "Future Command Candidates" "$REPO_ROOT/slashCommands/flows/P2-QualityTestsFlow.md"; then
  fail "P2 flow still describes completed commands as future candidates"
fi

echo "[slashcommands-complete-test] PASSED: P1/P2 slash commands are complete and mapped"