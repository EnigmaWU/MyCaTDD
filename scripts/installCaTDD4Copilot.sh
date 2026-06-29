#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR=""
CLEAN_PROMPTS=0
INIT=0
VERBOSE=0
YES=0

usage() {
  cat <<'USAGE'
Usage: scripts/installCaTDD4Copilot.sh --target DIR [--clean-prompts] [--init] [--verbose] [--yes]

Install or refresh CaTDD methodPrompts, slashCommands, and Copilot-native prompt wrappers into a target project.

Options:
  --target DIR      Target project directory.
  --clean-prompts   Remove existing generated UT_*.prompt.md and SPEC_*.prompt.md files before regenerating Copilot wrappers.
  --init            Create the target directory if it does not exist.
  --verbose         Print detailed action steps for diagnosis.
  --yes, -y         Skip the Y/n confirmation prompt (non-interactive / scripted use).
  -h, --help        Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || { echo "[installCaTDD4Copilot] --target requires a directory" >&2; exit 2; }
      TARGET_DIR="$2"
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
      echo "[installCaTDD4Copilot] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$TARGET_DIR" ]]; then
  echo "[installCaTDD4Copilot] Missing required --target DIR" >&2
  usage >&2
  exit 2
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  if [[ "$INIT" -eq 1 ]]; then
    mkdir -p "$TARGET_DIR"
  else
    echo "[installCaTDD4Copilot] Target directory does not exist: $TARGET_DIR" >&2
    echo "[installCaTDD4Copilot] Use --init to create it." >&2
    exit 1
  fi
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
CATDD_DIR="$TARGET_DIR/.catdd"
SPEC_DIR="$CATDD_DIR/spec"
ROOT_UBILANG_SOURCE="$REPO_ROOT/README_UbiLang.md"
ROOT_UBILANG_TARGET="$TARGET_DIR/README_UbiLang.md"
ROOT_UBILANG_ZH_SOURCE="$REPO_ROOT/README_UbiLang_ZH.md"
ROOT_UBILANG_ZH_TARGET="$TARGET_DIR/README_UbiLang_ZH.md"
GITHUB_DIR="$TARGET_DIR/.github"
PROMPTS_DIR="$GITHUB_DIR/prompts"
INSTRUCTIONS_DIR="$GITHUB_DIR/instructions"

# Compute version from the latest git commit in the MyCaTDD source repo
CATDD_VERSION="$(git -C "$REPO_ROOT" log -1 --format='%ad' --date='format:%Y%m%d.%H' 2>/dev/null || echo 'unknown')"

# Read currently installed version before overwriting
INSTALLED_VERSION=""
if [[ -f "$CATDD_DIR/CaTDD_INSTALL.md" ]]; then
  INSTALLED_VERSION="$(sed -n 's/^- Installed version: //p' "$CATDD_DIR/CaTDD_INSTALL.md" | head -1)"
fi

# Report version action
if [[ -z "$INSTALLED_VERSION" ]]; then
  echo "[installCaTDD4Copilot] version: $CATDD_VERSION (fresh install)"
elif [[ "$INSTALLED_VERSION" == "$CATDD_VERSION" ]] \
  || [[ "$CATDD_VERSION" == "unknown" ]] \
  || [[ "$INSTALLED_VERSION" == "unknown" ]]; then
  echo "[installCaTDD4Copilot] version: $CATDD_VERSION (same version, replacement)"
elif [[ "$CATDD_VERSION" > "$INSTALLED_VERSION" ]]; then
  echo "[installCaTDD4Copilot] version: $INSTALLED_VERSION -> $CATDD_VERSION (upgrade)"
else
  echo "[installCaTDD4Copilot] version: $INSTALLED_VERSION -> $CATDD_VERSION (downgrade)"
fi

# Y/n confirmation
if [[ "$YES" -eq 0 ]]; then
  read -r -p "[installCaTDD4Copilot] Proceed with installation? [Y/n]: " _confirm
  _confirm_lc="$(printf '%s' "$_confirm" | tr '[:upper:]' '[:lower:]')"
  case "$_confirm_lc" in
    n|no)
      echo "[installCaTDD4Copilot] Installation cancelled."
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
  echo "[installCaTDD4Copilot] ${action}: ${path#$TARGET_DIR/}"
}

log_replace_or_new() {
  local path="$1"
  if [[ -e "$path" ]]; then
    log_install_operation replace "$path"
  else
    log_install_operation new "$path"
  fi
}

