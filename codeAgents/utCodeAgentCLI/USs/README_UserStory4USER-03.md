# US-USER-03 [P0] — Review design skeletons (all tiers)

**As a** USER, **I want** the CLI to audit design skeletons across all CaTDD tiers before I implement anything, **so that** I catch coverage gaps and traceability breaks.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | Normal review |
| Edge | ValidFunc | AC-05 ~ AC-09 | 5 | Valid states |
| Misuse | InvalidFunc | AC-10 ~ AC-13 | 4 | Behavior-specific |
| Fault | InvalidFunc | AC-14 ~ AC-17 | 4 | Read-time failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Edge | 5 | 0 | 0 | 0 | 0 | 0 | 5 |
| Misuse | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Fault | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| **Total** | **17** | **0** | **0** | **0** | **0** | **0** | **17** |

---

## Typical (ValidFunc) — Normal review

### 【PENDING】AC-01 [Func/Typical]: P0 Functional review reports numeric status
- **Given** file has mixed-status P0 skeletons
- **When** `--behave reviewFuncTestsSkeleton`
- **Then** exit 0, stdout: counts per category/status, missing-tag list

### 【PENDING】AC-02 [Func/Typical]: P1 Design review reports State/Capability/Concurrency
- **Given** file has P1 design skeletons
- **When** `--behave reviewDesignTestsSkeleton`
- **Then** exit 0, stdout: per-category and per-status counts

### 【PENDING】AC-03 [Func/Typical]: P2 Quality review reports Performance/Robust/Compat/Config
- **Given** file has P2 quality skeletons
- **When** `--behave reviewQualityTestsSkeleton`
- **Then** exit 0, stdout: per-category and per-status counts

### 【PENDING】AC-04 [Func/Typical]: Review all tiers at once
- **Given** file has P0, P1, P2 skeletons
- **When** `--behave reviewAllSkeleton`
- **Then** exit 0, stdout reports all three tiers

---

## Edge (ValidFunc) — Valid states

### 【PENDING】AC-05 [Func/Edge]: Empty file reports 0 skeletons
- **Given** file has no CaTDD comments
- **When** review runs
- **Then** exit 0, stdout: 0 CaTDD skeleton TCs found

### 【PENDING】AC-06 [Func/Edge]: All-PLANNED file reports DESIGNED state
- **Given** every TC is PLANNED
- **When** review runs
- **Then** exit 0, all PLANNED, state DESIGNED

### 【PENDING】AC-07 [Func/Edge]: FULLY_RED file reports all RED
- **Given** every TC is RED
- **When** review runs
- **Then** exit 0, stdout reports FULLY_RED state

### 【PENDING】AC-08 [Func/Edge]: Review P0 on file with only P1/P2
- **Given** file only has P1 and P2
- **When** `--behave reviewFuncTestsSkeleton`
- **Then** exit 0, suggests other review behaviors

### 【PENDING】AC-09 [Func/Edge]: TC numbering has gaps but valid
- **Given** file has TC-01, TC-03, TC-05 (gaps)
- **When** review runs
- **Then** exit 0, lists gaps, counts present TCs

---

## Misuse (InvalidFunc) — Behavior-specific

### 【PENDING】AC-10 [Func/Misuse]: Corrupted `@[TC-*]` format
- **Given** malformed TC tags (missing bracket)
- **When** review runs
- **Then** exit 1, stderr: malformed TC tag

### 【PENDING】AC-11 [Func/Misuse]: Duplicate TC-ID
- **Given** two skeletons tagged `@[TC-01]`
- **When** review runs
- **Then** exit 1, stderr: duplicate TC-ID

### 【PENDING】AC-12 [Func/Misuse]: Unrecognized `@[Status]`
- **Given** a TC has `@[Status:DRAFT]`
- **When** review runs
- **Then** exit 0, stdout flags unrecognized

### 【PENDING】AC-13 [Func/Misuse]: Target is not a test file
- **Given** `--target src/AuthService.cpp`
- **When** review runs
- **Then** exit 1, stderr: no CaTDD structure

---

## Fault (InvalidFunc) — Read-time failure

### 【PENDING】AC-14 [Func/Fault]: File encoding not UTF-8
- **Given** file is UTF-16 or mixed encoding
- **When** review reads
- **Then** exit 1, stderr: encoding error

### 【PENDING】AC-15 [Func/Fault]: File locked by another process
- **Given** file has exclusive lock
- **When** CLI opens
- **Then** exit 1, stderr: lock conflict

### 【PENDING】AC-16 [Func/Fault]: File exceeds review size limit
- **Given** file >100MB
- **When** review runs
- **Then** exit 1, stderr: exceeds limit

### 【PENDING】AC-17 [Func/Fault]: Binary content in file
- **Given** file contains binary sequences (null bytes)
- **When** review parses
- **Then** exit 1, stderr: binary content detected