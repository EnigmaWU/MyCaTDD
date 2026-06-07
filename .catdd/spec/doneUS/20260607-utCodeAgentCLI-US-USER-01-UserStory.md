# User Story: utCodeAgentCLI USER US-USER-01 Parse and Validate CLI Arguments

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` slice `US-USER-01`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-USER-01 [P0]`

## Active Work Status

- Status: CLOSED.
- Active state: `.catdd/spec/doneUS/` completed artifact.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_analyzeIssue`.

## Story

As a USER,
I want the CLI to validate my invocation immediately,
so that I get clear, actionable feedback when my arguments are wrong instead of silent misbehavior.

## Independent Test Intent

A reviewer can inspect the CLI contract and verify that invalid invocations fail fast with clear stderr, valid invocations proceed, and every listed required argument or conflict case is handled deterministically.

## Acceptance Criteria

### AC-01: Missing required argument exits with error
- **Given** the CLI is invoked without `--goal`
- **When** argument parsing runs
- **Then** exit code is 1, stderr contains `"--goal"`, and stderr describes what `--goal` is for and why it is required
- **And** the same applies to `--target` and `--behave`

### AC-02: Mutually exclusive arguments are rejected
- **Given** the CLI is invoked with both `--goalStory "..."` and `--goalStoryFile "..."`, or both `--input "..."` and `--inputFile "..."`
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr names both conflicting arguments and states they cannot be used together

### AC-03: Unrecognized --behave value lists valid alternatives
- **Given** the CLI is invoked with `--behave "nonexistent"`
- **When** behavior resolution runs
- **Then** exit code is 1
- **And** stderr lists every valid `--behave` value

### AC-04: File-path arguments point to nonexistent files
- **Given** the CLI is invoked with `--inputFile`, `--goalStoryFile`, `--reference`, `--extra-prompt`, or `--config-file` pointing to a nonexistent path
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr names the missing path

### AC-05: Valid invocation proceeds without error
- **Given** all required arguments are present, mutually exclusive pairs are not violated, and file paths exist
- **When** argument parsing completes
- **Then** exit code is 0
- **And** execution proceeds to the behavior specified by `--behave`

## Scope

In scope:

- CLI argument validation behavior.
- Clear error messaging for missing, conflicting, or invalid arguments.
- Deterministic success path for valid invocations.

Out of scope:

- Test skeleton generation behavior.
- Execution of command behaviors beyond argument validation.
- Parser implementation details beyond the imported requirement slice.

## Risks

- Ambiguous error text can make automation brittle.
- Weak path validation can allow silent misbehavior.
- Incomplete `--behave` handling can leave invalid invocations unclear.

## Assumptions

- `utCodeAgentCLI` treats `--goal`, `--target`, and `--behave` as required for this invocation class.
- File existence checks are performed before behavior dispatch.
- The paired `README_UserGuide.md` explains invocation-plan patterns that should remain consistent with this story.

## Acceptance Questions

- Should error output be standardized across all behaviors or only argument parsing failures?
- Should the CLI stop at the first missing required argument or report all missing required arguments together?
- Should file validation distinguish missing files from unreadable files?

## Next Recommended Action

Run `/SPEC_analyzeIssue` on one pending issue to continue the next story cycle.

## Closure Summary

- Product code and tests committed in `3a98908`.
- CaTDD P0 Functional category trace corrected in `90268f7` so `TC-ARG-005` is Typical/ValidFunc, argument contract violations are Misuse/InvalidFunc, and missing path checks remain Fault/InvalidFunc.
- Verification summary: `node --test codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts` passed (12/12).
- Story artifacts moved from `doingUS` to `doneUS`.