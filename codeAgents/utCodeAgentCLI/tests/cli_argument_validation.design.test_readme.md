# Test Case: US-USER-01 CaTDD Functional UnitTesting

## Purpose
These test files verify `US-USER-01` CLI argument-validation behavior for `utCodeAgentCLI` using CaTDD category-specific UnitTesting files.

## Status
Implemented, passing (GREEN in local node test run).

## Covered
- User Story: `US-USER-01`.
- Acceptance Criteria: `AC-01`, `AC-02`, `AC-03`, `AC-04`, `AC-05`.
- Test Cases:
  - `UT_US-USER-01-Typical.ts`: `TC-ARG-005` (Typical / ValidFunc, valid dispatch)
  - `UT_US-USER-01-Edge.ts`: no executable TC; Edge is a traceable non-required category decision for this story
  - `UT_US-USER-01-Misuse.ts`: `TC-ARG-001`..`TC-ARG-004`, `TC-ARG-006`..`TC-ARG-007` (Misuse / InvalidFunc, caller contract violations)
  - `UT_US-USER-01-Fault.ts`: `TC-ARG-008`..`TC-ARG-012` (Fault / InvalidFunc, missing path validations)
- SUT boundary under test:
  - `codeAgents/utCodeAgentCLI/src/cli/main.ts` executed as a subprocess
- Delegated product code path under test:
  - `codeAgents/utCodeAgentCLI/src/cli/invocationValidator.ts`

## Manual
1. From repository root, run:
  `node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`
2. Confirm all 13 tests pass.
3. If failures occur, inspect:
  - subprocess invocation through `codeAgents/utCodeAgentCLI/src/cli/main.ts`
   - argument parsing and required-flag checks
   - exclusive-pair checks (`--goalStory`/`--goalStoryFile`, `--input`/`--inputFile`)
   - `--behave` allowlist handling
   - file-path existence checks for `--inputFile`, `--goalStoryFile`, `--reference`, `--extra-prompt`, `--config-file`
