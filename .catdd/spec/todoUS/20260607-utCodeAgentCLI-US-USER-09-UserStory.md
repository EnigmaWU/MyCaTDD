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

#### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | ✅ Normal review |
| Edge | ValidFunc | AC-05 ~ AC-08 | 4 | ✅ Boundary states |
| Misuse | InvalidFunc | AC-09 ~ AC-12 | 4 | ❌ Behavior-specific |
| Fault | InvalidFunc | AC-13 ~ AC-15 | 3 | ❌ Read-time failure |

---

### Typical (ValidFunc) — Normal review

##### AC-01 [Func/Typical]: Review reports implementation quality for RED TC
- **Given** TC-04 has `@[Status:RED]` with executable test code and preserved skeleton
- **When** `--behave reviewImplTestCase --target tests/auth_test.cpp::TC-04`
- **Then** exit 0, stdout includes: RED confirmed, skeleton preserved, code structure assessment, AC coverage deviation flagged
- **And** no file modified

##### AC-02 [Func/Typical]: Review reports for GREEN TC
- **Given** TC-04 has `@[Status:GREEN]`
- **When** reviewImplTestCase targets TC-04
- **Then** exit 0, stdout confirms GREEN and traceability

##### AC-03 [Func/Typical]: Reviews full skeleton tag completeness
- **Given** TC-04 has all tags: `@[US]`, `@[AC]`, `@[TC]`, `@[Category]`, `@[Status]`, `@[Priority]`
- **When** review runs
- **Then** stdout lists each tag with presence check (✓ / ✗)

##### AC-04 [Func/Typical]: Detects content drift — implementation tests less than AC scope
- **Given** TC-04 covers AC-03 (3 sub-conditions), implementation tests 2 of 3
- **When** review runs
- **Then** stdout: "AC-03 coverage: 2/3 conditions tested. Missing: <description>"

### Edge (ValidFunc) — Boundary states

##### AC-05 [Func/Edge]: Review on PLANNED TC reports not-yet-implemented
- **Given** TC-04 has `@[Status:PLANNED]`
- **When** reviewImplTestCase targets TC-04
- **Then** exit 0, stdout: "TC-04 is not yet implemented (Status: PLANNED). Use a design review behavior first."

##### AC-06 [Func/Edge]: TC has code but no skeleton
- **Given** TC-04 has test function but no `@[TC-04]` skeleton comment
- **When** review runs
- **Then** exit 0, stdout: "TC-04 has no CaTDD skeleton. Cannot verify traceability."

##### AC-07 [Func/Edge]: RED tag but no function body
- **Given** TC-04 has `@[Status:RED]` but only skeleton — no executable code
- **When** review runs
- **Then** exit 0, stdout flags: "TC-04 marked RED but has no test body. Skeleton may have been manually edited."

##### AC-08 [Func/Edge]: Developer-added comments alongside CaTDD tags
- **Given** TC-04 has `// TODO: add edge case` alongside CaTDD tags
- **When** review runs
- **Then** exit 0, CaTDD tags verified, developer annotations noted

### Misuse (InvalidFunc) — Behavior-specific

##### AC-09 [Func/Misuse]: TC skeleton tag value mismatches selector
- **Given** `--target tests/auth_test.cpp::TC-04` but skeleton at that position has `@[TC-05]`
- **When** review runs
- **Then** exit 1, stderr: selector TC-04 does not match skeleton tag TC-05

##### AC-10 [Func/Misuse]: RED TC missing `@[Category]`
- **Given** TC-04 has RED status and code but no `@[Category]` tag
- **When** review runs
- **Then** exit 0, stdout flags missing Category but reviews other tags

##### AC-11 [Func/Misuse]: Duplicate `@[Status]` tags
- **Given** TC-04 has both `@[Status:RED]` and `@[Status:PLANNED]`
- **When** review runs
- **Then** exit 1, stderr: TC-04 has duplicate @[Status] tags

##### AC-12 [Func/Misuse]: No `@[US]` section in file
- **Given** file has TC skeletons but no `@[US]` block
- **When** reviewImplTestCase runs
- **Then** exit 0, stdout: "No @[US] block found. AC traceback cannot be verified."

### Fault (InvalidFunc) — Read-time failure

##### AC-13 [Func/Fault]: Target TC not found in file
- **Given** `--target tests/auth_test.cpp::TC-99` but file only has TC-01..TC-10
- **When** review runs
- **Then** exit 1, stderr: TC-99 not found

##### AC-14 [Func/Fault]: File encoding prevents TC block parsing
- **Given** file encoding prevents reliable TC extraction
- **When** review runs
- **Then** exit 1, stderr: encoding error

##### AC-15 [Func/Fault]: TC comment block suspiciously large (>1000 lines)
- **Given** target TC comment block >1000 lines
- **When** review parses
- **Then** exit 1, stderr: comment block exceeds max skeleton size, possible corruption

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
