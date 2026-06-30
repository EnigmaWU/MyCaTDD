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

#### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-03 | 3 | ✅ Normal review |
| Edge | ValidFunc | AC-04 ~ AC-07 | 4 | ✅ Boundary states |
| Misuse | InvalidFunc | AC-08 ~ AC-11 | 4 | ❌ Behavior-specific |
| Fault | InvalidFunc | AC-12 ~ AC-14 | 3 | ❌ Read-time failure |

---

### Typical (ValidFunc) — Normal review

##### AC-01 [Func/Typical]: Per-TC review for all RED/GREEN TCs with summary
- **Given** TC-01 (RED), TC-02 (RED), TC-03 (PLANNED), TC-04 (RED)
- **When** `--behave reviewImplTestFile --target tests/auth_test.cpp`
- **Then** exit 0, per-TC review for TC-01, 02, 04; TC-03 skipped with note
- **And** summary: total RED, total GREEN, total PLANNED skipped, skeletons with issues

##### AC-02 [Func/Typical]: Reviews both RED and GREEN
- **Given** TC-01 (RED), TC-02 (GREEN), TC-03 (PLANNED)
- **When** reviewImplTestFile runs
- **Then** TC-01, TC-02 reviewed; TC-03 skipped; summary distinguishes RED vs GREEN

##### AC-03 [Func/Typical]: Review order follows file order
- **Given** TC-05 appears before TC-01 in file
- **When** review runs
- **Then** TC-05 reviewed before TC-01 (file-linear, not priority order)

### Edge (ValidFunc) — Boundary states

##### AC-04 [Func/Edge]: No implemented TCs (all PLANNED)
- **Given** every TC is PLANNED (DESIGNED state)
- **When** reviewImplTestFile runs
- **Then** exit 0, stdout: "0 implemented TCs found. All TCs are PLANNED."

##### AC-05 [Func/Edge]: FULLY_RED file — all TCs reviewed
- **Given** all TCs are RED
- **When** review runs
- **Then** exit 0, every TC reviewed, 0 skipped

##### AC-06 [Func/Edge]: ALL_GREEN file — all TCs reviewed
- **Given** all TCs are GREEN
- **When** review runs
- **Then** exit 0, every TC reviewed, summary all GREEN

##### AC-07 [Func/Edge]: No CaTDD skeletons at all (EMPTY)
- **Given** file has no CaTDD skeleton comments
- **When** reviewImplTestFile runs
- **Then** exit 0, stdout: "0 CaTDD skeleton TCs found."

### Misuse (InvalidFunc) — Behavior-specific

##### AC-08 [Func/Misuse]: No `@[US]` block — review proceeds with warning
- **Given** file has RED TCs but no `@[US]` section
- **When** reviewImplTestFile runs
- **Then** exit 0, stdout warns: no @[US] block, AC traceback skipped

##### AC-09 [Func/Misuse]: Duplicate TC-IDs
- **Given** two skeletons both tagged `@[TC-03]`
- **When** reviewImplTestFile runs
- **Then** exit 1, stderr: duplicate TC-ID at lines X and Y

##### AC-10 [Func/Misuse]: File has US/AC but zero TCs
- **Given** file has `@[US]` and `@[AC-*]` but no `@[TC-*]`
- **When** review runs
- **Then** exit 0, stdout: 0 TCs found, suggests design behavior

##### AC-11 [Func/Misuse]: CaTDD TCs mixed with non-CaTDD tests
- **Given** file has CaTDD TC-01 (RED), hand-written test, CaTDD TC-02 (RED)
- **When** review runs
- **Then** exit 0, CaTDD TCs reviewed, non-CaTDD ignored

### Fault (InvalidFunc) — Read-time failure

##### AC-12 [Func/Fault]: File modified mid-review
- **Given** file modified between reading TC-01 and TC-02
- **When** review detects change
- **Then** exit 1, stderr: file modified during review, re-run

##### AC-13 [Func/Fault]: File locked by another process
- **Given** file has exclusive lock
- **When** CLI opens
- **Then** exit 1, stderr: lock conflict

##### AC-14 [Func/Fault]: Binary content in TC body
- **Given** TC body contains binary data
- **When** review parses
- **Then** exit 1, stderr: binary content detected

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
