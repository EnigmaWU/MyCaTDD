#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

TARGET_DIR=""
TARGET_AGENT=""
CLEAN_PROMPTS=0
INIT=0
VERBOSE=0
YES=0
FORCE_OVERWRITE=0

usage() {
  cat <<'USAGE'
Usage: scripts/installCaTDD.sh --targetDir DIR --targetCodeAgent AGENT [options]

Install or refresh CaTDD methodPrompts, slashCommands, and CodeAgent-native
prompt wrappers into a target project.

Refresh is patch-aware: target files updated after the previous install (for
example by HARNESS_evolveHarness) are never silently overwritten. When both
the target and the source changed a file, the installer three-way merges so
target-evolved lines are kept while upstream changes still arrive. Files whose
changes overlap are kept as-is and reported as conflicts; use --force-overwrite
to restore canonical source for all managed files.

Options:
  --targetDir DIR           Target project directory (alias: --target DIR).
  --targetCodeAgent AGENT   Code agent to install for.
                            Supported: Copilot | Continue | Cline | Antigravity | dryRunner
  --clean-prompts           Remove and regenerate generated prompt wrappers.
  --init                    Create the target directory if it does not exist.
  --force-overwrite         Overwrite target-evolved files with canonical source.
  --verbose                 Print detailed action steps.
  --yes, -y                 Skip confirmation prompt.
  -h, --help                Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --targetDir|--target)
      [[ $# -ge 2 ]] || { echo "[installCaTDD] --targetDir requires a directory" >&2; exit 2; }
      TARGET_DIR="$2"
      shift 2
      ;;
    --targetCodeAgent)
      [[ $# -ge 2 ]] || { echo "[installCaTDD] --targetCodeAgent requires an agent name" >&2; exit 2; }
      TARGET_AGENT="$2"
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
    --force-overwrite)
      FORCE_OVERWRITE=1
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
      echo "[installCaTDD] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$TARGET_DIR" ]]; then
  echo "[installCaTDD] Missing required --targetDir DIR" >&2
  usage >&2
  exit 2
fi
if [[ -z "$TARGET_AGENT" ]]; then
  echo "[installCaTDD] Missing required --targetCodeAgent AGENT" >&2
  usage >&2
  exit 2
fi

# Map agent name to its install profile
AGENT_LABEL=""
case "$TARGET_AGENT" in
  Copilot|GitHub/Copilot)
    AGENT_LABEL="Copilot"
    ;;
  Continue)
    AGENT_LABEL="Continue"
    ;;
  Cline)
    AGENT_LABEL="Cline"
    ;;
  Antigravity)
    AGENT_LABEL="Antigravity"
    ;;
  dryRunner)
    echo "[installCaTDD] dryRunner: requested agent = ${TARGET_AGENT}"
    echo "[installCaTDD] dryRunner: targetDir        = ${TARGET_DIR}"
    echo "[installCaTDD] dryRunner: would call        = scripts/installCaTDD.sh --targetDir <DIR> --targetCodeAgent <AGENT> [--clean-prompts] [--force-overwrite]"
    echo "[installCaTDD] dryRunner: supported agents  = Copilot | Continue | Cline | Antigravity"
    echo "[installCaTDD] dryRunner: custom agents     = scripts/installCaTDD4Custom.sh (separate entry point)"
    exit 0
    ;;
  *)
    echo "[installCaTDD] Unknown --targetCodeAgent: $TARGET_AGENT. Supported: Copilot | Continue | Cline | Antigravity | dryRunner" >&2
    exit 2
    ;;
esac

LOG_TAG="installCaTDD4${AGENT_LABEL}"

if [[ ! -d "$TARGET_DIR" ]]; then
  if [[ "$INIT" -eq 1 ]]; then
    mkdir -p "$TARGET_DIR"
  else
    echo "[${LOG_TAG}] Target directory does not exist: $TARGET_DIR" >&2
    echo "[${LOG_TAG}] Use --init to create it." >&2
    exit 1
  fi
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
CATDD_DIR="$TARGET_DIR/.catdd"
SPEC_DIR="$CATDD_DIR/spec"
MANIFEST_FILE="$CATDD_DIR/CaTDD_INSTALL.manifest"
BASELINE_ROOT="$CATDD_DIR/.install-baseline"