mkdir -p "$CATDD_DIR" "$SPEC_DIR/pendingNews" "$SPEC_DIR/analyzedNews" "$SPEC_DIR/todoUS" "$SPEC_DIR/doingUS" "$SPEC_DIR/suspendUS" "$SPEC_DIR/abortUS" "$SPEC_DIR/doneUS" "$PROMPTS_DIR" "$INSTRUCTIONS_DIR"

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

if [[ ! -f "$ROOT_UBILANG_SOURCE" ]]; then
  echo "[installCaTDD4Copilot] Missing source file: $ROOT_UBILANG_SOURCE" >&2
  exit 1
fi
if [[ ! -f "$ROOT_UBILANG_ZH_SOURCE" ]]; then
  echo "[installCaTDD4Copilot] Missing source file: $ROOT_UBILANG_ZH_SOURCE" >&2
  exit 1
fi
log_replace_or_new "$ROOT_UBILANG_TARGET"
[[ $ROOT_UBILANG_SOURCE -ef $ROOT_UBILANG_TARGET ]] || cp "$ROOT_UBILANG_SOURCE" "$ROOT_UBILANG_TARGET"
log_replace_or_new "$ROOT_UBILANG_ZH_TARGET"
[[ $ROOT_UBILANG_ZH_SOURCE -ef $ROOT_UBILANG_ZH_TARGET ]] || cp "$ROOT_UBILANG_ZH_SOURCE" "$ROOT_UBILANG_ZH_TARGET"

log_replace_or_new "$CATDD_DIR/CaTDD_INSTALL.md"
printf '# CaTDD Install Marker\n\n- Installed version: %s\n\n' "$CATDD_VERSION" > "$CATDD_DIR/CaTDD_INSTALL.md"
cat >> "$CATDD_DIR/CaTDD_INSTALL.md" <<'MARKER'
This directory is managed by `scripts/installCaTDD4Copilot.sh` from MyCaTDD.

- `methodPrompts/` is the installed CaTDD method source.
- `slashCommands/` is the installed portable flow-command source.
- `spec/` is the installed SpecCoding artifact workspace.
- `.github/prompts/UT_*.prompt.md` and `.github/prompts/SPEC_*.prompt.md` files are generated Copilot adapters.
- `README_UbiLang.md` and `README_UbiLang_ZH.md` at project root are the installed CaTDD ubiquitous-language glossaries.
- Commit team-shared SpecCoding artifacts under `.catdd/spec/`, such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, and `doneUS/`.
- Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.
- Keep local SpecCoding work state such as `.catdd/spec/WorkingProcessLog.md` gitignored.

Refresh this project by rerunning the installer from the MyCaTDD repository.
MARKER

log_replace_or_new "$INSTRUCTIONS_DIR/catdd.instructions.md"
cat > "$INSTRUCTIONS_DIR/catdd.instructions.md" <<'INSTRUCTIONS'
---
description: "Use when working with CaTDD, comment-alive tests, US/AC/TC skeletons, or UT_* and SPEC_* slash commands."
---
# CaTDD Project Instructions

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- Copilot prompt wrappers: `.github/prompts/UT_*.prompt.md` and `.github/prompts/SPEC_*.prompt.md`
- Treat Copilot prompt files as thin adapters over `.catdd/slashCommands/`.
- Treat `.catdd/methodPrompts/` as the source of truth for category meaning, priority order, design skeleton rules, and CaTDD method constraints.
- Use project-root `README_UbiLang.md` and `README_UbiLang_ZH.md` as the canonical CaTDD terminology glossaries.
- Commit team-shared SpecCoding artifacts under `.catdd/spec/`, such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, and `doneUS/`.
- Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.
- Keep local SpecCoding work state such as `.catdd/spec/WorkingProcessLog.md` gitignored.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.
INSTRUCTIONS

generator_args=(
  --source-dir "$CATDD_DIR/slashCommands/commands"
  --workspace-root "$TARGET_DIR"
  --output "$PROMPTS_DIR"
)

if [[ "$CLEAN_PROMPTS" -eq 1 ]]; then
  generator_args+=(--clean)
fi

bash "$REPO_ROOT/scripts/makeSlashCmd4Copilot.sh" "${generator_args[@]}"

echo "[installCaTDD4Copilot] Installed CaTDD for Copilot into $TARGET_DIR"
echo "[installCaTDD4Copilot] Method source: .catdd/methodPrompts"
echo "[installCaTDD4Copilot] Slash command source: .catdd/slashCommands"
echo "[installCaTDD4Copilot] SpecCoding artifacts: .catdd/spec"
echo "[installCaTDD4Copilot] Copilot prompts: .github/prompts"