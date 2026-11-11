#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALLER="$REPO_ROOT/scripts/installCaTDD.sh"
CONTRACT="$REPO_ROOT/slashCommands/MetaspecWorkspaceResolution.md"
MIGRATE_COMMAND="$REPO_ROOT/slashCommands/commands/Px-HarnessKits/HARNESS_migrateMetaspec.md"
WORK="$(mktemp -d)"

cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

fail() {
  echo "[metaspec-workspace-test] $*" >&2
  exit 1
}

assert_contains() {
  grep -Fq -- "$2" "$1" || fail "$1 missing expected content: $2"
}

assert_not_contains() {
  ! grep -Fq -- "$2" "$1" || fail "$1 should not contain: $2"
}

write_context() {
  local path="$1"
  local root="$2"
  mkdir -p "$(dirname "$path")"
  cat > "$path" <<CONTEXT
# Workspace Test Context

## SpecFlow Life Cycle

No lifecycle state is stored here.

## SpecFlow Lifecycle State

metaspec_root: $root
CONTEXT
}

echo "[metaspec-workspace-test] Test: shared contract defines all supported roots"
[[ -f "$CONTRACT" ]] || fail "missing metaspec workspace contract"
for root in .catdd/metaspec .agents/metaspec .catdd/spec; do
  assert_contains "$CONTRACT" "$root"
done
assert_contains "$CONTRACT" 'metaspec_root: .catdd/metaspec'
assert_contains "$CONTRACT" 'mutating commands MUST stop'
assert_contains "$REPO_ROOT/README_UbiLang.md" 'SPEC = youWantR + iWhyD + aiHowC'
assert_contains "$REPO_ROOT/README_UbiLang.md" 'A `metaspec` artifact is not automatically `R`, `D`, `C`, or the complete `SPEC`.'
assert_contains "$REPO_ROOT/README_UbiLang_ZH.md" 'SPEC = youWantR + iWhyD + aiHowC'
assert_contains "$REPO_ROOT/slashCommands/templates/README_UbiLangTemplate.md" 'SPEC = youWantR + iWhyD + aiHowC'
assert_contains "$REPO_ROOT/slashCommands/SPEC_slashCommandTemplate.md" 'Metaspec Workspace Resolution'
assert_contains "$REPO_ROOT/slashCommands/commands/README.md" 'Metaspec Workspace Resolution'
assert_contains "$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md" 'metaspec_root: .catdd/metaspec'

echo "[metaspec-workspace-test] Test: every invocable slash command carries the resolution clause"
command_count=0
while IFS= read -r -d '' command_file; do
  command_count=$((command_count + 1))
  assert_contains "$command_file" '## Metaspec Workspace'
  assert_contains "$command_file" 'MetaspecWorkspaceResolution.md'
  assert_contains "$command_file" '`.catdd/metaspec`'
  assert_contains "$command_file" '`.agents/metaspec`'
  assert_contains "$command_file" '`.catdd/spec`'
