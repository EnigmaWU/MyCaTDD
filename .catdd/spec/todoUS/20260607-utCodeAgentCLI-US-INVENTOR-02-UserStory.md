# User Story: utCodeAgentCLI INVENTOR US-INVENTOR-02 Produce machine-readable execution traces

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4INVENTOR.md` slice `US-INVENTOR-02`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4INVENTOR.md](../../codeAgents/utCodeAgentCLI/README_UserStory4INVENTOR.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-INVENTOR-02 [P0]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As an INVENTOR,
I want every CLI run to leave a structured trace,
so that I can audit method compliance, replay invocations, and detect drift between what was asked and what was done.

## Independent Test Intent

A reviewer can inspect a trace artifact and verify that it is present on success and failure, and that it is parseable by a standard machine parser.

## Acceptance Criteria

### AC-01: Trace is written on successful execution
- **Given** a valid CLI invocation completes successfully
- **When** the CLI exits
- **Then** a trace artifact exists in a discoverable location
- **And** the trace includes: timestamp, full invocation string, resolved arguments, resolved slash commands (with file paths), files modified, TC-IDs affected with before/after status, exit code, and duration

### AC-02: Trace is written on execution failure
- **Given** a valid CLI invocation fails during execution (not during argument parsing)
- **When** the CLI exits with code 1
- **Then** the trace artifact still exists
- **And** it records the failure point: which step was active, the error message, and which steps completed before the failure

### AC-03: Trace format is machine-parseable
- **Given** any trace artifact written by the CLI
- **When** parsed by a standard JSON or YAML parser
- **Then** it is valid and all fields follow a documented schema

## Scope

In scope:

- Success and failure trace emission.
- Parseable trace format.
- Compliance/audit support.

Out of scope:

- Human-only log formatting.
- UI presentation of trace results.
- Non-trace runtime behavior.

## Risks

- Undiscoverable traces reduce auditability.
- Unparseable traces defeat automation.
- Missing failure traces hide execution problems.

## Assumptions

- The CLI writes traces for both success and failure.
- Traces are stored in a discoverable location.
- JSON or YAML is acceptable for machine parsing.

## Acceptance Questions

- Where should traces live by default?
- Should trace schema be versioned?
- Should traces include redacted sensitive fields by default?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
