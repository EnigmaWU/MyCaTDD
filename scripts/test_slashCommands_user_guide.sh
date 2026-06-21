#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SLASH_DIR="$REPO_ROOT/slashCommands"
GUIDE="$SLASH_DIR/README_UserGuide.md"
GUIDE_ZH="$SLASH_DIR/README_UserGuide_ZH.md"
MAIN_GUIDE="$REPO_ROOT/README_UserGuide.md"

fail() {
  echo "[slashCommands-user-guide-test] $*" >&2
  exit 1
}

[[ -f "$GUIDE" ]] || fail "missing slashCommands user guide: slashCommands/README_UserGuide.md"
[[ -f "$GUIDE_ZH" ]] || fail "missing Chinese slashCommands user guide: slashCommands/README_UserGuide_ZH.md"

grep -Fq 'This README is the WHAT / WHY entry point' "$SLASH_DIR/README.md" || fail "slashCommands README must own WHAT/WHY"
grep -Fq 'HOW, WHO, WHEN, and WHERE' "$SLASH_DIR/README.md" || fail "slashCommands README must delegate HOW/WHO/WHEN/WHERE to UserGuide"
grep -Fq 'Standalone user guides (`README_UserGuide.md`, `README_UserGuide_ZH.md`)' "$SLASH_DIR/README.md" || fail "slashCommands README missing standalone guide entries"
grep -Fq '本 README 是命令连接层的 WHAT / WHY 入口' "$SLASH_DIR/README_ZH.md" || fail "slashCommands Chinese README must own WHAT/WHY"
grep -Fq 'HOW、WHO、WHEN、WHERE' "$SLASH_DIR/README_ZH.md" || fail "slashCommands Chinese README must delegate HOW/WHO/WHEN/WHERE to UserGuide"
grep -Fq '独立用户指南（`README_UserGuide.md`、`README_UserGuide_ZH.md`）' "$SLASH_DIR/README_ZH.md" || fail "slashCommands Chinese README missing standalone guide entries"

for heading in '## Who' '## What' '## When' '## Where' '## Why' '## How' '## Usage Example'; do
  grep -Fq "$heading" "$GUIDE" || fail "slashCommands user guide missing $heading section"
done

grep -Fq 'scripts/installCaTDD4Copilot.sh --target "$TARGET_DIR" --clean-prompts' "$GUIDE" || fail "slashCommands user guide missing copy-exec Copilot install example"
grep -Fq '.catdd/slashCommands/README_UserGuide.md' "$GUIDE" || fail "slashCommands user guide missing installed slashCommands path check"
grep -Fq 'scripts/makeSlashCmd4Continue.sh --clean' "$GUIDE" || fail "slashCommands user guide missing Continue generation command"
grep -Fq 'flows/P0-FuncTestsFlow.md' "$GUIDE" || fail "slashCommands user guide missing flow map"
grep -Fq 'commands/P0-FuncTestsFlow/UT_implTestCase.md' "$GUIDE" || fail "slashCommands user guide missing command map"
grep -Fq '.catdd/spec/doingUS/' "$GUIDE" || fail "slashCommands user guide missing local SpecCoding artifact policy"
grep -Fq '.catdd/spec/suspendUS/' "$GUIDE" || fail "slashCommands user guide missing suspended SpecCoding artifact policy"
grep -Fq '.catdd/spec/abortUS/' "$GUIDE" || fail "slashCommands user guide missing aborted SpecCoding artifact policy"

grep -Fq '## 使用者' "$GUIDE_ZH" || fail "Chinese slashCommands user guide missing 使用者 section"
grep -Fq '## Usage Example' "$GUIDE_ZH" || fail "Chinese slashCommands user guide missing copy-exec Usage Example section"
grep -Fq 'scripts/installCaTDD4Copilot.sh --target "$TARGET_DIR" --clean-prompts' "$GUIDE_ZH" || fail "Chinese slashCommands user guide missing copy-exec Copilot install example"
grep -Fq '.catdd/slashCommands/README_UserGuide.md' "$GUIDE_ZH" || fail "Chinese slashCommands user guide missing installed slashCommands path check"
grep -Fq 'scripts/makeSlashCmd4Continue.sh --clean' "$GUIDE_ZH" || fail "Chinese slashCommands user guide missing Continue generation command"
grep -Fq 'flows/P0-FuncTestsFlow.md' "$GUIDE_ZH" || fail "Chinese slashCommands user guide missing flow map"

grep -Fq '[slashCommands/README_UserGuide.md](slashCommands/README_UserGuide.md)' "$MAIN_GUIDE" || fail "main user guide missing slashCommands sub-user-guide link"
grep -Fq '[slashCommands/README_UserGuide_ZH.md](slashCommands/README_UserGuide_ZH.md)' "$MAIN_GUIDE" || fail "main user guide missing ZH slashCommands sub-user-guide link"

echo "[slashCommands-user-guide-test] PASSED: slashCommands has standalone user guide"
