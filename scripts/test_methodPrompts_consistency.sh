#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
METHOD_DIR="$REPO_ROOT/methodPrompts"
FILE_NAMING="$METHOD_DIR/CaTDD_methodPrompt-fileNaming.md"
MASTER="$METHOD_DIR/CaTDD_methodPrompt.md"
TEST_STRUCTURE="$METHOD_DIR/CaTDD_methodPrompt-testStructure.md"
README="$METHOD_DIR/README.md"
README_ZH="$METHOD_DIR/README_ZH.md"
GUIDE="$METHOD_DIR/README_UserGuide.md"
GUIDE_ZH="$METHOD_DIR/README_UserGuide_ZH.md"
ROOT_GUIDE="$REPO_ROOT/README_UserGuide.md"
TEMPLATES=(
  "$METHOD_DIR/CaTDD_designAndImplTemplate.cxx"
  "$METHOD_DIR/CaTDD_designAndImplTemplate.ts"
  "$METHOD_DIR/CaTDD_designAndImplTemplate.py"
  "$METHOD_DIR/CaTDD_designAndImplTemplate.go"
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
assert_contains "$MASTER" 'test_{feature}_{category}.<ext>'
assert_contains "$TEST_STRUCTURE" 'test_{feature}_{category}.<ext>'

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

echo "[methodPrompts-consistency-test] notice: vendored copies under .github/skills/*/references/ and the devBooks drafts are out of scope for this pass"
echo "[methodPrompts-consistency-test] PASSED: naming, category sections, status markers, and README claims agree"
