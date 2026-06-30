# US-USER-09 [P0] — Review implemented test case

**As a** USER, **I want** the CLI to audit an implemented RED test case before I write product code, **so that** I verify the test is correct and preserves CaTDD traceability.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | Normal review |
| Edge | ValidFunc | AC-05 ~ AC-08 | 4 | Boundary states |
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

## Typical (ValidFunc) — Normal review

### 【PENDING】AC-01 [Func/Typical]: Review reports quality for RED TC
- **Given** TC-04 `@[Status:RED]`, executable code, preserved skeleton
- **When** `--behave reviewImplTestCase --target tests/auth_test.cpp::TC-04`
- **Then** exit 0, stdout: RED confirmed, skeleton preserved, AC coverage flagged

### 【PENDING】AC-02 [Func/Typical]: Review reports for GREEN TC
- **Given** TC-04 `@[Status:GREEN]`
- **When** reviewImplTestCase targets TC-04
- **Then** exit 0, confirms GREEN and traceability

### 【PENDING】AC-03 [Func/Typical]: Full skeleton tag completeness
- **Given** TC-04 has all CaTDD tags
- **When** review runs
- **Then** stdout lists each tag with presence check

### 【PENDING】AC-04 [Func/Typical]: Detects content drift from AC scope
- **Given** TC-04 covers AC-03 (3 conditions), tests 2 of 3
- **When** review runs
- **Then** stdout: coverage 2/3 conditions tested

---

## Edge (ValidFunc) — Boundary states

### 【PENDING】AC-05 [Func/Edge]: PLANNED TC reports not-yet-implemented
- **Given** TC-04 `@[Status:PLANNED]`
- **When** reviewImplTestCase targets TC-04
- **Then** exit 0, stdout: not yet implemented

### 【PENDING】AC-06 [Func/Edge]: TC has code but no skeleton
- **Given** TC-04 has test function but no `@[TC-04]` skeleton
- **When** review runs
- **Then** exit 0, stdout: no CaTDD skeleton

### 【PENDING】AC-07 [Func/Edge]: RED tag but no function body
- **Given** TC-04 `@[Status:RED]` but only skeleton, no executable code
- **When** review runs
- **Then** exit 0, flags: marked RED but no body

### 【PENDING】AC-08 [Func/Edge]: Developer comments alongside CaTDD tags
- **Given** TC-04 has `// TODO:` alongside CaTDD tags
- **When** review runs
- **Then** exit 0, CaTDD verified, annotations noted

---

## Misuse (InvalidFunc) — Behavior-specific

### 【PENDING】AC-09 [Func/Misuse]: Skeleton tag mismatches selector
- **Given** `--target ::TC-04` but skeleton has `@[TC-05]`
- **When** review runs
- **Then** exit 1, stderr: selector mismatches skeleton

### 【PENDING】AC-10 [Func/Misuse]: RED TC missing `@[Category]`
- **Given** TC-04 RED status but no `@[Category]`
- **When** review runs
- **Then** exit 0, flags missing Category, reviews other tags

### 【PENDING】AC-11 [Func/Misuse]: Duplicate `@[Status]` tags
- **Given** TC-04 has both `@[Status:RED]` and `@[Status:PLANNED]`
- **When** review runs
- **Then** exit 1, stderr: duplicate @[Status]

### 【PENDING】AC-12 [Func/Misuse]: No `@[US]` section in file
- **Given** file has TCs but no `@[US]`
- **When** reviewImplTestCase runs
- **Then** exit 0, stdout: no @[US], AC traceback cannot be verified

---

## Fault (InvalidFunc) — Read-time failure

### 【PENDING】AC-13 [Func/Fault]: Target TC not in file
- **Given** `--target ::TC-99` but file only has TC-01..TC-10
- **When** review runs
- **Then** exit 1, stderr: TC-99 not found

### 【PENDING】AC-14 [Func/Fault]: File encoding prevents TC parsing
- **Given** encoding prevents TC extraction
- **When** review runs
- **Then** exit 1, stderr: encoding error

### 【PENDING】AC-15 [Func/Fault]: TC comment block suspiciously large
- **Given** target TC block >1000 lines
- **When** review parses
- **Then** exit 1, stderr: exceeds max skeleton size