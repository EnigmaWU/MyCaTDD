# US-INVENTOR-02 [P0] — Produce machine-readable execution traces

**As an** INVENTOR, **I want** every CLI run to leave a structured trace, **so that** I can audit method compliance, replay invocations, and detect drift.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | Trace emitted |
| Edge | ValidFunc | AC-05 ~ AC-09 | 5 | Trace variations |
| Misuse | InvalidFunc | AC-10 ~ AC-13 | 4 | Trace config |
| Fault | InvalidFunc | AC-14 ~ AC-17 | 4 | Storage failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Edge | 5 | 0 | 0 | 0 | 0 | 0 | 5 |
| Misuse | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Fault | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| **Total** | **17** | **0** | **0** | **0** | **0** | **0** | **17** |

---

## Typical (ValidFunc) — Normal trace emission

### 【PENDING】AC-01 [Func/Typical]: Trace on success with complete metadata
- **Given** valid invocation exits 0
- **When** CLI exits
- **Then** trace at `.catdd/traces/trace-<ts>.json`, includes timestamp, argv, resolved args, command paths, files modified, TC-IDs, exit code, duration

### 【PENDING】AC-02 [Func/Typical]: Trace on execution failure
- **Given** valid invocation fails during execution (exit 1)
- **When** CLI exits
- **Then** trace exists, records active step, error, classification, completed steps

### 【PENDING】AC-03 [Func/Typical]: Valid JSON with documented schema
- **Given** any trace artifact
- **When** parsed by `JSON.parse()`
- **Then** valid JSON, keys match documented schema

### 【PENDING】AC-04 [Func/Typical]: Trace with `--diagSlashCommands` includes paths
- **Given** valid invocation with `--diagSlashCommands`
- **When** trace written
- **Then** resolution field includes command paths

---

## Edge (ValidFunc) — Trace variations

### 【PENDING】AC-05 [Func/Edge]: Minimal args — optional fields absent
- **Given** only `--goal`, `--target`, `--behave`
- **When** trace written
- **Then** optional fields absent from JSON

### 【PENDING】AC-06 [Func/Edge]: All optional args populated
- **Given** all optional arguments provided
- **When** trace written
- **Then** all fields populated, arrays correct

### 【PENDING】AC-07 [Func/Edge]: Concurrent invocations distinct files
- **Given** two invocations same second
- **When** traces written
- **Then** unique filenames, no interleaving

### 【PENDING】AC-08 [Func/Edge]: Read-only behavior — empty arrays
- **Given** `--behave reviewFuncTestsSkeleton` completes
- **When** trace written
- **Then** `filesModified: []`, `affectedTCs: []`

### 【PENDING】AC-09 [Func/Edge]: No trace for arg-parsing failures
- **Given** invocation fails during arg validation
- **When** CLI exits
- **Then** no trace created

---

## Misuse (InvalidFunc) — Trace config

### 【PENDING】AC-10 [Func/Misuse]: `--trace-dir` is a file
- **Given** `--trace-dir` points to existing file
- **When** CLI writes trace
- **Then** exit 1, stderr: path is a file

### 【PENDING】AC-11 [Func/Misuse]: `--trace-format` unrecognized
- **Given** `--trace-format xml`
- **When** validation runs
- **Then** exit 1, stderr: supported json, yaml

### 【PENDING】AC-12 [Func/Misuse]: `--no-trace` suppresses
- **Given** `--no-trace` and valid invocation
- **When** CLI executes
- **Then** exit 0, no trace file

### 【PENDING】AC-13 [Func/Misuse]: Trace file locked — unique name
- **Given** target trace file locked
- **When** CLI writes
- **Then** unique filename, exit 0

---

## Fault (InvalidFunc) — Storage failure

### 【PENDING】AC-14 [Func/Fault]: Trace directory not creatable
- **Given** parent not writable
- **When** CLI creates directory
- **Then** exit 1, stderr: permission error

### 【PENDING】AC-15 [Func/Fault]: Trace directory read-only
- **Given** trace directory read-only
- **When** CLI writes file
- **Then** exit 1, stderr: permission error

### 【PENDING】AC-16 [Func/Fault]: Non-serializable data fallback
- **Given** context has non-serializable data
- **When** trace serialization runs
- **Then** field replaced with `[unserializable]`

### 【PENDING】AC-17 [Func/Fault]: Trace write interrupted
- **Given** write stream interrupted mid-write
- **When** CLI handles interruption
- **Then** partial file removed, stderr warns