# US-USER-04 [P0] — Select next test case to implement

**As a** USER, **I want** the CLI to tell me exactly which TC to implement next, **so that** I follow TDD discipline without manually scanning the file.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | Normal selection |
| Edge | ValidFunc | AC-05 ~ AC-08 | 4 | Valid boundary |
| Misuse | InvalidFunc | AC-09 ~ AC-12 | 4 | Behavior-specific |
| Fault | InvalidFunc | AC-13 ~ AC-15 | 3 | Read-time failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Edge | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Misuse | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Fault | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| **Total** | **15** | **0** | **0** | **0** | **0** | **0** | **15** |

---

## Typical (ValidFunc) — Normal selection

### 【PENDING】AC-01 [Func/Typical]: First PLANNED in CaTDD priority order
- **Given** TC-01 (Typical, PLANNED), TC-02 (Typical, PLANNED), TC-03 (Edge, PLANNED)
- **When** `--behave tellMeNextImplTest`
- **Then** exit 0, stdout: "TC-01 (Category: Typical)"

### 【PENDING】AC-02 [Func/Typical]: Skips implemented TCs
- **Given** TC-01 (RED), TC-02 (PLANNED), TC-03 (PLANNED)
- **When** selection runs
- **Then** stdout selects TC-02

### 【PENDING】AC-03 [Func/Typical]: P0 category priority overrides file order
- **Given** TC-05 (Misuse, PLANNED) before TC-06 (Edge, PLANNED)
- **When** selection runs
- **Then** stdout selects TC-06 (Edge before Misuse)

### 【PENDING】AC-04 [Func/Typical]: P0 selected before P1
- **Given** P0-Misuse and P1-State both PLANNED
- **When** selection runs
- **Then** stdout selects the P0 TC

---

## Edge (ValidFunc) — Valid boundary

### 【PENDING】AC-05 [Func/Edge]: Only one PLANNED TC
- **Given** exactly one TC PLANNED
- **When** selection runs
- **Then** stdout outputs that single TC-ID

### 【PENDING】AC-06 [Func/Edge]: All TCs implemented — nothing to select
- **Given** every TC RED or GREEN
- **When** selection runs
- **Then** exit 0, stdout: all implemented, nothing to select

### 【PENDING】AC-07 [Func/Edge]: Empty file (no CaTDD skeletons)
- **Given** file has no CaTDD comments
- **When** selection runs
- **Then** exit 0, stdout: no skeletons, use design

### 【PENDING】AC-08 [Func/Edge]: All PLANNED but missing `@[Category]`
- **Given** all PLANNED but no Category tags
- **When** selection runs
- **Then** exit 0, falls back to file order with warning

---

## Misuse (InvalidFunc) — Behavior-specific

### 【PENDING】AC-09 [Func/Misuse]: No `@[Status]` tags on any TC
- **Given** TC skeletons all missing `@[Status]`
- **When** selection runs
- **Then** exit 1, stderr: no valid @[Status]

### 【PENDING】AC-10 [Func/Misuse]: Unrecognized status values
- **Given** all TCs have `@[Status:PENDING]` or `@[Status:TODO]`
- **When** selection runs
- **Then** exit 1, stderr: no PLANNED status found

### 【PENDING】AC-11 [Func/Misuse]: Unrecognized `@[Category]` values
- **Given** TCs have `@[Category:Unknown]`
- **When** selection runs
- **Then** exit 0, warns deprioritized

### 【PENDING】AC-12 [Func/Misuse]: Selected TC missing `@[AC]` traceback
- **Given** all PLANNED TCs missing `@[AC]` refs
- **When** selection runs
- **Then** exit 0, selects, stderr warns

---

## Fault (InvalidFunc) — Read-time failure

### 【PENDING】AC-13 [Func/Fault]: File encoding prevents TC parsing
- **Given** encoding prevents `@[TC-*]` matching
- **When** selection runs
- **Then** exit 1, stderr: encoding failure

### 【PENDING】AC-14 [Func/Fault]: File locked by another process
- **Given** file has exclusive lock
- **When** CLI reads
- **Then** exit 1, stderr: lock conflict

### 【PENDING】AC-15 [Func/Fault]: Target is a dangling symlink
- **Given** `--target` is dangling symlink
- **When** CLI resolves
- **Then** exit 1, stderr: dangling symlink