# User Story: utCodeAgentCLI USER US-USER-04 Select next test case to implement

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` slice `US-USER-04`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-USER-04 [P0]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a USER,
I want the CLI to tell me exactly which TC to implement next,
so that I follow TDD discipline without manually scanning the file or guessing priority.

## Independent Test Intent

A reviewer can inspect the selection output and confirm that exactly one TC is selected in CaTDD priority order without file modification.

## Acceptance Criteria

### AC-01: Next TC is the first unimplemented P0 TC
- **Given** a test file with TC-01 (Typical, PLANNED), TC-02 (Typical, PLANNED), TC-03 (Edge, PLANNED)
- **When** the CLI runs with `--behave tellMeNextImplTest`
- **Then** stdout outputs exactly one TC-ID: `TC-01` (first PLANNED, CaTDD priority order: P0 before P1 before P2, within P0: Typical → Edge → Misuse → Fault)
- **And** stdout includes the TC's category
- **And** no file is modified

### AC-02: When some TCs are already implemented
- **Given** a test file with TC-01 (RED), TC-02 (PLANNED), TC-03 (PLANNED)
- **When** `tellMeNextImplTest` is invoked
- **Then** stdout selects `TC-02` (first non-implemented, following CaTDD priority order)
- **And** already-RED and GREEN TCs are skipped

### AC-03: When all TCs are implemented
- **Given** a test file where every TC has `@[Status:RED]` or `@[Status:GREEN]` (FULLY_RED or ALL_GREEN state)
- **When** `tellMeNextImplTest` is invoked
- **Then** stdout reports: "All TCs are already implemented. Nothing to select."
- **And** exit code is 0

## Scope

In scope:

- Next-TC selection by CaTDD priority.
- Read-only reporting.
- Correct handling of fully implemented files.

Out of scope:

- Modifying the target file.
- Implementing a TC.
- Review or design behaviors.

## Risks

- Wrong priority order would mislead TDD flow.
- Selecting more than one TC would create ambiguity.
- Treating implemented TCs as selectable would violate RED discipline.

## Assumptions

- PLANNED TCs are eligible for selection.
- P0 category order is Typical → Edge → Misuse → Fault.
- The command is read-only.

## Acceptance Questions

- Should the CLI print only one TC-ID or also the target file path?
- Should the command emit a reason when skipping RED/GREEN TCs?
- Should it behave differently for multi-file targets?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
