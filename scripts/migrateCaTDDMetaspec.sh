#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT=""
APPLY=0
QUIET=0
PRINT_ROOT=0
TMP_DIR=""

usage() {
  cat <<'USAGE'
Usage: scripts/migrateCaTDDMetaspec.sh --project-root DIR [--apply] [--quiet]

Select and, when unambiguous, migrate the CaTDD SpecCoding artifact workspace.
Supported workspace locations are:

  .catdd/metaspec    canonical for new projects
  .agents/metaspec   agent-owned alternate
  .catdd/spec        legacy compatibility location

The default is a read-only dry run. --apply moves a sole populated legacy
workspace to .catdd/metaspec, updates projectContext.md and the managed
.gitignore block, or creates the canonical workspace when none exists.

The helper never merges multiple populated workspaces. Resolve that state
manually or with HARNESS_migrateMetaspec before rerunning.

Options:
  --project-root DIR  Project root containing the .catdd/.agents directories.
  --apply             Apply the reported migration.
  --quiet             Suppress successful dry-run/apply details.
  --print-root        Print only the selected workspace and exit without mutation.
  -h, --help          Show this help.
USAGE
}

cleanup() {
  [[ -z "$TMP_DIR" ]] || rm -rf "$TMP_DIR"
}
trap cleanup EXIT

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      [[ $# -ge 2 ]] || { echo "[migrateCaTDDMetaspec] --project-root requires a directory" >&2; exit 2; }
      PROJECT_ROOT="$2"
      shift 2
      ;;
    --apply)
      APPLY=1
      shift
      ;;
    --quiet)
      QUIET=1
      shift
      ;;
    --print-root)
      PRINT_ROOT=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[migrateCaTDDMetaspec] Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$PROJECT_ROOT" ]]; then
  echo "[migrateCaTDDMetaspec] Missing required --project-root DIR" >&2
  usage >&2
  exit 2
fi
if [[ ! -d "$PROJECT_ROOT" ]]; then
  echo "[migrateCaTDDMetaspec] Project root does not exist: $PROJECT_ROOT" >&2
  exit 1
fi

PROJECT_ROOT="$(cd "$PROJECT_ROOT" && pwd)"
TMP_DIR="$(mktemp -d)"

FAIL=0
ROOT_STATE=""
DECLARED_ROOT=""
SELECTED_ROOT=""
CONTEXT_FILE=""
POPULATED_COUNT=0
LEGACY_PRESENT=0
CANONICAL_PRESENT=0
AGENT_PRESENT=0

report_error() {
  echo "[migrateCaTDDMetaspec] ERROR: $*" >&2
  FAIL=1
}

is_populated() {
  local path="$1"
  [[ -d "$path" ]] || return 1
  [[ -n "$(find "$path" -type f ! -name '.DS_Store' -print -quit 2>/dev/null)" ]]
}

normalise_declared_root() {
  local value="$1"
  value="${value%%#*}"
  value="$(printf '%s' "$value" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/^`//; s/`$//')"
  printf '%s\n' "$value"
}

allowed_root() {
  case "$1" in
    .catdd/metaspec|.agents/metaspec|.catdd/spec) return 0 ;;
    *) return 1 ;;
  esac
}

root_status() {
  local rel="$1"
  local path="$PROJECT_ROOT/$rel"
  if is_populated "$path"; then
    printf 'populated'
  elif [[ -d "$path" ]]; then
    printf 'empty'
  else
    printf 'absent'
  fi
}

