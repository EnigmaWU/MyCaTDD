# US-INVENTOR-01 [P0] — Delegate all CaTDD semantics to methodPrompts

**As an** INVENTOR, **I want** the CLI to own zero CaTDD method knowledge, **so that** I can evolve categories, discipline rules, and prompt contracts without touching or re-releasing the CLI.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | Delegation works |
| Edge | ValidFunc | AC-05 ~ AC-08 | 4 | Delegation boundary |
| Misuse | InvalidFunc | AC-09 ~ AC-12 | 4 | Delegation contract |
| Fault | InvalidFunc | AC-13 ~ AC-16 | 4 | Missing dependencies |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Edge | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Misuse | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Fault | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| **Total** | **16** | **0** | **0** | **0** | **0** | **0** | **16** |

---

## Typical (ValidFunc) — Delegation succeeds normally

### 【PENDING】AC-01 [Func/Typical]: Category resolved from methodPrompts at runtime
- **Given** CLI needs Edge category meaning
- **When** `--behave designEdgeSkeleton` executes
- **Then** exit 0, `--diagMethodPrompts` shows resolved prompt path

### 【PENDING】AC-02 [Func/Typical]: Behavior delegates to slashCommands
- **Given** CLI resolves `--behave designFuncTestsSkeleton`
- **When** it executes
- **Then** exit 0, `--diagSlashCommands` shows resolved command path

### 【PENDING】AC-03 [Func/Typical]: Output artifacts from delegated layers
- **Given** any invocation modifying a test file
- **When** CaTDD content appears
- **Then** diag flags show delegation chain, no inline source

### 【PENDING】AC-04 [Func/Typical]: Both diag flags reveal full trace
- **Given** both `--diagMethodPrompts` and `--diagSlashCommands`
- **When** execution completes
- **Then** stderr shows prompt reads and command invocation

---

## Edge (ValidFunc) — Delegation boundary

### 【PENDING】AC-05 [Func/Edge]: Empty methodPrompt detected
- **Given** methodPrompt file is empty (0 bytes)
- **When** CLI resolves that category
- **Then** exit 1, stderr reports empty file, no hardcoded fallback

### 【PENDING】AC-06 [Func/Edge]: Empty slashCommand detected
- **Given** slashCommand file is empty
- **When** CLI invokes
- **Then** exit 1, stderr reports empty command

### 【PENDING】AC-07 [Func/Edge]: Multiple prompts resolve independently
- **Given** CLI needs category + status + priority
- **When** `--diagMethodPrompts` enabled
- **Then** three distinct prompt resolutions shown

### 【PENDING】AC-08 [Func/Edge]: Updated prompt picked up without CLI change
- **Given** methodPrompt updated with new constraint
- **When** CLI runs after update
- **Then** output reflects new content

---

## Misuse (InvalidFunc) — Delegation contract

### 【PENDING】AC-09 [Func/Misuse]: Prompt deleted at runtime
- **Given** required prompt deleted between start and resolution
- **When** CLI needs that category
- **Then** exit 1, stderr reports missing file

### 【PENDING】AC-10 [Func/Misuse]: slashCommand deleted at runtime
- **Given** behavior resolved to command then deleted
- **When** CLI attempts to read
- **Then** exit 1, stderr reports missing command

### 【PENDING】AC-11 [Func/Misuse]: Symlink escapes methodPrompts/
- **Given** prompt is symlink outside `methodPrompts/`
- **When** CLI resolves
- **Then** exit 1, stderr: symlink escape

### 【PENDING】AC-12 [Func/Misuse]: Circular slashCommand reference
- **Given** slashCommand includes self-reference
- **When** CLI processes
- **Then** exit 1, stderr: circular reference

---

## Fault (InvalidFunc) — Missing dependencies

### 【PENDING】AC-13 [Func/Fault]: `methodPrompts/` directory missing
- **Given** directory does not exist
- **When** CLI resolves any category
- **Then** exit 1, stderr: methodPrompts/ not found

### 【PENDING】AC-14 [Func/Fault]: Prompt file unreadable
- **Given** file exists but no read permission
- **When** CLI reads
- **Then** exit 1, stderr: permission error

### 【PENDING】AC-15 [Func/Fault]: `slashCommands/commands/` directory missing
- **Given** directory does not exist
- **When** CLI resolves behavior
- **Then** exit 1, stderr: directory not found

### 【PENDING】AC-16 [Func/Fault]: slashCommand path is a directory
- **Given** resolved path is a directory
- **When** CLI reads
- **Then** exit 1, stderr: path is a directory