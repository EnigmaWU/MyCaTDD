#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
METHOD_DIR="$REPO_ROOT/methodPrompts"
UBILANG="$REPO_ROOT/README_UbiLang.md"
UBILANG_ZH="$REPO_ROOT/README_UbiLang_ZH.md"
FILE_NAMING="$METHOD_DIR/CaTDD_methodPrompt-fileNaming.md"
MASTER="$METHOD_DIR/CaTDD_methodPrompt.md"
TEST_STRUCTURE="$METHOD_DIR/CaTDD_methodPrompt-testStructure.md"
TEST_DISCOVERY="$METHOD_DIR/CaTDD_methodPrompt-testPointDiscovery.md"
TODO_STORY_TEMPLATE="$REPO_ROOT/slashCommands/templates/SpecTodoUserStoryTemplate.md"
STORY_LEDGER_TEMPLATE="$REPO_ROOT/slashCommands/templates/README_UserStoriesTemplate.md"
TASKS_TEMPLATE="$REPO_ROOT/slashCommands/templates/SpecDoingUserStoryTasksTemplate.md"
DETAIL_TEMPLATE="$REPO_ROOT/slashCommands/templates/README_DetailDesignTemplate.md"
DETAIL_VERIFY_TEMPLATE="$REPO_ROOT/slashCommands/templates/README_DetailVerifyDesignTemplate.md"
ARCH_VERIFY_TEMPLATE="$REPO_ROOT/slashCommands/templates/README_ArchVerifyDesignTemplate.md"
ANALYZE_ISSUE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeIssue.md"
ANALYZE_FEATURE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeFeature.md"
IMPORT_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_importUserStory.md"
ANALYZE_ABORT="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_analyzeAbortedUserStory.md"
OPEN_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md"
DESIGN_TESTS="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_designTests.md"
IMPL_PRODUCT="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_implProductCodes.md"
DESIGN_FUNCTIONAL="$REPO_ROOT/slashCommands/commands/P0-FuncTestsFlow/TEST_designFuncTestsSkeleton.md"
UPDATE_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_updateUserStory.md"
REVIEW_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_reviewUserStory.md"
REVIEW_TESTS="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_reviewImplTests.md"
CLOSE_STORY="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md"
PARTIAL_CLOSE="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_partialCloseUserStory.md"
MERGE_WORKS="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_mergeWorks.md"
README="$METHOD_DIR/README.md"
README_ZH="$METHOD_DIR/README_ZH.md"
GUIDE="$METHOD_DIR/README_UserGuide.md"
GUIDE_ZH="$METHOD_DIR/README_UserGuide_ZH.md"
ROOT_GUIDE="$REPO_ROOT/README_UserGuide.md"
ACTION_CONCEPTS="$REPO_ROOT/devBooks/Action/01_defineConcepts.md"
TEMPLATES=(
  "$METHOD_DIR/CaTDD_designAndImplTemplate.cxx"
  "$METHOD_DIR/CaTDD_designAndImplTemplate.ts"
  "$METHOD_DIR/CaTDD_designAndImplTemplate.py"
  "$METHOD_DIR/CaTDD_designAndImplTemplate.go"
)
P0_DESIGN_COMMANDS=(
  "$DESIGN_FUNCTIONAL"
  "$REPO_ROOT/slashCommands/commands/P0-FuncTestsFlow/TEST_designTypicalSkeleton.md"
  "$REPO_ROOT/slashCommands/commands/P0-FuncTestsFlow/TEST_designEdgeSkeleton.md"
  "$REPO_ROOT/slashCommands/commands/P0-FuncTestsFlow/TEST_designMisuseSkeleton.md"
  "$REPO_ROOT/slashCommands/commands/P0-FuncTestsFlow/TEST_designFaultSkeleton.md"
)

fail() {
  echo "[methodPrompts-consistency-test] $*" >&2
  exit 1
}

assert_contains() {
  local file="$1"
  local text="$2"
  [[ -f "$file" ]] || fail "missing file: ${file#$REPO_ROOT/}"
  grep -Fq -- "$text" "$file" || fail "${file#$REPO_ROOT/} missing expected text: $text"
}

