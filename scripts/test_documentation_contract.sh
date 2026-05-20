#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

layers=(
  "methodPrompts"
  "slashCommands"
  "agentSkill"
  "utCodeAgentCLI"
)

fail() {
  echo "[documentation-contract-test] $*" >&2
  exit 1
}

for layer in "${layers[@]}"; do
  layer_dir="$REPO_ROOT/$layer"
  readme="$layer_dir/README.md"
  readme_zh="$layer_dir/README_ZH.md"
  guide="$layer_dir/README_UserGuide.md"
  guide_zh="$layer_dir/README_UserGuide_ZH.md"

  [[ -f "$readme" ]] || fail "missing $layer/README.md"
  [[ -f "$readme_zh" ]] || fail "missing $layer/README_ZH.md"
  [[ -f "$guide" ]] || fail "missing $layer/README_UserGuide.md"
  [[ -f "$guide_zh" ]] || fail "missing $layer/README_UserGuide_ZH.md"

  grep -Fq 'WHAT / WHY entry point' "$readme" || fail "$layer README must own WHAT/WHY"
  grep -Fq 'HOW, WHO, WHEN, and WHERE' "$readme" || fail "$layer README must delegate HOW/WHO/WHEN/WHERE"
  grep -Fq '## Documentation boundary' "$readme" || fail "$layer README missing documentation boundary"

  grep -Fq 'WHAT / WHY 入口' "$readme_zh" || fail "$layer Chinese README must own WHAT/WHY"
  grep -Fq 'HOW、WHO、WHEN、WHERE' "$readme_zh" || fail "$layer Chinese README must delegate HOW/WHO/WHEN/WHERE"
  if ! grep -Fq '## Documentation boundary' "$readme_zh" && ! grep -Fq '## 文档边界' "$readme_zh"; then
    fail "$layer Chinese README missing documentation boundary"
  fi

  for heading in '## Who' '## What' '## When' '## Where' '## Why' '## How' '## Usage Example'; do
    grep -Fq "$heading" "$guide" || fail "$layer user guide missing $heading section"
  done

  for heading in '## 使用者' '## 内容' '## 使用时机' '## 位置' '## 原因' '## 方法' '## Usage Example'; do
    grep -Fq "$heading" "$guide_zh" || fail "$layer Chinese user guide missing $heading section"
  done

  grep -Fq "$layer/README_UserGuide.md" "$REPO_ROOT/README.md" || fail "root README missing $layer user guide link"
  grep -Fq "$layer/README_UserGuide_ZH.md" "$REPO_ROOT/README_ZH.md" || fail "root Chinese README missing $layer Chinese user guide link"
  grep -Fq "[$layer/README_UserGuide.md]($layer/README_UserGuide.md)" "$REPO_ROOT/README_UserGuide.md" || fail "main user guide missing $layer sub-user-guide link"
  grep -Fq "[$layer/README_UserGuide_ZH.md]($layer/README_UserGuide_ZH.md)" "$REPO_ROOT/README_UserGuide.md" || fail "main user guide missing $layer ZH sub-user-guide link"
done

echo "[documentation-contract-test] PASSED: README/UserGuide contract is documented for completed layers"
