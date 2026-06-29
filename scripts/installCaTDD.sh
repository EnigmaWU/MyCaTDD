#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

TARGET_DIR=""
TARGET_AGENT=""
CLEAN_PROMPTS=0
INIT=0
VERBOSE=0
YES=0

usage() {
  cat <<'USAGE'
Usage: scripts/installCaTDD.sh --targetDir DIR --targetCodeAgent AGENT [options]

Install or refresh CaTDD methodPrompts, slashCommands, and CodeAgent-native
prompt wrappers into a target project by routing to the matching installer.

Options:
  --targetDir DIR           Target project directory.
  --targetCodeAgent AGENT   Code agent to install for.
                            Supported: Copilot | Continue | dryRunner
  --clean-prompts           Remove and regenerate prompt wrappers.
  --init                    Create the target directory if it does not exist.
  --verbose                 Print detailed action steps.
  --yes, -y                 Skip confirmation prompt.
  -h, --help                Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --targetDir)
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

# Validate required arguments
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

# Map agent name to sub-installer script
INSTALLER=""
AGENT_LABEL=""
case "$TARGET_AGENT" in
  Copilot|GitHub/Copilot)
    INSTALLER="$REPO_ROOT/scripts/installCaTDD4Copilot.sh"
    AGENT_LABEL="Copilot"
    ;;
  Continue)
    INSTALLER="$REPO_ROOT/scripts/installCaTDD4Continue.sh"
    AGENT_LABEL="Continue"
    ;;
  dryRunner)
    # dryRunner: report what would be called, exit cleanly
    echo "[installCaTDD] dryRunner: requested agent = ${TARGET_AGENT}"
    echo "[installCaTDD] dryRunner: targetDir        = ${TARGET_DIR}"
    echo "[installCaTDD] dryRunner: would call        = scripts/installCaTDD4<AGENT>.sh --target <DIR> [options]"
    echo "[installCaTDD] dryRunner: supported agents  = Copilot | Continue"
    exit 0
    ;;
  *)
    echo "[installCaTDD] Unknown --targetCodeAgent: $TARGET_AGENT. Supported: Copilot | Continue | dryRunner" >&2
    exit 2
    ;;
esac

# Ensure the sub-installer exists
if [[ ! -x "$INSTALLER" ]]; then
  echo "[installCaTDD] Sub-installer not found or not executable: $INSTALLER" >&2
  exit 1
fi

# Build forwarded arguments
FORWARD_ARGS=(--target "$TARGET_DIR")
[[ "$CLEAN_PROMPTS" -eq 1 ]] && FORWARD_ARGS+=(--clean-prompts)
[[ "$INIT" -eq 1 ]] && FORWARD_ARGS+=(--init)
[[ "$VERBOSE" -eq 1 ]] && FORWARD_ARGS+=(--verbose)
[[ "$YES" -eq 1 ]] && FORWARD_ARGS+=(--yes)

if [[ "$VERBOSE" -eq 1 ]]; then
  echo "[installCaTDD] Routing to ${AGENT_LABEL} installer"
  echo "[installCaTDD]   installer: ${INSTALLER}"
  echo "[installCaTDD]   args:      ${FORWARD_ARGS[*]}"
fi

exec "$INSTALLER" "${FORWARD_ARGS[@]}"
