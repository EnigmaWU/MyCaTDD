# UT_designCatSkeleton

## Purpose

Design a CaTDD category skeleton from an interface, protocol, existing draft, or neighboring category skeleton.

Use this command with `Cat=Typical` when a developer has a defined interface or protocol and wants to design the first functional skeleton before implementation.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `Cat`: `Typical`, `Edge`, `Misuse`, or `Fault` for P0 FuncTestsFlow.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: optional related skeletons for consistency.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Edge.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Edge.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Misuse.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Misuse.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Fault.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Fault.md)

## Output Contract

- A category-specific design skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries appropriate for the selected `Cat`.
- Explicit separation between valid functional categories and invalid functional categories.

## Prompt Template

Ask the assistant to:

1. Read the interface or protocol as the behavior source.
2. Select the category method prompt that matches `Cat`.
3. Draft only the skeleton for that category.
4. Preserve existing skeletons and avoid rewriting unrelated categories.
5. List missing information as questions or assumptions.

## Conflict Guard

Use `Edge` as the canonical category name. Treat `Boundary` only as an explanatory alias inside Edge guidance.
