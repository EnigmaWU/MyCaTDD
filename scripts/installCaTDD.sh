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
MIGRATE_METASPEC=0

usage() {
  cat <<'USAGE'
Usage: scripts/installCaTDD.sh --targetDir DIR --targetCodeAgent AGENT [options]

Install or refresh CaTDD methodPrompts, slashCommands, and Copilot or Codex
native wrappers into a target project.

Refresh is patch-aware: target files updated after the previous install (for
example by HARNESS_evolveHarness) are never silently overwritten. When both
the target and the source changed a file, the installer three-way merges so
target-evolved lines are kept while upstream changes still arrive. Files whose
changes overlap are kept as-is and reported as conflicts; use --force-overwrite
to restore canonical source for all managed files.

HARNESS_evolveHarness keeps its slash-command learning in local <Name>Evolved.md
overlays instead of editing canonical commands. These overlays are local-only:
refresh keeps them, and --force-overwrite preserves them rather than deleting
them.

Options:
  --targetDir DIR           Target project directory (alias: --target DIR).
  --targetCodeAgent AGENT   Code agent to install for. Supported:
                            ChatCopilotLocal (aliases: Copilot, GitHub/Copilot),
                            ChatCopilotAgentHost,
                            Codex (alias: OpenAI/Codex).
  --clean-prompts           Remove and regenerate generated prompt or skill wrappers.
  --init                    Create the target directory if it does not exist.
  --force-overwrite         Overwrite target-evolved files with canonical source.
  --migrate-metaspec        Explicitly migrate a sole legacy .catdd/spec workspace
                            to .catdd/metaspec. Normal refresh preserves legacy.
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
    --migrate-metaspec)
      MIGRATE_METASPEC=1
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
  ChatCopilotLocal|Copilot|GitHub/Copilot)
    AGENT_LABEL="ChatCopilotLocal"
    ;;
  ChatCopilotAgentHost)
    AGENT_LABEL="ChatCopilotAgentHost"
    ;;
  Codex|OpenAI/Codex)
    AGENT_LABEL="Codex"
    ;;
  *)
    echo "[installCaTDD] Unknown --targetCodeAgent: $TARGET_AGENT. Supported: ChatCopilotLocal, ChatCopilotAgentHost, Codex (aliases: Copilot, GitHub/Copilot, OpenAI/Codex)" >&2
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
SPEC_DIR="$CATDD_DIR/metaspec"
MANIFEST_FILE="$CATDD_DIR/CaTDD_INSTALL.manifest"
BASELINE_ROOT="$CATDD_DIR/.install-baseline"
METASPEC_HELPER_SRC="$REPO_ROOT/scripts/migrateCaTDDMetaspec.sh"
METASPEC_HELPER_INSTALLED="$CATDD_DIR/scripts/migrateCaTDDMetaspec.sh"

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

[[ -x "$METASPEC_HELPER_SRC" ]] || {
  echo "[${LOG_TAG}] Metaspec migration helper is missing or not executable: $METASPEC_HELPER_SRC" >&2
  exit 1
}
HAS_METASPEC_WORKSPACE=0
for _metaspec_candidate in .catdd/metaspec .agents/metaspec .catdd/spec; do
  if [[ -d "$TARGET_DIR/$_metaspec_candidate" ]]; then
    HAS_METASPEC_WORKSPACE=1
  fi
done
if [[ "$MIGRATE_METASPEC" -eq 1 || "$HAS_METASPEC_WORKSPACE" -eq 0 ]]; then
  "$METASPEC_HELPER_SRC" --project-root "$TARGET_DIR" --apply --quiet
else
  # Validate the selected root and ambiguity without relocating legacy state.
  "$METASPEC_HELPER_SRC" --project-root "$TARGET_DIR" --quiet
fi

SPEC_ROOT_REL="$("$METASPEC_HELPER_SRC" --project-root "$TARGET_DIR" --print-root)"
for _lifecycle_lane in pendingNews analyzedNews todoUS doingUS suspendUS abortUS doneUS; do
  mkdir -p "$TARGET_DIR/$SPEC_ROOT_REL/$_lifecycle_lane"
done
mkdir -p "$CATDD_DIR"

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
/.catdd/metaspec/WorkingProcessLog.md
/.agents/metaspec/WorkingProcessLog.md
/.catdd/spec/WorkingProcessLog.md
# END CaTDD SpecCoding local state
GITIGNORE
  } > "$gitignore_file"

  rm -f "$temp_file"
}

