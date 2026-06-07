# User Story: utCodeAgentCLI DEVELOPER US-DEV-05 Execute ASR reliability and safety policy deterministically

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md` slice `US-DEV-05`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-DEV-05 [P1]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P1 - important.
- Confidence: medium-high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a DEVELOPER,
I want ASR-derived reliability and safety policies to be executable and verifiable at CLI runtime,
so that architecture contracts are enforced as final-delivery behavior instead of static documentation.

## Independent Test Intent

A reviewer can inspect runtime behavior and verify that each ASR-derived policy is enforced deterministically with traceable outcomes.

## Acceptance Criteria

### AC-01: Retry/correction budget exhaustion is deterministic (ASR-R1)
- **Given** a step keeps failing with retry-eligible transient errors
- **When** retry and correction budgets are exhausted
- **Then** the CLI stops retrying that step
- **And** the trace records budget exhaustion and escalation outcome

### AC-02: Unknown `--behave` uses diagnostics fallback with clear exit (ASR-R2)
- **Given** `--behave` is unknown or unsupported
- **When** behavior resolution runs
- **Then** the CLI does not silently coerce behavior
- **And** it prints supported behavior values and exits with argument-error code

### AC-03: Failure class routing is explicit and testable (ASR-R3)
- **Given** one transient failure and one permanent failure case
- **When** execution handles each case
- **Then** transient failure follows retry-eligible routing
- **And** permanent failure bypasses retry and fails fast with diagnostics

### AC-04: Step-scoped rollback or compensation boundary is enforced (ASR-R4)
- **Given** a multi-step run fails after at least one completed step
- **When** failure handling executes
- **Then** the CLI preserves the last consistent step boundary
- **And** it blocks further mutating steps and writes compensation-oriented failure trace details

### AC-05: Non-interactive escalation is deterministic and CI-safe (ASR-R5)
- **Given** non-interactive mode and policy escalation conditions are reached
- **When** control handling evaluates escalation
- **Then** the CLI force-aborts with non-zero exit
- **And** trace includes an explicit non-interactive escalation tag

### AC-06: Shell safety and sensitive-path protection are enforced (ASR-R6)
- **Given** command execution attempts include allowed and sensitive paths
- **When** execution and trace persistence run
- **Then** only allowlisted execution surfaces are used
- **And** sensitive paths are denied by default unless policy-approved
- **And** token-like secrets are redacted in persisted traces

## Scope

In scope:

- Runtime-enforced reliability/safety policies.
- Deterministic failure routing and trace recording.
- ASR-to-runtime enforcement.

Out of scope:

- Full policy engine rollout.
- Adapter implementation details.
- Architecture-only documentation without runtime effect.

## Risks

- Policy drift between architecture and runtime.
- Overly strict enforcement could break valid flows.
- Missing redaction or rollback behavior could expose unsafe state.

## Assumptions

- ASR-R1..R6 are authoritative policy inputs.
- Runtime traces can record policy outcomes.
- Non-interactive CI behavior must be deterministic.

## Acceptance Questions

- Should retry budgets be global or per-step?
- Which errors are retry-eligible by default?
- Should policy violations be surfaced as distinct exit codes?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
