# utCodeAgentCLI Verification Design

This document captures module-scoped verification strategy and US/AC/TC traceability for `utCodeAgentCLI`.

## Story and Design Inputs

- Active story: [20260628-utCodeAgentCLI-US-USER-01-UserStory.md](../../.catdd/spec/doingUS/20260628-utCodeAgentCLI-US-USER-01-UserStory.md)
- Active TASKs: [20260628-utCodeAgentCLI-US-USER-01-TASKs.md](../../.catdd/spec/doingUS/20260628-utCodeAgentCLI-US-USER-01-TASKs.md)
- [README_ArchDesign.md](README_ArchDesign.md)
- [README_DetailDesign.md](README_DetailDesign.md)
- [SPEC_designUnitTests.md](../../slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md)
- [UT_designFuncTestsSkeleton.md](../../slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md)
- [CaTDD_designAndImplTemplate.ts](../../methodPrompts/CaTDD_designAndImplTemplate.ts)
- [UT_US-USER-01-Typical.ts](tests/UT_US-USER-01-Typical.ts) — 10 Typical ACs (AC-01~AC-10)
- [UT_US-USER-01-Edge.ts](tests/UT_US-USER-01-Edge.ts) — 10 Edge ACs (AC-11~AC-20)
- [UT_US-USER-01-Misuse.ts](tests/UT_US-USER-01-Misuse.ts) — 9 Misuse ACs (AC-21~AC-28, AC-32)
- [UT_US-USER-01-Fault.ts](tests/UT_US-USER-01-Fault.ts) — 3 Fault ACs (AC-29~AC-31)

## Testing Definition

- SUT: `utCodeAgentCLI`, executed as a subprocess through `src/cli/main.ts` and focused on the CLI argument-validation surface delegated to `src/cli/invocationValidator.ts`.
- UnitTesting verifies command-contract behavior and test-file trace structure at repository file scope.
- ModuleTesting verifies `utCodeAgentCLI` preserves CaTDD method delegation and CLI validation behavior.
- UserTesting remains outside this story unless the CLI execution surface is changed.

## Test Strategy

Design P0 Functional coverage first because `US-USER-01` is a CLI invocation contract story and because this story is applying CaTDD `UT_*` methodology to the `utCodeAgentCLI` UnitTesting surface. P1/P2 categories are deferred because this story does not introduce state, capability, concurrency, performance, robust, compatibility, or configuration behavior.

The redesigned TypeScript UnitTesting files use `UT_designFuncTestsSkeleton` semantics for the full P0 set (32-AC redesign via `SPEC_designUnitTests`):

- Typical (AC-01~AC-10): valid invocation proceeds to behavior dispatch readiness.
- Edge (AC-11~AC-20): valid boundary or mode variation — redesigned from non-required to required.
- Misuse (AC-21~AC-28, AC-32): missing required args, empty string args, mutually exclusive pairs, unrecognized/unparseable values, target/behave mismatch, and structurally wrong config rejected.
- Fault (AC-29~AC-31): missing file-path dependencies, invalid YAML config, and directory-as-config surfaced with diagnostics.

## CaTDD Category Coverage

| Priority | Category | Scope | Required Now | Notes |
| --- | --- | --- | --- | --- |
| P0 | Functional: Typical | Valid invocation success path (AC-01~AC-10) | Yes | Covers `TC-ARG-001..TC-ARG-010` in `UT_US-USER-01-Typical.ts`. |
| P0 | Functional: Edge | Valid boundary or mode variation (AC-11~AC-20) | Yes | Redesigned from non-required to required with 10 Edge ACs in `UT_US-USER-01-Edge.ts`. |
| P0 | Functional: Misuse | Invalid caller argument contract checks (AC-21~AC-28, AC-32) | Yes | Covers `TC-ARG-021..TC-ARG-026` (GREEN) and `TC-ARG-027..TC-ARG-031` (PLANNED) in `UT_US-USER-01-Misuse.ts`. |
| P0 | Functional: Fault | File-path failure handling (AC-29~AC-31) | Yes | Covers `TC-ARG-029..TC-ARG-033` (GREEN) and `TC-ARG-034..TC-ARG-035` (PLANNED) in `UT_US-USER-01-Fault.ts`. |
| P1 | Design: State/Capability/Concurrency | Runtime state or capability design | No | Not introduced by this story. |
| P2 | Quality: Performance/Robust/Compatibility/Configuration | Quality envelopes | No | Not introduced by this story. |

## US/AC/TC Traceability

| US | AC | TC | Test File | Status |
| --- | --- | --- | --- | --- |
| US-USER-01 | AC-01~AC-10 | TC-ARG-001..TC-ARG-010 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts | PLANNED/GREEN |
| US-USER-01 | AC-11~AC-20 | TC-ARG-011..TC-ARG-020 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts | PLANNED |
| US-USER-01 | AC-21 | TC-ARG-021..TC-ARG-023 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | GREEN |
| US-USER-01 | AC-25 | TC-ARG-024 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | GREEN |
| US-USER-01 | AC-23, AC-24 | TC-ARG-025..TC-ARG-026 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | GREEN |
| US-USER-01 | AC-22 | TC-ARG-027 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | PLANNED |
| US-USER-01 | AC-26 | TC-ARG-028 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | PLANNED |
| US-USER-01 | AC-27 | TC-ARG-029 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | PLANNED |
| US-USER-01 | AC-28 | TC-ARG-030 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | PLANNED |
| US-USER-01 | AC-32 | TC-ARG-031 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | PLANNED |
| US-USER-01 | AC-29 | TC-ARG-029..TC-ARG-033 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts | GREEN |
| US-USER-01 | AC-30 | TC-ARG-034 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts | PLANNED |
| US-USER-01 | AC-31 | TC-ARG-035 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts | PLANNED |

## Edge Category Decision

- [UT_US-USER-01-Edge.ts](tests/UT_US-USER-01-Edge.ts) was redesigned from non-required to required with 10 Edge ACs (AC-11~AC-20) to match the 32-AC spec. It now provides TC-ARG-011..TC-ARG-020 skeletons for valid boundary and mode-variation behavior.

## Regression Surface

The existing `US-USER-01` CLI validation tests must remain GREEN after any redesign:

```bash
node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts
```

Expected result: all existing `TC-ARG-001..TC-ARG-012` cases pass and are remapped to the new 32-AC TC numbering scheme (TC-ARG-001..TC-ARG-010 remain Typical, TC-ARG-011..TC-ARG-020 Edge, TC-ARG-021..TC-ARG-031 Misuse, TC-ARG-029..TC-ARG-035 Fault).

All executable `UT_US-USER-01` cases invoke `utCodeAgentCLI` as a subprocess. They do not call `validateInvocation(...)` directly.

## Risks and Deferred Coverage

- Test-file redesign can hide behavior drift unless old `TC-ARG-*` coverage is mapped deliberately.
- Flow documentation currently has separate active edits; implementation must preserve those changes.
- Root `README_VerifyDesign.md` may need to become a repository-wide index after module-specific verification ownership is clarified.

## Review Checklist

- SUT is explicit in the UnitTesting overviews and category skeletons.
- P0 Functional coverage is complete before P1/P2 promotion.
- Every TC traces to `US-USER-01` acceptance criteria.
- Edge is recorded as a non-required category decision rather than dangling AC/TC coverage.
- `UT_designFuncTestsSkeleton` remains design-only.
- TypeScript targets use `CaTDD_designAndImplTemplate.ts`.
- CLI validation behavior remains unchanged.
