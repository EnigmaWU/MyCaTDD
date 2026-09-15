#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/slashCommands/commands"
OUTPUT_DIR="$REPO_ROOT/.agents/skills"
PROMPTS_OUTPUT_DIR=""
WORKSPACE_ROOT="$REPO_ROOT"
CLEAN=0

usage() {
  cat <<'USAGE'
Usage: scripts/makeSlashCmd4Codex.sh [--source-dir DIR] [--output DIR] [--prompts-output DIR] [--workspace-root DIR] [--clean]

Generate Codex-native adapters from portable slashCommands:

- Codex skills (recommended): <output>/<skill-name>/SKILL.md, invoked as $<skill-name>
  or from /skills. Skills are the supported, repository-shareable surface.
- Codex custom prompts (deprecated): flat <prompts-output>/<Command>.md files, invoked
  as /prompts:<Command>. Codex reads custom prompts from the local Codex home only, so
  point --prompts-output at $CODEX_HOME/prompts (default ~/.codex/prompts).

Codex skill names accept lowercase letters, numbers, and hyphens only, so
UT_convertDemoToTypical becomes ut-convert-demo-to-typical. The canonical command
name stays in each wrapper description and body.

Options:
  --source-dir DIR      Portable command source directory. Defaults to slashCommands/commands.
  --output DIR          Output directory for generated Codex skill directories. Defaults to .agents/skills.
  --prompts-output DIR  Optional output directory for deprecated Codex custom prompts.
  --workspace-root DIR  Workspace root used for generated path references. Defaults to this repository root.
  --clean               Remove previously generated wrappers from the output directories first.
  -h, --help            Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source-dir)
      [[ $# -ge 2 ]] || { echo "[makeSlashCmd4Codex] --source-dir requires a directory" >&2; exit 2; }
      SOURCE_DIR="$2"
      shift 2
      ;;
    --output)
      [[ $# -ge 2 ]] || { echo "[makeSlashCmd4Codex] --output requires a directory" >&2; exit 2; }
      OUTPUT_DIR="$2"
      shift 2
      ;;
    --prompts-output)
      [[ $# -ge 2 ]] || { echo "[makeSlashCmd4Codex] --prompts-output requires a directory" >&2; exit 2; }
      PROMPTS_OUTPUT_DIR="$2"
      shift 2
      ;;
    --workspace-root)
      [[ $# -ge 2 ]] || { echo "[makeSlashCmd4Codex] --workspace-root requires a directory" >&2; exit 2; }
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
      echo "[makeSlashCmd4Codex] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "[makeSlashCmd4Codex] Missing source directory: slashCommands/commands" >&2
  exit 1
fi

if [[ ! -d "$WORKSPACE_ROOT" ]]; then
  echo "[makeSlashCmd4Codex] Missing workspace root: $WORKSPACE_ROOT" >&2
  exit 1
fi

SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"
WORKSPACE_ROOT="$(cd "$WORKSPACE_ROOT" && pwd)"
SLASH_ROOT="$(cd "$SOURCE_DIR/.." && pwd)"
METHOD_ROOT="$SLASH_ROOT/../methodPrompts"

if [[ ! -d "$METHOD_ROOT" ]]; then
  echo "[makeSlashCmd4Codex] Missing methodPrompts sibling for source: $METHOD_ROOT" >&2
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

if [[ -n "$PROMPTS_OUTPUT_DIR" ]]; then
  mkdir -p "$PROMPTS_OUTPUT_DIR"
  PROMPTS_OUTPUT_DIR="$(cd "$PROMPTS_OUTPUT_DIR" && pwd)"
fi

if [[ "$CLEAN" -eq 1 ]]; then
  for existing in "$OUTPUT_DIR"/ut-* "$OUTPUT_DIR"/spec-* "$OUTPUT_DIR"/harness-*; do
    [[ -d "$existing" ]] && rm -rf "$existing"
  done
  if [[ -n "$PROMPTS_OUTPUT_DIR" ]]; then
    find "$PROMPTS_OUTPUT_DIR" -maxdepth 1 -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) -delete
  fi
fi

skill_count=0
prompt_count=0

while IFS= read -r source_file; do
  command_file="$(basename "$source_file")"
  # Derive the Codex skill name from the command filename.
  # Codex accepts lowercase letters, numbers, and hyphens only, so convert:
  # SPEC_importIssue -> spec-import-issue, UT_designTypicalSkeleton -> ut-design-typical-skeleton,
  # HARNESS_patchCaTDDSource -> harness-patch-ca-tdd-source
  raw_name="${command_file%.md}"
  skill_name="$(printf '%s' "$raw_name" | sed -E 's/([A-Z]+)([A-Z][a-z])/\1-\2/g; s/([a-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]' | tr '_' '-')"
  flow_name="$(basename "$(dirname "$source_file")")"
  rel_source="$(rel_to_workspace "$source_file")"
  rel_method_index="$(rel_to_workspace "$METHOD_ROOT/README.md")"
  rel_slash_template="$(rel_to_workspace "$SLASH_ROOT/UT_slashCommandTemplate.md")"
  rel_flow_docs="$(rel_to_workspace "$SLASH_ROOT/flows")"
  rel_kit_docs="$(rel_to_workspace "$SLASH_ROOT/kits")"

  if [[ ! "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || [[ "${#skill_name}" -gt 64 ]]; then
    echo "[makeSlashCmd4Codex] Cannot derive a valid Codex skill name from: $command_file (got '$skill_name')" >&2
    exit 1
  fi

  # Extract a short description from the ## Purpose section.
  desc_line=""
  desc_line=$(awk '/^## Purpose/ {found=1; next} found && /^[[:space:]]*$/ {next} found && /^[^#]/ {print; exit}' "$source_file" | head -c 200 | tr -d '"\\' | tr '\n' ' ')
  if [[ -n "$desc_line" ]]; then
    description="Run CaTDD slash command ${raw_name} (flow ${flow_name}). ${desc_line}"
  else
    description="Run CaTDD slash command ${raw_name} (flow ${flow_name})"
  fi
  description="$(printf '%s' "${description:0:400}" | sed -E 's/[[:space:]]+$//')"

  skill_dir="$OUTPUT_DIR/$skill_name"
  mkdir -p "$skill_dir"

  cat > "$skill_dir/SKILL.md" <<SKILL
---
name: $skill_name
description: "$description"
---

# $raw_name

You are running a Codex Skill wrapper around a portable CaTDD slash command.

## Source Command

- Canonical command name: $raw_name
- Portable command path: $rel_source
- Flow or kit: $flow_name

## Method Source of Truth

- CaTDD method index: $rel_method_index
- Slash command contract: $rel_slash_template
- Flow docs: $rel_flow_docs
- Kit docs: $rel_kit_docs

## Execution Rules

1. Read and follow the portable source command located at \`$rel_source\` before acting.
2. Treat this file as a thin Codex Skill adapter; do not redefine CaTDD method semantics here.
3. Use methodPrompts for category meaning, priority order, design skeleton rules, and CaTDD constraints.
4. Use the source command for inputs, outputs, conflict guards, and next-step flow or kit contract.
5. Ask for missing product intent instead of inventing requirements.
6. Report the next recommended slash command when the step finishes.

ONE-MORE-THING: ask developer if something not sure
SKILL

  skill_count=$((skill_count + 1))

  if [[ -n "$PROMPTS_OUTPUT_DIR" ]]; then
    prompt_file="$PROMPTS_OUTPUT_DIR/$raw_name.md"

    cat > "$prompt_file" <<PROMPT
---
description: "$description"
argument-hint: "[INPUT=<task intent>] [SOURCE=<paths>] [TARGET=<paths>]"
---

# $raw_name

You are running a Codex custom-prompt wrapper around a portable CaTDD slash command.

## Developer Arguments

\$ARGUMENTS

## Source Command

- Canonical command name: $raw_name
- Portable command path: $rel_source
- Flow or kit: $flow_name

## Method Source of Truth

- CaTDD method index: $rel_method_index
- Slash command contract: $rel_slash_template
- Flow docs: $rel_flow_docs
- Kit docs: $rel_kit_docs

## Execution Rules

1. Read and follow the portable source command located at \`$rel_source\` before acting.
2. Treat this file as a thin Codex custom-prompt adapter; do not redefine CaTDD method semantics here.
3. Use methodPrompts for category meaning, priority order, design skeleton rules, and CaTDD constraints.
4. Use the source command for inputs, outputs, conflict guards, and next-step flow or kit contract.
5. Ask for missing product intent instead of inventing requirements.
6. Report the next recommended slash command when the step finishes.

ONE-MORE-THING: ask developer if something not sure
PROMPT

    prompt_count=$((prompt_count + 1))
  fi
done < <(find "$SOURCE_DIR" -type f \( -name 'UT_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | sort)

echo "[makeSlashCmd4Codex] Generated $skill_count Codex skill wrappers in $(rel_to_workspace "$OUTPUT_DIR")"

if [[ -n "$PROMPTS_OUTPUT_DIR" ]]; then
  echo "[makeSlashCmd4Codex] Generated $prompt_count Codex custom prompts in $(rel_to_workspace "$PROMPTS_OUTPUT_DIR")"
fi
