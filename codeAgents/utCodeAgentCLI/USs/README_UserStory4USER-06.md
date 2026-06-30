# US-USER-06 [P1] — Implement all test cases in a file

**As a** USER, **I want** the CLI to implement every PLANNED TC in a file in one invocation, following CaTDD priority order, **so that** I don't invoke `implTestCase` once per TC.

Paired review: US-USER-10 (review all implemented test cases).

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-03 | 3 | Normal batch impl |
| Edge | ValidFunc | AC-04 ~ AC-05 | 2 | Boundary states |
| Misuse | InvalidFunc | AC-06 ~ AC-07 | 2 | Behavior-specific |
| Fault | InvalidFunc | AC-08 ~ AC-09 | 2 | Execution failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| Edge | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Misuse | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Fault | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| **Total** | **9** | **0** | **0** | **0** | **0** | **0** | **9** |

---

## Typical (ValidFunc) — Normal batch implementation

### 【PENDING】AC-01 [Func/Typical]: All PLANNED TCs become RED in priority order
- **Given** TC-01 (Edge, PLANNED), TC-02 (Typical, PLANNED), TC-03 (Misuse, PLANNED)
- **When** `--behave implTestFile --target tests/auth_test.cpp`
- **Then** TC-02 → TC-01 → TC-03 (CaTDD priority order)
- **And** all transition PLANNED→RED, skeleton preserved

### 【PENDING】AC-02 [Func/Typical]: Already-implemented TCs skipped
- **Given** TC-01 (RED), TC-02 (PLANNED), TC-03 (PLANNED)
- **When** `implTestFile` runs
- **Then** TC-01 skipped, TC-02 → TC-03 implemented
- **And** summary: 2 implemented, 1 skipped

### 【PENDING】AC-03 [Func/Typical]: Priority order: P0 before P1 before P2
- **Given** P0-Misuse (PLANNED) and P1-State (PLANNED)
- **When** `implTestFile` runs
- **Then** P0 TC implemented before P1 TC

---

## Edge (ValidFunc) — Boundary states

### 【PENDING】AC-04 [Func/Edge]: File is FULLY_RED — nothing to implement
- **Given** all TCs are RED
- **When** `implTestFile` runs
- **Then** exit 0, stdout: 0 implemented, all already done

### 【PENDING】AC-05 [Func/Edge]: File is ALL_GREEN — nothing to implement
- **Given** all TCs are GREEN
- **When** `implTestFile` runs
- **Then** exit 0, stdout: 0 implemented, all GREEN

---

## Misuse (InvalidFunc) — Behavior-specific

### 【PENDING】AC-06 [Func/Misuse]: One TC fails integrity mid-run — continues with next
- **Given** TC-02 fails integrity pre-check
- **When** `implTestFile` processes TC-02
- **Then** TC-02 left PLANNED, continues to TC-03
- **And** summary: 2 implemented, 0 skipped, 1 failed

### 【PENDING】AC-07 [Func/Misuse]: File has only PLANNED but missing @[Category]
- **Given** all TCs PLANNED but no Category tags
- **When** `implTestFile` runs
- **Then** exit 1, stderr: cannot determine priority order

---

## Fault (InvalidFunc) — Execution failure

### 【PENDING】AC-08 [Func/Fault]: Target file not writable mid-batch
- **Given** target file becomes read-only during batch
- **When** CLI attempts to write
- **Then** exit 1, stderr: write error, partial results recorded

### 【PENDING】AC-09 [Func/Fault]: File locked by another process
- **Given** file has exclusive lock
- **When** CLI opens
- **Then** exit 1, stderr: lock conflict