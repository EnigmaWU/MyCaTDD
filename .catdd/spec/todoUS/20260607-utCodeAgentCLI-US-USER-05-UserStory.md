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

#### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-05 | 5 | ✅ Normal implementation |
| Edge | ValidFunc | AC-06 ~ AC-09 | 4 | ✅ Boundary cases |
| Misuse | InvalidFunc | AC-10 ~ AC-14 | 5 | ❌ Behavior-specific contract |
| Fault | InvalidFunc | AC-15 ~ AC-18 | 4 | ❌ Implement-time failure |

---

### Typical (ValidFunc) — Normal implementation

##### AC-01 [Func/Typical]: Skeleton TC becomes executable RED test
- **Given** TC-04 has `@[Status:PLANNED]`, `@[Category:Edge]`, valid `@[AC]`, `--inputFile` provides SUT context
- **When** `--behave implTestCase --target tests/auth_test.cpp::TC-04`
- **Then** exit 0, skeleton preserved, executable body added, PLANNED→RED, no other TC modified

##### AC-02 [Func/Typical]: Generated code references correct SUT
- **Given** `--inputFile src/AuthService.h` with `class AuthService { bool login(...); }`
- **When** implementation runs
- **Then** exit 0, test code references AuthService and tests login

##### AC-03 [Func/Typical]: Extra-prompt guides test structure
- **Given** `--extra-prompt "use AAA pattern with // Arrange, // Act, // Assert"`
- **When** implementation runs
- **Then** exit 0, generated code contains AAA markers

##### AC-04 [Func/Typical]: Implementation from inline `--input`
- **Given** `--input "int add(int a, int b);"`
- **When** implementation runs
- **Then** exit 0, test code tests the add function

##### AC-05 [Func/Typical]: Include/import for SUT is generated
- **Given** `--inputFile src/AuthService.h`
- **When** implementation runs
- **Then** generated code includes appropriate include/import for SUT

### Edge (ValidFunc) — Boundary cases

##### AC-06 [Func/Edge]: First TC implementation transitions DESIGNED→PARTIAL
- **Given** all-PLANNED file (DESIGNED) with TC-01 (PLANNED)
- **When** implTestCase targets TC-01
- **Then** exit 0, file state becomes PARTIAL

##### AC-07 [Func/Edge]: Last PLANNED TC transitions PARTIAL→FULLY_RED
- **Given** TC-02 (RED), TC-03 (PLANNED) — PARTIAL state
- **When** implTestCase targets TC-03
- **Then** exit 0, file state becomes FULLY_RED

##### AC-08 [Func/Edge]: TC at end of file does not corrupt boundary
- **Given** target TC is last in file
- **When** implementation runs
- **Then** exit 0, file ends cleanly after added test body

##### AC-09 [Func/Edge]: TC at start of file preserves header
- **Given** target TC is TC-01 (first in file)
- **When** implementation runs
- **Then** exit 0, file header and provenance preserved

### Misuse (InvalidFunc) — Behavior-specific contract

##### AC-10 [Func/Misuse]: TC already RED not overwritten
- **Given** TC-04 has `@[Status:RED]`
- **When** implTestCase targets TC-04
- **Then** exit 1, stderr: TC-04 already implemented, no file change

##### AC-11 [Func/Misuse]: TC already GREEN not overwritten
- **Given** TC-04 has `@[Status:GREEN]`
- **When** implTestCase targets TC-04
- **Then** exit 1, stderr: cannot return to RED via this behavior

##### AC-12 [Func/Misuse]: Missing `@[Category]` fails integrity check
- **Given** TC-04 skeleton has no `@[Category]`
- **When** pre-check runs
- **Then** exit 1, stderr: integrity check failed, missing @[Category]

##### AC-13 [Func/Misuse]: `@[Status]` not PLANNED fails integrity check
- **Given** TC-04 has `@[Status:DRAFT]`
- **When** pre-check runs
- **Then** exit 1, stderr: @[Status] is DRAFT, expected PLANNED

##### AC-14 [Func/Misuse]: `@[AC]` references non-existent AC
- **Given** TC-04 has `@[AC]: AC-99` but US section only defines AC-01..AC-03
- **When** pre-check runs
- **Then** exit 1, stderr: AC-99 not defined in @[US] section

### Fault (InvalidFunc) — Implementation-time failure

##### AC-15 [Func/Fault]: `--inputFile` has no testable interface
- **Given** input file has only comments and whitespace
- **When** implementation runs
- **Then** exit 1, stderr: no testable interface found

##### AC-16 [Func/Fault]: Target TC not found in file
- **Given** `--target tests/auth_test.cpp::TC-99` but file only has TC-01..TC-10
- **When** implementation runs
- **Then** exit 1, stderr: TC-99 not found

##### AC-17 [Func/Fault]: Target file not writable
- **Given** target file is read-only
- **When** implementation modifies
- **Then** exit 1, stderr: write permission error

##### AC-18 [Func/Fault]: Skeleton comment block malformed
- **Given** TC-04 skeleton comment boundaries broken (unclosed comment)
- **When** implementation parses skeleton
- **Then** exit 1, stderr: malformed skeleton structure for TC-04

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
