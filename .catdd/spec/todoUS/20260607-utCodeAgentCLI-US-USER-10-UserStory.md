# User Story: utCodeAgentCLI USER US-USER-10 Review all implemented test cases in a file

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` slice `US-USER-10`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-USER-10 [P0]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a USER,
I want the CLI to audit every implemented RED TC in a file in one invocation,
so that I can verify implementation quality across the entire file before writing product code.

## Independent Test Intent

A reviewer can inspect a file-level review output and verify that every implemented TC is reviewed, PLANNED TCs are skipped, and no file is modified.

## Acceptance Criteria

### AC-01: Every implemented TC is reviewed
- **Given** a test file containing multiple TCs with mixed statuses (PLANNED, RED, GREEN)
- **When** the CLI runs with `--behave reviewImplTestFile --target tests/auth_test.cpp`
- **Then** each RED/GREEN TC in the file is reviewed in turn
- **And** stdout reports per-TC findings for implemented cases only
- **And** PLANNED TCs are skipped with no review failure

### AC-02: Summary reports implemented and skipped counts
- **Given** a test file with a mix of implemented and PLANNED TCs
- **When** `reviewImplTestFile` completes
- **Then** stdout includes a summary of implemented TCs reviewed and PLANNED TCs skipped
- **And** no file is modified

### AC-03: Empty or unimplemented file is handled gracefully
- **Given** a test file where all TCs are PLANNED, or the file has no CaTDD skeletons
- **When** `reviewImplTestFile` runs
- **Then** stdout reports that no implemented TCs were available for review
- **And** exit code is 0

## Scope

In scope:

- File-level implemented-TC review.
- Mixed-status counting and skip behavior.
- Read-only operation.

Out of scope:

- Modifying TC status.
- Implementing tests.
- Skeleton design behavior.

## Risks

- Reviewing PLANNED TCs as if they were implemented would be misleading.
- Missing summary counts would reduce file-level audit value.
- File modifications during review would violate review expectations.

## Assumptions

- Implemented TCs are those with RED or GREEN status.
- PLANNED TCs are skipped, not failed.
- The command is read-only.

## Acceptance Questions

- Should the review order follow file order or CaTDD priority order?
- Should per-TC output be machine-parseable?
- Should empty files be reported the same as all-PLANNED files?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
