# US-USER-07 [P1] — Batch skeleton design across multiple files

**As a** USER, **I want** to design skeletons into several test files from one source and one User Story, **so that** I can prepare multi-module test coverage in one pass.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-02 | 2 | Normal batch design |
| Edge | ValidFunc | AC-03 | 1 | Boundary state |
| Misuse | InvalidFunc | AC-04 ~ AC-05 | 2 | Behavior-specific |
| Fault | InvalidFunc | AC-06 ~ AC-07 | 2 | Execution failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Edge | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| Misuse | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Fault | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| **Total** | **7** | **0** | **0** | **0** | **0** | **0** | **7** |

---

## Typical (ValidFunc) — Normal batch design

### 【PENDING】AC-01 [Func/Typical]: Multiple target files each receive skeletons
- **Given** `--target tests/auth_api_test.cpp,tests/auth_error_test.cpp`, shared `--inputFile` and `--goalStoryFile`
- **When** `--behave designAllSkeleton`
- **Then** both files created/updated with US/AC/TC skeletons
- **And** stdout reports per-file results

### 【PENDING】AC-02 [Func/Typical]: Each file gets distinct category-appropriate skeletons
- **Given** `auth_api_test.cpp` targets API layer, `auth_error_test.cpp` targets error handling
- **When** batch design runs
- **Then** each file's skeletons match its focus area
- **And** no cross-contamination

---

## Edge (ValidFunc) — Boundary state

### 【PENDING】AC-03 [Func/Edge]: One target file already exists with skeletons — merges
- **Given** one file already has skeletons, other is empty
- **When** batch design runs
- **Then** existing file's skeletons preserved, new skeletons added
- **And** empty file receives full skeleton set

---

## Misuse (InvalidFunc) — Behavior-specific

### 【PENDING】AC-04 [Func/Misuse]: One target file path is invalid
- **Given** one target path is unparseable
- **When** batch design runs
- **Then** exit 1, stderr names bad path
- **And** valid files are not modified

### 【PENDING】AC-05 [Func/Misuse]: Target list empty (no files after comma split)
- **Given** `--target` resolves to empty list
- **When** batch design runs
- **Then** exit 1, stderr: no target files specified

---

## Fault (InvalidFunc) — Execution failure

### 【PENDING】AC-06 [Func/Fault]: One target file's parent directory cannot be created
- **Given** one target path's parent is not writable
- **When** CLI creates file
- **Then** exit 1, stderr: directory creation failure

### 【PENDING】AC-07 [Func/Fault]: Shared `--inputFile` missing
- **Given** `--inputFile` points to nonexistent path
- **When** batch design runs
- **Then** exit 1, stderr: input file not found