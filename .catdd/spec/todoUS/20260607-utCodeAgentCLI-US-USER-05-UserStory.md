# User Story: utCodeAgentCLI USER US-USER-05 Implement one executable test case (RED)

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` slice `US-USER-05`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-USER-05 [P0]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a USER,
I want the CLI to turn one skeleton TC into compilable test code,
so that I enter the RED phase of TDD with executable tests, not just comments.

## Independent Test Intent

A reviewer can inspect one selected TC and verify that it remains traceable, changes from PLANNED to RED, and gains executable test code without touching other TCs.

## Acceptance Criteria

### AC-01: Skeleton TC becomes executable RED test
- **Given** a test file where TC-04 has a `@[TC-04]` skeleton comment with `@[Status:PLANNED]`, `@[Category:Edge]`, and valid `@[AC]` traceback, and a source file provides implementation context (`--inputFile`)
- **When** the CLI runs with `--behave implTestCase --target tests/auth_test.cpp::TC-04`
- **Then** TC-04's comment skeleton is preserved (all `@[US]`, `@[AC]`, `@[TC]`, `@[Category]` tags remain)
- **And** an executable test function body is added below the TC-04 skeleton comment
- **And** `@[Status:PLANNED]` is replaced with `@[Status:RED]`
- **And** no other TC in the file is modified
- **And** the file state transitions: DESIGNED → PARTIAL, or PARTIAL → PARTIAL/FULLY_RED

### AC-02: TC already implemented is not overwritten
- **Given** TC-04 already has `@[Status:RED]` or `@[Status:GREEN]`
- **When** `implTestCase` targets TC-04 again
- **Then** exit code is 1
- **And** stderr reports: "TC-04 is already implemented. Use a review behavior or re-design the skeleton first."
- **And** the file is not modified (no state downgrade)

### AC-03: Target selector does not resolve to a single TC
- **Given** `--target tests/auth_test.cpp` (a whole file, not a specific TC)
- **When** `--behave implTestCase` is invoked
- **Then** exit code is 1
- **And** stderr reports the `--target` / `--behave` mismatch and suggests valid combinations

### AC-04: Skeleton fails integrity check before implementation
- **Given** TC-04 has a `@[TC-04]` skeleton comment but is missing `@[Category]`, or has an unrecognized `@[Status]` value (not PLANNED/RED/GREEN)
- **When** `implTestCase` targets TC-04
- **Then** the CLI performs a skeleton integrity pre-check
- **And** exit code is 1
- **And** stderr reports: "TC-04 skeleton integrity check failed: missing @[Category]" (with specifics)
- **And** the file is not modified

## Scope

In scope:

- One-TC implementation behavior.
- Preservation of skeleton traceability.
- Integrity checks before code generation.

Out of scope:

- Whole-file implementation.
- Review behaviors.
- Any non-target TC modification.

## Risks

- Overwriting RED/GREEN TCs would break TDD state discipline.
- Missing integrity checks could generate broken test code.
- Loose target selection could affect the wrong TC.

## Assumptions

- A specific `tests/file.cpp::TC-xx` target is required.
- PLANNED is the only eligible status for implementation.
- The command preserves trace comments while adding executable code.

## Acceptance Questions

- Should implementation preserve formatting/style of existing test code?
- Should the CLI support multiple TC selectors in one run for this behavior?
- Should integrity failures report all missing tags or fail fast on the first one?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
