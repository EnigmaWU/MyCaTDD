# UT_designTypicalSkeleton

## Purpose

Design a CaTDD Typical functional skeleton from an interface, protocol, existing draft, or behavior contract.

Use this command when a developer has a defined behavior source and wants to specify the primary valid behavior before implementation.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: optional related skeletons for consistency.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md)

## Output Contract

- A Typical functional skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that capture the primary valid behavior and expected success path.
- Explicit separation from Edge, Misuse, Fault, and later-category coverage.

## Prompt Template

Ask the assistant to:

1. Read the interface or protocol as the behavior source.
2. Use the Typical method prompt as the category source of truth.
3. Draft only the Typical skeleton and preserve unrelated categories.
4. Identify the main valid behavior, normal preconditions, and expected outcomes.
5. Recommend whether to continue to `UT_designEdgeSkeleton` or `UT_reviewFuncTestsSkeleton`.

## Conflict Guard

This command designs Typical coverage only. It should not design Edge, Misuse, Fault, or implementation test code.

ONE-MORE-THING: ask developer if something not sure