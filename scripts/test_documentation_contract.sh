#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

layers=(
  "methodPrompts"
  "slashCommands"
  "agentSkills"
  "codeAgents/utCodeAgentCLI"
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

link_label_issues="$(
  find "$REPO_ROOT/methodPrompts" "$REPO_ROOT/slashCommands" -type f -name '*.md' -print0 \
    | xargs -0 perl -ne '
        BEGIN {
          our (%seen_target, %seen_line, $current_file);
          %seen_target = ();
          %seen_line = ();
          $current_file = "";
        }
        if ($ARGV ne $current_file) {
          %seen_target = ();
          %seen_line = ();
          $current_file = $ARGV;
        }
        while (/\[([^\]]+)\]\(([^)]+)\)/g) {
          my ($label, $target) = ($1, $2);
          my $path_label =
            $label =~ m{^(?:\./|\.\./)} ||
            $label eq $target ||
            $target =~ m{(?:^|/)\Q$label\E\.md(?:#|$)};
          if ($label =~ /\.md/) {
            print "$ARGV:$.: label must omit .md: [$label]($target)\n";
          }
          if ($label =~ m{/} && $path_label) {
            print "$ARGV:$.: label must be a readable name, not a path: [$label]($target)\n";
          }
          if (exists $seen_target{$label} && $seen_target{$label} ne $target) {
            print "$ARGV:$.: ambiguous label [$label] maps to [$seen_target{$label}] at line $seen_line{$label} and [$target]\n";
          }
          $seen_target{$label} = $target unless exists $seen_target{$label};
          $seen_line{$label} = $. unless exists $seen_line{$label};
        }
      '
)"
[[ -z "$link_label_issues" ]] || fail "Markdown link labels must be clean, meaningful, and unambiguous:
$link_label_issues"

echo "[documentation-contract-test] PASSED: README/UserGuide contract is documented for completed layers"
