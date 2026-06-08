# Issue: clarify why SPEC_designUnitTests is used instead of UT_doXYZ in P0-FuncTestsFlow

Imported via SPEC_importIssue on 2026-06-08.

## Source

WHY call 'SPEC_designUnitTests', not called 'UT_doXYZ' in P0-FuncTestFlow?

## Classification

- Type: clarification / flow-contract question.
- Area: `slashCommands/flows/Px-SpecFlow.md`, `slashCommands/flows/P0-FuncTestsFlow.md`, and SPEC-vs-UT command boundary.
- Severity: P2 - process clarity and teaching quality.

## Observed Behavior

Current execution flow routes story-level orchestration through `SPEC_designUnitTests` before implementation, while concrete category-specific testing actions are represented in `UT_*` commands. This can look inconsistent when reading P0 flow names in isolation.

## Expected Behavior

1. Clarify in flow docs why `SPEC_designUnitTests` is the story-orchestration entry and where `UT_*` commands are expected to be called.
2. Clarify whether a direct `UT_doXYZ` naming pattern should exist or remain intentionally abstract behind `SPEC_designUnitTests`.
3. Ensure command-boundary wording is explicit so users understand when to invoke SPEC vs UT commands.

## Related

- `.catdd/slashCommands/flows/Px-SpecFlow.md`
- `.catdd/slashCommands/flows/P0-FuncTestsFlow.md`
- `.catdd/slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md`

## Next Recommended Command

`/SPEC_analyzeIssue`
