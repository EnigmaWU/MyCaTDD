# Test Case: cli_argument_validation.design.test

## Purpose
This test file verifies `US-USER-01` CLI argument-validation behavior for `utCodeAgentCLI`. It checks fail-fast diagnostics for missing required arguments, mutually exclusive argument conflicts, unsupported `--behave` values, and nonexistent file-path inputs, and also verifies a valid invocation success path.

## Status
Implemented, passing (GREEN in local node test run).

## Covered
- User Story: `US-USER-01`.
- Acceptance Criteria: `AC-01`, `AC-02`, `AC-03`, `AC-04`, `AC-05`.
- Test Cases:
  - `TC-ARG-001`..`TC-ARG-003` (Typical, required args)
  - `TC-ARG-004`..`TC-ARG-005` (Edge, behavior list and valid dispatch)
  - `TC-ARG-006`..`TC-ARG-007` (Misuse, exclusive pair conflicts)
  - `TC-ARG-008`..`TC-ARG-012` (Fault, missing path validations)
- Product code path under test:
  - `codeAgents/utCodeAgentCLI/src/cli/invocationValidator.ts`

## Manual
1. From repository root, run:
   `node --test codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts`
2. Confirm all 12 tests pass.
3. If failures occur, inspect:
   - argument parsing and required-flag checks
   - exclusive-pair checks (`--goalStory`/`--goalStoryFile`, `--input`/`--inputFile`)
   - `--behave` allowlist handling
   - file-path existence checks for `--inputFile`, `--goalStoryFile`, `--reference`, `--extra-prompt`, `--config-file`
