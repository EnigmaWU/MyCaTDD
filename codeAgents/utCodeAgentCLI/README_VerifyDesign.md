# utCodeAgentCLI Verification Design

This document captures module-scoped verification strategy and US/AC/TC traceability for `utCodeAgentCLI`.

## Story and Design Inputs

- Active story: [../../.catdd/spec/doingUS/20260609-align-SPEC-designUnitTests-with-UT-designFuncTestsSkeleton-UserStory.md](../../.catdd/spec/doingUS/20260609-align-SPEC-designUnitTests-with-UT-designFuncTestsSkeleton-UserStory.md)
- Active TASKs: [../../.catdd/spec/doingUS/20260609-align-SPEC-designUnitTests-with-UT-designFuncTestsSkeleton-TASKs.md](../../.catdd/spec/doingUS/20260609-align-SPEC-designUnitTests-with-UT-designFuncTestsSkeleton-TASKs.md)
- Architecture: [README_ArchDesign.md](README_ArchDesign.md)
- Detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related command: [../../slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md](../../slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md)
- Related command: [../../slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md](../../slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md)
- Related template: [../../methodPrompts/CaTDD_designAndImplTemplate.ts](../../methodPrompts/CaTDD_designAndImplTemplate.ts)
- Typical UnitTesting file: [tests/UT_US-USER-01-Typical.ts](tests/UT_US-USER-01-Typical.ts)
- Edge UnitTesting file: [tests/UT_US-USER-01-Edge.ts](tests/UT_US-USER-01-Edge.ts)
- Misuse UnitTesting file: [tests/UT_US-USER-01-Misuse.ts](tests/UT_US-USER-01-Misuse.ts)
- Fault UnitTesting file: [tests/UT_US-USER-01-Fault.ts](tests/UT_US-USER-01-Fault.ts)

## Testing Definition

- UnitTesting verifies command-contract behavior and test-file trace structure at repository file scope.
- ModuleTesting verifies `utCodeAgentCLI` preserves CaTDD method delegation and CLI validation behavior.
- UserTesting remains outside this story unless the CLI execution surface is changed.

## Test Strategy

Design P0 Functional coverage first because `US-USER-01` is a CLI invocation contract story and because this story is applying CaTDD `UT_*` methodology to the `utCodeAgentCLI` UnitTesting surface. P1/P2 categories are deferred because this story does not introduce state, capability, concurrency, performance, robust, compatibility, or configuration behavior.

The redesigned TypeScript UnitTesting files use `UT_designFuncTestsSkeleton` semantics for the full P0 set:

- Typical: valid invocation proceeds to behavior dispatch readiness.
- Edge: explicitly present as a design skeleton with no required TC for `US-USER-01` because no valid edge behavior is specified.
- Misuse: missing required args, unknown `--behave`, and mutually exclusive flag pairs are rejected.
- Fault: missing file-path dependencies are surfaced with path-level diagnostics.

## CaTDD Category Coverage

| Priority | Category | Scope | Required Now | Notes |
| --- | --- | --- | --- | --- |
| P0 | Functional: Typical | Valid invocation success path | Yes | Covers `TC-ARG-005` in `UT_US-USER-01-Typical.ts`. |
| P0 | Functional: Edge | Valid boundary or mode variation | No | Skeleton present in `UT_US-USER-01-Edge.ts`; no valid edge scenario is specified in `US-USER-01`. |
| P0 | Functional: Misuse | Invalid caller argument contract checks | Yes | Covers `TC-ARG-001..TC-ARG-004`, `TC-ARG-006..TC-ARG-007` in `UT_US-USER-01-Misuse.ts`. |
| P0 | Functional: Fault | File-path failure handling | Yes | Covers `TC-ARG-008..TC-ARG-012` in `UT_US-USER-01-Fault.ts`. |
| P1 | Design: State/Capability/Concurrency | Runtime state or capability design | No | Not introduced by this story. |
| P2 | Quality: Performance/Robust/Compatibility/Configuration | Quality envelopes | No | Not introduced by this story. |

## US/AC/TC Traceability

| US | AC | TC | Test File | Status |
| --- | --- | --- | --- | --- |
| US-USER-01 | AC-05 | TC-ARG-005 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts | GREEN |
| US-USER-01 | AC-01 | TC-ARG-001 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | GREEN |
| US-USER-01 | AC-01 | TC-ARG-002 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | GREEN |
| US-USER-01 | AC-01 | TC-ARG-003 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | GREEN |
| US-USER-01 | AC-03 | TC-ARG-004 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | GREEN |
| US-USER-01 | AC-02 | TC-ARG-006 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | GREEN |
| US-USER-01 | AC-02 | TC-ARG-007 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts | GREEN |
| US-USER-01 | AC-04 | TC-ARG-008 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts | GREEN |
| US-USER-01 | AC-04 | TC-ARG-009 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts | GREEN |
| US-USER-01 | AC-04 | TC-ARG-010 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts | GREEN |
| US-USER-01 | AC-04 | TC-ARG-011 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts | GREEN |
| US-USER-01 | AC-04 | TC-ARG-012 | codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts | GREEN |

## Regression Surface

The existing `US-USER-01` CLI validation tests must remain GREEN after any redesign:

```bash
node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts
```

Expected result: all existing `TC-ARG-001..TC-ARG-012` cases pass. Any future replacement TC set must be explicitly trace-equivalent and still cover AC-01..AC-05.

## Risks and Deferred Coverage

- Test-file redesign can hide behavior drift unless old `TC-ARG-*` coverage is mapped deliberately.
- Flow documentation currently has separate active edits; implementation must preserve those changes.
- Root `README_VerifyDesign.md` may need to become a repository-wide index after module-specific verification ownership is clarified.

## Review Checklist

- P0 Functional coverage is complete before P1/P2 promotion.
- Every TC traces to `US-USER-01` acceptance criteria.
- `UT_designFuncTestsSkeleton` remains design-only.
- TypeScript targets use `CaTDD_designAndImplTemplate.ts`.
- CLI validation behavior remains unchanged.
