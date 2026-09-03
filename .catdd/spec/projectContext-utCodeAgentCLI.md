# utCodeAgentCLI SpecFlow Subproject Context

This file is the team-shared, durable subproject context for `codeAgents/utCodeAgentCLI/`. It refines the repository-wide rules in `projectContext.md` without duplicating lifecycle snapshots.

## Subproject Facts

- Subproject: `utCodeAgentCLI`.
- Path: `codeAgents/utCodeAgentCLI/`.
- Purpose: provide the CaTDD-native CLI execution layer while consuming method semantics from `methodPrompts/` and portable behavior from `slashCommands/`.
- Current implementation: runnable invocation validation and incremental delegation slices; no distributable end-to-end agent binary yet.

## Architecture-Only Design Policy

- `codeAgents/utCodeAgentCLI/README_ArchDesign.md` and its ZH mirror are the sole module design authority.
- Standalone `README_DetailDesign.md`, `README_DetailDesign_ZH.md`, and project-root DetailDesign files created for `utCodeAgentCLI` are forbidden.
- Durable design decisions belong in `codeAgents/utCodeAgentCLI/ADRs/` and must be reflected in ArchDesign.
- User-observable requirements belong in UserStory, UserGuide, and UsageDesign documents.
- Verification strategy and US/AC/TC traceability belong in `README_VerifyDesign.md` and executable tests.
- Exact executable behavior belongs in `src/` and is proved by `tests/`; ArchDesign owns module boundaries, responsibilities, dependency direction, state/control policy, and quality tradeoffs.

Decision source: `codeAgents/utCodeAgentCLI/ADRs/ADR_ArchitectureOnlyDesignPolicy.md`.

## SpecFlow Routing Override

- Initial or changed `utCodeAgentCLI` design routes through `SPEC_takeArchDesign` or `SPEC_updateArchDesign`, followed by `SPEC_reviewArchDesign`.
- Do not route this subproject through `SPEC_takeDetailDesign`, `SPEC_updateDetailDesign`, or `SPEC_reviewDetailDesign` while the architecture-only ADR is active.
- After architecture review passes, use the active story plan to choose requirement review, CaTDD test design, implementation, or closure.
- Historical DetailDesign commands and evidence remain history only; they are not current guidance.

## Canonical Knowledge Routes

| Knowledge | Canonical Source |
| --- | --- |
| Architecture and module design | `codeAgents/utCodeAgentCLI/README_ArchDesign.md` |
| Architecture decisions | `codeAgents/utCodeAgentCLI/ADRs/` |
| Product requirements | `codeAgents/utCodeAgentCLI/README_UserStory.md` and `USs/` |
| Public CLI contract | `codeAgents/utCodeAgentCLI/README_UsageDesign.md` |
| Operational guidance | `codeAgents/utCodeAgentCLI/README_UserGuide.md` |
| Verification and traceability | `codeAgents/utCodeAgentCLI/README_VerifyDesign.md` and `tests/` |
| Executable implementation | `codeAgents/utCodeAgentCLI/SrcTS/` |
| Method semantics | `methodPrompts/` |
| Portable commands | `slashCommands/` |

## Validation Invariants

- No `README_DetailDesign*` file exists under `codeAgents/utCodeAgentCLI/`.
- No project-root `README_DetailDesign.md` exists for a `utCodeAgentCLI` story.
- Current subproject documentation contains no live link to a deleted DetailDesign file.
- English and Chinese ArchDesign heading structures remain aligned.
- Superseding this policy requires a reviewed ADR.

## Lifecycle State

Read live state from `.catdd/spec/todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, and `doneUS/`. Do not store directory snapshots or next-task recommendations in this subproject context.

## Open Questions

- None.
