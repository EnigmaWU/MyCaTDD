# US-INVENTOR-01 [P0] — Delegate all CaTDD semantics to methodPrompts

**As an** INVENTOR, **I want** the CLI to own zero CaTDD method knowledge, **so that** I can evolve categories, discipline rules, and prompt contracts without touching or re-releasing the CLI.

## Runtime Delegation Contract

- Resolve and read required `methodPrompts/` and `slashCommands/` assets fresh during every CLI invocation. Invocation-local reuse is allowed only after the current invocation reads the source; persistent semantic caching across invocations is not allowed.
- Make resolved paths, current source content, and ordered `prompt-read` and `command-invocation` events available to structured run-plan or fake-runtime capture. US-INVENTOR-03 owns flag-controlled CLI diagnostic rendering.
- Fail explicitly when a required asset is missing, empty, unreadable, outside its configured root, or the wrong file kind. Never substitute hardcoded CaTDD semantics.
- Method/CLI version negotiation and version-drift detection are deferred to a future compatibility story.
- [README_UserStoryStatus.md](../README_UserStoryStatus.md) is the authoritative AC lifecycle dashboard for this module.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
| --- | --- | --- | --- | --- |
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | Delegation works |
| Edge | ValidFunc | AC-07 ~ AC-08 | 2 | Delegation boundary |
| Misuse | InvalidFunc | AC-11 ~ AC-12 | 2 | Rejected caller/configured topology |
| Fault | InvalidFunc | AC-05 ~ AC-06, AC-09 ~ AC-10, AC-13 ~ AC-16 | 8 | Dependency failures |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Typical | 0 | 4 | 0 | 0 | 0 | 0 | 4 |
| Edge | 0 | 2 | 0 | 0 | 0 | 0 | 2 |
| Misuse | 0 | 2 | 0 | 0 | 0 | 0 | 2 |
| Fault | 0 | 8 | 0 | 0 | 0 | 0 | 8 |
| **Total** | **0** | **16** | **0** | **0** | **0** | **0** | **16** |

---

## Typical (ValidFunc) — Delegation succeeds normally

### 【TODO】AC-01 [Func/Typical]: Category resolved from methodPrompts at runtime
- **Given** CLI needs Edge category meaning
- **When** `--behave designEdgeSkeleton` is prepared for a fake runtime
- **Then** captured run input contains the path and current source content of `CaTDD_methodPrompt4Cat-Edge.md`

### 【TODO】AC-02 [Func/Typical]: Behavior delegates to slashCommands
- **Given** CLI resolves `--behave designFuncTestsSkeleton`
- **When** the prepared step executes through a fake runtime
- **Then** structured capture records the resolved `UT_designFuncTestsSkeleton.md` path and its `command-invocation` event

### 【TODO】AC-03 [Func/Typical]: Run input comes from delegated assets
- **Given** an invocation requires CaTDD method and command content
- **When** its run plan is captured before execution
- **Then** captured content comes from the resolved assets, with no inline semantic fallback supplied by CLI code

### 【TODO】AC-04 [Func/Typical]: Structured events preserve delegation order
- **Given** a run requires method prompts and a slash command
- **When** the run executes through a fake runtime
- **Then** structured capture records each resolved path and all `prompt-read` events before the `command-invocation` event

---

## Edge (ValidFunc) — Delegation boundary

### 【TODO】AC-07 [Func/Edge]: Multiple prompts resolve independently
- **Given** CLI needs Edge category meaning, test status structure, and default execution order
- **When** method-prompt resolution runs
- **Then** structured capture records independent `prompt-read` events for `CaTDD_methodPrompt4Cat-Edge.md`, `CaTDD_methodPrompt-testStructure.md`, and `CaTDD_methodPrompt-workflow.md`

### 【TODO】AC-08 [Func/Edge]: Updated prompt picked up without CLI change
- **Given** `CaTDD_methodPrompt4Cat-Edge.md` is updated with a sentinel after one invocation completes
- **When** the next invocation is prepared for a fake runtime
- **Then** captured run input contains the sentinel from current source content rather than content retained by a persistent cross-invocation cache

---

## Misuse (InvalidFunc) — Delegation contract

### 【TODO】AC-11 [Func/Misuse]: Symlink escapes methodPrompts/
- **Given** caller/configuration selects a prompt candidate that is a symlink outside the configured `methodPrompts/` root
- **When** CLI resolves
- **Then** exit 1, stderr: symlink escape

### 【TODO】AC-12 [Func/Misuse]: SlashCommand escapes configured root
- **Given** caller/configuration selects a slash-command symlink or path outside the configured `slashCommands/` root
- **When** CLI canonicalizes the resolved command path
- **Then** exit 1, stderr reports a configured-root escape, and no command content is read or invoked

---

## Fault (InvalidFunc) — Missing dependencies

### 【TODO】AC-05 [Func/Fault]: Empty methodPrompt dependency
- **Given** a valid invocation requires a methodPrompt dependency that is empty (0 bytes)
- **When** CLI resolves that category
- **Then** exit 1, stderr reports empty file, no hardcoded fallback

### 【TODO】AC-06 [Func/Fault]: Empty slashCommand dependency
- **Given** a valid invocation resolves a slashCommand dependency that is empty
- **When** CLI invokes
- **Then** exit 1, stderr reports empty command, no inline logic substituted

### 【TODO】AC-09 [Func/Fault]: Prompt deleted at runtime
- **Given** a valid invocation selects a required prompt dependency that is deleted before read
- **When** CLI needs that category
- **Then** exit 1, stderr reports missing file, no hardcoded fallback

### 【TODO】AC-10 [Func/Fault]: slashCommand deleted at runtime
- **Given** a valid invocation resolves a slashCommand dependency that is deleted before read
- **When** CLI attempts to read
- **Then** exit 1, stderr reports missing command, no inline logic substituted

### 【TODO】AC-13 [Func/Fault]: `methodPrompts/` directory missing
- **Given** directory does not exist
- **When** CLI resolves any category
- **Then** exit 1, stderr: methodPrompts/ not found

### 【TODO】AC-14 [Func/Fault]: Prompt file unreadable
- **Given** file exists but no read permission
- **When** CLI reads
- **Then** exit 1, stderr: permission error

### 【TODO】AC-15 [Func/Fault]: `slashCommands/commands/` directory missing
- **Given** directory does not exist
- **When** CLI resolves behavior
- **Then** exit 1, stderr: directory not found

### 【TODO】AC-16 [Func/Fault]: slashCommand path is a directory
- **Given** resolved path is a directory
- **When** CLI reads
- **Then** exit 1, stderr: path is a directory
