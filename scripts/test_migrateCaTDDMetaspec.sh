#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HELPER="$REPO_ROOT/scripts/migrateCaTDDMetaspec.sh"
WORK="$(mktemp -d)"

cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

fail() {
  echo "[migrate-metaspec-test] $*" >&2
  exit 1
}

assert_contains() {
  grep -Fq -- "$2" "$1" || fail "$1 missing expected content: $2"
}

write_context() {
  local path="$1"
  local root="$2"
  mkdir -p "$(dirname "$path")"
  cat > "$path" <<CONTEXT
# Test Project Context

## SpecFlow Lifecycle State

metaspec_root: $root
CONTEXT
}

[[ -x "$HELPER" ]] || fail "missing executable helper"

echo "[migrate-metaspec-test] Test: legacy dry run does not mutate"
LEGACY="$WORK/legacy"
mkdir -p "$LEGACY/.catdd/spec/pendingNews"
printf 'pending\n' > "$LEGACY/.catdd/spec/pendingNews/item.md"
write_context "$LEGACY/.catdd/spec/projectContext.md" .catdd/spec
printf '/dist/\n' > "$LEGACY/.gitignore"
dry_output="$("$HELPER" --project-root "$LEGACY" 2>&1)"
grep -Fq 'action: migrate' <<< "$dry_output" || fail "dry run did not report migration"
grep -Fq 'dry run only' <<< "$dry_output" || fail "dry run did not identify itself"
[[ -f "$LEGACY/.catdd/spec/pendingNews/item.md" ]] || fail "dry run moved legacy content"
[[ ! -e "$LEGACY/.catdd/metaspec" ]] || fail "dry run created canonical workspace"

echo "[migrate-metaspec-test] Test: legacy apply preserves content and declares canonical root"
"$HELPER" --project-root "$LEGACY" --apply --quiet
[[ ! -e "$LEGACY/.catdd/spec" ]] || fail "legacy workspace still exists after migration"
[[ -f "$LEGACY/.catdd/metaspec/pendingNews/item.md" ]] || fail "pending artifact was not preserved"
assert_contains "$LEGACY/.catdd/metaspec/pendingNews/item.md" 'pending'
assert_contains "$LEGACY/.catdd/metaspec/projectContext.md" 'metaspec_root: .catdd/metaspec'
for lane in pendingNews analyzedNews todoUS doingUS suspendUS abortUS doneUS; do
  [[ -d "$LEGACY/.catdd/metaspec/$lane" ]] || fail "missing lifecycle lane after migration: $lane"
done
assert_contains "$LEGACY/.gitignore" '/.catdd/metaspec/WorkingProcessLog.md'
assert_contains "$LEGACY/.gitignore" '/.agents/metaspec/WorkingProcessLog.md'
assert_contains "$LEGACY/.gitignore" '/.catdd/spec/WorkingProcessLog.md'
"$HELPER" --project-root "$LEGACY" --apply --quiet
[[ -f "$LEGACY/.catdd/metaspec/pendingNews/item.md" ]] || fail "second apply was not idempotent"

echo "[migrate-metaspec-test] Test: agent-owned workspace remains selected"
AGENTS="$WORK/agents"
write_context "$AGENTS/.agents/metaspec/projectContext.md" .agents/metaspec
mkdir -p "$AGENTS/.agents/metaspec/todoUS"
printf 'todo\n' > "$AGENTS/.agents/metaspec/todoUS/story.md"
"$HELPER" --project-root "$AGENTS" --apply --quiet
[[ -f "$AGENTS/.agents/metaspec/todoUS/story.md" ]] || fail "agent-owned story was not preserved"
[[ ! -e "$AGENTS/.catdd/metaspec" ]] || fail "canonical workspace should not be created beside an agent-owned workspace"
assert_contains "$AGENTS/.agents/metaspec/projectContext.md" 'metaspec_root: .agents/metaspec'

echo "[migrate-metaspec-test] Test: fresh project creates canonical lanes without inventing context"
FRESH="$WORK/fresh"
mkdir -p "$FRESH"
"$HELPER" --project-root "$FRESH" --apply --quiet
[[ -d "$FRESH/.catdd/metaspec/pendingNews" ]] || fail "fresh migration did not create canonical workspace"
[[ ! -e "$FRESH/.catdd/metaspec/projectContext.md" ]] || fail "migration helper invented project context"

echo "[migrate-metaspec-test] Test: populated roots are never merged"
CONFLICT="$WORK/conflict"
write_context "$CONFLICT/.catdd/metaspec/projectContext.md" .catdd/metaspec
mkdir -p "$CONFLICT/.catdd/spec/pendingNews"
printf 'legacy\n' > "$CONFLICT/.catdd/spec/pendingNews/legacy.md"
if "$HELPER" --project-root "$CONFLICT" --apply --quiet >"$WORK/conflict.out" 2>&1; then
  fail "helper accepted multiple populated workspaces"
fi
grep -Fq 'multiple populated metaspec workspaces exist' "$WORK/conflict.out" || fail "conflict was not explained"
[[ -f "$CONFLICT/.catdd/spec/pendingNews/legacy.md" ]] || fail "conflict mutated legacy workspace"
[[ -f "$CONFLICT/.catdd/metaspec/projectContext.md" ]] || fail "conflict mutated canonical workspace"

echo "[migrate-metaspec-test] Test: physical location must match projectContext declaration"
DRIFT="$WORK/drift"
write_context "$DRIFT/.catdd/spec/projectContext.md" .catdd/metaspec
mkdir -p "$DRIFT/.catdd/spec/todoUS"
printf 'story\n' > "$DRIFT/.catdd/spec/todoUS/story.md"
if "$HELPER" --project-root "$DRIFT" --apply --quiet >"$WORK/drift.out" 2>&1; then
  fail "helper accepted a context stored outside its declared root"
fi
grep -Fq 'projectContext declares' "$WORK/drift.out" || fail "declaration drift was not explained"
[[ -f "$DRIFT/.catdd/spec/todoUS/story.md" ]] || fail "drift mutated the legacy workspace"

echo "[migrate-metaspec-test] PASSED: metaspec migration helper preserves state and blocks ambiguity"
