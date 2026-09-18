#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMAND_DIR="$REPO_ROOT/slashCommands/commands/Px-SpecFlow"
INIT_CONTEXT="$COMMAND_DIR/SPEC_initProjectContext.md"
UPDATE_CONTEXT="$COMMAND_DIR/SPEC_updateProjectContext.md"
DIAGNOSE_PROJECT="$REPO_ROOT/slashCommands/commands/Px-HarnessKits/HARNESS_diagnoseProject.md"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
FLOW_DOC_ZH="$REPO_ROOT/slashCommands/flows/Px-SpecFlow_ZH.md"
USER_GUIDE="$REPO_ROOT/slashCommands/README_UserGuide.md"
USER_GUIDE_ZH="$REPO_ROOT/slashCommands/README_UserGuide_ZH.md"
UBILANG="$REPO_ROOT/README_UbiLang.md"
UBILANG_ZH="$REPO_ROOT/README_UbiLang_ZH.md"
INSTALLER="$REPO_ROOT/scripts/installCaTDD.sh"

fail() {
  echo "[specflow-agent-surfaces-test] $*" >&2
  exit 1
}

assert_contains() {
  local file="$1"
  local text="$2"
  [[ -f "$file" ]] || fail "missing file: ${file#$REPO_ROOT/}"
  grep -Fq -- "$text" "$file" || fail "${file#$REPO_ROOT/} missing expected text: $text"
}

# 1. init records the surfaces with provenance, ownership, and the authority ceiling.
assert_contains "$INIT_CONTEXT" '## Agent Instruction Surface Rule'
assert_contains "$INIT_CONTEXT" 'The agent instruction surface in scope for project context is the `AGENTS.md` family'
assert_contains "$INIT_CONTEXT" '`agents_md_files`: optional detected list of repository `AGENTS.md` files (root and nested, including `AGENTS.override.md`)'
assert_contains "$INIT_CONTEXT" 'Out of scope: the other adapter files the installer generates'
assert_contains "$INIT_CONTEXT" 'they carry no hand-written region to follow and no provenance to resolve'
assert_contains "$INIT_CONTEXT" '`~/.codex/AGENTS.md` is personal scope and never enters team project context'
assert_contains "$INIT_CONTEXT" 'not from timestamps'
assert_contains "$INIT_CONTEXT" 'only the CaTDD managed block is `catdd-created`'
assert_contains "$INIT_CONTEXT" 'hand-written text and no managed block is `pre-existing`'
assert_contains "$INIT_CONTEXT" 'a file with both is `mixed`'
assert_contains "$INIT_CONTEXT" 'an empty file is `present-empty`'
assert_contains "$INIT_CONTEXT" 'Ownership follows the region, not the file'
assert_contains "$INIT_CONTEXT" '`pre-existing` and `mixed` files are followed, never overwritten'
assert_contains "$INIT_CONTEXT" '`catdd-created` files are mastered'
assert_contains "$INIT_CONTEXT" 'Authority ceiling: `AGENTS.md` may own operating conventions only.'
assert_contains "$INIT_CONTEXT" '`agents_md_files`: optional detected list'
assert_contains "$INIT_CONTEXT" 'A `## Agent Instruction Surfaces` section listing every detected `AGENTS.md` family file'
assert_contains "$INIT_CONTEXT" 'This works because `AGENTS.md` is the one surface the installer patches in place instead of rewriting.'
assert_contains "$INIT_CONTEXT" 'Do not rewrite hand-written text in a `pre-existing` or `mixed` surface'
assert_contains "$INIT_CONTEXT" 'Do not resolve provenance from file timestamps'

