# US-USER-08 [P1] — Combined design-and-implement in one pass

**As a** USER, **I want** the CLI to design all skeletons and immediately implement them in one invocation, **so that** I can go from zero to RED test code without intermediate steps.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-02 | 2 | Normal combined pass |
| Edge | ValidFunc | AC-03 ~ AC-04 | 2 | Boundary states |
| Misuse | InvalidFunc | AC-05 ~ AC-06 | 2 | Behavior-specific |
| Fault | InvalidFunc | AC-07 ~ AC-08 | 2 | Execution failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Edge | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Misuse | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Fault | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| **Total** | **8** | **0** | **0** | **0** | **0** | **0** | **8** |

---

## Typical (ValidFunc) — Normal combined pass

### 【PENDING】AC-01 [Func/Typical]: Design then implement — FULLY_RED result
- **Given** source file, User Story, empty target file (EMPTY)
- **When** `--behave designAndImplTest`
- **Then** skeletons designed first (EMPTY→DESIGNED)
- **Then** all TCs implemented (DESIGNED→FULLY_RED)
- **And** `@[US]` preserves the provided Story
- **And** trace records two-phase execution

### 【PENDING】AC-02 [Func/Typical]: Trace records design→implement phases
- **Given** `--behave designAndImplTest` completes
- **When** trace is written
- **Then** trace contains separate sections for design phase and implement phase
- **And** each phase has completed steps and affected files

---

## Edge (ValidFunc) — Boundary states

### 【PENDING】AC-03 [Func/Edge]: Target file already exists — merges then implements
- **Given** target file already has some skeletons (DESIGNED state)
- **When** `--behave designAndImplTest`
- **Then** new skeletons merged alongside existing, no duplicates
- **And** all PLANNED TCs implemented → RED

### 【PENDING】AC-04 [Func/Edge]: Design phase fails — implement phase skipped
- **Given** source file is unparseable, design fails
- **When** combined pass runs
- **Then** exit 1, stderr reports design failure
- **And** implement phase is not attempted
- **And** trace records design phase failure, implement phase skipped

---

## Misuse (InvalidFunc) — Behavior-specific

### 【PENDING】AC-05 [Func/Misuse]: Design succeeds but one TC fails integrity
- **Given** design phase succeeds, one TC has missing `@[Category]`
- **When** implement phase processes that TC
- **Then** exit 1, stderr: integrity failure, TC left PLANNED
- **And** other TCs still implemented

### 【PENDING】AC-06 [Func/Misuse]: No source or story provided
- **Given** no `--inputFile`/`--input` and no `--goalStory`/`--goalStoryFile`
- **When** `--behave designAndImplTest` runs
- **Then** exit 1, stderr: required inputs missing

---

## Fault (InvalidFunc) — Execution failure

### 【PENDING】AC-07 [Func/Fault]: Target file not writable after design phase
- **Given** design phase succeeds, file becomes read-only before implement phase
- **When** implement phase attempts to write
- **Then** exit 1, stderr: write error
- **And** skeletons from design phase preserved

### 【PENDING】AC-08 [Func/Fault]: Source file deleted between phases
- **Given** `--inputFile` deleted after design phase, before implement phase
- **When** implement phase reads source
- **Then** exit 1, stderr: source file not found