assert_not_contains() {
  local file="$1"
  local text="$2"
  [[ -f "$file" ]] || fail "missing file: ${file#$REPO_ROOT/}"
  ! grep -Fq -- "$text" "$file" || fail "${file#$REPO_ROOT/} must not contain: $text"
}

# 1. Every category prompt exposes the same section contract.
expected_sections="Checklist
Common Mistakes
Design Focus
Design Skeleton
Do Not Use When
Naming Examples
Position
TestPointsInMind
US/AC/TC Pattern
Use When"

category_count=0
for category_file in "$METHOD_DIR"/CaTDD_methodPrompt4Cat-*.md; do
  category_count=$((category_count + 1))
  assert_contains "$category_file" 'project-wide-traceability-ids'
  for trace_field in US AC TP TC; do
    assert_contains "$category_file" "// @[$trace_field]:"
  done
  actual_sections="$(grep '^## ' "$category_file" | sed 's/^## //' | LC_ALL=C sort)"
  if [[ "$actual_sections" != "$expected_sections" ]]; then
    actual_sections_file="$(mktemp)"
    expected_sections_file="$(mktemp)"
    printf '%s\n' "$actual_sections" > "$actual_sections_file"
    printf '%s\n' "$expected_sections" > "$expected_sections_file"
    echo "--- section diff for ${category_file#$REPO_ROOT/}" >&2
    diff -u "$expected_sections_file" "$actual_sections_file" >&2 || true
    rm -f "$actual_sections_file" "$expected_sections_file"
    fail "category prompt section set differs from the shared contract"
  fi
done
[[ "$category_count" -eq 15 ]] || fail "expected 15 category prompts, found $category_count"

for design_command in "$REPO_ROOT"/slashCommands/commands/{P0-FuncTestsFlow,P1-DesignTestsFlow,P2-QualityTestsFlow}/TEST_design*Skeleton.md; do
  assert_contains "$design_command" '@[TP]'
done

# 2. The canonical naming authority covers every category token.
declare -a category_names=(Typical Edge Misuse Fault State Capability Interaction Concurrency Performance Robust Compatibility Configuration Diagnosis Security DemoExample)
declare -a category_tokens=(funcValidTypical funcValidEdge funcInvalidMisuse funcInvalidFault designState designCapability designInteraction designConcurrency qualityPerformance qualityRobust qualityCompatibility qualityConfiguration qualityDiagnosis qualitySecurity addonDemoExample)

for index in "${!category_names[@]}"; do
  category_file="$METHOD_DIR/CaTDD_methodPrompt4Cat-${category_names[$index]}.md"
  [[ -f "$category_file" ]] || fail "missing category prompt: ${category_file#$REPO_ROOT/}"
  assert_contains "$FILE_NAMING" "\`${category_tokens[$index]}\`"
done

token_rows="$(grep -c '^| P[0-3] ' "$FILE_NAMING")"
[[ "$token_rows" -eq "${#category_tokens[@]}" ]] || fail "fileNaming token table has $token_rows rows, expected ${#category_tokens[@]}"

