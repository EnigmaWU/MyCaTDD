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

#### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | ✅ Normal selection |
| Edge | ValidFunc | AC-05 ~ AC-08 | 4 | ✅ Valid boundary |
| Misuse | InvalidFunc | AC-09 ~ AC-12 | 4 | ❌ Behavior-specific |
| Fault | InvalidFunc | AC-13 ~ AC-15 | 3 | ❌ Read-time failure |

---

### Typical (ValidFunc) — Normal selection

##### AC-01 [Func/Typical]: First PLANNED in CaTDD priority order
- **Given** TC-01 (Typical, PLANNED), TC-02 (Typical, PLANNED), TC-03 (Edge, PLANNED)
- **When** `--behave tellMeNextImplTest`
- **Then** exit 0, stdout: "TC-01 (Category: Typical)"
- **And** no file modified

##### AC-02 [Func/Typical]: Skips implemented TCs
- **Given** TC-01 (RED), TC-02 (PLANNED), TC-03 (PLANNED)
- **When** selection runs
- **Then** stdout selects TC-02

##### AC-03 [Func/Typical]: P0 category priority overrides file order
- **Given** TC-05 (Misuse, PLANNED) before TC-06 (Edge, PLANNED) in file
- **When** selection runs
- **Then** stdout selects TC-06 (Edge before Misuse per CaTDD priority)

##### AC-04 [Func/Typical]: P0 selected before P1
- **Given** P0-Misuse TC (PLANNED) and P1-State TC (PLANNED)
- **When** selection runs
- **Then** stdout selects the P0 TC

### Edge (ValidFunc) — Valid boundary

##### AC-05 [Func/Edge]: Only one PLANNED TC
- **Given** exactly one TC at PLANNED, all others GREEN
- **When** selection runs
- **Then** stdout outputs that single TC-ID

##### AC-06 [Func/Edge]: All TCs implemented — nothing to select
- **Given** every TC is RED or GREEN
- **When** selection runs
- **Then** exit 0, stdout: "All TCs are already implemented. Nothing to select."

##### AC-07 [Func/Edge]: Empty file (no CaTDD skeletons)
- **Given** file has no CaTDD comments
- **When** selection runs
- **Then** exit 0, stdout: "0 CaTDD skeleton TCs found. Use a design behavior first."

##### AC-08 [Func/Edge]: All TCs PLANNED but missing `@[Category]`
- **Given** all TCs PLANNED but no Category tags
- **When** selection runs
- **Then** exit 0, stdout: "No TCs with valid @[Category] tags. Falls back to file order."

### Misuse (InvalidFunc) — Behavior-specific

##### AC-09 [Func/Misuse]: No `@[Status]` tags on any TC
- **Given** file has TC skeletons but all missing `@[Status]`
- **When** selection runs
- **Then** exit 1, stderr: no TC has valid @[Status] tag

##### AC-10 [Func/Misuse]: Unrecognized status values on all TCs
- **Given** all TCs have `@[Status:PENDING]` or `@[Status:TODO]`
- **When** selection runs
- **Then** exit 1, stderr: no TCs with PLANNED status found

##### AC-11 [Func/Misuse]: Unrecognized `@[Category]` values
- **Given** TCs have `@[Category:Unknown]` not in CaTDD map
- **When** selection runs
- **Then** exit 0, stdout warns unrecognized categories deprioritized

##### AC-12 [Func/Misuse]: Selected TC missing `@[AC]` traceback
- **Given** all PLANNED TCs missing `@[AC]` references
- **When** selection runs
- **Then** exit 0, selects normally, stderr warns traceability incomplete

### Fault (InvalidFunc) — Read-time failure

##### AC-13 [Func/Fault]: File encoding prevents TC tag parsing
- **Given** file encoding prevents `@[TC-*]` matching
- **When** selection runs
- **Then** exit 1, stderr: encoding/parsing failure

##### AC-14 [Func/Fault]: File locked by another process
- **Given** file has exclusive lock
- **When** CLI reads
- **Then** exit 1, stderr: lock conflict

##### AC-15 [Func/Fault]: Target is a dangling symlink
- **Given** `--target` is a symlink to nonexistent target
- **When** CLI resolves and reads
- **Then** exit 1, stderr: dangling symlink

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
