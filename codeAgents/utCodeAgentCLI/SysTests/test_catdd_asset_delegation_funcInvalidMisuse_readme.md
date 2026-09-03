# Test Case: catdd_asset_delegation_funcInvalidMisuse

## Purpose

Plan rejected caller/configured-topology tests for method-prompt or slash-command paths that escape their configured roots.

## Status

PLANNED / design-only. Two CaTDD TC skeletons exist; no executable test bodies are implemented.

## Covered

- SUT: `utCodeAgentCLI` CaTDD asset-delegation module interface.
- Category: P0 Functional / InvalidFunc / Misuse.
- Story: US-INVENTOR-01.
- Acceptance criteria: AC-11 through AC-12.
- Test cases: TC-DELEGATE-011 through TC-DELEGATE-012.
- Source: `README_UserStory4INVENTOR-01.md`, `README_ArchDesign.md`, and relevant ADRs.

## Manual

Run from the repository root:

```bash
FILE=codeAgents/utCodeAgentCLI/SysTests/test_catdd_asset_delegation_funcInvalidMisuse.ts
test "$(rg -c '@\[Status:PLANNED\]' "$FILE")" -eq 2
if rg -n '(^|[^/])\b(test|it|describe)\s*\(' "$FILE"; then exit 1; fi
```

Expected result: no output and exit code 0.
