#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR=""
CUSTOM_DIR=".customCodeAgent"
CLEAN_PROMPTS=0
INIT=0
VERBOSE=0
YES=0

usage() {
  cat <<'USAGE'
Usage: scripts/installCaTDD4Custom.sh --target DIR [--custom-dir NAME] [--clean-prompts] [--init] [--verbose] [--yes]

Install or refresh CaTDD methodPrompts, slashCommands, SpecCoding artifact workspace,
and custom rule/prompt wrappers into a target project.

Options:
  --target DIR      Target project directory.
  --custom-dir NAME Custom subdir name under target (default: .customCodeAgent).
  --clean-prompts   Remove existing generated TEST_*.prompt, SPEC_*.prompt, and HARNESS_*.prompt files before regenerating wrappers.
  --init            Create the target directory if it does not exist.
  --verbose         Print detailed action steps for diagnosis.
  --yes, -y         Skip the Y/n confirmation prompt (non-interactive / scripted use).
  -h, --help        Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || { echo "[installCaTDD4Custom] --target requires a directory" >&2; exit 2; }
      TARGET_DIR="$2"
      shift 2
      ;;
    --custom-dir)
      [[ $# -ge 2 ]] || { echo "[installCaTDD4Custom] --custom-dir requires a directory name" >&2; exit 2; }
      CUSTOM_DIR="$2"
      shift 2
      ;;
    --clean-prompts)
      CLEAN_PROMPTS=1
      shift
      ;;
    --init)
      INIT=1
      shift
      ;;
    --verbose)
      VERBOSE=1
      shift
      ;;
    --yes|-y)
      YES=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[installCaTDD4Custom] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$TARGET_DIR" ]]; then
  echo "[installCaTDD4Custom] Missing required --target DIR" >&2
  usage >&2
  exit 2
fi

