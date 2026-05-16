#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$REPO_ROOT"
git config --local core.hooksPath .githooks

echo "Configured local git hooks path: .githooks"
echo "Run this command to verify: git config --local --get core.hooksPath"
