# TEST_designEdgeSkeleton

## Metaspec Workspace

Before reading or writing any SpecCoding artifact, follow [Metaspec Workspace Resolution](../../MetaspecWorkspaceResolution.md). Use `projectContext.md` to declare or retrieve `metaspec_root`; supported roots are `.catdd/metaspec`, `.agents/metaspec`, and legacy `.catdd/spec`.

## Purpose

Design a CaTDD Edge functional skeleton from valid behavior boundaries and existing Typical coverage.

Use this command after the primary valid behavior is understood and boundary, limit, empty, minimum, maximum, or unusual-but-valid inputs matter.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must read the behavior source and the existing Typical skeleton, draft boundary coverage, and check that every case it captured is still **valid** input — the moment a case is invalid, it belongs to Misuse or Fault, not Edge.

### ReACT Execution

Repeat until the Edge skeleton holds only valid boundary behavior.

1. **Thought** — Read `interface_or_protocol_file` and the existing Typical skeleton. Using the Edge method prompt as the category source of truth, identify missing boundaries, limits, empty cases, ordering edges, and valid exceptional shapes.
2. **Action** — Draft only the Edge skeleton with the full `@[...]` metadata set. Preserve unrelated categories untouched.
3. **Observation** — Check validity: every Edge case must be input the contract *accepts*. A case the contract rejects belongs to Misuse; a case caused by a dependency belongs to Fault → back to **Thought** and hand it over. Check the [US/AC/TP/TC cardinality](../../../methodPrompts/CaTDD_methodPrompt-testStructure.md#usactptc-contract) for the declared scope; unassigned TPs block completion.
4. **Stop** — Exit when all cases are valid boundaries and the cardinality check passes. Recommend `TEST_designMisuseSkeleton` or `TEST_reviewFuncTestsSkeleton`.

### Worked Example

Adding boundary coverage on top of Typical. IDs below are abbreviated; generated artifacts use registered Story IDs and qualified AC/TP/TC IDs.

```text
/TEST_designEdgeSkeleton
interface_or_protocol_file: services/payment/gatewayPort.h
feature_name: payment authorization
existing_skeletons: Typical (US-01, AC-01, AC-02)
```

Expected result:

- **Thought**: contract accepts amounts in `[1, 999999]` → boundaries at 1 and 999999. Also an empty optional metadata map, which the contract accepts.
- **Action**: US-02 drafted with AC-03 (minimum amount), AC-04 (maximum amount), AC-05 (empty metadata), each with one TP mapped to exactly one TC.
- **Observation**: a fourth case "amount = 0" was drafted — but the contract *rejects* 0, so it is invalid input → not Edge → back to **Thought** → handed to `TEST_designMisuseSkeleton`.
- **Observation**: remaining three ACs cover accepted inputs, each has a TP, every TP maps to exactly one TC, and every TC covers a TP; cardinality passes.
- **Stop**: Edge holds valid boundaries only. Recommended `TEST_designMisuseSkeleton`.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical skeleton or related valid functional skeletons for consistency.

## Method References

- [P0-FuncTestsFlow](../../flows/P0-FuncTestsFlow.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)
- [CaTDD_methodPrompt4Cat-Edge](../../../methodPrompts/CaTDD_methodPrompt4Cat-Edge.md)

## Output Contract

- An Edge functional skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, `@[TP]`, and `@[TC]`.
- US/AC/TP/TC entries that capture valid boundary behavior and unusual-but-supported inputs.
- Explicit separation between Edge coverage and invalid Misuse or Fault coverage.

## Conflict Guard

Use `Edge` as the canonical category name. Treat `Boundary` only as an explanatory alias inside Edge guidance.

ONE-MORE-THING: ask developer if something not sure