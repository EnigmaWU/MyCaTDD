# User Story: utCodeAgentCLI USER US-USER-09 Review implemented test case

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` slice `US-USER-09`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-USER-09 [P0]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a USER,
I want the CLI to audit an implemented RED test case before I write product code,
so that I verify the test is correct, follows its skeleton, and preserves CaTDD traceability before the GREEN phase.

## Independent Test Intent

A reviewer can inspect a selected implemented TC and verify that status, skeleton traceability, and implementation quality are reported without modifying the file.

## Acceptance Criteria

### AC-01: Review reports implementation quality
- **Given** a test file where TC-04 has `@[Status:RED]` with executable test code and preserved skeleton comments
- **When** the CLI runs with `--behave reviewImplTestCase --target tests/auth_test.cpp::TC-04`
- **Then** stdout includes: whether `@[Status:RED]` is correctly set, whether the skeleton comments are preserved intact, whether the test code follows CaTDD structure, any deviation from the skeleton's AC coverage
- **And** no file is modified

### AC-02: Review on PLANNED TC reports not-yet-implemented
- **Given** TC-04 has `@[Status:PLANNED]` (not yet implemented)
- **When** `reviewImplTestCase` targets TC-04
- **Then** stdout reports: "TC-04 is not yet implemented (Status: PLANNED). Use a design review behavior first."
- **And** exit code is 0 (not an error)

### AC-03: Target selector does not resolve to a single TC
- **Given** `--target tests/auth_test.cpp` (a whole file, not a specific TC)
- **When** `--behave reviewImplTestCase` is invoked
- **Then** exit code is 1
- **And** stderr reports the `--target` / `--behave` mismatch and suggests valid combinations

## Scope

In scope:

- Read-only quality review of one implemented TC.
- Skeleton preservation and coverage reporting.
- Handling of not-yet-implemented targets.

Out of scope:

- File modification.
- Implementation or design generation.
- Whole-file review behavior.

## Risks

- Misreporting RED status would confuse downstream product-code work.
- A mutating review would violate the review contract.
- Incomplete traceability reporting weakens review usefulness.

## Assumptions

- The command is read-only.
- A specific `tests/file.cpp::TC-xx` target is required.
- PLANNED targets are allowed and reported as not yet implemented.

## Acceptance Questions

- Should the review produce a structured checklist or only prose?
- Should it attempt code-style checks or only CaTDD structural checks?
- Should the command support batch review of multiple RED TCs?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
