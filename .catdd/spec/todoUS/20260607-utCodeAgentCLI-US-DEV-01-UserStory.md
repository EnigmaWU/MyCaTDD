# User Story: utCodeAgentCLI DEVELOPER US-DEV-01 Actionable error messages for all failure states

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md` slice `US-DEV-01`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-DEV-01 [P0]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a DEVELOPER,
I want every error message to name the problem, identify the affected argument, and suggest the correction,
so that I can debug invocation issues without reading CLI source code.

## Independent Test Intent

A reviewer can inspect failure output and verify that the message names the problem, affected argument, and a correction suggestion for each supported failure mode.

## Acceptance Criteria

### AC-01: Unrecognized argument value suggests a correction
- **Given** the CLI is invoked with `--behave "deisgnAllSkeleton"` (typo)
- **When** validation fails
- **Then** stderr includes the string `"deisgnAllSkeleton" is not recognized`
- **And** stderr includes a suggestion: `"Did you mean 'designAllSkeleton'?"` (best match)
- **And** stderr includes the full list of valid values

### AC-02: Missing file error includes the exact path
- **Given** `--inputFile nonexistent/path.h`
- **When** validation fails
- **Then** stderr includes the full resolved path `nonexistent/path.h`
- **And** stderr states the argument name (`--inputFile`)

### AC-03: Target/behavior mismatch explains why and suggests alternatives
- **Given** `--target tests/auth_test.cpp::TC-03 --behave designAllSkeleton`
- **When** validation detects the mismatch
- **Then** stderr explains: skeleton design requires a file-level `--target`, not a TC-level target
- **And** stderr suggests valid `--target` forms for skeleton design or valid `--behave` values for TC-level targets

## Scope

In scope:

- Developer-facing diagnostics.
- Argument-specific corrections.
- Actionable suggestions for invalid invocations.

Out of scope:

- Logging verbosity controls.
- Interactive confirmations.
- Adapter interface design.

## Risks

- Vague errors slow down debugging.
- Missing argument names make automation brittle.
- No suggestions force source-code inspection.

## Assumptions

- Stderr is the primary failure channel.
- Suggestions are deterministic enough to test.
- Error wording can be asserted by tests.

## Acceptance Questions

- Should suggestions prioritize best match or list all alternatives first?
- Should argument names appear in every failure message?
- Should validation errors share a common prefix or format?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
