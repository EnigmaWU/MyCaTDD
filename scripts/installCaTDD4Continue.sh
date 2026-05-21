#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR=""
CLEAN_PROMPTS=0
INIT=0

usage() {
  cat <<'USAGE'
Usage: scripts/installCaTDD4Continue.sh --target DIR [--clean-prompts] [--init]

Install or refresh CaTDD methodPrompts, slashCommands, SpecCoding artifact workspace, Continue project rules, and Continue prompt wrappers into a target project.

Options:
  --target DIR      Target project directory.
  --clean-prompts   Remove existing generated UT_*.prompt and SPEC_*.prompt files before regenerating Continue wrappers.
  --init            Create the target directory if it does not exist.
  -h, --help        Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || { echo "[installCaTDD4Continue] --target requires a directory" >&2; exit 2; }
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
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[installCaTDD4Continue] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$TARGET_DIR" ]]; then
  echo "[installCaTDD4Continue] Missing required --target DIR" >&2
  usage >&2
  exit 2
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  if [[ "$INIT" -eq 1 ]]; then
    mkdir -p "$TARGET_DIR"
  else
    echo "[installCaTDD4Continue] Target directory does not exist: $TARGET_DIR" >&2
    echo "[installCaTDD4Continue] Use --init to create it." >&2
    exit 1
  fi
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
CATDD_DIR="$TARGET_DIR/.catdd"
SPEC_DIR="$CATDD_DIR/spec"
CONTINUE_RULES_DIR="$TARGET_DIR/.continue/rules"
CONTINUE_PROMPTS_DIR="$TARGET_DIR/.continue/prompts"

mkdir -p "$CATDD_DIR" "$SPEC_DIR/pendingNews" "$SPEC_DIR/todoUS" "$SPEC_DIR/doingUS" "$SPEC_DIR/doneUS" "$CONTINUE_RULES_DIR" "$CONTINUE_PROMPTS_DIR"

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
/.catdd/spec/doingUS/
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

This directory is managed by `scripts/installCaTDD4Continue.sh` from MyCaTDD.

- `methodPrompts/` is the installed CaTDD method source.
- `slashCommands/` is the installed portable flow-command source.
- `spec/` is the installed SpecCoding artifact workspace.
- Continue project rule: `.continue/rules/catdd.md`.
- Continue prompt wrappers: `.continue/prompts/UT_*.prompt` and `.continue/prompts/SPEC_*.prompt`.
- Commit team-shared SpecCoding artifacts under `.catdd/spec/`, such as `projectContext.md`, `pendingNews/`, `todoUS/`, and `doneUS/`.
- Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.
- Keep local SpecCoding work state such as `.catdd/spec/doingUS/` and `.catdd/spec/WorkingProcessLog.md` gitignored.

Refresh this project by rerunning the installer from the MyCaTDD repository.
MARKER

cat > "$CONTINUE_RULES_DIR/catdd.md" <<'RULES'
# CaTDD Continue Project Rule

This is a Continue project rule installed by MyCaTDD. Use it when working with CaTDD, SpecCoding, VibeCoding, comment-alive tests, US/AC/TC skeletons, or UT_* and SPEC_* commands.

## Installed Sources

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- Continue prompt wrappers: `.continue/prompts/UT_*.prompt` and `.continue/prompts/SPEC_*.prompt`
- SpecCoding flow: `.catdd/slashCommands/flows/Px-SpecFlow.md`
- SpecCoding artifact workspace: `.catdd/spec/`
- Project-root README SPEC docs: `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.

## Continue Behavior

- Treat this file as a thin Continue adapter over `.catdd/methodPrompts/` and `.catdd/slashCommands/`.
- Use `.continue/prompts/` for triggerable UT_* and SPEC_* prompt wrappers.
- Treat `.catdd/methodPrompts/` as the source of truth for CaTDD category meaning, priority order, design skeleton rules, and method constraints.
- Use `.catdd/slashCommands/commands/` for UT_* and SPEC_* commands; read the portable command before acting.
- Keep SpecCoding lifecycle state under `.catdd/spec/`.
- Commit team-shared artifacts such as `.catdd/spec/projectContext.md`, `.catdd/spec/pendingNews/`, `.catdd/spec/todoUS/`, `.catdd/spec/doneUS/`, and project-root `README*` SPEC docs.
- Keep local work state such as `.catdd/spec/doingUS/` and `.catdd/spec/WorkingProcessLog.md` gitignored.
- Prefer explicit SpecFlow intake commands: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_analyzeIssue`, and `SPEC_analyzeFeature`.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.

ONE-MORE-THING: ask developer if something not sure
RULES

generator_args=(
  --source-dir "$CATDD_DIR/slashCommands/commands"
  --workspace-root "$TARGET_DIR"
  --output "$CONTINUE_PROMPTS_DIR"
)

if [[ "$CLEAN_PROMPTS" -eq 1 ]]; then
  generator_args+=(--clean)
fi

bash "$REPO_ROOT/scripts/makeSlashCmd4Continue.sh" "${generator_args[@]}"

echo "[installCaTDD4Continue] Installed CaTDD for Continue into $TARGET_DIR"
echo "[installCaTDD4Continue] Method source: .catdd/methodPrompts"
echo "[installCaTDD4Continue] Slash command source: .catdd/slashCommands"
echo "[installCaTDD4Continue] SpecCoding artifacts: .catdd/spec"
echo "[installCaTDD4Continue] Continue rule: .continue/rules/catdd.md"
echo "[installCaTDD4Continue] Continue prompts: .continue/prompts"