#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMMAND_DIRS=(
  "slashCommands/commands/Px-SpecFlow"
  "slashCommands/commands/Px-HarnessKits"
  "slashCommands/commands/P0-FuncTestsFlow"
  "slashCommands/commands/P1-DesignTestsFlow"
  "slashCommands/commands/P2-QualityTestsFlow"
)

failures=0

fail() {
  echo "[slashcommands-cot-test] $*" >&2
  failures=$((failures + 1))
}

for dir in "${COMMAND_DIRS[@]}"; do
  for file in "$REPO_ROOT/$dir"/{SPEC,HARNESS,UT}_*.md; do
    [[ -f "$file" ]] || continue
    rel="${file#"$REPO_ROOT"/}"

    grep -q '^## CoT Pattern$' "$file" || { fail "$rel: missing '## CoT Pattern'"; continue; }

    # Every pattern named in the CoT block must have its own execution subsection,
    # so composite declarations cannot hide a missing loop.
    declared="$(sed -n '/^## CoT Pattern$/,/^## /p' "$file" \
      | grep -oE '\*\*[^*]*(ReACT|ToT|Linear)[^*]*\*\*' \
      | grep -oE '(ReACT|ToT|Linear)' | sort -u)"
    [[ -n "$declared" ]] || { fail "$rel: CoT Pattern must declare ReACT, ToT, or Linear in bold"; continue; }

    for pattern in $declared; do
      grep -qE "^### ${pattern} Execution( .*)?\$" "$file" \
        || fail "$rel: names ${pattern} but has no '### ${pattern} Execution' subsection"
    done

    grep -q '^### Worked Example$' "$file" || fail "$rel: missing '### Worked Example'"

    # The execution loop and its example belong to CoT Pattern, not a later section.
    cot_line="$(grep -n '^## CoT Pattern$' "$file" | cut -d: -f1)"
    next_h2="$(awk -v start="$cot_line" 'NR>start && /^## /{print NR; exit}' "$file")"
    : "${next_h2:=$(wc -l <"$file")}"
    while read -r line; do
      [[ -n "$line" ]] || continue
      (( line > cot_line && line < next_h2 )) \
        || fail "$rel: execution/example subsections must be nested under '## CoT Pattern'"
    done < <(grep -nE '^### ((ReACT|ToT|Linear) Execution( .*)?|Worked Example)$' "$file" | cut -d: -f1)

    grep -q '^## Prompt Template$' "$file" \
      && fail "$rel: '## Prompt Template' duplicates the execution loop; remove it"

    if grep -qE '^\*\*ReACT\*\*' "$file"; then
      grep -q '\*\*Thought\*\*' "$file" || fail "$rel: ReACT loop has no **Thought** step"
      grep -q '\*\*Action\*\*' "$file" || fail "$rel: ReACT loop has no **Action** step"
      grep -q '\*\*Observation\*\*' "$file" || fail "$rel: ReACT loop has no **Observation** step"
    fi
  done
done

if (( failures > 0 )); then
  echo "[slashcommands-cot-test] FAILED: $failures problem(s)" >&2
  exit 1
fi

echo "[slashcommands-cot-test] PASSED: every UT_*/SPEC_*/HARNESS_* command declares a CoT pattern with a matching execution loop and worked example"
