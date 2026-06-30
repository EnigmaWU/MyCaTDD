# US-DEV-03 [P1] — Interactive per-command confirmation

**As a** DEVELOPER, **I want** to preview each slash command before it runs, **so that** I can approve, skip, or abort multi-step invocations without blind execution.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-02 | 2 | Normal interactive |
| Edge | ValidFunc | AC-03 ~ AC-04 | 2 | Interactive boundary |
| Misuse | InvalidFunc | AC-05 | 1 | Interactive misuse |
| Fault | InvalidFunc | AC-06 | 1 | Interactive failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Edge | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Misuse | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| Fault | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| **Total** | **6** | **0** | **0** | **0** | **0** | **0** | **6** |

---

## Typical (ValidFunc) — Normal interactive

### 【PENDING】AC-01 [Func/Typical]: Each slash command prompts before execution
- **Given** `--behave designAndImplTest` with `--interactive-slash-commands`
- **When** CLI resolves a slash command
- **Then** stdout prompts: "Execute <command> on <target>? [y/n/s(kip)/a(bort)]"
- **And** CLI waits for input before proceeding

### 【PENDING】AC-02 [Func/Typical]: Abort stops all further execution
- **Given** interactive session with multiple pending slash commands
- **When** user inputs "a" (abort) at any prompt
- **Then** no further commands execute
- **And** CLI exits with code 1
- **And** trace records which commands were skipped

---

## Edge (ValidFunc) — Interactive boundary

### 【PENDING】AC-03 [Func/Edge]: Skip skips one command, proceeds to next
- **Given** multiple pending commands
- **When** user inputs "s" (skip)
- **Then** current command skipped
- **And** next command receives prompt

### 【PENDING】AC-04 [Func/Edge]: Not interactive mode — no prompts
- **Given** `--behave designAndImplTest` without `--interactive-slash-commands`
- **When** CLI executes
- **Then** no prompts appear
- **And** all commands execute automatically

---

## Misuse (InvalidFunc) — Interactive misuse

### 【PENDING】AC-05 [Func/Misuse]: Invalid input at prompt
- **Given** interactive prompt waiting
- **When** user inputs "x" (not y/n/s/a)
- **Then** stderr: invalid choice, prompt again
- **And** CLI does not proceed until valid input received

---

## Fault (InvalidFunc) — Interactive failure

### 【PENDING】AC-06 [Func/Fault]: stdin not available in non-interactive CI
- **Given** CI environment with no stdin
- **When** CLI attempts to read input
- **Then** exit 1, stderr: no stdin available, use non-interactive mode