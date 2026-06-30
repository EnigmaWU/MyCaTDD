# User Story: utCodeAgentCLI INVENTOR US-INVENTOR-01 Delegate all CaTDD semantics to methodPrompts

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4INVENTOR.md` slice `US-INVENTOR-01`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4INVENTOR.md](../../codeAgents/utCodeAgentCLI/README_UserStory4INVENTOR.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-INVENTOR-01 [P0]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As an INVENTOR,
I want the CLI to own zero CaTDD method knowledge,
so that I can evolve categories, discipline rules, and prompt contracts without touching or re-releasing the CLI.

## Independent Test Intent

A reviewer can inspect CLI resolution behavior and verify that category meaning and command behavior are delegated to methodPrompts and slashCommands rather than hardcoded in the CLI.

## Acceptance Criteria

#### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | ✅ Delegation works |
| Edge | ValidFunc | AC-05 ~ AC-08 | 4 | ✅ Delegation boundary |
| Misuse | InvalidFunc | AC-09 ~ AC-12 | 4 | ❌ Delegation contract |
| Fault | InvalidFunc | AC-13 ~ AC-16 | 4 | ❌ Missing dependencies |

---

### Typical (ValidFunc) — Delegation works

##### AC-01 [Func/Typical]: Category resolved from methodPrompts at runtime
- **Given** CLI needs Edge category meaning
- **When** `--behave designEdgeSkeleton` executes
- **Then** exit 0, `--diagMethodPrompts` shows resolved prompt path, generated TC follows Edge semantics

##### AC-02 [Func/Typical]: Behavior delegates to slashCommands
- **Given** CLI resolves `--behave designFuncTestsSkeleton`
- **When** it executes
- **Then** exit 0, `--diagSlashCommands` shows resolved command path

##### AC-03 [Func/Typical]: Output artifacts from delegated layers
- **Given** any invocation modifying a test file
- **When** `@[US]`, `@[AC]`, `@[TC]`, `@[Category]`, `@[Status]` appear
- **Then** diag flags show delegation chain, no "inline" source

##### AC-04 [Func/Typical]: Both diag flags reveal full delegation trace
- **Given** both `--diagMethodPrompts` and `--diagSlashCommands`
- **When** execution completes
- **Then** stderr shows prompt file reads and command invocation

### Edge (ValidFunc) — Delegation boundary

##### AC-05 [Func/Edge]: Empty methodPrompt detected and fails
- **Given** a methodPrompt file is empty (0 bytes)
- **When** CLI resolves that category
- **Then** exit 1, stderr reports empty file, no hardcoded fallback

##### AC-06 [Func/Edge]: Empty slashCommand detected and fails
- **Given** a slashCommand file is empty
- **When** CLI invokes that command
- **Then** exit 1, stderr reports empty command, no inline logic substituted

##### AC-07 [Func/Edge]: Multiple prompts resolve independently
- **Given** CLI needs category + status + priority meanings
- **When** `--diagMethodPrompts` enabled
- **Then** stderr shows three distinct prompt file resolutions

##### AC-08 [Func/Edge]: Updated prompt picked up without CLI change
- **Given** methodPrompt updated with new constraint
- **When** CLI runs after update
- **Then** output reflects new content, no cached version used

### Misuse (InvalidFunc) — Delegation contract

##### AC-09 [Func/Misuse]: Prompt deleted at runtime — CLI fails
- **Given** required prompt file deleted between start and resolution
- **When** CLI needs that category
- **Then** exit 1, stderr reports missing file

##### AC-10 [Func/Misuse]: slashCommand deleted at runtime — CLI fails
- **Given** behavior resolves to a command file then deleted
- **When** CLI attempts to read
- **Then** exit 1, stderr reports missing command, no fallback

##### AC-11 [Func/Misuse]: Symlink escapes methodPrompts/ directory
- **Given** prompt file is a symlink outside `methodPrompts/`
- **When** CLI resolves
- **Then** exit 1, stderr reports symlink escape

##### AC-12 [Func/Misuse]: Circular slashCommand reference
- **Given** slashCommand includes self-reference
- **When** CLI processes
- **Then** exit 1, stderr: circular reference detected

### Fault (InvalidFunc) — Missing dependencies

##### AC-13 [Func/Fault]: `methodPrompts/` directory missing
- **Given** directory does not exist
- **When** CLI resolves any category
- **Then** exit 1, stderr: methodPrompts/ not found

##### AC-14 [Func/Fault]: Prompt file unreadable
- **Given** file exists but no read permission
- **When** CLI reads
- **Then** exit 1, stderr: permission error

##### AC-15 [Func/Fault]: `slashCommands/commands/` directory missing
- **Given** directory does not exist
- **When** CLI resolves behavior
- **Then** exit 1, stderr: directory not found

##### AC-16 [Func/Fault]: slashCommand path is a directory
- **Given** resolved path is a directory, not file
- **When** CLI reads
- **Then** exit 1, stderr: path is a directory, expected command file

## Scope

In scope:

- Delegation of CaTDD semantics.
- Hardcoded-method avoidance.
- Traceable artifact generation.

Out of scope:

- CLI behavior implementation details outside delegation rules.
- New category definitions.
- Runtime adapter policy.

## Risks

- Hardcoded semantics would make the CLI stale when CaTDD evolves.
- Duplicate logic across CLI and prompts would create drift.
- Unclear delegation boundaries would make maintenance harder.

## Assumptions

- `methodPrompts/` remains the source of truth for CaTDD meaning.
- Portable commands remain the source of truth for behavior execution.
- The CLI should be thin orchestration only.

## Acceptance Questions

- Should the CLI ever cache method semantics locally for performance?
- What diagnostics should prove delegation happened?
- How should version drift between CLI and methodPrompts be reported?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