CUSTOM_DIR="${CUSTOM_DIR%/}"
if [[ -z "$CUSTOM_DIR" ]] || [[ "$CUSTOM_DIR" == "." ]] || [[ "$CUSTOM_DIR" == ".." ]] || [[ "$CUSTOM_DIR" == /* ]] || [[ "$CUSTOM_DIR" == *"/"* ]]; then
  echo "[installCaTDD4Custom] --custom-dir must be a single relative subdir name (example: .customCodeAgent)" >&2
  exit 2
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  if [[ "$INIT" -eq 1 ]]; then
    mkdir -p "$TARGET_DIR"
  else
    echo "[installCaTDD4Custom] Target directory does not exist: $TARGET_DIR" >&2
    echo "[installCaTDD4Custom] Use --init to create it." >&2
    exit 1
  fi
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
CATDD_DIR="$TARGET_DIR/.catdd"
SPEC_DIR="$CATDD_DIR/spec"
CUSTOM_ROOT_DIR="$TARGET_DIR/$CUSTOM_DIR"
CUSTOM_RULES_DIR="$CUSTOM_ROOT_DIR/rules"
CUSTOM_PROMPTS_DIR="$CUSTOM_ROOT_DIR/prompts"

# Compute version from the latest git commit in the MyCaTDD source repo
CATDD_VERSION="$(git -C "$REPO_ROOT" log -1 --format='%ad' --date='format:%Y%m%d.%H' 2>/dev/null || echo 'unknown')"

# Read currently installed version before overwriting
INSTALLED_VERSION=""
if [[ -f "$CATDD_DIR/CaTDD_INSTALL.md" ]]; then
  INSTALLED_VERSION="$(sed -n 's/^- Installed version: //p' "$CATDD_DIR/CaTDD_INSTALL.md" | head -1)"
fi

# Report version action
if [[ -z "$INSTALLED_VERSION" ]]; then
  echo "[installCaTDD4Custom] version: $CATDD_VERSION (fresh install)"
elif [[ "$INSTALLED_VERSION" == "$CATDD_VERSION" ]] \
  || [[ "$CATDD_VERSION" == "unknown" ]] \
  || [[ "$INSTALLED_VERSION" == "unknown" ]]; then
  echo "[installCaTDD4Custom] version: $CATDD_VERSION (same version, replacement)"
elif [[ "$CATDD_VERSION" > "$INSTALLED_VERSION" ]]; then
  echo "[installCaTDD4Custom] version: $INSTALLED_VERSION -> $CATDD_VERSION (upgrade)"
else
  echo "[installCaTDD4Custom] version: $INSTALLED_VERSION -> $CATDD_VERSION (downgrade)"
fi

# Y/n confirmation
if [[ "$YES" -eq 0 ]]; then
  read -r -p "[installCaTDD4Custom] Proceed with installation? [Y/n]: " _confirm
  _confirm_lc="$(printf '%s' "$_confirm" | tr '[:upper:]' '[:lower:]')"
  case "$_confirm_lc" in
    n|no)
      echo "[installCaTDD4Custom] Installation cancelled."
      exit 0
      ;;
  esac
fi

if [[ "$VERBOSE" -eq 1 ]]; then
  set -x
fi

log_install_operation() {
  local action="$1"
  local path="$2"
  [[ "$VERBOSE" -eq 1 ]] || return 0
  echo "[installCaTDD4Custom] ${action}: ${path#$TARGET_DIR/}"
}

log_replace_or_new() {
  local path="$1"
  if [[ -e "$path" ]]; then
    log_install_operation replace "$path"
  else
    log_install_operation new "$path"
  fi
}

rel_to_workspace() {
  local path="$1"
  if [[ "$path" == "$TARGET_DIR" ]]; then
    printf '%s\n' "."
  elif [[ "$path" == "$TARGET_DIR/"* ]]; then
    printf '%s\n' "${path#$TARGET_DIR/}"
  else
    printf '%s\n' "$path"
  fi
}

generate_custom_prompts() {
  local source_dir="$CATDD_DIR/slashCommands/commands"
  local slash_root="$CATDD_DIR/slashCommands"
  local method_root="$CATDD_DIR/methodPrompts"
  local source_file command_file command_name flow_name
  local rel_source rel_method_index rel_slash_template rel_flow_docs rel_kit_docs
  local output_file
  local generated_count=0

  if [[ "$CLEAN_PROMPTS" -eq 1 ]]; then
    find "$CUSTOM_PROMPTS_DIR" -maxdepth 1 -type f \( -name 'UT_*.prompt' -o -name 'TEST_*.prompt' -o -name 'SPEC_*.prompt' -o -name 'HARNESS_*.prompt' \) -delete
  fi

  while IFS= read -r source_file; do
    command_file="$(basename "$source_file")"
    command_name="${command_file%.md}"
    flow_name="$(basename "$(dirname "$source_file")")"
    rel_source="$(rel_to_workspace "$source_file")"
    rel_method_index="$(rel_to_workspace "$method_root/README.md")"
    rel_slash_template="$(rel_to_workspace "$slash_root/TEST_slashCommandTemplate.md")"
    rel_flow_docs="$(rel_to_workspace "$slash_root/flows")"
    rel_kit_docs="$(rel_to_workspace "$slash_root/kits")"
    output_file="$CUSTOM_PROMPTS_DIR/$command_name.prompt"

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

1. Read and follow the portable source command before acting; if a sibling <Name>Evolved.md overlay exists, follow the overlay instead because it supersedes the canonical command locally.
2. Treat this file as a thin Continue adapter; do not redefine CaTDD method semantics here.
3. Use methodPrompts for category meaning, priority order, design skeleton rules, and CaTDD constraints.
4. Use the source command for inputs, outputs, conflict guards, and next-step flow or kit contract.
5. Ask for missing product intent instead of inventing requirements.
6. Report the next recommended slash command when the step finishes.

ONE-MORE-THING: ask developer if something not sure
PROMPT

    generated_count=$((generated_count + 1))
  done < <(find "$source_dir" -type f \( -name 'TEST_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | sort)

  echo "[installCaTDD4Custom] Generated $generated_count custom prompt wrappers in $(rel_to_workspace "$CUSTOM_PROMPTS_DIR")"
}

if [[ -e "$CUSTOM_ROOT_DIR" && ! -d "$CUSTOM_ROOT_DIR" ]]; then
  echo "[installCaTDD4Custom] Cannot create $CUSTOM_DIR/rules/catdd.md because $CUSTOM_DIR exists and is not a directory." >&2
  exit 1
fi

mkdir -p "$CATDD_DIR" "$SPEC_DIR/pendingNews" "$SPEC_DIR/analyzedNews" "$SPEC_DIR/todoUS" "$SPEC_DIR/doingUS" "$SPEC_DIR/suspendUS" "$SPEC_DIR/abortUS" "$SPEC_DIR/doneUS" "$CUSTOM_RULES_DIR" "$CUSTOM_PROMPTS_DIR"

update_spec_gitignore() {
  local gitignore_file="$TARGET_DIR/.gitignore"
  local temp_file
  local gitignore_exists=0
  temp_file="$(mktemp)"

  if [[ -f "$gitignore_file" ]]; then
    gitignore_exists=1
    awk '
      $0 == "# BEGIN CaTDD SpecCoding local state" { skip = 1; next }
      $0 == "# END CaTDD SpecCoding local state" { skip = 0; next }
      !skip { print }
    ' "$gitignore_file" > "$temp_file"
  else
    : > "$temp_file"
  fi

  if [[ -s "$temp_file" ]]; then
    perl -0pi -e 's/[ \t\r]*\n+\z/\n/' "$temp_file"
  fi

  if [[ "$gitignore_exists" -eq 1 ]]; then
    log_install_operation patch "$gitignore_file"
  else
    log_install_operation new "$gitignore_file"
  fi

  {
    if [[ -s "$temp_file" ]]; then
      cat "$temp_file"
      printf '\n'
    fi
    cat <<'GITIGNORE'
# BEGIN CaTDD SpecCoding local state
/.catdd/spec/WorkingProcessLog.md
# END CaTDD SpecCoding local state
GITIGNORE
  } > "$gitignore_file"

  rm -f "$temp_file"
}

log_replace_or_new "$CATDD_DIR/methodPrompts"
log_replace_or_new "$CATDD_DIR/slashCommands"
rm -rf "$CATDD_DIR/methodPrompts" "$CATDD_DIR/slashCommands"
cp -R "$REPO_ROOT/methodPrompts" "$CATDD_DIR/methodPrompts"
cp -R "$REPO_ROOT/slashCommands" "$CATDD_DIR/slashCommands"
update_spec_gitignore

log_replace_or_new "$CATDD_DIR/CaTDD_INSTALL.md"
printf '# CaTDD Install Marker\n\n- Installed version: %s\n\n' "$CATDD_VERSION" > "$CATDD_DIR/CaTDD_INSTALL.md"
cat >> "$CATDD_DIR/CaTDD_INSTALL.md" <<MARKER
This directory is managed by \
\`scripts/installCaTDD4Custom.sh\` from MyCaTDD.

- \`methodPrompts/\` is the installed CaTDD method source.
- \`slashCommands/\` is the installed portable flow-command source.
- \`spec/\` is the installed SpecCoding artifact workspace.
- Custom project rule: \`$CUSTOM_DIR/rules/catdd.md\`.
- Continue-format prompt wrappers: \`$CUSTOM_DIR/prompts/TEST_*.prompt\`, \`$CUSTOM_DIR/prompts/SPEC_*.prompt\`, and \`$CUSTOM_DIR/prompts/HARNESS_*.prompt\`.
- Commit team-shared SpecCoding artifacts under \`.catdd/spec/\`, such as \`projectContext.md\`, \`pendingNews/\`, \`analyzedNews/\`, \`todoUS/\`, \`doingUS/\`, \`suspendUS/\`, \`abortUS/\`, and \`doneUS/\`.
- Use project-root \`README*\` files for shared SPEC docs such as \`README.md\`, \`README_ArchDesign.md\`, \`README_UserStories.md\`, \`README_UserGuide.md\`, \`README_DetailDesign.md\`, \`README_DetailVerifyDesign.md\`, \`README_ErrorDesign.md\`, \`README_ResourceDesign.md\`, \`README_StateDesign.md\`, \`README_PerfDesign.md\`, \`README_CompatDesign.md\`, \`README_DiagnosisDesign.md\`, \`README_ArchVerifyDesign.md\`, and \`README_VerifyDesign.md\` as needed.
- Keep local SpecCoding work state such as \`.catdd/spec/WorkingProcessLog.md\` gitignored.

Refresh this project by rerunning the installer from the MyCaTDD repository.
MARKER

log_replace_or_new "$CUSTOM_RULES_DIR/catdd.md"
cat > "$CUSTOM_RULES_DIR/catdd.md" <<RULES
# CaTDD Custom Project Rule

This is a custom project rule installed by MyCaTDD. Use it when working with CaTDD, SpecCoding, VibeCoding, comment-alive tests, US/AC/TC skeletons, or TEST_*, SPEC_*, and HARNESS_* commands.

## Installed Sources

- CaTDD method source: \`.catdd/methodPrompts/\`
- Portable slash command source: \`.catdd/slashCommands/\`
- Continue-format prompt wrappers: \`$CUSTOM_DIR/prompts/TEST_*.prompt\`, \`$CUSTOM_DIR/prompts/SPEC_*.prompt\`, and \`$CUSTOM_DIR/prompts/HARNESS_*.prompt\`
- SpecCoding flow: \`.catdd/slashCommands/flows/Px-SpecFlow.md\`
- SpecCoding artifact workspace: \`.catdd/spec/\`
- Project-root README SPEC docs: \`README.md\`, \`README_ArchDesign.md\`, \`README_UserStories.md\`, \`README_UserGuide.md\`, \`README_DetailDesign.md\`, \`README_DetailVerifyDesign.md\`, \`README_ErrorDesign.md\`, \`README_ResourceDesign.md\`, \`README_StateDesign.md\`, \`README_PerfDesign.md\`, \`README_CompatDesign.md\`, \`README_DiagnosisDesign.md\`, \`README_ArchVerifyDesign.md\`, and \`README_VerifyDesign.md\` as needed.

## Custom Behavior

- Treat this file as a thin custom adapter over \`.catdd/methodPrompts/\` and \`.catdd/slashCommands/\`.
- Use \`$CUSTOM_DIR/prompts/\` for triggerable TEST_*, SPEC_*, and HARNESS_* prompt wrappers in Continue format.
- Treat \`.catdd/methodPrompts/\` as the source of truth for CaTDD category meaning, priority order, design skeleton rules, and method constraints.
- Use \`.catdd/slashCommands/commands/\` for TEST_*, SPEC_*, and HARNESS_* commands; read the portable command before acting.
- Keep SpecCoding lifecycle state under \`.catdd/spec/\`.
- Commit team-shared artifacts such as \`.catdd/spec/projectContext.md\`, \`.catdd/spec/pendingNews/\`, \`.catdd/spec/analyzedNews/\`, \`.catdd/spec/todoUS/\`, \`.catdd/spec/doingUS/\`, \`.catdd/spec/suspendUS/\`, \`.catdd/spec/abortUS/\`, \`.catdd/spec/doneUS/\`, and project-root \`README*\` SPEC docs.
- Keep local work state such as \`.catdd/spec/WorkingProcessLog.md\` gitignored.
- Prefer explicit SpecFlow intake commands: \`SPEC_importIssue\`, \`SPEC_importFeature\`, \`SPEC_importUserStory\`, \`SPEC_analyzeIssue\`, and \`SPEC_analyzeFeature\`.
- After every meaningful verified success, report \`success_learning_checkpoint = recommended\` and remind the developer to run \`/HARNESS_evolveHarness\` with \`evolution_mode=auto\`. Keep the hook non-blocking, preserve any required lifecycle/commit/merge/safety command as the immediate next action, and never auto-apply an evolution proposal. While running \`HARNESS_evolveHarness\`, suppress this hook for the command's own completion or the same evidence; only materially new verified evidence may trigger another checkpoint.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.

ONE-MORE-THING: ask developer if something not sure
RULES

generate_custom_prompts

echo "[installCaTDD4Custom] Installed CaTDD for custom adapter into $TARGET_DIR"
echo "[installCaTDD4Custom] Method source: .catdd/methodPrompts"
echo "[installCaTDD4Custom] Slash command source: .catdd/slashCommands"
echo "[installCaTDD4Custom] SpecCoding artifacts: .catdd/spec"
echo "[installCaTDD4Custom] Custom rule: $CUSTOM_DIR/rules/catdd.md"
echo "[installCaTDD4Custom] Custom prompts: $CUSTOM_DIR/prompts"
