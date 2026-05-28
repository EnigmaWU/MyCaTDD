#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLOW_DOC="$REPO_ROOT/slashCommands/flows/Px-SpecFlow.md"
TAKE_DETAIL_DESIGN="$REPO_ROOT/slashCommands/commands/Px-SpecFlow/SPEC_takeDetailDesign.md"

fail() {
  echo "[readme-template-test] $*" >&2
  exit 1
}

required_pairs=(
  "README.md|slashCommands/templates/README_Template.md"
  "README_ArchDesign.md|slashCommands/templates/README_ArchDesignTemplate.md"
  "README_UserStories.md|slashCommands/templates/README_UserStoriesTemplate.md"
  "README_UserGuide.md|slashCommands/templates/README_UserGuideTemplate.md"
  "README_DetailDesign.md|slashCommands/templates/README_DetailDesignTemplate.md"
  "README_ErrorDesign.md|slashCommands/templates/README_ErrorDesignTemplate.md"
  "README_ResourceDesign.md|slashCommands/templates/README_ResourceDesignTemplate.md"
  "README_StateDesign.md|slashCommands/templates/README_StateDesignTemplate.md"
  "README_PerfDesign.md|slashCommands/templates/README_PerfDesignTemplate.md"
  "README_CompatDesign.md|slashCommands/templates/README_CompatDesignTemplate.md"
  "README_DiagnosisDesign.md|slashCommands/templates/README_DiagnosisDesignTemplate.md"
  "README_VerifyDesign.md|slashCommands/templates/README_VerifyDesignTemplate.md"
  "README_UsageDesign.md|slashCommands/templates/README_UsageDesignTemplate.md"
)

domain_templates=(
  "slashCommands/templates/README_ArchDesignTemplate.md"
  "slashCommands/templates/README_DetailDesignTemplate.md"
  "slashCommands/templates/README_ErrorDesignTemplate.md"
  "slashCommands/templates/README_ResourceDesignTemplate.md"
  "slashCommands/templates/README_StateDesignTemplate.md"
  "slashCommands/templates/README_PerfDesignTemplate.md"
  "slashCommands/templates/README_CompatDesignTemplate.md"
  "slashCommands/templates/README_DiagnosisDesignTemplate.md"
  "slashCommands/templates/README_VerifyDesignTemplate.md"
)

missing=0

for pair in "${required_pairs[@]}"; do
  readme="${pair%%|*}"
  template="${pair##*|}"

  if [[ ! -f "$REPO_ROOT/$template" ]]; then
    echo "[readme-template-test] missing SpecCoding README template for $readme: $template" >&2
    missing=1
  fi

  grep -Fq "\`$readme\`" "$FLOW_DOC" || {
    echo "[readme-template-test] Px-SpecFlow does not document required README SPEC doc: $readme" >&2
    missing=1
  }

  if [[ "$readme" != "README.md" ]]; then
    grep -Fq "\`$readme\`" "$TAKE_DETAIL_DESIGN" || {
      echo "[readme-template-test] SPEC_takeDetailDesign does not name required README SPEC doc: $readme" >&2
      missing=1
    }
  fi

  if [[ -f "$REPO_ROOT/$template" ]]; then
    grep -Fq '## Usage Example' "$REPO_ROOT/$template" || {
      echo "[readme-template-test] template missing Usage Example: $template" >&2
      missing=1
    }
  fi
done

for template in "${domain_templates[@]}"; do
  if [[ -f "$REPO_ROOT/$template" ]]; then
    grep -Fq 'Embedded software' "$REPO_ROOT/$template" || {
      echo "[readme-template-test] template missing Embedded software points: $template" >&2
      missing=1
    }
    grep -Fq 'digital video/audio' "$REPO_ROOT/$template" || {
      echo "[readme-template-test] template missing digital video/audio points: $template" >&2
      missing=1
    }
  fi
done

[[ "$missing" -eq 0 ]] || fail "missing SpecCoding README template files"

echo "[readme-template-test] PASSED: every SpecCoding README SPEC doc has a portable template"