# Optional source override (used by tests to simulate upstream changes)
SOURCE_ROOT="${CATDD_SOURCE_ROOT:-$REPO_ROOT}"
METHOD_SRC="$SOURCE_ROOT/methodPrompts"
SLASH_SRC="$SOURCE_ROOT/slashCommands"
if [[ ! -d "$METHOD_SRC" || ! -d "$SLASH_SRC" ]]; then
  echo "[${LOG_TAG}] CaTDD source trees not found under: $SOURCE_ROOT" >&2
  exit 1
fi

# Compute version from the latest git commit in the MyCaTDD source repo
CATDD_VERSION="$(git -C "$REPO_ROOT" log -1 --format='%ad' --date='format:%Y%m%d.%H' 2>/dev/null || echo 'unknown')"

# Read currently installed version before syncing
INSTALLED_VERSION=""
if [[ -f "$CATDD_DIR/CaTDD_INSTALL.md" ]]; then
  INSTALLED_VERSION="$(sed -n 's/^- Installed version: //p' "$CATDD_DIR/CaTDD_INSTALL.md" | head -1)"
fi

# Report version action
if [[ -z "$INSTALLED_VERSION" ]]; then
  echo "[${LOG_TAG}] version: $CATDD_VERSION (fresh install)"
elif [[ "$INSTALLED_VERSION" == "$CATDD_VERSION" ]] \
  || [[ "$CATDD_VERSION" == "unknown" ]] \
  || [[ "$INSTALLED_VERSION" == "unknown" ]]; then
  echo "[${LOG_TAG}] version: $CATDD_VERSION (same version, replacement)"
elif [[ "$CATDD_VERSION" > "$INSTALLED_VERSION" ]]; then
  echo "[${LOG_TAG}] version: $INSTALLED_VERSION -> $CATDD_VERSION (upgrade)"
else
  echo "[${LOG_TAG}] version: $INSTALLED_VERSION -> $CATDD_VERSION (downgrade)"
fi

# Y/n confirmation
if [[ "$YES" -eq 0 ]]; then
  read -r -p "[${LOG_TAG}] Proceed with installation? [Y/n]: " _confirm
  _confirm_lc="$(printf '%s' "$_confirm" | tr '[:upper:]' '[:lower:]')"
  case "$_confirm_lc" in
    n|no)
      echo "[${LOG_TAG}] Installation cancelled."
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
  echo "[${LOG_TAG}] ${action}: ${path#$TARGET_DIR/}"
}

log_replace_or_new() {
  local path="$1"
  if [[ -e "$path" ]]; then
    log_install_operation replace "$path"
  else
    log_install_operation new "$path"
  fi
}

mkdir -p "$CATDD_DIR" "$SPEC_DIR/pendingNews" "$SPEC_DIR/analyzedNews" "$SPEC_DIR/todoUS" "$SPEC_DIR/doingUS" "$SPEC_DIR/suspendUS" "$SPEC_DIR/abortUS" "$SPEC_DIR/doneUS"

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

# ---------------------------------------------------------------
# Patch-aware sync helpers
# ---------------------------------------------------------------

sha256_of() {
  shasum -a 256 "$1" 2>/dev/null | awk '{print $1}'
}

list_tree() {
  (cd "$1" && find . -type f ! -name '.DS_Store' | sed 's#^\./##' | LC_ALL=C sort)
}

MANIFEST_RELS=()
MANIFEST_HASHES=()
MANIFEST_VERS=()

