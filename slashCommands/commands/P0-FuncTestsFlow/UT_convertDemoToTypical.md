# UT_convertDemoToTypical

## Purpose

Convert existing demo tests into CaTDD `P0 Functional / Typical` skeletons.

Use this command when a developer has demo tests and wants to convert them into CaTDD instead of starting from a blank template.

## Inputs

- `demo_test_file`: existing demo or example test file.
- `feature_name`: feature or behavior being extracted.
- `target_test_file`: new or existing CaTDD test file to update.
- `language` and `test_framework`: optional context for generated examples.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md)

## Output Contract

- A `P0 Functional / ValidFunc` and `Typical` design skeleton.
- US/AC/TC comments extracted from demo behavior.
- TC names following `verifyBehavior_byCondition_expectResult`.
- Clear notes for behavior that should move to Edge, Misuse, Fault, or another category.

## Prompt Template

Ask the assistant to:

1. Read `demo_test_file` as Stage-0 raw material.
2. Identify the core happy-path behavior demonstrated by the test.
3. Convert that behavior into a Typical design skeleton.
4. Preserve traceability from demo behavior to US/AC/TC.
5. Mark unclear behavior as open questions instead of inventing requirements.

## Conflict Guard

Demo tests are input material. Do not classify them as CaTDD `P3 Demo/Example` unless the goal is documentation-oriented demo coverage.