# Codex reads AGENTS.md as project guidance, so CaTDD guidance is written as a
# managed block instead of overwriting a file the target project probably owns.
update_codex_agents_md() {
  local agents_file="$TARGET_DIR/AGENTS.md"
  local temp_file
  local agents_exists=0
  temp_file="$(mktemp)"

  if [[ -f "$agents_file" ]]; then
    agents_exists=1
    awk '
      $0 == "<!-- BEGIN CaTDD Codex instructions -->" { skip = 1; next }
      $0 == "<!-- END CaTDD Codex instructions -->" { skip = 0; next }
      !skip { print }
    ' "$agents_file" > "$temp_file"
  else
    : > "$temp_file"
  fi

  if [[ -s "$temp_file" ]]; then
    perl -0pi -e 's/[ \t\r]*\n+\z/\n/' "$temp_file"
  fi

  if [[ "$agents_exists" -eq 1 ]]; then
    log_install_operation patch "$agents_file"
  else
    log_install_operation new "$agents_file"
  fi

  {
    if [[ -s "$temp_file" ]]; then
      cat "$temp_file"
      printf '\n'
    fi
    cat <<'AGENTSMD'
<!-- BEGIN CaTDD Codex instructions -->
## CaTDD Codex Instructions

This managed block is installed by `scripts/installCaTDD.sh` from MyCaTDD. Use it when working with CaTDD, SpecCoding, VibeCoding, comment-alive tests, US/AC/TC skeletons, or TEST_*, SPEC_*, and HARNESS_* commands.

This block is the CaTDD-owned region and projects the rules recorded in `<metaspec_root>/projectContext.md`; text outside these markers belongs to the project and is never rewritten by CaTDD.

### Installed Sources

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- Codex skill wrappers: `.agents/skills/` (invoke with `$test-*`, `$spec-*`, `$harness-*`, or from `/skills`)
- SpecCoding flow: `.catdd/slashCommands/flows/Px-SpecFlow.md`
- SpecCoding artifact workspace: the `metaspec_root` declared in `projectContext.md`, defaulting to `.catdd/metaspec/`
- Workspace migration helper: `.catdd/scripts/migrateCaTDDMetaspec.sh`
- Project-root README SPEC docs: `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_ArchVerifyDesign.md`, and `README_VerifyDesign.md` as needed.

### Codex Behavior

- Treat each Codex skill under `.agents/skills/` as a thin adapter over `.catdd/slashCommands/commands/`; read the portable command before acting.
- If a `<Name>Evolved.md` overlay exists beside the canonical `<Name>.md` command, flow, or kit, follow the overlay: it supersedes the canonical artifact locally. Local `*Evolved.md` files are kept across refresh and `--force-overwrite`.
- Treat `.catdd/methodPrompts/` as the source of truth for CaTDD category meaning, priority order, design skeleton rules, and method constraints.
- Codex skill names are lowercase and hyphenated: `test-convert-demo-to-typical` adapts `TEST_convertDemoToTypical`.
- Before reading or writing lifecycle state, follow `.catdd/slashCommands/MetaspecWorkspaceResolution.md`; supported roots are `.catdd/metaspec/`, `.agents/metaspec/`, and legacy `.catdd/spec/`.
- Keep SpecCoding lifecycle state under the resolved `metaspec_root`.
- Commit team-shared artifacts such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, `doneUS/`, and project-root `README*` SPEC docs under the resolved `metaspec_root`.
- Keep local work state such as `WorkingProcessLog.md` gitignored in every supported workspace.
- Use `/HARNESS_migrateMetaspec` to reconcile or migrate workspaces; never merge populated roots during normal command execution.
- Prefer explicit SpecFlow intake commands: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_importUserStory`, `SPEC_analyzeIssue`, and `SPEC_analyzeFeature`.
- After every meaningful verified success, report `success_learning_checkpoint = recommended` and remind the developer to run `/HARNESS_evolveHarness` with `evolution_mode=auto`. Keep the hook non-blocking, preserve any required lifecycle/commit/merge/safety command as the immediate next action, and never auto-apply an evolution proposal. While running `HARNESS_evolveHarness`, suppress this hook for the command's own completion or the same evidence; only materially new verified evidence may trigger another checkpoint.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.

ONE-MORE-THING: ask developer if something not sure
<!-- END CaTDD Codex instructions -->
AGENTSMD
  } > "$agents_file"

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
      if [[ "$rel" == *Evolved.md ]]; then
        echo "[${LOG_TAG}] sync: evolved overlay (local-only, kept): ${label}/${rel}"
      else
        echo "[${LOG_TAG}] sync: local-only (kept): ${label}/${rel}"
      fi
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
# Local `<Name>Evolved.md` overlays are local-only learning created by
# HARNESS_evolveHarness, not canonical source, so they are preserved across the
# reset instead of being deleted.
force_reset_tree() {
  local src_tree="$1" dst_tree="$2" label="$3"
  local rel preserve_tmp
  preserve_tmp="$(mktemp -d)"

  if [[ -d "$dst_tree" ]]; then
    while IFS= read -r rel; do
      [[ -n "$rel" ]] || continue
      [[ "$rel" == *Evolved.md ]] || continue
      mkdir -p "$(dirname "$preserve_tmp/$rel")"
      cp "$dst_tree/$rel" "$preserve_tmp/$rel"
      echo "[${LOG_TAG}] sync: preserve evolved overlay (force-overwrite): ${label}/${rel}"
    done < <(list_tree "$dst_tree")
  fi

  log_replace_or_new "$dst_tree"
  rm -rf "$dst_tree"
  mkdir -p "$dst_tree"
  while IFS= read -r rel; do
    [[ -n "$rel" ]] || continue
    mkdir -p "$(dirname "$dst_tree/$rel")"
    cp "$src_tree/$rel" "$dst_tree/$rel"
    record_canonical "$label" "$rel" "$src_tree/$rel"
  done < <(list_tree "$src_tree")

  while IFS= read -r rel; do
    [[ -n "$rel" ]] || continue
    mkdir -p "$(dirname "$dst_tree/$rel")"
    cp "$preserve_tmp/$rel" "$dst_tree/$rel"
  done < <(list_tree "$preserve_tmp")
  rm -rf "$preserve_tmp"

  echo "[${LOG_TAG}] sync ${label}: force-overwrite canonical source"
}

# Move known retired names before sync so local changes retain their merge base.
migrate_command_names() {
  local rel old_rel new_rel suffix path base old_hash old_name new_name
  local target="$CATDD_DIR/slashCommands"
  local baseline="$BASELINE_ROOT/slashCommands"
  [[ -d "$target" ]] || return 0
  while IFS= read -r rel; do
    old_rel=""
    case "$rel" in
      commands/*/TEST_*.md) old_rel="${rel%/*}/UT_${rel##*/TEST_}" ;;
      TEST_slashCommandTemplate.md) old_rel="UT_slashCommandTemplate.md" ;;
      commands/Px-SpecFlow/SPEC_designTests.md) old_rel="${rel%Tests.md}UnitTests.md" ;;
      commands/Px-SpecFlow/SPEC_implTests.md) old_rel="${rel%Tests.md}UnitTests.md" ;;
      commands/Px-SpecFlow/SPEC_refactTests.md) old_rel="${rel%Tests.md}UnitTests.md" ;;
      commands/Px-SpecFlow/SPEC_reviewImplTests.md) old_rel="${rel%Tests.md}UnitTests.md" ;;
    esac
    [[ -n "$old_rel" ]] || continue
    for suffix in "" Evolved; do
      new_rel="${rel%.md}${suffix}.md"
      path="${old_rel%.md}${suffix}.md"
      [[ -f "$target/$path" ]] || continue
      if [[ -e "$target/$new_rel" ]]; then
        echo "[${LOG_TAG}] rename conflict: both $path and $new_rel exist; reconcile them before refresh" >&2
        return 1
      fi
      mkdir -p "$(dirname "$target/$new_rel")"
      mv "$target/$path" "$target/$new_rel"
      # Rewrite command identifiers only in the migrated artifact and its base.
      base="$baseline/$path"
      old_hash="$(manifest_hash_of "$path")" || old_hash=""
      old_name="${old_rel##*/}"
      old_name="${old_name%.md}"
      new_name="${rel##*/}"
      new_name="${new_name%.md}"
      for path in "$target/$new_rel" "$base"; do
        [[ -f "$path" ]] || continue
        sed "s/$old_name/$new_name/g" "$path" > "$path.rename-tmp"
        mv "$path.rename-tmp" "$path"
      done
      if [[ -f "$base" && -n "$old_hash" ]]; then
        record_canonical slashCommands "$new_rel" "$base"
        rm -f "$base"
      fi
      manifest_drop "${old_rel%.md}${suffix}.md"
      CLEAN_PROMPTS=1
      echo "[${LOG_TAG}] sync: renamed ${old_rel%.md}${suffix}.md -> $new_rel"
    done
  done < <(list_tree "$SLASH_SRC")
}

update_spec_gitignore
manifest_load
migrate_command_names

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

log_replace_or_new "$METASPEC_HELPER_INSTALLED"
mkdir -p "$(dirname "$METASPEC_HELPER_INSTALLED")"
cp "$METASPEC_HELPER_SRC" "$METASPEC_HELPER_INSTALLED"
chmod +x "$METASPEC_HELPER_INSTALLED"

log_replace_or_new "$CATDD_DIR/CaTDD_INSTALL.md"
printf '# CaTDD Install Marker\n\n- Installed version: %s\n- Target agent: %s\n\n' "$CATDD_VERSION" "$AGENT_LABEL" > "$CATDD_DIR/CaTDD_INSTALL.md"
cat >> "$CATDD_DIR/CaTDD_INSTALL.md" <<'MARKER'
This directory is managed by `scripts/installCaTDD.sh` from MyCaTDD.

- `methodPrompts/` is the installed CaTDD method source.
- `slashCommands/` is the installed portable flow-command source.
- `scripts/migrateCaTDDMetaspec.sh` selects or migrates the SpecCoding artifact workspace.
- `projectContext.md` declares the active `metaspec_root`; supported roots are `.catdd/metaspec/`, `.agents/metaspec/`, and legacy `.catdd/spec/`.
- `CaTDD_INSTALL.manifest` records the canonical baseline hash of every managed file.
- `.install-baseline/` stores canonical baseline content used for three-way merge.
- Refresh keeps target files evolved after install (for example by `HARNESS_evolveHarness`).
  Disjoint upstream and target edits are merged; overlapping edits keep the target and are reported.
- `HARNESS_evolveHarness` writes slash-command learning to local `<Name>Evolved.md` overlays, which supersede the canonical `<Name>.md` locally.
  Overlays are local-only: refresh and `--force-overwrite` preserve them instead of overwriting or deleting them.
- `--force-overwrite` restores canonical source for all managed files.
- Commit team-shared SpecCoding artifacts under the resolved `metaspec_root`, such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, and `doneUS/`.
- Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_ArchVerifyDesign.md`, and `README_VerifyDesign.md` as needed.
- Keep local SpecCoding work state such as `WorkingProcessLog.md` gitignored in every supported workspace.

Refresh this project by rerunning the installer from the MyCaTDD repository.
MARKER

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

to_skill_name() {
  local raw_name="$1"
  printf '%s' "$raw_name" \
    | sed -E 's/([A-Z]+)([A-Z][a-z])/\1-\2/g; s/([a-z0-9])([A-Z])/\1-\2/g' \
    | tr '[:upper:]' '[:lower:]' \
    | tr '_' '-'
}

clean_copilot_wrappers() {
  local prompts_dir="$1"
  local skills_dir="$2"
  local existing
  if [[ -d "$prompts_dir" ]]; then
    find "$prompts_dir" -maxdepth 1 -type f \( -name 'UT_*.prompt.md' -o -name 'TEST_*.prompt.md' -o -name 'SPEC_*.prompt.md' -o -name 'HARNESS_*.prompt.md' \) -delete
  fi
  if [[ -d "$skills_dir" ]]; then
    for existing in "$skills_dir"/ut-* "$skills_dir"/test-* "$skills_dir"/spec-* "$skills_dir"/harness-*; do
      [[ -d "$existing" ]] || continue
      if [[ -f "$existing/SKILL.md" ]] && grep -Fq 'portable CaTDD slash command' "$existing/SKILL.md"; then
        rm -rf "$existing"
      elif [[ -z "$(ls -A "$existing" 2>/dev/null)" ]]; then
        rm -rf "$existing"
      fi
    done
  fi
}

case "$AGENT_LABEL" in
  ChatCopilotLocal)
    GITHUB_DIR="$TARGET_DIR/.github"
    PROMPTS_DIR="$GITHUB_DIR/prompts"
    SKILLS_DIR="$GITHUB_DIR/skills"
    INSTRUCTIONS_DIR="$GITHUB_DIR/instructions"
    mkdir -p "$PROMPTS_DIR" "$INSTRUCTIONS_DIR"

    log_replace_or_new "$INSTRUCTIONS_DIR/catdd.instructions.md"
    cat > "$INSTRUCTIONS_DIR/catdd.instructions.md" <<'INSTRUCTIONS'
---
description: "Use when working with CaTDD, comment-alive tests, US/AC/TC skeletons, or TEST_*, SPEC_*, and HARNESS_* slash commands."
---
# CaTDD Project Instructions

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- Copilot prompt wrappers: `.github/prompts/TEST_*.prompt.md`, `.github/prompts/SPEC_*.prompt.md`, and `.github/prompts/HARNESS_*.prompt.md`
- Treat Copilot prompt files as thin adapters over `.catdd/slashCommands/`.
- Before reading or writing SpecCoding artifacts, follow `.catdd/slashCommands/MetaspecWorkspaceResolution.md` and use the `metaspec_root` declared in `projectContext.md`.
- Supported workspaces are canonical `.catdd/metaspec/`, agent-owned `.agents/metaspec/`, and legacy `.catdd/spec/`; use `HARNESS_migrateMetaspec` rather than merging populated roots.
- If a `<Name>Evolved.md` overlay exists beside the canonical `<Name>.md` command, flow, or kit, follow the overlay: it supersedes the canonical artifact locally. Local `*Evolved.md` files are kept across refresh and `--force-overwrite`.
- Treat `.catdd/methodPrompts/` as the source of truth for category meaning, priority order, design skeleton rules, and CaTDD method constraints.
- Use project-root `README_UbiLang.md` and `README_UbiLang_ZH.md` as the canonical CaTDD terminology glossaries.
- Commit team-shared SpecCoding artifacts under the resolved `metaspec_root`, such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, and `doneUS/`.
- Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_ArchVerifyDesign.md`, and `README_VerifyDesign.md` as needed.
- Keep local SpecCoding work state such as `WorkingProcessLog.md` gitignored in every supported workspace.
- After every meaningful verified success, report `success_learning_checkpoint = recommended` and remind the developer to run `/HARNESS_evolveHarness` with `evolution_mode=auto`. Keep the hook non-blocking, preserve any required lifecycle/commit/merge/safety command as the immediate next action, and never auto-apply an evolution proposal. While running `HARNESS_evolveHarness`, suppress this hook for the command's own completion or the same evidence; only materially new verified evidence may trigger another checkpoint.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.
INSTRUCTIONS

    if [[ "$CLEAN_PROMPTS" -eq 1 ]]; then
      clean_copilot_wrappers "$PROMPTS_DIR" "$SKILLS_DIR"
    fi

    generated_count=0
    while IFS= read -r source_file; do
      command_file="$(basename "$source_file")"
      command_name="${command_file%.md}"
      flow_name="$(basename "$(dirname "$source_file")")"
      rel_source="$(rel_to_workspace "$source_file")"
      rel_method_index="$(rel_to_workspace "$CATDD_DIR/methodPrompts/README.md")"
      rel_slash_template="$(rel_to_workspace "$CATDD_DIR/slashCommands/TEST_slashCommandTemplate.md")"
      rel_flow_docs="$(rel_to_workspace "$CATDD_DIR/slashCommands/flows")"
      rel_kit_docs="$(rel_to_workspace "$CATDD_DIR/slashCommands/kits")"
      output_file="$PROMPTS_DIR/$command_name.prompt.md"

      cat > "$output_file" <<PROMPT
---
description: "Run CaTDD slash command $command_name"
agent: "agent"
argument-hint: "Fill required command inputs, source files, target files, language, and test framework"
---
# $command_name

You are running a Copilot-native wrapper around a portable CaTDD slash command.

## Source Command

- Portable command path: $rel_source
- Default workspace link: [$rel_source](../../$rel_source)
- Flow or kit: $flow_name

## Method Source of Truth

- CaTDD method index: [$rel_method_index](../../$rel_method_index)
- Slash command contract: [$rel_slash_template](../../$rel_slash_template)
- Flow docs: [$rel_flow_docs](../../$rel_flow_docs)
- Kit docs: [$rel_kit_docs](../../$rel_kit_docs)

## Execution Rules

1. Read and follow the portable source command before acting; if a sibling <Name>Evolved.md overlay exists, follow the overlay instead because it supersedes the canonical command locally.
2. Treat this file as a thin Copilot adapter; do not redefine CaTDD method semantics here.
3. Use methodPrompts for category meaning, priority order, design skeleton rules, and CaTDD constraints.
4. Use the source command for inputs, outputs, conflict guards, and next-step flow or kit contract.
5. Ask for missing product intent instead of inventing requirements.
6. Report the next recommended slash command when the step finishes.

ONE-MORE-THING: ask developer if something not sure
PROMPT

      generated_count=$((generated_count + 1))
    done < <(find "$CATDD_DIR/slashCommands/commands" -type f \( -name 'TEST_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | sort)

    echo "[${LOG_TAG}] Generated $generated_count Copilot prompt wrappers in .github/prompts"

    echo "[${LOG_TAG}] Installed CaTDD for $AGENT_LABEL into $TARGET_DIR"
    echo "[${LOG_TAG}] Method source: .catdd/methodPrompts"
    echo "[${LOG_TAG}] Slash command source: .catdd/slashCommands"
    echo "[${LOG_TAG}] SpecCoding artifacts: $SPEC_ROOT_REL"
    echo "[${LOG_TAG}] Copilot prompts: .github/prompts"
    ;;

  ChatCopilotAgentHost)
    GITHUB_DIR="$TARGET_DIR/.github"
    PROMPTS_DIR="$GITHUB_DIR/prompts"
    SKILLS_DIR="$GITHUB_DIR/skills"
    INSTRUCTIONS_DIR="$GITHUB_DIR/instructions"
    if [[ -e "$SKILLS_DIR" && ! -d "$SKILLS_DIR" ]]; then
      echo "[${LOG_TAG}] Cannot create .github/skills because .github/skills exists and is not a directory." >&2
      exit 1
    fi
    mkdir -p "$SKILLS_DIR" "$INSTRUCTIONS_DIR"

    log_replace_or_new "$INSTRUCTIONS_DIR/catdd.instructions.md"
    cat > "$INSTRUCTIONS_DIR/catdd.instructions.md" <<'INSTRUCTIONS'
---
description: "Use when working with CaTDD, comment-alive tests, US/AC/TC skeletons, or TEST_*, SPEC_*, and HARNESS_* slash commands."
---
# CaTDD Project Instructions

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- Copilot skill wrappers: `.github/skills/test-*/SKILL.md`, `.github/skills/spec-*/SKILL.md`, and `.github/skills/harness-*/SKILL.md`
- Treat Copilot skill files as thin adapters over `.catdd/slashCommands/`.
- If a `<Name>Evolved.md` overlay exists beside the canonical `<Name>.md` command, flow, or kit, follow the overlay: it supersedes the canonical artifact locally. Local `*Evolved.md` files are kept across refresh and `--force-overwrite`.
- Treat `.catdd/methodPrompts/` as the source of truth for category meaning, priority order, design skeleton rules, and CaTDD method constraints.
- Use project-root `README_UbiLang.md` and `README_UbiLang_ZH.md` as the canonical CaTDD terminology glossaries.
- Commit team-shared SpecCoding artifacts under the resolved `metaspec_root`, such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, and `doneUS/`.
- Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_ArchVerifyDesign.md`, and `README_VerifyDesign.md` as needed.
- Keep local SpecCoding work state such as `WorkingProcessLog.md` gitignored in every supported workspace.
- After every meaningful verified success, report `success_learning_checkpoint = recommended` and remind the developer to run `/HARNESS_evolveHarness` with `evolution_mode=auto`. Keep the hook non-blocking, preserve any required lifecycle/commit/merge/safety command as the immediate next action, and never auto-apply an evolution proposal. While running `HARNESS_evolveHarness`, suppress this hook for the command's own completion or the same evidence; only materially new verified evidence may trigger another checkpoint.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.
INSTRUCTIONS

    if [[ "$CLEAN_PROMPTS" -eq 1 ]]; then
      clean_copilot_wrappers "$PROMPTS_DIR" "$SKILLS_DIR"
    fi

    generated_count=0
    while IFS= read -r source_file; do
      command_file="$(basename "$source_file")"
      command_name="${command_file%.md}"
      skill_name="$(to_skill_name "$command_name")"
      flow_name="$(basename "$(dirname "$source_file")")"
      rel_source="$(rel_to_workspace "$source_file")"
      rel_method_index="$(rel_to_workspace "$CATDD_DIR/methodPrompts/README.md")"
      rel_slash_template="$(rel_to_workspace "$CATDD_DIR/slashCommands/TEST_slashCommandTemplate.md")"
      rel_flow_docs="$(rel_to_workspace "$CATDD_DIR/slashCommands/flows")"
      rel_kit_docs="$(rel_to_workspace "$CATDD_DIR/slashCommands/kits")"

      if [[ ! "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || [[ "${#skill_name}" -gt 64 ]]; then
        echo "[${LOG_TAG}] Cannot derive a valid Copilot skill name from: $command_file (got '$skill_name')" >&2
        exit 1
      fi

      desc_line=""
      desc_line="$(awk '/^## Purpose/ {found=1; next} found && /^[[:space:]]*$/ {next} found && /^[^#]/ {print; exit}' "$source_file" | head -c 200 | tr -d '"\\' | tr '\n' ' ')"
      if [[ -n "$desc_line" ]]; then
        description="Run CaTDD slash command ${command_name} (flow ${flow_name}). ${desc_line}"
      else
        description="Run CaTDD slash command ${command_name} (flow ${flow_name})"
      fi
      description="$(printf '%s' "${description:0:400}" | sed -E 's/[[:space:]]+$//')"

      skill_dir="$SKILLS_DIR/$skill_name"
      mkdir -p "$skill_dir"
      output_file="$skill_dir/SKILL.md"

      cat > "$output_file" <<SKILL
---
name: $skill_name
description: "$description"
argument-hint: "Fill required command inputs, source files, target files, language, and test framework"
disable-model-invocation: true
---
# $command_name

You are running a Copilot-native skill wrapper around a portable CaTDD slash command.

## Source Command

- Canonical command name: $command_name
- Portable command path: $rel_source
- Default workspace link: [$rel_source](../../../$rel_source)
- Flow or kit: $flow_name

## Method Source of Truth

- CaTDD method index: [$rel_method_index](../../../$rel_method_index)
- Slash command contract: [$rel_slash_template](../../../$rel_slash_template)
- Flow docs: [$rel_flow_docs](../../../$rel_flow_docs)
- Kit docs: [$rel_kit_docs](../../../$rel_kit_docs)

## Execution Rules

1. Read and follow the portable source command before acting; if a sibling <Name>Evolved.md overlay exists, follow the overlay instead because it supersedes the canonical command locally.
2. Treat this file as a thin Copilot adapter; do not redefine CaTDD method semantics here.
3. Use methodPrompts for category meaning, priority order, design skeleton rules, and CaTDD constraints.
4. Use the source command for inputs, outputs, conflict guards, and next-step flow or kit contract.
5. Ask for missing product intent instead of inventing requirements.
6. Report the next recommended slash command when the step finishes.

ONE-MORE-THING: ask developer if something not sure
SKILL

      generated_count=$((generated_count + 1))
    done < <(find "$CATDD_DIR/slashCommands/commands" -type f \( -name 'TEST_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | sort)

    echo "[${LOG_TAG}] Generated $generated_count Copilot skill wrappers in .github/skills"

    echo "[${LOG_TAG}] Installed CaTDD for $AGENT_LABEL into $TARGET_DIR"
    echo "[${LOG_TAG}] Method source: .catdd/methodPrompts"
    echo "[${LOG_TAG}] Slash command source: .catdd/slashCommands"
    echo "[${LOG_TAG}] SpecCoding artifacts: $SPEC_ROOT_REL"
    echo "[${LOG_TAG}] Copilot skills: .github/skills"
    ;;

  Codex)
    CODEX_SKILLS_DIR="$TARGET_DIR/.agents/skills"
    if [[ -e "$CODEX_SKILLS_DIR" && ! -d "$CODEX_SKILLS_DIR" ]]; then
      echo "[${LOG_TAG}] Cannot create .agents/skills because .agents/skills exists and is not a directory." >&2
      exit 1
    fi
    log_replace_or_new "$CODEX_SKILLS_DIR"
    mkdir -p "$CODEX_SKILLS_DIR"

    update_codex_agents_md

    if [[ "$CLEAN_PROMPTS" -eq 1 ]]; then
      clean_copilot_wrappers "" "$CODEX_SKILLS_DIR"
    fi

    generated_count=0
    while IFS= read -r source_file; do
      command_file="$(basename "$source_file")"
      command_name="${command_file%.md}"
      skill_name="$(to_skill_name "$command_name")"
      flow_name="$(basename "$(dirname "$source_file")")"
      rel_source="$(rel_to_workspace "$source_file")"
      rel_method_index="$(rel_to_workspace "$CATDD_DIR/methodPrompts/README.md")"
      rel_slash_template="$(rel_to_workspace "$CATDD_DIR/slashCommands/TEST_slashCommandTemplate.md")"
      rel_flow_docs="$(rel_to_workspace "$CATDD_DIR/slashCommands/flows")"
      rel_kit_docs="$(rel_to_workspace "$CATDD_DIR/slashCommands/kits")"

      if [[ ! "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || [[ "${#skill_name}" -gt 64 ]]; then
        echo "[${LOG_TAG}] Cannot derive a valid Codex skill name from: $command_file (got '$skill_name')" >&2
        exit 1
      fi

      desc_line=""
      desc_line="$(awk '/^## Purpose/ {found=1; next} found && /^[[:space:]]*$/ {next} found && /^[^#]/ {print; exit}' "$source_file" | head -c 200 | tr -d '"\\' | tr '\n' ' ')"
      if [[ -n "$desc_line" ]]; then
        description="Run CaTDD slash command ${command_name} (flow ${flow_name}). ${desc_line}"
      else
        description="Run CaTDD slash command ${command_name} (flow ${flow_name})"
      fi
      description="$(printf '%s' "${description:0:400}" | sed -E 's/[[:space:]]+$//')"

      skill_dir="$CODEX_SKILLS_DIR/$skill_name"
      mkdir -p "$skill_dir/agents"
      output_file="$skill_dir/SKILL.md"
      openai_yaml="$skill_dir/agents/openai.yaml"

      cat > "$output_file" <<SKILL
---
name: $skill_name
description: "$description"
---

# $command_name

You are running a Codex Skill wrapper around a portable CaTDD slash command.

## Source Command

- Canonical command name: $command_name
- Portable command path: $rel_source
- Flow or kit: $flow_name

## Method Source of Truth

- CaTDD method index: $rel_method_index
- Slash command contract: $rel_slash_template
- Flow docs: $rel_flow_docs
- Kit docs: $rel_kit_docs

## Execution Rules

1. Read and follow the portable source command located at \`$rel_source\` before acting; if a sibling <Name>Evolved.md overlay exists, follow the overlay instead because it supersedes the canonical command locally.
2. Treat this file as a thin Codex Skill adapter; do not redefine CaTDD method semantics here.
3. Use methodPrompts for category meaning, priority order, design skeleton rules, and CaTDD constraints.
4. Use the source command for inputs, outputs, conflict guards, and next-step flow or kit contract.
5. Ask for missing product intent instead of inventing requirements.
6. Report the next recommended slash command when the step finishes.

ONE-MORE-THING: ask developer if something not sure
SKILL

      cat > "$openai_yaml" <<YAML
interface:
  display_name: "$command_name"
  short_description: "Run CaTDD slash command $command_name ($flow_name)"
policy:
  allow_implicit_invocation: false
YAML

      generated_count=$((generated_count + 1))
    done < <(find "$CATDD_DIR/slashCommands/commands" -type f \( -name 'TEST_*.md' -o -name 'SPEC_*.md' -o -name 'HARNESS_*.md' \) | sort)

    echo "[${LOG_TAG}] Generated $generated_count Codex skill wrappers in .agents/skills"

    echo "[${LOG_TAG}] Installed CaTDD for Codex into $TARGET_DIR"
    echo "[${LOG_TAG}] Method source: .catdd/methodPrompts"
    echo "[${LOG_TAG}] Slash command source: .catdd/slashCommands"
    echo "[${LOG_TAG}] SpecCoding artifacts: $SPEC_ROOT_REL"
    echo "[${LOG_TAG}] Codex instructions: AGENTS.md (managed CaTDD block)"
    echo "[${LOG_TAG}] Codex skills: .agents/skills"
    ;;

esac
