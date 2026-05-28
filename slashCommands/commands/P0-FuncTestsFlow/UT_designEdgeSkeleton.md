# UT_designEdgeSkeleton

## Purpose

Design a CaTDD Edge functional skeleton from valid behavior boundaries and existing Typical coverage.

Use this command after the primary valid behavior is understood and boundary, limit, empty, minimum, maximum, or unusual-but-valid inputs matter.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical skeleton or related valid functional skeletons for consistency.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Edge.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Edge.md)

## Output Contract

- An Edge functional skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that capture valid boundary behavior and unusual-but-supported inputs.
- Explicit separation between Edge coverage and invalid Misuse or Fault coverage.

## Prompt Template

Ask the assistant to:

1. Read the interface or protocol as the behavior source.
2. Read the existing Typical skeleton when available.
3. Use the Edge method prompt as the category source of truth.
4. Draft only the Edge skeleton and preserve unrelated categories.
5. Identify missing boundaries, limits, empty cases, ordering edges, or valid exceptional shapes.
6. Recommend whether to continue to `UT_designMisuseSkeleton` or `UT_reviewFuncTestsSkeleton`.

## Conflict Guard

Use `Edge` as the canonical category name. Treat `Boundary` only as an explanatory alias inside Edge guidance.

ONE-MORE-THING: ask developer if something not sure