manifest_load() {
  local rel="" hash="" ver=""
  MANIFEST_RELS=()
  MANIFEST_HASHES=()
  MANIFEST_VERS=()
  [[ -f "$MANIFEST_FILE" ]] || return 0
  while IFS=$'\t' read -r rel hash ver _junk; do
    [[ "$rel" == \#* ]] && continue
    MANIFEST_RELS+=("$rel")
    MANIFEST_HASHES+=("$hash")
    MANIFEST_VERS+=("$ver")
  done < "$MANIFEST_FILE"
}

manifest_index_of() {
  local rel="$1" i
  for i in "${!MANIFEST_RELS[@]}"; do
    if [[ "${MANIFEST_RELS[$i]}" == "$rel" ]]; then
      printf '%s\n' "$i"
      return 0
    fi
  done
  return 1
}

manifest_hash_of() {
  local rel="$1" i
  i="$(manifest_index_of "$rel")" || return 1
  printf '%s\n' "${MANIFEST_HASHES[$i]}"
}

manifest_upsert() {
  local rel="$1" hash="$2" ver="$3" i
  if i="$(manifest_index_of "$rel")"; then
    MANIFEST_HASHES[$i]="$hash"
    MANIFEST_VERS[$i]="$ver"
  else
    MANIFEST_RELS+=("$rel")
    MANIFEST_HASHES+=("$hash")
    MANIFEST_VERS+=("$ver")
  fi
}

manifest_drop() {
  local rel="$1" i
  local next_rels=() next_hashes=() next_vers=()
  for i in "${!MANIFEST_RELS[@]}"; do
    [[ "${MANIFEST_RELS[$i]}" == "$rel" ]] && continue
    next_rels+=("${MANIFEST_RELS[$i]}")
    next_hashes+=("${MANIFEST_HASHES[$i]}")
    next_vers+=("${MANIFEST_VERS[$i]}")
  done
  MANIFEST_RELS=("${next_rels[@]}")
  MANIFEST_HASHES=("${next_hashes[@]}")
  MANIFEST_VERS=("${next_vers[@]}")
}

manifest_flush() {
  local tmp rel hash ver i
  tmp="$(mktemp)"
  printf '# CaTDD install manifest\n# relpath<TAB>canonical_sha256<TAB>installed_version\n' > "$tmp"
  for i in "${!MANIFEST_RELS[@]}"; do
    printf '%s\t%s\t%s\n' "${MANIFEST_RELS[$i]}" "${MANIFEST_HASHES[$i]}" "${MANIFEST_VERS[$i]}" >> "$tmp"
  done
  mv "$tmp" "$MANIFEST_FILE"
}

# Record that the canonical source content for rel is now src_file.
record_canonical() {
  local label="$1" rel="$2" src_file="$3" base_file src_sha
  src_sha="$(sha256_of "$src_file")"
  manifest_upsert "$rel" "$src_sha" "$CATDD_VERSION"
  base_file="$BASELINE_ROOT/$label/$rel"
  mkdir -p "$(dirname "$base_file")"
  cp "$src_file" "$base_file"
}

# Three-way-merge aware tree sync:
#   new        - file was not present in target
#   updated    - target matched the recorded baseline, upstream changed
#   same       - target and source already identical
#   kept-local - target differs from baseline (evolved locally); kept as-is
#   merged     - target evolved and upstream changed in disjoint regions
#   conflict   - overlapping edits; target kept, upstream not applied
#   local-only - file only exists in target; kept
sync_managed_tree() {
  local src_tree="$1" dst_tree="$2" label="$3"
  local rel src_file tgt_file base_file src_sha tgt_sha base_sha
  local merged_tmp merged_sha
  local count_new=0 count_updated=0 count_same=0 count_kept=0 count_merged=0 count_conflict=0 count_local_only=0

  [[ -d "$src_tree" ]] || { echo "[${LOG_TAG}] sync: source tree missing: $src_tree" >&2; return 1; }
  mkdir -p "$dst_tree" "$BASELINE_ROOT/$label"

  while IFS= read -r rel; do
    [[ -n "$rel" ]] || continue
    src_file="$src_tree/$rel"
    tgt_file="$dst_tree/$rel"
    base_file="$BASELINE_ROOT/$label/$rel"
    src_sha="$(sha256_of "$src_file")"
    if [[ -f "$tgt_file" ]]; then
      tgt_sha="$(sha256_of "$tgt_file")"
    else
      tgt_sha=""
    fi
    base_sha=""
    base_sha="$(manifest_hash_of "$rel")" || true

    if [[ -z "$tgt_sha" ]]; then
      log_install_operation new "$tgt_file"
      mkdir -p "$(dirname "$tgt_file")"
      cp "$src_file" "$tgt_file"
      count_new=$((count_new + 1))
      record_canonical "$label" "$rel" "$src_file"
    elif [[ "$tgt_sha" == "$src_sha" ]]; then
      count_same=$((count_same + 1))
      record_canonical "$label" "$rel" "$src_file"
    elif [[ -n "$base_sha" && "$tgt_sha" == "$base_sha" && -f "$base_file" ]]; then
      log_install_operation replace "$tgt_file"
      cp "$src_file" "$tgt_file"
      count_updated=$((count_updated + 1))
      record_canonical "$label" "$rel" "$src_file"
    elif [[ -z "$base_sha" || ! -f "$base_file" ]]; then
      echo "[${LOG_TAG}] sync: kept-local (no baseline, assume evolved): ${label}/${rel}"
      count_kept=$((count_kept + 1))
    elif [[ "$src_sha" == "$base_sha" ]]; then
      echo "[${LOG_TAG}] sync: kept-local (target updated beyond this version): ${label}/${rel}"
      count_kept=$((count_kept + 1))
    else
      merged_tmp="$(mktemp)"
      if diff3 -m "$src_file" "$base_file" "$tgt_file" > "$merged_tmp" 2>/dev/null; then
        merged_sha="$(sha256_of "$merged_tmp")"
        if [[ "$merged_sha" == "$tgt_sha" ]]; then
          echo "[${LOG_TAG}] sync: kept-local (merge keeps target content): ${label}/${rel}"
          count_kept=$((count_kept + 1))
          record_canonical "$label" "$rel" "$src_file"
        elif [[ "$merged_sha" == "$src_sha" ]]; then
          log_install_operation replace "$tgt_file"
          cp "$src_file" "$tgt_file"
          count_updated=$((count_updated + 1))
          record_canonical "$label" "$rel" "$src_file"
        else
          log_install_operation replace "$tgt_file"
          cp "$merged_tmp" "$tgt_file"
          echo "[${LOG_TAG}] sync: merged (kept target-evolved lines): ${label}/${rel}"
          count_merged=$((count_merged + 1))
          record_canonical "$label" "$rel" "$src_file"
        fi
      else
        echo "[${LOG_TAG}] sync: conflict (kept target; upstream not applied): ${label}/${rel}"
        count_conflict=$((count_conflict + 1))
      fi
      rm -f "$merged_tmp"
    fi
  done < <(list_tree "$src_tree")

  # Files present in the target but gone from source are kept (never deleted).
  while IFS= read -r rel; do
    [[ -n "$rel" ]] || continue
    if [[ ! -e "$src_tree/$rel" ]]; then
      echo "[${LOG_TAG}] sync: local-only (kept): ${label}/${rel}"
      count_local_only=$((count_local_only + 1))
      manifest_drop "$rel"
      rm -f "$BASELINE_ROOT/$label/$rel"
    fi
  done < <(list_tree "$dst_tree")

  # Purge stale baseline entries for files missing from both sides.
  while IFS= read -r rel; do
    [[ -n "$rel" ]] || continue
    if [[ ! -e "$src_tree/$rel" && ! -e "$dst_tree/$rel" ]]; then
      manifest_drop "$rel"
      rm -f "$BASELINE_ROOT/$label/$rel"
    fi
  done < <(list_tree "$BASELINE_ROOT/$label")

  echo "[${LOG_TAG}] sync ${label}: new=${count_new} updated=${count_updated} same=${count_same} kept-local=${count_kept} merged=${count_merged} conflict=${count_conflict} local-only=${count_local_only}"
}

# Canonical reset: replace every managed file with source and rebuild baseline.
force_reset_tree() {
  local src_tree="$1" dst_tree="$2" label="$3"
  local rel
  log_replace_or_new "$dst_tree"
  rm -rf "$dst_tree"
  mkdir -p "$dst_tree"
  while IFS= read -r rel; do
    [[ -n "$rel" ]] || continue
    mkdir -p "$(dirname "$dst_tree/$rel")"
    cp "$src_tree/$rel" "$dst_tree/$rel"
    record_canonical "$label" "$rel" "$src_tree/$rel"
  done < <(list_tree "$src_tree")
  echo "[${LOG_TAG}] sync ${label}: force-overwrite canonical source"
}

update_spec_gitignore
manifest_load

log_replace_or_new "$CATDD_DIR/methodPrompts"
log_replace_or_new "$CATDD_DIR/slashCommands"

if [[ "$FORCE_OVERWRITE" -eq 1 ]]; then
  force_reset_tree "$METHOD_SRC" "$CATDD_DIR/methodPrompts" "methodPrompts"
  force_reset_tree "$SLASH_SRC" "$CATDD_DIR/slashCommands" "slashCommands"
else
  sync_managed_tree "$METHOD_SRC" "$CATDD_DIR/methodPrompts" "methodPrompts"
  sync_managed_tree "$SLASH_SRC" "$CATDD_DIR/slashCommands" "slashCommands"
fi
manifest_flush

log_replace_or_new "$CATDD_DIR/CaTDD_INSTALL.md"
printf '# CaTDD Install Marker\n\n- Installed version: %s\n- Target agent: %s\n\n' "$CATDD_VERSION" "$AGENT_LABEL" > "$CATDD_DIR/CaTDD_INSTALL.md"
cat >> "$CATDD_DIR/CaTDD_INSTALL.md" <<'MARKER'
This directory is managed by `scripts/installCaTDD.sh` from MyCaTDD.

- `methodPrompts/` is the installed CaTDD method source.
- `slashCommands/` is the installed portable flow-command source.
- `spec/` is the installed SpecCoding artifact workspace.
- `CaTDD_INSTALL.manifest` records the canonical baseline hash of every managed file.
- `.install-baseline/` stores canonical baseline content used for three-way merge.
- Refresh keeps target files evolved after install (for example by `HARNESS_evolveHarness`).
  Disjoint upstream and target edits are merged; overlapping edits keep the target and are reported.
- `--force-overwrite` restores canonical source for all managed files.
- Commit team-shared SpecCoding artifacts under `.catdd/spec/`, such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, and `doneUS/`.
- Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.
- Keep local SpecCoding work state such as `.catdd/spec/WorkingProcessLog.md` gitignored.

Refresh this project by rerunning the installer from the MyCaTDD repository.
MARKER

case "$AGENT_LABEL" in
  Copilot)
    GITHUB_DIR="$TARGET_DIR/.github"
    PROMPTS_DIR="$GITHUB_DIR/prompts"
    INSTRUCTIONS_DIR="$GITHUB_DIR/instructions"
    mkdir -p "$PROMPTS_DIR" "$INSTRUCTIONS_DIR"

    log_replace_or_new "$INSTRUCTIONS_DIR/catdd.instructions.md"
    cat > "$INSTRUCTIONS_DIR/catdd.instructions.md" <<'INSTRUCTIONS'
---
description: "Use when working with CaTDD, comment-alive tests, US/AC/TC skeletons, or UT_*, SPEC_*, and HARNESS_* slash commands."
---
# CaTDD Project Instructions

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- Copilot prompt wrappers: `.github/prompts/UT_*.prompt.md`, `.github/prompts/SPEC_*.prompt.md`, and `.github/prompts/HARNESS_*.prompt.md`
- Treat Copilot prompt files as thin adapters over `.catdd/slashCommands/`.
- Treat `.catdd/methodPrompts/` as the source of truth for category meaning, priority order, design skeleton rules, and CaTDD method constraints.
- Use project-root `README_UbiLang.md` and `README_UbiLang_ZH.md` as the canonical CaTDD terminology glossaries.
- Commit team-shared SpecCoding artifacts under `.catdd/spec/`, such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, and `doneUS/`.
- Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.
- Keep local SpecCoding work state such as `.catdd/spec/WorkingProcessLog.md` gitignored.
- After every meaningful verified success, report `success_learning_checkpoint = recommended` and remind the developer to run `/HARNESS_evolveHarness` with `evolution_mode=auto`. Keep the hook non-blocking, preserve any required lifecycle/commit/merge/safety command as the immediate next action, and never auto-apply an evolution proposal. While running `HARNESS_evolveHarness`, suppress this hook for the command's own completion or the same evidence; only materially new verified evidence may trigger another checkpoint.
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

    echo "[${LOG_TAG}] Installed CaTDD for Copilot into $TARGET_DIR"
    echo "[${LOG_TAG}] Method source: .catdd/methodPrompts"
    echo "[${LOG_TAG}] Slash command source: .catdd/slashCommands"
    echo "[${LOG_TAG}] SpecCoding artifacts: .catdd/spec"
    echo "[${LOG_TAG}] Copilot prompts: .github/prompts"
    ;;

  Continue)
    CONTINUE_RULES_DIR="$TARGET_DIR/.continue/rules"
    CONTINUE_PROMPTS_DIR="$TARGET_DIR/.continue/prompts"
    mkdir -p "$CONTINUE_RULES_DIR" "$CONTINUE_PROMPTS_DIR"

    log_replace_or_new "$CONTINUE_RULES_DIR/catdd.md"
    cat > "$CONTINUE_RULES_DIR/catdd.md" <<'RULES'
