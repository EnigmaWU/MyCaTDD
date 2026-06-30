# US-USER-05 [P0] — Implement one executable test case (RED)

**As a** USER, **I want** the CLI to turn one skeleton TC into compilable test code, **so that** I enter the RED phase of TDD.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-05 | 5 | Normal implementation |
| Edge | ValidFunc | AC-06 ~ AC-09 | 4 | Boundary cases |
| Misuse | InvalidFunc | AC-10 ~ AC-14 | 5 | Behavior-specific contract |
| Fault | InvalidFunc | AC-15 ~ AC-18 | 4 | Implement-time failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 5 | 0 | 0 | 0 | 0 | 0 | 5 |
| Edge | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Misuse | 5 | 0 | 0 | 0 | 0 | 0 | 5 |
| Fault | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| **Total** | **18** | **0** | **0** | **0** | **0** | **0** | **18** |

---

## Typical (ValidFunc) — Normal implementation

### 【PENDING】AC-01 [Func/Typical]: Skeleton TC becomes executable RED test
- **Given** TC-04 `@[Status:PLANNED]`, `@[Category:Edge]`, valid `@[AC]`, `--inputFile` provides SUT
- **When** `--behave implTestCase --target tests/auth_test.cpp::TC-04`
- **Then** exit 0, skeleton preserved, PLANNED→RED, no other TC modified

### 【PENDING】AC-02 [Func/Typical]: Generated code references correct SUT
- **Given** `--inputFile src/AuthService.h` with `class AuthService`
- **When** implementation runs
- **Then** exit 0, test code references AuthService

### 【PENDING】AC-03 [Func/Typical]: Extra-prompt guides test structure
- **Given** `--extra-prompt "use AAA pattern"`
- **When** implementation runs
- **Then** exit 0, code contains AAA markers

### 【PENDING】AC-04 [Func/Typical]: Implementation from inline `--input`
- **Given** `--input "int add(int a, int b);"`
- **When** implementation runs
- **Then** exit 0, test code tests the add function

### 【PENDING】AC-05 [Func/Typical]: Include/import for SUT generated
- **Given** `--inputFile src/AuthService.h`
- **When** implementation runs
- **Then** generated code has appropriate include/import

---

## Edge (ValidFunc) — Boundary cases

### 【PENDING】AC-06 [Func/Edge]: First TC DESIGNED→PARTIAL
- **Given** all-PLANNED (DESIGNED), TC-01 (PLANNED)
- **When** implTestCase targets TC-01
- **Then** exit 0, file becomes PARTIAL

### 【PENDING】AC-07 [Func/Edge]: Last PLANNED TC PARTIAL→FULLY_RED
- **Given** TC-02 (RED), TC-03 (PLANNED) — PARTIAL
- **When** implTestCase targets TC-03
- **Then** exit 0, file becomes FULLY_RED

### 【PENDING】AC-08 [Func/Edge]: TC at end of file preserves boundary
- **Given** target TC is last in file
- **When** implementation runs
- **Then** exit 0, file ends cleanly

### 【PENDING】AC-09 [Func/Edge]: TC at start preserves header
- **Given** target TC is TC-01 (first)
- **When** implementation runs
- **Then** exit 0, header and provenance preserved

---

## Misuse (InvalidFunc) — Behavior-specific contract

### 【PENDING】AC-10 [Func/Misuse]: TC already RED not overwritten
- **Given** TC-04 `@[Status:RED]`
- **When** implTestCase targets TC-04
- **Then** exit 1, stderr: already implemented

### 【PENDING】AC-11 [Func/Misuse]: TC already GREEN not overwritten
- **Given** TC-04 `@[Status:GREEN]`
- **When** implTestCase targets TC-04
- **Then** exit 1, stderr: cannot return to RED

### 【PENDING】AC-12 [Func/Misuse]: Missing `@[Category]` fails integrity
- **Given** TC-04 has no `@[Category]`
- **When** pre-check runs
- **Then** exit 1, stderr: missing @[Category]

### 【PENDING】AC-13 [Func/Misuse]: `@[Status]` not PLANNED fails integrity
- **Given** TC-04 `@[Status:DRAFT]`
- **When** pre-check runs
- **Then** exit 1, stderr: expected PLANNED

### 【PENDING】AC-14 [Func/Misuse]: `@[AC]` references non-existent AC
- **Given** TC-04 references AC-99 but story only has AC-01..AC-03
- **When** pre-check runs
- **Then** exit 1, stderr: AC not defined

---

## Fault (InvalidFunc) — Implementation-time failure

### 【PENDING】AC-15 [Func/Fault]: `--inputFile` has no testable interface
- **Given** input file only comments/whitespace
- **When** implementation runs
- **Then** exit 1, stderr: no testable interface

### 【PENDING】AC-16 [Func/Fault]: Target TC not found
- **Given** `--target tests/auth_test.cpp::TC-99` but only TC-01..TC-10
- **When** implementation runs
- **Then** exit 1, stderr: TC-99 not found

### 【PENDING】AC-17 [Func/Fault]: Target file not writable
- **Given** target file is read-only
- **When** implementation modifies
- **Then** exit 1, stderr: write permission error

### 【PENDING】AC-18 [Func/Fault]: Skeleton comment block malformed
- **Given** TC-04 skeleton broken (unclosed comment)
- **When** implementation parses
- **Then** exit 1, stderr: malformed skeleton