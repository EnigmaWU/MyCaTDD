#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/slashCommands/commands"
OUTPUT_DIR="$REPO_ROOT/.continue/prompts"
WORKSPACE_ROOT="$REPO_ROOT"
CLEAN=0

usage() {
  cat <<'USAGE'
Usage: scripts/makeSlashCmd4Continue.sh [--source-dir DIR] [--output DIR] [--workspace-root DIR] [--clean]

Generate Continue-native .prompt wrappers from portable slashCommands.

Options:
  --source-dir DIR      Portable command source directory. Defaults to slashCommands/commands.
  --output DIR          Output directory for generated prompt files. Defaults to .continue/prompts.
  --workspace-root DIR  Workspace root used for generated path references. Defaults to this repository root.
  --clean               Remove existing generated UT_*.prompt, SPEC_*.prompt, and HARNESS_*.prompt files from the output directory first.
  -h, --help            Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source-dir)
      [[ $# -ge 2 ]] || { echo "[makeSlashCmd4Continue] --source-dir requires a directory" >&2; exit 2; }
      SOURCE_DIR="$2"
      shift 2
      ;;
    --output)
      [[ $# -ge 2 ]] || { echo "[makeSlashCmd4Continue] --output requires a directory" >&2; exit 2; }
      OUTPUT_DIR="$2"
      shift 2
      ;;
    --workspace-root)
      [[ $# -ge 2 ]] || { echo "[makeSlashCmd4Continue] --workspace-root requires a directory" >&2; exit 2; }
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
      echo "[makeSlashCmd4Continue] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "[makeSlashCmd4Continue] Missing source directory: slashCommands/commands" >&2
  exit 1
fi

if [[ ! -d "$WORKSPACE_ROOT" ]]; then
  echo "[makeSlashCmd4Continue] Missing workspace root: $WORKSPACE_ROOT" >&2
  exit 1
fi

SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"
WORKSPACE_ROOT="$(cd "$WORKSPACE_ROOT" && pwd)"
SLASH_ROOT="$(cd "$SOURCE_DIR/.." && pwd)"
METHOD_ROOT="$SLASH_ROOT/../methodPrompts"

if [[ ! -d "$METHOD_ROOT" ]]; then
  echo "[makeSlashCmd4Continue] Missing methodPrompts sibling for source: $METHOD_ROOT" >&2
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

if [[ "$CLEAN" -eq 1 ]]; then
  find "$OUTPUT_DIR" -maxdepth 1 -type f \( -name 'UT_*.prompt' -o -name 'SPEC_*.prompt' -o -name 'HARNESS_*.prompt' \) -delete
fi

generated_count=0

while IFS= read -r source_file; do
  command_file="$(basename "$source_file")"
  command_name="${command_file%.md}"
  flow_name="$(basename "$(dirname "$source_file")")"
  rel_source="$(rel_to_workspace "$source_file")"
  rel_method_index="$(rel_to_workspace "$METHOD_ROOT/README.md")"
  rel_slash_template="$(rel_to_workspace "$SLASH_ROOT/UT_slashCommandTemplate.md")"
  rel_flow_docs="$(rel_to_workspace "$SLASH_ROOT/flows")"
  rel_kit_docs="$(rel_to_workspace "$SLASH_ROOT/kits")"
  output_file="$OUTPUT_DIR/$command_name.prompt"

  cat > "$output_file" <<PROMPT
---
name: $command_name
description: Run CaTDD slash command $command_name
---
# $command_name

You are running a Continue-native prompt wrapper around a portable CaTDD slash command.

## Developer Input

{{{ input }}}

## Source Command

- Portable command path: $rel_source
- Flow or kit: $flow_name

## Method Source of Truth

- CaTDD method index: $rel_method_index
- Slash command contract: $rel_slash_template
- Flow docs: $rel_flow_docs
- Kit docs: $rel_kit_docs

## Execution Rules

1. Read and follow the portable source command before acting.
2. Treat this file as a thin Continue adapter; do not redefine CaTDD method semantics here.
3. Use methodPrompts for category meaning, priority order, design skeleton rules, and CaTDD constraints.
4. Use the source command for inputs, outputs, conflict guards, and next-step flow or kit contract.
5. Ask for missing product intent instead of inventing requirements.
6. Report the next recommended slash command when the step finishes.

ONE-MORE-THING: ask developer if something not sure
PROMPT

  generated_count=$((generated_count + 1))
done < <(find "$SOURCE_DIR" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | sort)

echo "[makeSlashCmd4Continue] Generated $generated_count Continue prompt wrappers in $(rel_to_workspace "$OUTPUT_DIR")"