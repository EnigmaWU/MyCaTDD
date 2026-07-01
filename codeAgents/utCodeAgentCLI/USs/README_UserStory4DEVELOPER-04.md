# US-DEV-04 [P0] — Runtime adapter interface (AgentSDK)

**As a** DEVELOPER, **I want** the CLI's capabilities exposed through a documented `CliRuntimeAdapter` interface, **so that** any code agent (Copilot-native, OpenCode, custom) can invoke CaTDD operations programmatically without forking a CLI process.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-05 | 5 | Adapter works correctly |
| Edge | ValidFunc | AC-06 ~ AC-09 | 4 | Valid boundary cases |
| Misuse | InvalidFunc | AC-10 ~ AC-13 | 4 | Adapter contract violations |
| Fault | InvalidFunc | AC-14 ~ AC-17 | 4 | Adapter runtime failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 5 | 0 | 0 | 0 | 0 | 0 | 5 |
| Edge | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Misuse | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Fault | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| **Total** | **17** | **0** | **0** | **0** | **0** | **0** | **17** |

---

## Typical (ValidFunc) — Adapter works correctly

### 【PENDING】AC-01 [Func/Typical]: Adapter conforms to defined interface
- **Given** a runtime adapter implementing `CliRuntimeAdapter` with `invoke(slashCommand, context)`
- **When** CLI needs to execute a slash command
- **Then** it calls `adapter.invoke(commandPath, { target, source, goal, references, config })`
- **And** the adapter receives all required context fields
- **And** the CLI does not assume any specific runtime language

### 【PENDING】AC-02 [Func/Typical]: Default adapter provided
- **Given** no custom adapter is configured
- **When** CLI runs any behavior
- **Then** built-in default adapter executes slash commands directly in-process
- **And** exit 0, results returned via adapter interface

### 【PENDING】AC-03 [Func/Typical]: Adapter returns structured result
- **Given** adapter's `invoke()` completes
- **When** the adapter returns
- **Then** result is `{ exitCode, stdout, stderr, filesModified[], affectedTCs[] }`
- **And** CLI uses result for trace and orchestration

### 【PENDING】AC-04 [Func/Typical]: Context preserves traceability
- **Given** invocation with `--goalStoryFile`, `--inputFile`, `--reference`, `--config-file`
- **When** adapter is called
- **Then** all resolved paths and inline values passed in context

### 【PENDING】AC-05 [Func/Typical]: Multi-command orchestration
- **Given** `--behave designAndImplTest` (two-phase)
- **When** CLI orchestrates via adapter
- **Then** adapter called for each phase, context updated between calls

---

## Edge (ValidFunc) — Valid boundary cases

### 【PENDING】AC-06 [Func/Edge]: Custom adapter via config
- **Given** `--config-file` specifies `adapter: "./myRuntimeAdapter.js"`
- **When** CLI loads config


## Misuse (InvalidFunc) — Adapter contract violations

### 【PENDING】AC-10 [Func/Misuse]: Adapter missing invoke method
- **Given** custom adapter lacks `invoke` method
- **When** CLI attempts to call it
- **Then** exit 1, stderr: adapter does not implement CliRuntimeAdapter
- **And** no slash commands executed

### 【PENDING】AC-11 [Func/Misuse]: Malformed result returned
- **Given** adapter returns `{ ok: true }` instead of structured result
- **When** CLI processes result
- **Then** exit 1, stderr: adapter result missing required fields
- **And** trace records the error

### 【PENDING】AC-12 [Func/Misuse]: Extra context fields ignored
- **Given** adapter adds non-standard fields to context
- **When** CLI passes context to adapter
- **Then** only standard fields present, extra fields on return ignored
- **And** adapter accepted if result contract is met

### 【PENDING】AC-13 [Func/Misuse]: Adapter throws unhandled exception
- **Given** adapter's `invoke()` throws uncaught error
- **When** CLI calls adapter
- **Then** exit 1, stderr: adapter threw: <error>
- **And** trace records exception with stack

---

## Fault (InvalidFunc) — Adapter runtime failure

### 【PENDING】AC-14 [Func/Fault]: Adapter module not found
- **Given** config specifies adapter path that does not exist
- **When** CLI loads adapter
- **Then** exit 1, stderr: adapter module not found at <path>
- **And** no fallback to default adapter

### 【PENDING】AC-15 [Func/Fault]: Adapter module has syntax error
- **Given** config points to file with load error
- **When** CLI requires the adapter
- **Then** exit 1, stderr: failed to load adapter — includes error line number

### 【PENDING】AC-16 [Func/Fault]: Adapter crashes mid-execution
- **Given** adapter crashes (segfault, process.exit) during invoke
- **When** CLI detects crash
- **Then** exit 1, stderr: adapter process terminated unexpectedly

### 【PENDING】AC-17 [Func/Fault]: Adapter exceeds memory limit
- **Given** adapter exceeds configured memory ceiling
- **When** CLI monitors resource usage
- **Then** exit 1, stderr: adapter exceeded memory limit
- **And** trace records memory exhaustion
- **Then** custom adapter used instead of default

### 【PENDING】AC-07 [Func/Edge]: Minimal config works
- **Given** custom adapter with only path, no extra settings
- **When** CLI loads and uses it
- **Then** adapter receives minimal valid context, no undefined errors

### 【PENDING】AC-08 [Func/Edge]: Concurrent invocations isolated
- **Given** two CLI invocations through same adapter simultaneously
- **When** both complete
- **Then** results are isolated, each correct

### 【PENDING】AC-09 [Func/Edge]: Adapter timeout handled
- **Given** adapter exceeds configured timeout
- **When** CLI waits for result
- **Then** exit 1, stderr: adapter timed out, no hang