discover_contexts() {
  local rel path count=0
  local context_roots=()
  local context_paths=()

  for rel in .catdd/metaspec .agents/metaspec .catdd/spec; do
    path="$PROJECT_ROOT/$rel/projectContext.md"
    if [[ -f "$path" ]]; then
      context_roots+=("$rel")
      context_paths+=("$path")
      count=$((count + 1))
    fi
  done

  CONTEXT_FILE=""
  DECLARED_ROOT=""
  if [[ "$count" -gt 1 ]]; then
    report_error "multiple projectContext.md files exist: ${context_roots[*]}"
    return 1
  fi
  [[ "$count" -eq 1 ]] || return 0

  CONTEXT_FILE="${context_paths[0]}"
  local physical_root="${context_roots[0]}"
  DECLARED_ROOT="$(sed -nE 's/^metaspec_root:[[:space:]]*(.*)$/\1/p' "$CONTEXT_FILE" | head -1)"
  DECLARED_ROOT="$(normalise_declared_root "$DECLARED_ROOT")"
  if [[ -n "$DECLARED_ROOT" ]] && ! allowed_root "$DECLARED_ROOT"; then
    report_error "unsupported metaspec_root '$DECLARED_ROOT' in $CONTEXT_FILE"
    return 1
  fi
  if [[ -n "$DECLARED_ROOT" && "$DECLARED_ROOT" != "$physical_root" ]]; then
    report_error "projectContext declares '$DECLARED_ROOT' but is stored under '$physical_root'"
    return 1
  fi
  return 0
}

discover_roots() {
  local rel state
  local populated_roots=()

  for rel in .catdd/metaspec .agents/metaspec .catdd/spec; do
    state="$(root_status "$rel")"
    ROOT_STATE="${ROOT_STATE}${rel}=${state}
"
    case "$rel:$state" in
      .catdd/metaspec:populated) CANONICAL_PRESENT=1; populated_roots+=("$rel") ;;
      .catdd/metaspec:*) ;;
      .agents/metaspec:populated) AGENT_PRESENT=1; populated_roots+=("$rel") ;;
      .catdd/spec:populated) LEGACY_PRESENT=1; populated_roots+=("$rel") ;;
      .catdd/spec:*) ;;
    esac
  done

  POPULATED_COUNT="${#populated_roots[@]}"
  if [[ "$POPULATED_COUNT" -gt 1 ]]; then
    report_error "multiple populated metaspec workspaces exist: ${populated_roots[*]}"
    report_error "refusing to merge workspace state automatically"
    return 1
  fi

  discover_contexts || return 1

  if [[ -n "$DECLARED_ROOT" ]]; then
    SELECTED_ROOT="$DECLARED_ROOT"
  elif [[ "$POPULATED_COUNT" -eq 1 ]]; then
    SELECTED_ROOT="${populated_roots[0]}"
    if [[ -n "$CONTEXT_FILE" && -z "$DECLARED_ROOT" ]]; then
      DECLARED_ROOT="$SELECTED_ROOT"
    fi
  else
    SELECTED_ROOT=".catdd/metaspec"
  fi
}

update_context_field() {
  local path="$1"
  local root="$2"
  local tmp="$TMP_DIR/projectContext.md"

  if grep -qE '^metaspec_root:' "$path"; then
    awk -v root="$root" '
      /^metaspec_root:/ { print "metaspec_root: " root; next }
      { print }
    ' "$path" > "$tmp"
  elif grep -qE '^## SpecFlow Lifecycle State[[:space:]]*$' "$path"; then
    awk -v root="$root" '
      { print }
      /^## SpecFlow Lifecycle State[[:space:]]*$/ {
        print ""
        print "metaspec_root: " root
      }
    ' "$path" > "$tmp"
  else
    {
      cat "$path"
      printf '\n## SpecFlow Lifecycle State\n\nmetaspec_root: %s\n' "$root"
    } > "$tmp"
  fi
  mv "$tmp" "$path"
}

