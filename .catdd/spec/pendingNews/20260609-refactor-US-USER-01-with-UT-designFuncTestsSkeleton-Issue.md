# Issue: refactor US-USER-01 test file to follow UT_designFuncTestsSkeleton

Imported via SPEC_importIssue on 2026-06-09.

## Source

refact US-USER-01 of utCodeAgentCLI with UT_designFuncTestsSkeleton

## Classification

- Type: refactor / process-conformance issue.
- Area: `codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts`, `methodPrompts/CaTDD_designAndImplTemplate.ts`, and `slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md`.
- Severity: P2 - improves CaTDD template consistency, command-boundary clarity, and future maintainability.

## Observed Behavior

`codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts` contains valid CaTDD category skeletons and executable GREEN tests for `US-USER-01`, but it does not follow the full `CaTDD_designAndImplTemplate.ts` design+implementation template shape.

The file also does not explicitly show that P0 Functional skeleton design came from `UT_designFuncTestsSkeleton.md`, which can make `SPEC_designUnitTests` and `UT_*` command responsibilities look inconsistent.

## Expected Behavior

1. Preserve the existing tested behavior and `US-USER-01` traceability.
2. Refactor the test file structure so its comment-alive sections align with the design+implementation template shape where appropriate.
3. Make the relationship between `SPEC_designUnitTests` orchestration and `UT_designFuncTestsSkeleton` P0 skeleton design explicit enough for future readers.
4. Keep all existing CLI argument validation tests GREEN after refactor.

## Related

- `codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts`
- `methodPrompts/CaTDD_designAndImplTemplate.ts`
- `slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md`
- `.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-USER-01-UserStory.md`
- `.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-USER-01-TASKs.md`

## Next Recommended Command

`/SPEC_analyzeIssue`