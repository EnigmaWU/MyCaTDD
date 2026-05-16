# P2 QualityTestsFlow

`P2 QualityTestsFlow` is the third slash-command flow priority. It starts when functional and design behavior are stable enough to test quality attributes.

## Method Alignment

Slash flow `P2 QualityTestsFlow` uses the same priority as CaTDD method category `P2 Quality`:

- Performance
- Robust
- Compatibility
- Configuration

The flow commands orchestrate execution; category meaning remains in `methodPrompts`.

## Entry Conditions

- P0 functional coverage exists.
- P1 design coverage exists when relevant.
- The component has quality risks, service-level goals, compatibility requirements, or configuration variations.

## Future Command Candidates

- `UT_designPerformanceSkeleton`
- `UT_designRobustSkeleton`
- `UT_designCompatibilitySkeleton`
- `UT_designConfigurationSkeleton`
- `UT_reviewQualityTestsSkeleton`

## Conflict Guard

QualityTestsFlow must reference `methodPrompts/CaTDD_methodPrompt4Cat-Performance.md`, `Robust.md`, `Compatibility.md`, and `Configuration.md` instead of redefining those category meanings here.