# 2. update reconciles by ownership and reports drift.
assert_contains "$UPDATE_CONTEXT" '## Agent Surface Reconcile Rule'
assert_contains "$UPDATE_CONTEXT" 'Reconcile each `AGENTS.md` file by ownership, never by file'
assert_contains "$UPDATE_CONTEXT" '| `catdd-created` | Update the managed region so it matches project context, and never touch text outside it. |'
assert_contains "$UPDATE_CONTEXT" '| `mixed` | Update only the managed region'
assert_contains "$UPDATE_CONTEXT" '| `pre-existing` | Never rewrite it.'
assert_contains "$UPDATE_CONTEXT" '| `present-empty` | Record it as existing but contributing no guidance'
assert_contains "$UPDATE_CONTEXT" 'Surface appeared or removed since the last update'
assert_contains "$UPDATE_CONTEXT" '`agent_surface_drift` reporting each difference between the recorded inventory and the `AGENTS.md` family'
assert_contains "$UPDATE_CONTEXT" '`agents_md_files`: optional detected list'
assert_contains "$UPDATE_CONTEXT" '`AGENTS.md` family file | A repository `AGENTS.md` or `AGENTS.override.md`'
assert_contains "$UPDATE_CONTEXT" 'Do not rewrite a hand-written region of any `AGENTS.md` file'
assert_contains "$UPDATE_CONTEXT" 'Authority ceiling: `AGENTS.md` may own operating conventions only.'
assert_contains "$UPDATE_CONTEXT" 'Out of scope: the installer-generated adapters'
assert_contains "$UPDATE_CONTEXT" 'Do not add the installer-generated adapters or generated adapter trees to the surface inventory'

# 3. The flow lists the surfaces as artifacts and constrains them.
assert_contains "$FLOW_DOC" '`AGENTS.md` and `AGENTS.override.md` (root and nested): the repository files that tell a code agent how to work here'
assert_contains "$FLOW_DOC" '| `AGENTS.md` / `AGENTS.override.md` (root and nested) | Team-shared |'
assert_contains "$FLOW_DOC" 'It is the one agent surface the installer patches in place'
assert_contains "$FLOW_DOC" 'are rewritten wholesale on refresh and stay out of scope'
assert_contains "$FLOW_DOC" 'Do not let `AGENTS.md` override method semantics, category meaning, gate rules, traceability, or project facts'
assert_contains "$FLOW_DOC" 'Do not rewrite the hand-written region of a `pre-existing` or `mixed` `AGENTS.md`'
assert_contains "$FLOW_DOC_ZH" '`AGENTS.md` 与 `AGENTS.override.md`（根目录与嵌套）'
assert_contains "$FLOW_DOC_ZH" '不得让 `AGENTS.md` 凌驾于方法语义、分类语义、门禁规则、追溯关系或项目事实之上'

en_headings="$(grep -c '^##* ' "$FLOW_DOC")"
zh_headings="$(grep -c '^##* ' "$FLOW_DOC_ZH")"
[[ "$en_headings" -eq "$zh_headings" ]] || fail "flow heading mismatch: EN=$en_headings, ZH=$zh_headings"

# 4. Diagnosis can flag surface drift.
assert_contains "$DIAGNOSE_PROJECT" '`agent-surface-drift`'
assert_contains "$DIAGNOSE_PROJECT" '| agent-surface-drift |'
assert_contains "$DIAGNOSE_PROJECT" 'refresh the inventory with `SPEC_updateProjectContext`'

# 5. Vocabulary and guides carry the same rules.
assert_contains "$UBILANG" '| agent instruction surface |'
assert_contains "$UBILANG" 'Provenance comes from the file itself'
assert_contains "$UBILANG" 'Authority is capped at operating conventions, so `AGENTS.md` never overrides'
assert_contains "$UBILANG_ZH" '| agent instruction surface（智能体指令面） |'
assert_contains "$UBILANG" 'stay out of this model'
assert_contains "$UBILANG_ZH" '其权限上限为"操作约定"'
assert_contains "$USER_GUIDE" 'A file that existed before CaTDD is followed; one CaTDD created is mastered.'
assert_contains "$USER_GUIDE_ZH" '早于 CaTDD 存在的文件被遵循；由 CaTDD 创建的被掌管。'

# 6. The installer states the region ownership it writes.
assert_contains "$INSTALLER" 'This block is the CaTDD-owned region and projects the rules recorded in `.catdd/spec/projectContext.md`'
assert_contains "$INSTALLER" 'text outside these markers belongs to the project and is never rewritten by CaTDD'

echo "[specflow-agent-surfaces-test] PASSED: agent instruction surfaces are recorded, followed or mastered by region, and capped at operating conventions"
