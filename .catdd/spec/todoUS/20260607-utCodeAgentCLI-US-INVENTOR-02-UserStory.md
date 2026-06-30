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

#### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | ✅ Trace emitted |
| Edge | ValidFunc | AC-05 ~ AC-09 | 5 | ✅ Trace variations |
| Misuse | InvalidFunc | AC-10 ~ AC-13 | 4 | ❌ Trace config |
| Fault | InvalidFunc | AC-14 ~ AC-17 | 4 | ❌ Storage failure |

---

### Typical (ValidFunc) — Normal trace emission

##### AC-01 [Func/Typical]: Trace on success with complete metadata
- **Given** valid invocation exits 0
- **When** CLI exits
- **Then** trace at `.catdd/traces/trace-<ts>.json`, includes timestamp, argv, resolved args, command paths, files modified, TC-IDs with before/after status, exit code, duration, valid JSON

##### AC-02 [Func/Typical]: Trace on execution failure
- **Given** valid invocation fails during execution (exit 1)
- **When** CLI exits
- **Then** trace exists, records active step, error message, error classification, completed steps

##### AC-03 [Func/Typical]: Valid JSON with documented schema
- **Given** any trace artifact
- **When** parsed by `JSON.parse()`
- **Then** valid JSON, top-level keys match schema

##### AC-04 [Func/Typical]: Trace with `--diagSlashCommands` includes command paths
- **Given** valid invocation with `--diagSlashCommands`
- **When** trace written
- **Then** resolution field includes each command's file path and resolution method

### Edge (ValidFunc) — Trace variations

##### AC-05 [Func/Edge]: Minimal args — optional fields absent
- **Given** only `--goal`, `--target`, `--behave`
- **When** trace written
- **Then** optional fields absent from JSON, trace valid

##### AC-06 [Func/Edge]: All optional args populated
- **Given** all optional arguments provided
- **When** trace written
- **Then** all fields populated, arrays correct

##### AC-07 [Func/Edge]: Concurrent invocations produce distinct files
- **Given** two invocations within same second
- **When** traces written
- **Then** unique filenames, no interleaving

##### AC-08 [Func/Edge]: Read-only behavior — empty arrays
- **Given** `--behave reviewFuncTestsSkeleton` completes
- **When** trace written
- **Then** `filesModified: []`, `affectedTCs: []`

##### AC-09 [Func/Edge]: No trace for argument-parsing failures
- **Given** invocation fails during US-USER-01 arg validation
- **When** CLI exits
- **Then** no trace artifact created

### Misuse (InvalidFunc) — Trace config

##### AC-10 [Func/Misuse]: `--trace-dir` is a file, not directory
- **Given** `--trace-dir` points to existing file
- **When** CLI writes trace
- **Then** exit 1, stderr: path is a file, expected directory

##### AC-11 [Func/Misuse]: `--trace-format` unrecognized
- **Given** `--trace-format xml`
- **When** validation runs
- **Then** exit 1, stderr lists supported: json, yaml

##### AC-12 [Func/Misuse]: `--no-trace` suppresses trace
- **Given** `--no-trace` and valid invocation
- **When** CLI executes
- **Then** exit 0, no trace file created

##### AC-13 [Func/Misuse]: Trace file locked — unique name
- **Given** target trace file locked
- **When** CLI writes trace
- **Then** unique filename generated, exit 0

### Fault (InvalidFunc) — Storage failure

##### AC-14 [Func/Fault]: Trace directory cannot be created
- **Given** parent not writable
- **When** CLI creates directory
- **Then** exit 1, stderr: permission error

##### AC-15 [Func/Fault]: Trace directory read-only
- **Given** trace directory is read-only
- **When** CLI writes file
- **Then** exit 1, stderr: permission error

##### AC-16 [Func/Fault]: Non-serializable data fallback
- **Given** context has non-serializable data
- **When** trace serialization runs
- **Then** field replaced with `[unserializable]`, trace still valid JSON

##### AC-17 [Func/Fault]: Trace write interrupted
- **Given** write stream interrupted mid-write
- **When** CLI handles interruption
- **Then** partial file removed, stderr warns

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