# CaTDD Continue Project Rule

This is a Continue project rule installed by MyCaTDD. Use it when working with CaTDD, SpecCoding, VibeCoding, comment-alive tests, US/AC/TC skeletons, or UT_*, SPEC_*, and HARNESS_* commands.

## Installed Sources

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- Continue prompt wrappers: `.continue/prompts/UT_*.prompt`, `.continue/prompts/SPEC_*.prompt`, and `.continue/prompts/HARNESS_*.prompt`
- SpecCoding flow: `.catdd/slashCommands/flows/Px-SpecFlow.md`
- SpecCoding artifact workspace: `.catdd/spec/`
- Project-root README SPEC docs: `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.

## Continue Behavior

- Treat this file as a thin Continue adapter over `.catdd/methodPrompts/` and `.catdd/slashCommands/`.
- Use `.continue/prompts/` for triggerable UT_*, SPEC_*, and HARNESS_* prompt wrappers.
- Treat `.catdd/methodPrompts/` as the source of truth for CaTDD category meaning, priority order, design skeleton rules, and method constraints.
- Use `.catdd/slashCommands/commands/` for UT_*, SPEC_*, and HARNESS_* commands; read the portable command before acting.
- Keep SpecCoding lifecycle state under `.catdd/spec/`.
- Commit team-shared artifacts such as `.catdd/spec/projectContext.md`, `.catdd/spec/pendingNews/`, `.catdd/spec/analyzedNews/`, `.catdd/spec/todoUS/`, `.catdd/spec/doingUS/`, `.catdd/spec/suspendUS/`, `.catdd/spec/abortUS/`, `.catdd/spec/doneUS/`, and project-root `README*` SPEC docs.
- Keep local work state such as `.catdd/spec/WorkingProcessLog.md` gitignored.
- Prefer explicit SpecFlow intake commands: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_importUserStory`, `SPEC_analyzeIssue`, and `SPEC_analyzeFeature`.
- After every meaningful verified success, report `success_learning_checkpoint = recommended` and remind the developer to run `/HARNESS_evolveHarness` with `evolution_mode=auto`. Keep the hook non-blocking, preserve any required lifecycle/commit/merge/safety command as the immediate next action, and never auto-apply an evolution proposal. While running `HARNESS_evolveHarness`, suppress this hook for the command's own completion or the same evidence; only materially new verified evidence may trigger another checkpoint.
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

    echo "[${LOG_TAG}] Installed CaTDD for Continue into $TARGET_DIR"
    echo "[${LOG_TAG}] Method source: .catdd/methodPrompts"
    echo "[${LOG_TAG}] Slash command source: .catdd/slashCommands"
    echo "[${LOG_TAG}] SpecCoding artifacts: .catdd/spec"
    echo "[${LOG_TAG}] Continue rule: .continue/rules/catdd.md"
    echo "[${LOG_TAG}] Continue prompts: .continue/prompts"
    ;;

  Cline)
    CLINE_RULES_DIR="$TARGET_DIR/.clinerules"
    CLINE_SKILLS_DIR="$TARGET_DIR/.cline/skills"
    if [[ -e "$CLINE_RULES_DIR" && ! -d "$CLINE_RULES_DIR" ]]; then
      echo "[${LOG_TAG}] Cannot create .clinerules/catdd.md because .clinerules exists and is not a directory." >&2
      exit 1
    fi
    mkdir -p "$CLINE_RULES_DIR" "$CLINE_SKILLS_DIR"

    log_replace_or_new "$CLINE_RULES_DIR/catdd.md"
    cat > "$CLINE_RULES_DIR/catdd.md" <<'RULES'
