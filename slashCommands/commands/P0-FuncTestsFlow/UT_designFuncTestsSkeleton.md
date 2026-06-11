# UT_designFuncTestsSkeleton

## Purpose

Design the complete P0 Functional CaTDD skeleton set: Typical, Edge, Misuse, and Fault.

Use this command when a developer wants the full functional skeleton set from one interface, protocol, existing draft, or behavior contract before implementation begins.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
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

- A complete P0 Functional skeleton set with Typical, Edge, Misuse, and Fault sections.
- Category-specific `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]` entries.
- Traceability cardinality gate: each `@[US]` has >=1 linked `@[AC]`, and each `@[AC]` has >=1 linked `@[TC]`.
- Explicit SUT declaration in the test-file overview (for example: `SUT: utCodeAgentCLI`).
- No executable implementation test code.

## Prompt Template

Ask the assistant to:

1. Read the interface or protocol as the behavior source.
2. Use the P0 category method prompts as the category source of truth.
3. Draft or update the Typical skeleton first.
4. Draft or update the Edge, Misuse, and Fault skeletons in that order.
5. Preserve existing skeletons and avoid rewriting unrelated categories.
6. List missing information as questions or assumptions.
7. Recommend whether to continue to `UT_reviewFuncTestsSkeleton` before implementation.

## Conflict Guard

This command designs P0 Functional coverage only. It should not design P1/P2 categories or implement tests.
Do not leave partially mapped skeletons where any US lacks AC links or any AC lacks TC links.

ONE-MORE-THING: ask developer if something not sure