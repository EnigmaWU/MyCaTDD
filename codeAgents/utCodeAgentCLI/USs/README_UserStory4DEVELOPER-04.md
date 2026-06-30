# US-DEV-04 [P2] — Runtime adapter interface

**As a** DEVELOPER, **I want** the CLI's slash-command execution backend to be replaceable through a documented adapter interface, **so that** `utCodeAgentCLI` can run on top of Copilot-native, OpenCode, or custom agent runtimes without rewriting the CLI core.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-02 | 2 | Normal adapter |
| Edge | ValidFunc | AC-03 | 1 | Adapter boundary |
| Misuse | InvalidFunc | AC-04 | 1 | Adapter misuse |
| Fault | InvalidFunc | AC-05 | 1 | Adapter failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 2 | 0 | 0 | 0 | 0 | 0 | 2 |
| Edge | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| Misuse | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| Fault | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| **Total** | **5** | **0** | **0** | **0** | **0** | **0** | **5** |

---

## Typical (ValidFunc) — Normal adapter

### 【PENDING】AC-01 [Func/Typical]: Adapter conforms to defined interface
- **Given** a runtime adapter implementing the `CliRuntimeAdapter` interface
- **When** CLI needs to invoke a slash command
- **Then** it calls the adapter's `invoke(slashCommand, context)` method
- **And** adapter receives resolved command path, target, source, and goal context
- **And** CLI does not assume any specific runtime (TypeScript, Python, shell)

### 【PENDING】AC-02 [Func/Typical]: Default adapter provided
- **Given** no custom adapter is configured
- **When** CLI runs
- **Then** built-in default adapter executes slash commands directly

---

## Edge (ValidFunc) — Adapter boundary

### 【PENDING】AC-03 [Func/Edge]: Custom adapter path set via config
- **Given** `--config-file` specifies a custom adapter path
- **When** CLI loads config
- **Then** uses the custom adapter instead of default
- **And** invocation result matches the custom adapter's behavior

---

## Misuse (InvalidFunc) — Adapter misuse

### 【PENDING】AC-04 [Func/Misuse]: Custom adapter does not implement required interface
- **Given** custom adapter path specified but module lacks required methods
- **When** CLI attempts to invoke
- **Then** exit 1, stderr: adapter does not implement CliRuntimeAdapter

---

## Fault (InvalidFunc) — Adapter failure

### 【PENDING】AC-05 [Func/Fault]: Custom adapter entry point not found
- **Given** custom adapter path configured but file not found
- **When** CLI attempts to load adapter
- **Then** exit 1, stderr: adapter module not found