# CaTDD Cline Project Rule

This is a Cline project rule installed by MyCaTDD. Use it when working with CaTDD, SpecCoding, VibeCoding, comment-alive tests, US/AC/TC skeletons, or UT_*, SPEC_*, and HARNESS_* commands.

## Installed Sources

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- SpecCoding flow: `.catdd/slashCommands/flows/Px-SpecFlow.md`
- SpecCoding artifact workspace: `.catdd/spec/`
- Project-root README SPEC docs: `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.

## Cline Behavior

- Treat this file as a thin Cline adapter over `.catdd/methodPrompts/` and `.catdd/slashCommands/`.
- Treat `.catdd/methodPrompts/` as the source of truth for CaTDD category meaning, priority order, design skeleton rules, and method constraints.
- Use `.catdd/slashCommands/commands/` for UT_*, SPEC_*, and HARNESS_* commands; read the portable command before acting.
- Keep SpecCoding lifecycle state under `.catdd/spec/`.
- Commit team-shared artifacts such as `.catdd/spec/projectContext.md`, `.catdd/spec/pendingNews/`, `.catdd/spec/analyzedNews/`, `.catdd/spec/todoUS/`, `.catdd/spec/doingUS/`, `.catdd/spec/suspendUS/`, `.catdd/spec/abortUS/`, `.catdd/spec/doneUS/`, and project-root `README*` SPEC docs.
- Keep local work state such as `.catdd/spec/WorkingProcessLog.md` gitignored.
- Prefer explicit SpecFlow intake commands: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_importUserStory`, `SPEC_analyzeIssue`, and `SPEC_analyzeFeature`.
- After every meaningful verified success, report `success_learning_checkpoint = recommended` and remind the developer to run `/HARNESS_evolveHarness` with `evolution_mode=auto`. Keep the hook non-blocking, preserve any required lifecycle/commit/merge/safety command as the immediate next action, and never auto-apply an evolution proposal. While running `HARNESS_evolveHarness`, suppress this hook for the command's own completion or the same evidence; only materially new verified evidence may trigger another checkpoint.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.