assert_contains "$FILE_NAMING" 'test_{feature}_{category}.<ext>'
assert_contains "$FILE_NAMING" '## Superseded Names'
assert_contains "$FILE_NAMING" 'deprecated'
assert_contains "$FILE_NAMING" '@[TestLevel]'
assert_contains "$TEST_STRUCTURE" '@[TestScope]'
assert_contains "$TEST_STRUCTURE" 'mockSysRtm <marker> | realSysRtm <marker>'
assert_contains "$TEST_STRUCTURE" '## Project-Wide Traceability IDs'
assert_contains "$TEST_STRUCTURE" '`US-<story>-AC-<n>`'
assert_contains "$TEST_STRUCTURE" '`US-<story>-TP-<n>`'
assert_contains "$TEST_STRUCTURE" '`US-<story>-TC-<n>`'
assert_contains "$TEST_STRUCTURE" 'each TP MUST map to exactly one TC'
assert_contains "$TEST_STRUCTURE" 'human-readable form'
assert_contains "$TEST_STRUCTURE" 'US-<whoName>-<doWhat>'
assert_contains "$TEST_STRUCTURE" 'US-eventProducer-postEventsWithoutBlocking'
assert_not_contains "$TEST_STRUCTURE" 'UUIDv4'
assert_contains "$TEST_STRUCTURE" '@[TP]'
assert_contains "$TODO_STORY_TEMPLATE" '**Story ID:** {{StoryID}}'
assert_contains "$TODO_STORY_TEMPLATE" '### {{StoryID}}-AC-{{n}}:'
assert_contains "$TODO_STORY_TEMPLATE" 'US-<whoName>-<doWhat> with lowerCamelCase segments'
assert_contains "$ANALYZE_ISSUE" 'register the Story ID'
assert_contains "$ANALYZE_ISSUE" 'project-wide-traceability-ids'
assert_contains "$ANALYZE_ISSUE" 'US-<whoName>-<doWhat>'
assert_contains "$ANALYZE_FEATURE" 'US-<whoName>-<doWhat>'
assert_contains "$IMPORT_STORY" 'US-<whoName>-<doWhat>'
assert_contains "$ANALYZE_ABORT" 'US-<whoName>-<doWhat>'
assert_contains "$IMPORT_STORY" 'assign a human-readable project Story ID in'
assert_contains "$ANALYZE_ABORT" 'revision of the same story'
assert_contains "$STORY_LEDGER_TEMPLATE" '## Story Identity Registry'
assert_contains "$STORY_LEDGER_TEMPLATE" 'US-<whoName>-<doWhat>'
assert_contains "$STORY_LEDGER_TEMPLATE" '{{StoryID}}-AC-{{n}}'
for intake_command in "$ANALYZE_FEATURE" "$IMPORT_STORY" "$ANALYZE_ABORT" "$OPEN_STORY"; do
  assert_contains "$intake_command" 'project-wide-traceability-ids'
done
assert_contains "$MASTER" 'project-wide-traceability-ids'
assert_contains "$MASTER" 'Each TP **MUST** map to exactly one TC'
assert_contains "$UBILANG" 'US / AC / TP / TC Cardinality'
assert_contains "$UBILANG" 'each TP MUST map to exactly one TC'
assert_contains "$UBILANG_ZH" '每个 TP MUST 恰好映射到一个 TC'
assert_contains "$TEST_DISCOVERY" 'story-qualified TP ID'
for trace_command in "$DESIGN_TESTS" "$IMPL_PRODUCT" "$DESIGN_FUNCTIONAL"; do
  assert_contains "$trace_command" 'project-wide-traceability-ids'
done
for template in "${TEMPLATES[@]}"; do
  assert_contains "$template" 'US-PROJECT-01-AC-01'
  assert_contains "$template" 'US-PROJECT-01-TP-01'
  assert_contains "$template" 'US-PROJECT-01-TC-01'
  assert_contains "$template" 'abbreviated sample IDs'
done
assert_contains "$TASKS_TEMPLATE" '**ID:** {{StoryID}}'
assert_contains "$DETAIL_TEMPLATE" '{{StoryID}}-AC-{{n}}'
assert_contains "$DETAIL_VERIFY_TEMPLATE" '{{StoryID}}-TP-{{n}}'
assert_contains "$ARCH_VERIFY_TEMPLATE" '{{StoryID}}-TP-{{n}}'
for lifecycle_command in "$UPDATE_STORY" "$REVIEW_STORY" "$REVIEW_TESTS" "$CLOSE_STORY" "$PARTIAL_CLOSE" "$MERGE_WORKS"; do
  assert_contains "$lifecycle_command" 'project-wide-traceability-ids'
done
assert_contains "$MERGE_WORKS" 'integrated project'
assert_not_contains "$TEST_STRUCTURE" 'AC-n: GIVEN'
assert_contains "$MASTER" 'test_{feature}_{category}.<ext>'
assert_contains "$TEST_STRUCTURE" 'test_{feature}_{category}.<ext>'

# A new mandatory rule must not coexist with the old permissive rule.
for contract_file in "$MASTER" "$TEST_DISCOVERY" "${TEMPLATES[@]}"; do
  assert_not_contains "$contract_file" '$1:N$ and $N:1$ are valid when justified'
  assert_not_contains "$contract_file" '`1 : N` (Decomposed)'
  assert_not_contains "$contract_file" '1:N (multiple checks)'
  assert_contains "$contract_file" 'Each TP MUST be covered by exactly one TC'
  assert_contains "$contract_file" 'Each TC MUST cover at least one TP and MAY cover multiple TPs'
