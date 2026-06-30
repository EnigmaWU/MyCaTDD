# US-USER-02 [P0] — Design CaTDD test skeletons

**As a** USER, **I want** the CLI to generate US/AC/TC skeletons into a test file from my source code and User Story, **so that** I have a structured, traceable test plan before writing any executable test code.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-06 | 6 | Normal design flows |
| Edge | ValidFunc | AC-07 ~ AC-11 | 5 | Warn, proceed |
| Misuse | InvalidFunc | AC-12 ~ AC-16 | 5 | Behavior-specific contract |
| Fault | InvalidFunc | AC-17 ~ AC-20 | 4 | Design-time dependency |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 6 | 0 | 0 | 0 | 0 | 0 | 6 |
| Edge | 5 | 0 | 0 | 0 | 0 | 0 | 5 |
| Misuse | 5 | 0 | 0 | 0 | 0 | 0 | 5 |
| Fault | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| **Total** | **20** | **0** | **0** | **0** | **0** | **0** | **20** |

---

## Typical (ValidFunc) — Normal usage patterns

### 【PENDING】AC-01 [Func/Typical]: Design P0 Functional skeletons all four categories
- **Given** `--goalStoryFile`, `--inputFile`, empty/nonexistent `--target`
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit 0, file EMPTY→DESIGNED, contains `@[US]`, `@[AC-*]`, `@[TC-*]`, all `@[Status:PLANNED]`
- **And** no executable code

### 【PENDING】AC-02 [Func/Typical]: Design one P0 category
- **Given** source and story
- **When** `--behave designEdgeSkeleton`
- **Then** exit 0, only Edge-category skeletons

### 【PENDING】AC-03 [Func/Typical]: Design all P0/P1/P2 skeletons
- **Given** source and story
- **When** `--behave designAllSkeleton`
- **Then** exit 0, file has P0 + P1 + P2 skeletons

### 【PENDING】AC-04 [Func/Typical]: Inline story + inline source
- **Given** `--goalStory "..."` and `--input "..."`
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit 0, skeletons from inline values

### 【PENDING】AC-05 [Func/Typical]: Design with reference files
- **Given** `--reference docs/api.md,docs/schema.md`
- **When** `--behave designAllSkeleton`
- **Then** exit 0, references consulted

### 【PENDING】AC-06 [Func/Typical]: Design with all optional args together
- **Given** `--extra-prompt`, `--config-file`, diag flags
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit 0, all coexist

---

## Edge (ValidFunc) — Boundary cases


## Misuse (InvalidFunc) — Behavior-specific contract

### 【PENDING】AC-12 [Func/Misuse]: `--inputFile` not valid source code
- **Given** `--inputFile` points to binary or no code structure
- **When** skeleton design parses
- **Then** exit 1, stderr: not a parseable source file

### 【PENDING】AC-13 [Func/Misuse]: Design into FULLY_RED file
- **Given** target is FULLY_RED (all TCs RED)
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit 1, stderr: file has implemented TCs

### 【PENDING】AC-14 [Func/Misuse]: `--goalStoryFile` has no story structure
- **Given** file readable but no role/US/AC structure
- **When** skeleton design runs
- **Then** exit 1, stderr: no User Story content

### 【PENDING】AC-15 [Func/Misuse]: Config incompatible with design scope
- **Given** config `strict-p0-only` with `--behave designAllSkeleton`
- **When** config applied
- **Then** exit 1, stderr reports scope conflict

### 【PENDING】AC-16 [Func/Misuse]: `--reference` provides no usable context
- **Given** ref file has no test-relevant content
- **When** skeleton design runs
- **Then** exit 0, stderr warns, skeletons generated

---

## Fault (InvalidFunc) — Design-time dependency failures

### 【PENDING】AC-17 [Func/Fault]: `--inputFile` has no testable interface
- **Given** input file empty class or no methods
- **When** skeleton design runs
- **Then** exit 1, stderr: no testable interface

### 【PENDING】AC-18 [Func/Fault]: Target parent directory cannot be created
- **Given** `--target missing/deep/path/test.cpp`
- **When** CLI creates target file
- **Then** exit 1, stderr: directory creation failure

### 【PENDING】AC-19 [Func/Fault]: `--reference` is a broken symlink
- **Given** `--reference docs/broken-link.md`
- **When** CLI reads reference
- **Then** exit 1, stderr names broken symlink

### 【PENDING】AC-20 [Func/Fault]: `--goalStoryFile` is a directory
- **Given** `--goalStoryFile codeAgents/`
- **When** validation detects
- **Then** exit 1, stderr: path is a directory

### 【PENDING】AC-07 [Func/Edge]: Existing file preserves non-CaTDD content
- **Given** target has hand-written test code
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit 0, non-CaTDD preserved, skeletons appended

### 【PENDING】AC-08 [Func/Edge]: No User Story uses placeholder
- **Given** source but no `--goalStory` or `--goalStoryFile`
- **When** skeleton design runs
- **Then** exit 0, `@[US]` placeholder, stderr warns

### 【PENDING】AC-09 [Func/Edge]: Empty `--goalStory ""` treated as not provided
- **Given** `--goalStory ""`
- **When** skeleton design runs
- **Then** exit 0, placeholder, stderr warns

### 【PENDING】AC-10 [Func/Edge]: `--reference` with whitespace ignored
- **Given** `--reference " , "`
- **When** skeleton design runs
- **Then** exit 0, stderr warns empty refs ignored

### 【PENDING】AC-11 [Func/Edge]: Single-category merges into existing
- **Given** target has Typical skeletons
- **When** `--behave designEdgeSkeleton`
- **Then** exit 0, Edge added, no duplicates