ONE-MORE-THING: ask developer if something not sure
RULES

    generator_args=(
      --source-dir "$CATDD_DIR/slashCommands/commands"
      --workspace-root "$TARGET_DIR"
      --output "$CLINE_SKILLS_DIR"
    )
    if [[ "$CLEAN_PROMPTS" -eq 1 ]]; then
      generator_args+=(--clean)
    fi
    bash "$REPO_ROOT/scripts/makeSlashCmd4Cline.sh" "${generator_args[@]}"

    echo "[${LOG_TAG}] Installed CaTDD for Cline into $TARGET_DIR"
    echo "[${LOG_TAG}] Method source: .catdd/methodPrompts"
    echo "[${LOG_TAG}] Slash command source: .catdd/slashCommands"
    echo "[${LOG_TAG}] SpecCoding artifacts: .catdd/spec"
    echo "[${LOG_TAG}] Cline rule: .clinerules/catdd.md"
    echo "[${LOG_TAG}] Cline skills: .cline/skills"
    ;;

  Antigravity)
    ANTIGRAVITY_RULES_DIR="$TARGET_DIR/.antigravityrules"
    if [[ -e "$ANTIGRAVITY_RULES_DIR" && ! -d "$ANTIGRAVITY_RULES_DIR" ]]; then
      echo "[${LOG_TAG}] Cannot create .antigravityrules/catdd.md because .antigravityrules exists and is not a directory." >&2
      exit 1
    fi
    mkdir -p "$ANTIGRAVITY_RULES_DIR"

    log_replace_or_new "$ANTIGRAVITY_RULES_DIR/catdd.md"
    cat > "$ANTIGRAVITY_RULES_DIR/catdd.md" <<'RULES'