done
assert_contains "$TEST_DISCOVERY" 'US -> AC -> TP -> TC cardinality'
assert_contains "$TEST_DISCOVERY" 'cardinality_gate: FAIL'
assert_contains "$GUIDE" 'each TP to map to exactly one TC'
assert_contains "$GUIDE_ZH" '每个 TP 恰好映射到一个 TC'

for design_command in "${P0_DESIGN_COMMANDS[@]}"; do
  assert_contains "$design_command" 'CaTDD_methodPrompt-testStructure.md#usactptc-contract'
  assert_not_contains "$design_command" 'US/AC/TC cardinality'
  assert_not_contains "$design_command" 'every AC has ≥1 TC'
  assert_not_contains "$design_command" 'every `@[AC]` has ≥1 `@[TC]`'
done
assert_contains "$DESIGN_FUNCTIONAL" 'every AC has at least one TP'
assert_contains "$DESIGN_FUNCTIONAL" 'every TP maps to exactly one TC'
assert_contains "$DESIGN_FUNCTIONAL" 'every TC covers at least one TP'
assert_contains "$DESIGN_FUNCTIONAL" 'a TP maps to zero or multiple TCs'

story_id='US-eventProducer-postEventsWithoutBlocking'
case_names=(
  'verifyEventPost_byFullQueue_expectNonBlockReturn'
  'verifyEventPost_byFullQueue_expectErrorCode'
  'verifyEventPost_byFullQueue_expectNotQueued'
)
for index in "${!case_names[@]}"; do
  printf -v child_token '%02d' "$((index + 1))"
  case_id="$story_id-TC-$child_token"
  name_count="$(grep -Ec "$case_id[[:space:]]+${case_names[$index]}" "$ACTION_CONCEPTS")" || [[ $? -eq 1 ]]
  case_count="$(grep -Ec "$case_id[[:space:]]+verify" "$ACTION_CONCEPTS")" || [[ $? -eq 1 ]]
  [[ "$name_count" -eq 2 && "$case_count" -eq 2 ]] || fail "$case_id must keep the same behavior in the full chain and tracking example"
  assert_contains "$ACTION_CONCEPTS" "@[Trace]: $story_id | $story_id-AC-01 | $story_id-TP-$child_token | $case_id"
done
awk '
  /^## The Implementation Tracking Template$/ { tracking = 1; next }
  tracking && /^## / { tracking = 0 }
  tracking && /@\[Trace\]:/ { statuses = 0; trace_case = $NF }
  tracking && /@\[Status\]: mockSysRtm .* \| realSysRtm [^[:space:]]/ { statuses++ }
  tracking && /@\[TC\]:/ {
    cases++
    if ($3 != trace_case) {
      print "TC differs from its trace at line " NR > "/dev/stderr"
      failed = 1
    }
    if (statuses != 1) {
      print "Missing or duplicate two-scope status at line " NR > "/dev/stderr"
      failed = 1
    }
  }
  END {
    if (cases != 3) {
      print "Expected three tracked full-queue test cases, found " cases > "/dev/stderr"
      failed = 1
    }
    exit failed
  }
' "$ACTION_CONCEPTS" || fail "Action tracking example must give every TC one two-scope status"

# 3. No deprecated level-prefixed test file names outside the vendored/refDoc material.
deprecated_name_pattern='(UT|ST|UAT)_[A-Za-z0-9_]+-(Typical|Edge|Misuse|Fault|State|Capability|Interaction|Concurrency|Performance|Robust|Compatibility|Configuration|Diagnosis|Security)\.[A-Za-z]+'
deprecated_hits="$(
  grep -rEn --include='*.md' --include='*.cxx' --include='*.ts' --include='*.py' --include='*.go' \
    "$deprecated_name_pattern" "$METHOD_DIR" "$REPO_ROOT/slashCommands" \
    "$REPO_ROOT/README.md" "$REPO_ROOT/README_ZH.md" "$REPO_ROOT/README_UserGuide.md" 2>/dev/null \
    | grep -v 'CaTDD_methodPrompt-fileNaming.md' || true
)"
[[ -z "$deprecated_hits" ]] || fail "deprecated test file names are still taught:"$'\n'"$deprecated_hits"

