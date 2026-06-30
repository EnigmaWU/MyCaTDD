# US-DEV-02 [P1] — Configurable logging and diagnostic output

**As a** DEVELOPER, **I want** `--log-level` to control output verbosity, **so that** I can run quietly in production or verbosely when debugging.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-02 | 2 | Normal logging |
| Edge | ValidFunc | AC-03 ~ AC-04 | 2 | Logging boundary |
| Misuse | InvalidFunc | AC-05 | 1 | Logging misuse |
| Fault | InvalidFunc | AC-06 | 1 | Logging failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Edge | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Misuse | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| Fault | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| **Total** | **6** | **0** | **0** | **0** | **0** | **0** | **6** |

---

## Typical (ValidFunc) — Normal logging

### 【PENDING】AC-01 [Func/Typical]: `--log-level error` suppresses non-error output
- **Given** any valid invocation with `--log-level error`
- **When** CLI executes successfully
- **Then** only error-class messages appear in stderr
- **And** stdout is unaffected (behavior output still appears)

### 【PENDING】AC-02 [Func/Typical]: `--log-level debug` reveals internal resolution
- **Given** any valid invocation with `--log-level debug`
- **When** CLI executes
- **Then** stderr includes state transitions: argument parsing, behavior resolution, slash-command selection, file writes

---

## Edge (ValidFunc) — Logging boundary

### 【PENDING】AC-03 [Func/Edge]: `--log-level info` default — normal output
- **Given** invocation with `--log-level info`
- **When** CLI executes
- **Then** stderr shows info-level messages
- **And** no debug-level messages appear

### 【PENDING】AC-04 [Func/Edge]: `--log-level warn` — only warnings and errors
- **Given** invocation with `--log-level warn`
- **When** CLI executes
- **Then** stderr shows only warn and error messages
- **And** info-level messages suppressed

---

## Misuse (InvalidFunc) — Logging misuse

### 【PENDING】AC-05 [Func/Misuse]: Unrecognized `--log-level` value
- **Given** `--log-level "verbose"`
- **When** validation runs
- **Then** exit 1, stderr lists valid values: error, warn, info, debug

---

## Fault (InvalidFunc) — Logging failure

### 【PENDING】AC-06 [Func/Fault]: Log file specified is not writable
- **Given** `--log-file /read-only/log.txt`
- **When** CLI opens log file
- **Then** warns, continues with stderr-only output