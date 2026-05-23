# {{ProjectName}} Verification Design

This is the SpecCoding template for project-root `README_VerifyDesign.md`. Create or update it from `SPEC_designUnitTests` when test strategy, CaTDD category coverage, US/AC/TC traceability, or target test files change.

## Story and Design Inputs

- Story: {{US identifier and title}}
- Detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Active story artifact: {{.catdd/spec/doingUS path}}
- Target test files: {{test file paths}}

## Testing Definition

- **UnitTesting**: verifies behavior at subPackage/subModule/Class/function scope.
- **ModuleTesting**: verifies behavior at module-level Package/Service/Interface scope.
- **UserTesting**: verifies end-to-end user flow with demo/examples.

Rules:

- If the module is simple, treat `UnitTesting == ModuleTesting`.
- If the module is complex, keep `UnitTesting` at sub-level scope and `ModuleTesting` at module-level scope.
- `UnitTesting` and `ModuleTesting` both use CaTDD categories.
- `UserTesting` is not CaTDD category testing; it is full-flow verification.

## Test Strategy

{{Describe how tests verify the story and which risks they reduce.}}

## CaTDD Category Coverage

| Priority | Category | Scope | Required Now | Notes |
| --- | --- | --- | --- | --- |
| P0 | Functional: Typical | {{Scope}} | {{Yes/No}} | {{Notes}} |
| P0 | Functional: Edge | {{Scope}} | {{Yes/No}} | {{Notes}} |
| P0 | Functional: Misuse | {{Scope}} | {{Yes/No}} | {{Notes}} |
| P0 | Functional: Fault | {{Scope}} | {{Yes/No}} | {{Notes}} |
| P1 | Design: State/Capability/Concurrency | {{Scope}} | {{Yes/No}} | {{Notes}} |
| P2 | Quality: Performance/Robust/Compatibility/Configuration | {{Scope}} | {{Yes/No}} | {{Notes}} |

## US/AC/TC Traceability

| US | AC | TC | Test File | Status |
| --- | --- | --- | --- | --- |
| US-{{n}} | AC-{{n}} | TC-{{n}} | {{path/to/test}} | {{RED/GREEN/REVIEWED}} |

## Test Case Design Notes

```text
TC-{{n}}:
  @[Name]: {{test name}}
  @[Purpose]: {{what this verifies}}
  @[Brief]: {{setup, behavior, verify, cleanup}}
  @[Expect]: {{observable expected result}}
```

## Risks and Deferred Coverage

- {{Risk}} -> {{Coverage now or deferred reason}}

## Embedded and Digital Media Verification Points

Embedded software points:

- Hardware interaction tests: {{register/HAL/peripheral behavior to verify}}
- Timing tests: {{ISR latency, watchdog window, timeout, jitter, RTOS scheduling}}
- Resource tests: {{static RAM, stack, heap, DMA buffer, cache coherency}}
- Fault injection: {{bus error, brownout, timeout, reset, overrun, underrun}}

digital video/audio points:

- Pipeline tests: {{decode/render/capture/playback stage to verify}}
- Media quality tests: {{frame drop, audio underrun, stutter, artifact, glitch}}
- Sync tests: {{A/V sync drift, timestamp discontinuity, seek/flush behavior}}
- Format tests: {{codec, resolution, frame rate, sample rate, channel layout}}

## Usage Example

Run from the repository root to instantiate this verification-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_VerifyDesign.md"
cp slashCommands/templates/README_VerifyDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows verification strategy, CaTDD category coverage, and US/AC/TC traceability sections.

## Review Checklist

- P0 Functional coverage is addressed before P1/P2 promotion.
- Every test case traces to an AC and story.
- Deferred coverage has an explicit reason and owner.
