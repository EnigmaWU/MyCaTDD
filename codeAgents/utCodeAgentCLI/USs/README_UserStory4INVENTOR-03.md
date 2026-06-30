# US-INVENTOR-03 [P1] — Diagnostic visibility into method resolution

**As an** INVENTOR, **I want** `--diagMethodPrompts` and `--diagSlashCommands` to reveal exactly which prompts and commands the CLI resolved, **so that** I can verify the CLI did not substitute, skip, or bypass any CaTDD asset.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-02 | 2 | Normal diagnostics |
| Edge | ValidFunc | AC-03 ~ AC-04 | 2 | Diagnostic boundary |
| Misuse | InvalidFunc | AC-05 | 1 | Diagnostic misuse |
| Fault | InvalidFunc | AC-06 | 1 | Diagnostic failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Edge | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Misuse | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| Fault | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| **Total** | **6** | **0** | **0** | **0** | **0** | **0** | **6** |

---

## Typical (ValidFunc) — Normal diagnostics

### 【PENDING】AC-01 [Func/Typical]: `--diagMethodPrompts` logs resolved prompts
- **Given** any valid CLI invocation with `--diagMethodPrompts`
- **When** CLI resolves method prompts during execution
- **Then** stderr lists each resolved prompt file path and the CaTDD category/rule it was resolved for
- **And** every prompt used during execution is logged

### 【PENDING】AC-02 [Func/Typical]: `--diagSlashCommands` logs resolved commands
- **Given** `--behave designFuncTestsSkeleton` with `--diagSlashCommands`
- **When** CLI resolves the behavior to slash commands
- **Then** diagnostic output lists each slash command name and file path in resolution order

---

## Edge (ValidFunc) — Diagnostic boundary

### 【PENDING】AC-03 [Func/Edge]: Both diag flags together — no conflict
- **Given** both `--diagMethodPrompts` and `--diagSlashCommands`
- **When** execution runs
- **Then** both sets of diagnostics appear in stderr
- **And** no overlapping/duplicate lines between them

### 【PENDING】AC-04 [Func/Edge]: No diag flags — no diagnostic output
- **Given** a valid invocation without any `--diag*` flag
- **When** execution completes
- **Then** no DIAG-level messages in stderr

---

## Misuse (InvalidFunc) — Diagnostic misuse

### 【PENDING】AC-05 [Func/Misuse]: `--diagMethodPrompts` with invalid behave
- **Given** `--diagMethodPrompts` and `--behave "nonexistent"`
- **When** validation fails
- **Then** exit 1, stderr: unrecognized behave
- **And** diagnostic output may still show prompt resolution before failure

---

## Fault (InvalidFunc) — Diagnostic failure

### 【PENDING】AC-06 [Func/Fault]: SlashCommands directory missing — diag reports
- **Given** `--diagSlashCommands` with `slashCommands/commands/` missing
- **When** behavior resolution runs
- **Then** exit 1, stderr: slashcommands directory not found
- **And** diag output shows the attempted resolution path