deprecated_files="$(
  find "$REPO_ROOT/codeAgents" -type f \
    \( -name 'UT_*-*.ts' -o -name 'UT_*-*.cxx' -o -name 'UT_*-*.py' -o -name 'UT_*-*.go' \
       -o -name 'ST_*-*.ts' -o -name 'UAT_*-*.ts' \) 2>/dev/null || true
)"
[[ -z "$deprecated_files" ]] || fail "deprecated test file names still exist in codeAgents:"$'\n'"$deprecated_files"

for canonical_file in test_us_user_01_funcValidTypical.ts test_us_user_01_funcValidEdge.ts test_us_user_01_funcInvalidMisuse.ts test_us_user_01_funcInvalidFault.ts; do
  [[ -f "$REPO_ROOT/codeAgents/utCodeAgentCLI/SysTests/$canonical_file" ]] || fail "missing canonical test file: $canonical_file"
done

# 4. One status-marker vocabulary, documented once and reused everywhere.
for marker_row in '| ⚪ |' '| 🔴 |' '| 🟢 |' '| ⚠️ BROKEN_TEST |' '| ⚠️ ISSUES |' '| 🚫 BLOCKED |'; do
  assert_contains "$GUIDE" "$marker_row"
  assert_contains "$GUIDE_ZH" "$marker_row"
done
assert_contains "$GUIDE" '`RED/IMPLEMENTED` is a superseded alias'
assert_contains "$GUIDE_ZH" '`RED/IMPLEMENTED` 是已废弃的别名'
assert_contains "$GUIDE" 'Category legend icons must not reuse status glyphs'
assert_contains "$TEST_STRUCTURE" 'RED/FAILING: test written, executing cleanly'

for template in "${TEMPLATES[@]}"; do
  assert_not_contains "$template" 'RED/IMPLEMENTED'
done

# The guides may only mention the superseded alias on a deprecation line.
for guide_file in "$GUIDE" "$GUIDE_ZH" "$ROOT_GUIDE"; do
  if grep -Fq 'RED/IMPLEMENTED' "$guide_file"; then
    while IFS= read -r alias_line; do
      case "$alias_line" in
        *superseded*|*已废弃*) ;;
        *) fail "${guide_file#$REPO_ROOT/} uses RED/IMPLEMENTED outside a deprecation statement: $alias_line" ;;
      esac
    done < <(grep -Fn 'RED/IMPLEMENTED' "$guide_file")
  fi
done

blocked_hits="$(
  grep -rFn --include='*.md' '⚠️ BLOCKED' "$METHOD_DIR" "$REPO_ROOT/slashCommands" \
    "$REPO_ROOT/README.md" "$REPO_ROOT/README_ZH.md" "$REPO_ROOT/README_UserGuide.md" \
    "$REPO_ROOT/README_UbiLang.md" "$REPO_ROOT/README_UbiLang_ZH.md" 2>/dev/null | grep -v 'BLOCKED / BROKEN_TEST' || true
)"
[[ -z "$blocked_hits" ]] || fail "use 🚫 BLOCKED as the single BLOCKED rendering:"$'\n'"$blocked_hits"

for template in "${TEMPLATES[@]}"; do
  assert_not_contains "$template" '🚫 MISUSE:'
  assert_not_contains "$template" '⚠️ FAULT:'
done

# 5. The method README describes the layer as it actually is.
assert_contains "$README" 'Four implementation templates'
assert_contains "$README" 'ValidFunc(Typical + Edge)'
assert_contains "$README" 'InvalidFunc(Misuse + Fault)'
assert_contains "$README_ZH" '四份实现模板'
assert_contains "$README_ZH" 'ValidFunc(Typical + Edge)'
assert_contains "$README_ZH" 'InvalidFunc(Misuse + Fault)'

for template in "${TEMPLATES[@]}"; do
  assert_contains "$template" '@[Notes]'
  assert_contains "$template" '@[Expect]'
  assert_contains "$template" '@[Status]'
done
assert_not_contains "${TEMPLATES[0]}" 'UT_NameofCategory'

echo "[methodPrompts-consistency-test] notice: vendored copies under .github/skills/*/references/ and other devBooks examples are out of scope for this pass"
echo "[methodPrompts-consistency-test] PASSED: naming, cardinality, category sections, status markers, and checked examples agree"