done < <(find "$REPO_ROOT/slashCommands/commands" -type f \( -name 'TEST_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) -print0)
[[ "$command_count" -ge 70 ]] || fail "expected at least 70 invocable command documents, found $command_count"

echo "[metaspec-workspace-test] Test: migration command is discoverable in HarnessKits"
[[ -f "$MIGRATE_COMMAND" ]] || fail "missing HARNESS_migrateMetaspec"
assert_contains "$MIGRATE_COMMAND" 'scripts/migrateCaTDDMetaspec.sh'
assert_contains "$MIGRATE_COMMAND" 'Never merge two populated workspaces automatically'
assert_contains "$REPO_ROOT/slashCommands/commands/Px-HarnessKits/README.md" 'HARNESS_migrateMetaspec.md'
assert_contains "$REPO_ROOT/slashCommands/kits/Px-HarnessKits.md" 'HARNESS_migrateMetaspec.md'

echo "[metaspec-workspace-test] Test: the source project intentionally remains on legacy .catdd/spec"
[[ -d "$REPO_ROOT/.catdd/spec" ]] || fail "current project legacy workspace was migrated unexpectedly"
[[ ! -e "$REPO_ROOT/.catdd/metaspec" ]] || fail "current project gained an unrequested .catdd/metaspec workspace"
assert_contains "$REPO_ROOT/.catdd/spec/projectContext.md" 'metaspec_root: .catdd/spec'

echo "[metaspec-workspace-test] Test: fresh install creates canonical workspace and migration helper"
FRESH="$WORK/fresh"
"$INSTALLER" --targetDir "$FRESH" --targetCodeAgent Copilot --init --yes >/dev/null 2>&1
[[ -d "$FRESH/.catdd/metaspec/pendingNews" ]] || fail "fresh install missing canonical workspace"
[[ ! -e "$FRESH/.catdd/spec" ]] || fail "fresh install created legacy workspace"
[[ -x "$FRESH/.catdd/scripts/migrateCaTDDMetaspec.sh" ]] || fail "fresh install missing executable migration helper"
[[ -f "$FRESH/.github/prompts/HARNESS_migrateMetaspec.prompt.md" ]] || fail "fresh install missing migration prompt wrapper"
assert_contains "$FRESH/.gitignore" '/.catdd/metaspec/WorkingProcessLog.md'
assert_contains "$FRESH/.gitignore" '/.agents/metaspec/WorkingProcessLog.md'
assert_contains "$FRESH/.gitignore" '/.catdd/spec/WorkingProcessLog.md'

echo "[metaspec-workspace-test] Test: normal refresh preserves legacy workspace; explicit flag migrates"
LEGACY="$WORK/legacy"
write_context "$LEGACY/.catdd/spec/projectContext.md" .catdd/spec
mkdir -p "$LEGACY/.catdd/spec/pendingNews"
printf 'legacy input\n' > "$LEGACY/.catdd/spec/pendingNews/item.md"
"$INSTALLER" --targetDir "$LEGACY" --targetCodeAgent Copilot --init --yes >/dev/null 2>&1
[[ -f "$LEGACY/.catdd/spec/pendingNews/item.md" ]] || fail "normal refresh migrated or removed legacy content"
[[ ! -e "$LEGACY/.catdd/metaspec" ]] || fail "normal refresh created canonical workspace beside legacy content"
assert_contains "$LEGACY/.catdd/spec/projectContext.md" 'metaspec_root: .catdd/spec'
"$INSTALLER" --targetDir "$LEGACY" --targetCodeAgent Copilot --yes --migrate-metaspec >/dev/null 2>&1
[[ ! -e "$LEGACY/.catdd/spec" ]] || fail "explicit migration retained populated legacy workspace"
[[ -f "$LEGACY/.catdd/metaspec/pendingNews/item.md" ]] || fail "explicit migration lost legacy content"
assert_contains "$LEGACY/.catdd/metaspec/projectContext.md" 'metaspec_root: .catdd/metaspec'

echo "[metaspec-workspace-test] Test: existing .agents/metaspec remains the active workspace"
AGENT_ROOT="$WORK/agent-root"
write_context "$AGENT_ROOT/.agents/metaspec/projectContext.md" .agents/metaspec
mkdir -p "$AGENT_ROOT/.agents/metaspec/todoUS"
printf 'agent story\n' > "$AGENT_ROOT/.agents/metaspec/todoUS/story.md"
"$INSTALLER" --targetDir "$AGENT_ROOT" --targetCodeAgent Codex --init --yes >/dev/null 2>&1
[[ -f "$AGENT_ROOT/.agents/metaspec/todoUS/story.md" ]] || fail "installer removed agent-owned lifecycle state"
[[ ! -e "$AGENT_ROOT/.catdd/metaspec" ]] || fail "installer created canonical workspace beside .agents/metaspec"
assert_contains "$AGENT_ROOT/.agents/metaspec/projectContext.md" 'metaspec_root: .agents/metaspec'
assert_contains "$AGENT_ROOT/AGENTS.md" 'MetaspecWorkspaceResolution.md'

echo "[metaspec-workspace-test] PASSED: all commands support the shared workspace contract and current project remains legacy"