update_gitignore() {
  local gitignore="$PROJECT_ROOT/.gitignore"
  local tmp="$TMP_DIR/gitignore"
  local exists=0
  if [[ -f "$gitignore" ]]; then
    exists=1
    awk '
      $0 == "# BEGIN CaTDD SpecCoding local state" { skip = 1; next }
      $0 == "# END CaTDD SpecCoding local state" { skip = 0; next }
      !skip { print }
    ' "$gitignore" > "$tmp"
  else
    : > "$tmp"
  fi
  if [[ -s "$tmp" ]]; then
    perl -0pi -e 's/[ \t\r]*\n+\z/\n/' "$tmp"
  fi
  {
    if [[ -s "$tmp" ]]; then
      cat "$tmp"
      printf '\n'
    fi
    cat <<'GITIGNORE'
# BEGIN CaTDD SpecCoding local state
/.catdd/metaspec/WorkingProcessLog.md
/.agents/metaspec/WorkingProcessLog.md
/.catdd/spec/WorkingProcessLog.md
# END CaTDD SpecCoding local state
GITIGNORE
  } > "$TMP_DIR/gitignore.next"
  mv "$TMP_DIR/gitignore.next" "$gitignore"
  if [[ "$exists" -eq 0 && "$QUIET" -eq 0 ]]; then
    echo "[migrateCaTDDMetaspec] created: .gitignore"
  fi
}

create_lifecycle_dirs() {
  local root="$1"
  local lane
  for lane in pendingNews analyzedNews todoUS doingUS suspendUS abortUS doneUS; do
    mkdir -p "$PROJECT_ROOT/$root/$lane"
  done
}

discover_roots

if [[ "$FAIL" -ne 0 ]]; then
  exit 1
fi

if [[ "$PRINT_ROOT" -eq 1 ]]; then
  printf '%s\n' "$SELECTED_ROOT"
  exit 0
fi

if [[ "$QUIET" -eq 0 ]]; then
  echo "[migrateCaTDDMetaspec] project_root: $PROJECT_ROOT"
  printf '%s' "$ROOT_STATE" | while IFS= read -r line; do
    [[ -n "$line" ]] && echo "[migrateCaTDDMetaspec] candidate: $line"
  done
  [[ -z "$CONTEXT_FILE" ]] || echo "[migrateCaTDDMetaspec] project_context: ${CONTEXT_FILE#$PROJECT_ROOT/}"
  [[ -z "$DECLARED_ROOT" ]] || echo "[migrateCaTDDMetaspec] declared_root: $DECLARED_ROOT"
  echo "[migrateCaTDDMetaspec] selected_root: $SELECTED_ROOT"
fi

ACTION="none"
DEST_ROOT="$SELECTED_ROOT"

if [[ "$SELECTED_ROOT" == ".catdd/spec" ]]; then
  if [[ -e "$PROJECT_ROOT/.catdd/metaspec" ]]; then
    report_error "cannot migrate .catdd/spec because .catdd/metaspec already exists"
  else
    ACTION="migrate"
    DEST_ROOT=".catdd/metaspec"
  fi
elif [[ "$POPULATED_COUNT" -eq 0 ]]; then
  ACTION="create"
fi

if [[ "$FAIL" -ne 0 ]]; then
  exit 1
fi

if [[ "$QUIET" -eq 0 ]]; then
  echo "[migrateCaTDDMetaspec] action: $ACTION"
  if [[ "$ACTION" == "migrate" ]]; then
    echo "[migrateCaTDDMetaspec] move: .catdd/spec -> .catdd/metaspec"
  fi
fi

if [[ "$APPLY" -eq 0 ]]; then
  [[ "$QUIET" -eq 1 ]] || echo "[migrateCaTDDMetaspec] dry run only; pass --apply to execute"
  exit 0
fi

if [[ "$ACTION" == "migrate" ]]; then
  mv "$PROJECT_ROOT/.catdd/spec" "$PROJECT_ROOT/.catdd/metaspec"
fi

create_lifecycle_dirs "$DEST_ROOT"

CONTEXT_FILE="$PROJECT_ROOT/$DEST_ROOT/projectContext.md"
if [[ -f "$CONTEXT_FILE" ]]; then
  update_context_field "$CONTEXT_FILE" "$DEST_ROOT"
fi

update_gitignore

if [[ "$QUIET" -eq 0 ]]; then
  echo "[migrateCaTDDMetaspec] applied: selected_root=$DEST_ROOT"
  [[ ! -f "$CONTEXT_FILE" ]] || echo "[migrateCaTDDMetaspec] updated: ${CONTEXT_FILE#$PROJECT_ROOT/}"
fi

exit 0
