# US-USER-10 [P0] — Review all implemented test cases in a file

**As a** USER, **I want** the CLI to audit every implemented RED TC in a file in one invocation, **so that** I can verify implementation quality across the entire file.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-03 | 3 | Normal review |
| Edge | ValidFunc | AC-04 ~ AC-07 | 4 | Boundary states |
| Misuse | InvalidFunc | AC-08 ~ AC-11 | 4 | Behavior-specific |
| Fault | InvalidFunc | AC-12 ~ AC-14 | 3 | Read-time failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| Edge | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Misuse | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Fault | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| **Total** | **14** | **0** | **0** | **0** | **0** | **0** | **14** |

---

## Typical (ValidFunc) — Normal review

### 【PENDING】AC-01 [Func/Typical]: Per-TC review for all RED/GREEN TCs
- **Given** TC-01 (RED), TC-02 (RED), TC-03 (PLANNED), TC-04 (RED)
- **When** `--behave reviewImplTestFile --target tests/auth_test.cpp`
- **Then** exit 0, per-TC for TC-01,02,04; TC-03 skipped; summary

### 【PENDING】AC-02 [Func/Typical]: Reviews both RED and GREEN
- **Given** TC-01 (RED), TC-02 (GREEN), TC-03 (PLANNED)
- **When** reviewImplTestFile runs
- **Then** TC-01,02 reviewed; TC-03 skipped

### 【PENDING】AC-03 [Func/Typical]: Review order follows file order
- **Given** TC-05 before TC-01 in file
- **When** review runs
- **Then** TC-05 reviewed before TC-01

---

## Edge (ValidFunc) — Boundary states

### 【PENDING】AC-04 [Func/Edge]: No implemented TCs (all PLANNED)
- **Given** every TC PLANNED (DESIGNED state)
- **When** reviewImplTestFile runs
- **Then** exit 0, stdout: 0 implemented, all PLANNED

### 【PENDING】AC-05 [Func/Edge]: FULLY_RED file — all reviewed
- **Given** all TCs RED
- **When** review runs
- **Then** exit 0, every TC reviewed, 0 skipped

### 【PENDING】AC-06 [Func/Edge]: ALL_GREEN file — all reviewed
- **Given** all TCs GREEN
- **When** review runs
- **Then** exit 0, every TC reviewed

### 【PENDING】AC-07 [Func/Edge]: No CaTDD skeletons (EMPTY)
- **Given** file has no CaTDD comments
- **When** reviewImplTestFile runs
- **Then** exit 0, stdout: 0 CaTDD TCs

---

## Misuse (InvalidFunc) — Behavior-specific

### 【PENDING】AC-08 [Func/Misuse]: No `@[US]` block — review with warning
- **Given** file has RED TCs but no `@[US]`
- **When** reviewImplTestFile runs
- **Then** exit 0, warns: no @[US], AC traceback skipped

### 【PENDING】AC-09 [Func/Misuse]: Duplicate TC-IDs
- **Given** two skeletons tagged `@[TC-03]`
- **When** review runs
- **Then** exit 1, stderr: duplicate TC-ID

### 【PENDING】AC-10 [Func/Misuse]: File has US/AC but zero TCs
- **Given** file has `@[US]` and `@[AC-*]` but no `@[TC-*]`
- **When** review runs
- **Then** exit 0, stdout: 0 TCs, suggests design

### 【PENDING】AC-11 [Func/Misuse]: CaTDD mixed with non-CaTDD tests
- **Given** file has CaTDD TC-01 (RED), hand-written test, TC-02 (RED)
- **When** review runs
- **Then** exit 0, CaTDD reviewed, non-CaTDD ignored

---

## Fault (InvalidFunc) — Read-time failure

### 【PENDING】AC-12 [Func/Fault]: File modified mid-review
- **Given** file changed between reading TC-01 and TC-02
- **When** review detects
- **Then** exit 1, stderr: file modified during review

### 【PENDING】AC-13 [Func/Fault]: File locked by another process
- **Given** file has exclusive lock
- **When** CLI opens
- **Then** exit 1, stderr: lock conflict

### 【PENDING】AC-14 [Func/Fault]: Binary content in TC body
- **Given** TC body contains binary data
- **When** review parses
- **Then** exit 1, stderr: binary content detected