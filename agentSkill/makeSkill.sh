#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEFAULT_SKILL="comment-alive-test-driven-development"
SUPPORTED_SKILLS=(
  "comment-alive-test-driven-development"
  "user-story-centered-spec-coding"
)
SKILL_NAME=""
OUTPUT_ROOT="$SCRIPT_DIR/dist"

usage() {
  cat <<'USAGE'
Usage: agentSkill/makeSkill.sh [SKILL_NAME] [--output DIR]

Generate a self-contained skill package under agentSkill/dist by default.

Supported skills:
  - comment-alive-test-driven-development
  - user-story-centered-spec-coding

Options:
  --output DIR   Directory that will receive the generated skill package.
  -h, --help     Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      [[ $# -ge 2 ]] || { echo "[makeSkill] --output requires a directory" >&2; exit 2; }
      OUTPUT_ROOT="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      echo "[makeSkill] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [[ -n "$SKILL_NAME" ]]; then
        echo "[makeSkill] Unexpected extra argument: $1" >&2
        usage >&2
        exit 2
      fi
      SKILL_NAME="$1"
      shift
      ;;
  esac
done

SKILL_NAME="${SKILL_NAME:-$DEFAULT_SKILL}"

is_supported_skill() {
  local candidate="$1"
  local supported
  for supported in "${SUPPORTED_SKILLS[@]}"; do
    if [[ "$candidate" == "$supported" ]]; then
      return 0
    fi
  done
  return 1
}

if ! is_supported_skill "$SKILL_NAME"; then
  echo "Unsupported skill '$SKILL_NAME'. Supported: ${SUPPORTED_SKILLS[*]}" >&2
  exit 1
fi

SOURCE_SKILL_DIR="$SCRIPT_DIR/$SKILL_NAME"

if [[ ! -d "$SOURCE_SKILL_DIR" ]]; then
  echo "Skill directory not found: $SOURCE_SKILL_DIR" >&2
  exit 1
fi

required_sources=(
  "$SOURCE_SKILL_DIR/SKILL.md"
  "$SOURCE_SKILL_DIR/README.md"
  "$REPO_ROOT/methodPrompts/README_UserGuide.md"
  "$REPO_ROOT/methodPrompts/README_UserGuide_ZH.md"
  "$REPO_ROOT/methodPrompts/CaTDD_methodPrompt.md"
  "$REPO_ROOT/methodPrompts/CaTDD_ImplTemplate.cxx"
  "$REPO_ROOT/slashCommands"
)

for source in "${required_sources[@]}"; do
  if [[ ! -e "$source" ]]; then
    echo "Required source not found: $source" >&2
    exit 1
  fi
done

if [[ -e "$SOURCE_SKILL_DIR/slashCommands" && ! -L "$SOURCE_SKILL_DIR/slashCommands" ]]; then
  echo "Refusing to remove non-symlink source path: $SOURCE_SKILL_DIR/slashCommands" >&2
  exit 1
fi

legacy_source_links=(
  "$SOURCE_SKILL_DIR/slashCommands"
  "$SOURCE_SKILL_DIR/references/README_UserGuide.md"
  "$SOURCE_SKILL_DIR/references/CaTDD_methodPrompt.md"
  "$SOURCE_SKILL_DIR/references/CaTDD_ImplTemplate.cxx"
  "$SOURCE_SKILL_DIR/references/CaTDD-UserGuide-PPT.md"
  "$SOURCE_SKILL_DIR/references/CaTDD-UserGuide-PPT-ZH_CN.md"
  "$SOURCE_SKILL_DIR/references/CaTDD_UserGuide.md"
  "$SOURCE_SKILL_DIR/references/CaTDD_DesignPrompt.md"
)

for legacy_link in "${legacy_source_links[@]}"; do
  if [[ -L "$legacy_link" ]]; then
    rm -f "$legacy_link"
  fi
done

rmdir "$SOURCE_SKILL_DIR/references" 2>/dev/null || true

mkdir -p "$OUTPUT_ROOT"
OUTPUT_ROOT="$(cd "$OUTPUT_ROOT" && pwd)"
DIST_SKILL_DIR="$OUTPUT_ROOT/$SKILL_NAME"

rm -rf "$DIST_SKILL_DIR"
mkdir -p "$DIST_SKILL_DIR/references"

cp "$SOURCE_SKILL_DIR/SKILL.md" "$DIST_SKILL_DIR/SKILL.md"
cp "$SOURCE_SKILL_DIR/README.md" "$DIST_SKILL_DIR/README.md"
cp "$REPO_ROOT/methodPrompts/README_UserGuide.md" "$DIST_SKILL_DIR/references/README_UserGuide.md"
cp "$REPO_ROOT/methodPrompts/README_UserGuide_ZH.md" "$DIST_SKILL_DIR/references/README_UserGuide_ZH.md"
cp "$REPO_ROOT/methodPrompts/CaTDD_methodPrompt.md" "$DIST_SKILL_DIR/references/CaTDD_methodPrompt.md"
cp "$REPO_ROOT/methodPrompts/CaTDD_ImplTemplate.cxx" "$DIST_SKILL_DIR/references/CaTDD_ImplTemplate.cxx"
cp -R "$REPO_ROOT/slashCommands" "$DIST_SKILL_DIR/slashCommands"

dist_symlink_count="$(find "$DIST_SKILL_DIR" -type l | wc -l | tr -d '[:space:]')"
if [[ "$dist_symlink_count" != "0" ]]; then
  echo "Generated package contains $dist_symlink_count symlink(s), expected a self-contained copy." >&2
  exit 1
fi

echo "Skill packaged as self-contained dist: $DIST_SKILL_DIR"
