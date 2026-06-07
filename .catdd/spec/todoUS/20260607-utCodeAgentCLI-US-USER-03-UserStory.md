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

### AC-01: P0 Functional review reports numeric skeleton status
- **Given** a test file containing CaTDD skeleton TCs — some PLANNED, some RED, some GREEN, some with missing categories (DESIGNED, PARTIAL, or FULLY_RED state)
- **When** the CLI runs with `--behave reviewFuncTestsSkeleton` targeting that file
- **Then** stdout includes: total TC count, count per P0 category (Typical, Edge, Misuse, Fault), count per status (PLANNED, RED, GREEN), list of TC-IDs missing `@[Category]` or `@[Status]` tags
- **And** no file is modified

### AC-02: Review on a file without skeletons reports empty
- **Given** a test file with no CaTDD skeleton comments (EMPTY state)
- **When** review is invoked
- **Then** stdout reports: "0 CaTDD skeleton TCs found"
- **And** exit code is 0 (not an error — the file is valid, just empty)

### AC-03: P1 Design review reports State/Capability/Concurrency status
- **Given** a test file containing P1 design skeleton TCs (State, Capability, Concurrency categories)
- **When** the CLI runs with `--behave reviewDesignTestsSkeleton`
- **Then** stdout includes count per P1 category and per status
- **And** no file is modified

### AC-04: P2 Quality review reports Performance/Robust/Compatibility/Configuration status
- **Given** a test file containing P2 quality skeleton TCs (Performance, Robust, Compatibility, Configuration categories)
- **When** the CLI runs with `--behave reviewQualityTestsSkeleton`
- **Then** stdout includes count per P2 category and per status
- **And** no file is modified

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
