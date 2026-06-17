#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/slashCommands/commands"
OUTPUT_DIR="$REPO_ROOT/.cline/skills"
WORKSPACE_ROOT="$REPO_ROOT"
CLEAN=0

usage() {
  cat <<'USAGE'
Usage: scripts/makeSlashCmd4Cline.sh [--source-dir DIR] [--output DIR] [--workspace-root DIR] [--clean]

Generate Cline SKILL.md wrappers from portable slashCommands, so each command
can be triggered as /UT_* or /SPEC_* in Cline chat.

Options:
  --source-dir DIR      Portable command source directory. Defaults to slashCommands/commands.
  --output DIR          Output directory for generated skill directories. Defaults to .cline/skills.
  --workspace-root DIR  Workspace root used for generated path references. Defaults to this repository root.
  --clean               Remove existing generated skill directories from the output directory first.
  -h, --help            Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source-dir)
      [[ $# -ge 2 ]] || { echo "[makeSlashCmd4Cline] --source-dir requires a directory" >&2; exit 2; }
      SOURCE_DIR="$2"
      shift 2
      ;;
    --output)
      [[ $# -ge 2 ]] || { echo "[makeSlashCmd4Cline] --output requires a directory" >&2; exit 2; }
      OUTPUT_DIR="$2"
      shift 2
      ;;
    --workspace-root)
      [[ $# -ge 2 ]] || { echo "[makeSlashCmd4Cline] --workspace-root requires a directory" >&2; exit 2; }
      WORKSPACE_ROOT="$2"
      shift 2
      ;;
    --clean)
      CLEAN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[makeSlashCmd4Cline] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "[makeSlashCmd4Cline] Missing source directory: slashCommands/commands" >&2
  exit 1
fi

if [[ ! -d "$WORKSPACE_ROOT" ]]; then
  echo "[makeSlashCmd4Cline] Missing workspace root: $WORKSPACE_ROOT" >&2
  exit 1
fi

SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"
WORKSPACE_ROOT="$(cd "$WORKSPACE_ROOT" && pwd)"
SLASH_ROOT="$(cd "$SOURCE_DIR/.." && pwd)"
METHOD_ROOT="$SLASH_ROOT/../methodPrompts"

if [[ ! -d "$METHOD_ROOT" ]]; then
  echo "[makeSlashCmd4Cline] Missing methodPrompts sibling for source: $METHOD_ROOT" >&2
  exit 1
fi

METHOD_ROOT="$(cd "$METHOD_ROOT" && pwd)"

rel_to_workspace() {
  local path="$1"
  if [[ "$path" == "$WORKSPACE_ROOT" ]]; then
    printf '%s\n' "."
  elif [[ "$path" == "$WORKSPACE_ROOT/"* ]]; then
    printf '%s\n' "${path#$WORKSPACE_ROOT/}"
  else
    printf '%s\n' "$path"
  fi
}

mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR="$(cd "$OUTPUT_DIR" && pwd)"

# Clean mode: remove existing generated skill directories
if [[ "$CLEAN" -eq 1 ]]; then
  for existing in "$OUTPUT_DIR"/ut-* "$OUTPUT_DIR"/spec-*; do
    [[ -d "$existing" ]] && rm -rf "$existing"
  done
fi

generated_count=0

while IFS= read -r source_file; do
  command_file="$(basename "$source_file")"
  # Derive the Cline skill name from the command filename
  raw_name="${command_file%.md}"
  # Cline enforces: "Skill name may only contain lowercase letters, numbers, and hyphens."
  # So convert: SPEC_importIssue -> spec-import-issue, UT_designTypicalSkeleton -> ut-design-typical-skeleton
  command_name="$(printf '%s' "$raw_name" | sed 's/\([a-z0-9]\)\([A-Z]\)/\1-\2/g' | tr '[:upper:]' '[:lower:]' | tr '_' '-')"
  flow_name="$(basename "$(dirname "$source_file")")"
  rel_source="$(rel_to_workspace "$source_file")"
  rel_method_index="$(rel_to_workspace "$METHOD_ROOT/README.md")"
  rel_slash_template="$(rel_to_workspace "$SLASH_ROOT/UT_slashCommandTemplate.md")"
  rel_flow_docs="$(rel_to_workspace "$SLASH_ROOT/flows")"

  # Extract a short description from the ## Purpose section
  description=""
  if [[ -f "$source_file" ]]; then
    # Find the Purpose section and get the first non-empty, non-heading line after it
    desc_line=$(awk '/^## Purpose/ {found=1; next} found && /^[[:space:]]*$/ {next} found && /^[^#]/ {print; exit}' "$source_file" | head -c 200)
    if [[ -n "$desc_line" ]]; then
      description="$desc_line"
    fi
  fi
  if [[ -z "$description" ]]; then
    description="Run CaTDD slash command $command_name"
  fi

  skill_dir="$OUTPUT_DIR/$command_name"
  mkdir -p "$skill_dir"

  cat > "$skill_dir/SKILL.md" <<SKILL
---
name: $command_name
description: $description
---

# $command_name

You are running a Cline Skill wrapper around a portable CaTDD slash command.

## Developer Input

{{{ input }}}

## Source Command

- Portable command path: $rel_source
- Flow: $flow_name

## Method Source of Truth

- CaTDD method index: $rel_method_index
- Slash command contract: $rel_slash_template
- Flow docs: $rel_flow_docs

## Execution Rules

1. Read and follow the portable source command located at \`$rel_source\` before acting.
2. Treat this file as a thin Cline Skill adapter; do not redefine CaTDD method semantics here.
3. Use methodPrompts for category meaning, priority order, design skeleton rules, and CaTDD constraints.
4. Use the source command for inputs, outputs, conflict guards, and next-step flow.
5. Ask for missing product intent instead of inventing requirements.
6. Report the next recommended slash command when the step finishes.

ONE-MORE-THING: ask developer if something not sure
SKILL

  generated_count=$((generated_count + 1))
done < <(find "$SOURCE_DIR" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' \) | sort)

echo "[makeSlashCmd4Cline] Generated $generated_count Cline Skill wrappers in $(rel_to_workspace "$OUTPUT_DIR")"