# CaTDD Antigravity Project Rule

This is an Antigravity project rule installed by MyCaTDD. Use it when working with CaTDD, SpecCoding, VibeCoding, comment-alive tests, US/AC/TC skeletons, or UT_*, SPEC_*, and HARNESS_* commands.

## Installed Sources

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- SpecCoding flow: `.catdd/slashCommands/flows/Px-SpecFlow.md`
- SpecCoding artifact workspace: `.catdd/spec/`
- Project-root README SPEC docs: `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.

## Antigravity Behavior

- Treat this file as a thin Antigravity adapter over `.catdd/methodPrompts/` and `.catdd/slashCommands/`.
- Treat `.catdd/methodPrompts/` as the source of truth for CaTDD category meaning, priority order, design skeleton rules, and method constraints.
- Use `.catdd/slashCommands/commands/` for UT_*, SPEC_*, and HARNESS_* commands; read the portable command before acting.
- Keep SpecCoding lifecycle state under `.catdd/spec/`.
- Commit team-shared artifacts such as `.catdd/spec/projectContext.md`, `.catdd/spec/pendingNews/`, `.catdd/spec/analyzedNews/`, `.catdd/spec/todoUS/`, `.catdd/spec/doingUS/`, `.catdd/spec/suspendUS/`, `.catdd/spec/abortUS/`, `.catdd/spec/doneUS/`, and project-root `README*` SPEC docs.
- Keep local work state such as `.catdd/spec/WorkingProcessLog.md` gitignored.
- Prefer explicit SpecFlow intake commands: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_importUserStory`, `SPEC_analyzeIssue`, and `SPEC_analyzeFeature`.
- After every meaningful verified success, report `success_learning_checkpoint = recommended` and remind the developer to run `/HARNESS_evolveHarness` with `evolution_mode=auto`. Keep the hook non-blocking, preserve any required lifecycle/commit/merge/safety command as the immediate next action, and never auto-apply an evolution proposal. While running `HARNESS_evolveHarness`, suppress this hook for the command's own completion or the same evidence; only materially new verified evidence may trigger another checkpoint.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.

ONE-MORE-THING: ask developer if something not sure
RULES

    echo "[${LOG_TAG}] Installed CaTDD for Antigravity into $TARGET_DIR"
    echo "[${LOG_TAG}] Method source: .catdd/methodPrompts"
    echo "[${LOG_TAG}] Slash command source: .catdd/slashCommands"
    echo "[${LOG_TAG}] SpecCoding artifacts: .catdd/spec"
    echo "[${LOG_TAG}] Antigravity rule: .antigravityrules/catdd.md"
    ;;
esac
