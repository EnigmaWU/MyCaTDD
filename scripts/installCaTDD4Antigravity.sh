#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR=""
INIT=0

usage() {
  cat <<'USAGE'
Usage: scripts/installCaTDD4Antigravity.sh --target DIR [--init]

Install or refresh CaTDD methodPrompts, slashCommands, SpecCoding artifact workspace, and Antigravity project rules into a target project.

Options:
  --target DIR      Target project directory.
  --init            Create the target directory if it does not exist.
  -h, --help        Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || { echo "[installCaTDD4Antigravity] --target requires a directory" >&2; exit 2; }
      TARGET_DIR="$2"
      shift 2
      ;;
    --init)
      INIT=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[installCaTDD4Antigravity] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$TARGET_DIR" ]]; then
  echo "[installCaTDD4Antigravity] Missing required --target DIR" >&2
  usage >&2
  exit 2
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  if [[ "$INIT" -eq 1 ]]; then
    mkdir -p "$TARGET_DIR"
  else
    echo "[installCaTDD4Antigravity] Target directory does not exist: $TARGET_DIR" >&2
    echo "[installCaTDD4Antigravity] Use --init to create it." >&2
    exit 1
  fi
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
CATDD_DIR="$TARGET_DIR/.catdd"
SPEC_DIR="$CATDD_DIR/spec"
ANTIGRAVITY_RULES_DIR="$TARGET_DIR/.antigravityrules"

if [[ -e "$ANTIGRAVITY_RULES_DIR" && ! -d "$ANTIGRAVITY_RULES_DIR" ]]; then
  echo "[installCaTDD4Antigravity] Cannot create .antigravityrules/catdd.md because .antigravityrules exists and is not a directory." >&2
  exit 1
fi

mkdir -p "$CATDD_DIR" "$SPEC_DIR/pendingNews" "$SPEC_DIR/analyzedNews" "$SPEC_DIR/todoUS" "$SPEC_DIR/doingUS" "$SPEC_DIR/doneUS" "$ANTIGRAVITY_RULES_DIR"

update_spec_gitignore() {
  local gitignore_file="$TARGET_DIR/.gitignore"
  local temp_file
  temp_file="$(mktemp)"

  if [[ -f "$gitignore_file" ]]; then
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

rm -rf "$CATDD_DIR/methodPrompts" "$CATDD_DIR/slashCommands"
cp -R "$REPO_ROOT/methodPrompts" "$CATDD_DIR/methodPrompts"
cp -R "$REPO_ROOT/slashCommands" "$CATDD_DIR/slashCommands"
update_spec_gitignore

cat > "$CATDD_DIR/CaTDD_INSTALL.md" <<'MARKER'
# CaTDD Install Marker

This directory is managed by `scripts/installCaTDD4Antigravity.sh` from MyCaTDD.

- `methodPrompts/` is the installed CaTDD method source.
- `slashCommands/` is the installed portable flow-command source.
- `spec/` is the installed SpecCoding artifact workspace.
- Antigravity project rule: `.antigravityrules/catdd.md`.
- Commit team-shared SpecCoding artifacts under `.catdd/spec/`, such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, and `doneUS/`.
- Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.
- Keep local SpecCoding work state such as `.catdd/spec/WorkingProcessLog.md` gitignored.

Refresh this project by rerunning the installer from the MyCaTDD repository.
MARKER

cat > "$ANTIGRAVITY_RULES_DIR/catdd.md" <<'RULES'
# CaTDD Antigravity Project Rule

This is an Antigravity project rule installed by MyCaTDD. Use it when working with CaTDD, SpecCoding, VibeCoding, comment-alive tests, US/AC/TC skeletons, or UT_* and SPEC_* commands.

## Installed Sources

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- SpecCoding flow: `.catdd/slashCommands/flows/Px-SpecFlow.md`
- SpecCoding artifact workspace: `.catdd/spec/`
- Project-root README SPEC docs: `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.

## Antigravity Behavior

- Treat this file as a thin Antigravity adapter over `.catdd/methodPrompts/` and `.catdd/slashCommands/`.
- Treat `.catdd/methodPrompts/` as the source of truth for CaTDD category meaning, priority order, design skeleton rules, and method constraints.
- Use `.catdd/slashCommands/commands/` for UT_* and SPEC_* commands; read the portable command before acting.
- Keep SpecCoding lifecycle state under `.catdd/spec/`.
- Commit team-shared artifacts such as `.catdd/spec/projectContext.md`, `.catdd/spec/pendingNews/`, `.catdd/spec/analyzedNews/`, `.catdd/spec/todoUS/`, `.catdd/spec/doingUS/`, `.catdd/spec/doneUS/`, and project-root `README*` SPEC docs.
- Keep local work state such as `.catdd/spec/WorkingProcessLog.md` gitignored.
- Prefer explicit SpecFlow intake commands: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_analyzeIssue`, and `SPEC_analyzeFeature`.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.

ONE-MORE-THING: ask developer if something not sure
RULES

echo "[installCaTDD4Antigravity] Installed CaTDD for Antigravity into $TARGET_DIR"
echo "[installCaTDD4Antigravity] Method source: .catdd/methodPrompts"
echo "[installCaTDD4Antigravity] Slash command source: .catdd/slashCommands"
echo "[installCaTDD4Antigravity] SpecCoding artifacts: .catdd/spec"
echo "[installCaTDD4Antigravity] Antigravity rule: .antigravityrules/catdd.md"
