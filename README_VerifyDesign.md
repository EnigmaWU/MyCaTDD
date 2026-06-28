# MyCaTDD Verification Design

This document captures verification strategy and US/AC/TC traceability for active SpecFlow execution slices.

## Story and Design Inputs

- Active story: [.catdd/spec/doneUS/20260628-utCodeAgentCLI-US-USER-01-UserStory.md](.catdd/spec/doneUS/20260628-utCodeAgentCLI-US-USER-01-UserStory.md)
- Active TASKs: [.catdd/spec/doneUS/20260628-utCodeAgentCLI-US-USER-01-TASKs.md](.catdd/spec/doneUS/20260628-utCodeAgentCLI-US-USER-01-TASKs.md)
- Detail design: [codeAgents/utCodeAgentCLI/README_DetailDesign.md](codeAgents/utCodeAgentCLI/README_DetailDesign.md)
- Target test files (32-AC redesign):
  - [codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts](codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts) — 10 Typical ACs (AC-01~AC-10)
  - [codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts](codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts) — 10 Edge ACs (AC-11~AC-20)
  - [codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts](codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts) — 9 Misuse ACs (AC-21~AC-28, AC-32)
  - [codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts](codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts) — 3 Fault ACs (AC-29~AC-31)

## Testing Definition

- UnitTesting verifies behavior at parser/validator function scope.
- ModuleTesting verifies behavior at CLI invocation validation scope.
- UserTesting verifies end-to-end CLI interaction flow.

Rules:

- For this slice, UnitTesting and ModuleTesting are aligned at CLI validation boundary.
- UnitTesting and ModuleTesting both use CaTDD categories.
- UserTesting remains full-flow verification outside category skeleton design.

## Test Strategy

Design P0 Functional coverage first for argument validation because this story is a contract-gate before any runtime behavior dispatch. Tests prioritize fail-fast diagnostics and deterministic success pass-through.

## CaTDD Category Coverage

| Priority | Category | Scope | Required Now | Notes |
| --- | --- | --- | --- | --- |
| P0 | Functional: Typical | Valid invocation success path (AC-01~AC-10) | Yes | Covers `TC-ARG-001..TC-ARG-010` in `UT_US-USER-01-Typical.ts`. |
| P0 | Functional: Edge | Valid boundary or mode variation (AC-11~AC-20) | Yes | Redesigned from non-required to required with 10 Edge ACs in `UT_US-USER-01-Edge.ts`. |
| P0 | Functional: Misuse | Invalid caller argument checks (AC-21~AC-28, AC-32) | Yes | `TC-ARG-021..TC-ARG-026` GREEN, `TC-ARG-027..TC-ARG-031` PLANNED in `UT_US-USER-01-Misuse.ts`. |
| P0 | Functional: Fault | File-path failure handling (AC-29~AC-31) | Yes | `TC-ARG-029..TC-ARG-033` GREEN, `TC-ARG-034..TC-ARG-035` PLANNED in `UT_US-USER-01-Fault.ts`. |
| P1 | Design: State/Capability/Concurrency | Parser/validator internals | No | Defer until runtime state model requires dedicated tests. |
| P2 | Quality: Performance/Robust/Compatibility/Configuration | CLI quality envelopes | No | Defer until executable implementation baseline exists. |

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

## Test Case Design Notes

```text
TC-ARG-004:
  @[Name]: verifyBehaviorList_byUnknownBehave_expectAllValidAlternatives
  @[Category]: Misuse
  @[Purpose]: Ensure unknown behavior values produce deterministic guidance.
  @[Brief]: Invoke parser/validator with invalid --behave and inspect stderr plus exit code.
  @[Expect]: Exit code 1 and list of valid behavior alternatives.
```

## Risks and Deferred Coverage

- Diagnostic wording brittleness -> keep assertions on key phrases and argument names, not entire prose.
- P1 internal-state coverage deferred -> enable once parser/executor state transitions are executable.
- P2 quality coverage deferred -> enable once baseline implementation exists and can be profiled.

## Embedded and Digital Media Verification Points

Embedded software points:

- Hardware interaction tests: not applicable for this CLI story.
- Timing tests: not applicable for this CLI story.
- Resource tests: basic path and config resource checks are covered in P0 Fault.
- Fault injection: missing file paths are modeled as deterministic fault inputs.

digital video/audio points:

- Pipeline tests: not applicable.
- Media quality tests: not applicable.
- Sync tests: not applicable.
- Format tests: not applicable.

## Usage Example

Run from repository root to inspect the designed skeleton file:

```bash
sed -n '1,220p' codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts
```

Expected result: category-specific CaTDD UnitTesting files with `@[US]`, `@[AC]`, `@[TC]`, `@[Category]`, and `@[Status]: GREEN` tags where executable TCs exist.

## Review Checklist

- P0 Functional classification follows the methodPrompts formula: ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault).
- Every TC traces to AC and US-USER-01.
- Deferred coverage reasons are explicit.
