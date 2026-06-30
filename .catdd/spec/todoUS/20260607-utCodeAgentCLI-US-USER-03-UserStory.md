# User Story: utCodeAgentCLI USER US-USER-03 Review design skeletons (all tiers)

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` slice `US-USER-03`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-USER-03 [P0]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a USER,
I want the CLI to audit design skeletons across all CaTDD tiers (P0 Functional, P1 Design, P2 Quality) before I implement anything,
so that I catch coverage gaps and traceability breaks at every level, not just P0.

## Independent Test Intent

A reviewer can inspect a test file and verify that review output reports counts, missing tags, and state without modifying the file.

## Acceptance Criteria

#### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | ✅ Normal review |
| Edge | ValidFunc | AC-05 ~ AC-09 | 5 | ✅ Valid states |
| Misuse | InvalidFunc | AC-10 ~ AC-13 | 4 | ❌ Behavior-specific |
| Fault | InvalidFunc | AC-14 ~ AC-17 | 4 | ❌ Read-time failure |

---

### Typical (ValidFunc) — Normal review

##### AC-01 [Func/Typical]: P0 Functional review reports numeric status
- **Given** file has mixed-status P0 skeletons
- **When** `--behave reviewFuncTestsSkeleton`
- **Then** exit 0, stdout includes total TC count, per-category counts, per-status counts, missing-tag list
- **And** no file modified

##### AC-02 [Func/Typical]: P1 Design review reports State/Capability/Concurrency
- **Given** file has P1 design skeletons
- **When** `--behave reviewDesignTestsSkeleton`
- **Then** exit 0, stdout shows per-category and per-status counts

##### AC-03 [Func/Typical]: P2 Quality review reports Performance/Robust/Compat/Config
- **Given** file has P2 quality skeletons
- **When** `--behave reviewQualityTestsSkeleton`
- **Then** exit 0, stdout shows per-category and per-status counts

##### AC-04 [Func/Typical]: Review all tiers at once
- **Given** file has P0, P1, P2 skeletons
- **When** `--behave reviewAllSkeleton`
- **Then** exit 0, stdout reports all three tiers in labeled sections

### Edge (ValidFunc) — Valid states

##### AC-05 [Func/Edge]: Empty file reports 0 skeletons
- **Given** file has no CaTDD comments
- **When** review runs
- **Then** exit 0, stdout: "0 CaTDD skeleton TCs found"

##### AC-06 [Func/Edge]: All-PLANNED file reports DESIGNED state
- **Given** every TC is PLANNED
- **When** review runs
- **Then** exit 0, stdout shows all PLANNED, 0 RED, 0 GREEN, state DESIGNED

##### AC-07 [Func/Edge]: FULLY_RED file reports all RED
- **Given** every TC is RED
- **When** review runs
- **Then** exit 0, stdout reports FULLY_RED state

##### AC-08 [Func/Edge]: Review P0 on file with only P1/P2 skeletons
- **Given** file has only P1 and P2, no P0
- **When** `--behave reviewFuncTestsSkeleton`
- **Then** exit 0, stdout: "0 P0 TCs found. Contains P1/P2 — use reviewDesignTestsSkeleton or reviewQualityTestsSkeleton"

##### AC-09 [Func/Edge]: TC numbering has gaps but content valid
- **Given** file has TC-01, TC-03, TC-05 (gaps)
- **When** review runs
- **Then** exit 0, stdout lists gaps but counts present TCs

### Misuse (InvalidFunc) — Behavior-specific

##### AC-10 [Func/Misuse]: Corrupted `@[TC-*]` format
- **Given** file has malformed TC tags (missing bracket)
- **When** review runs
- **Then** exit 1, stderr: malformed TC tag at line N

##### AC-11 [Func/Misuse]: Duplicate TC-ID
- **Given** two skeletons tagged `@[TC-01]`
- **When** review runs
- **Then** exit 1, stderr: duplicate TC-ID at lines X and Y

##### AC-12 [Func/Misuse]: Unrecognized `@[Status]`
- **Given** a TC has `@[Status:DRAFT]`
- **When** review runs
- **Then** exit 0, stdout flags: unrecognized status value

##### AC-13 [Func/Misuse]: Target is not a test file
- **Given** `--target src/AuthService.cpp` (product source)
- **When** review runs
- **Then** exit 1, stderr: no CaTDD structure found

### Fault (InvalidFunc) — Read-time failure

##### AC-14 [Func/Fault]: File encoding not UTF-8
- **Given** file is UTF-16 or mixed encoding
- **When** review reads
- **Then** exit 1, stderr: encoding error

##### AC-15 [Func/Fault]: File locked by another process
- **Given** file has exclusive lock
- **When** CLI opens for reading
- **Then** exit 1, stderr: lock conflict

##### AC-16 [Func/Fault]: File exceeds review size limit
- **Given** file >100MB
- **When** review runs
- **Then** exit 1, stderr: file exceeds review limit

##### AC-17 [Func/Fault]: Binary content in file
- **Given** file contains binary sequences (null bytes)
- **When** review parses TC tags
- **Then** exit 1, stderr: binary content detected

## Scope

In scope:

- Tier-by-tier review output.
- Skeleton completeness and traceability reporting.
- Non-mutating review behavior.

Out of scope:

- File modification.
- Implementation or design generation.
- Behavior selection beyond review commands.

## Risks

- Missing counts reduce usefulness for review automation.
- Silent file changes would violate review expectations.
- Inconsistent reporting across tiers would obscure coverage gaps.

## Assumptions

- Review behaviors are read-only.
- P0/P1/P2 category groupings are stable.
- Missing skeletons are allowed and reported as empty, not as errors.

## Acceptance Questions

- Should review output be text-only or machine-parseable too?
- Should missing tag lists be grouped by TC-ID or by category?
- Should EMPTY files be reported identically across all review behaviors?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
