# UT_designFuncTestsSkeleton

## Purpose

Design the complete P0 Functional CaTDD skeleton set: Typical, Edge, Misuse, and Fault.

Use this command when a developer wants the full functional skeleton set from one interface, protocol, existing draft, or behavior contract before implementation begins.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must read the behavior source, draft one category skeleton at a time, and check each draft against the traceability cardinality gate before moving on. The loop exists because a category often reveals ACs the previous category missed.

### ReACT Execution

Repeat per category in order — Typical, then Edge, Misuse, Fault.

1. **Thought** — Read `interface_or_protocol_file` as the behavior source and the matching category method prompt as the category source of truth. Decide which behaviors belong to this category and not another.
2. **Action** — Draft or update that one category skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, `@[TC]`. Preserve existing skeletons; never rewrite an unrelated category.
3. **Observation** — Apply the cardinality gate: every `@[US]` has ≥1 `@[AC]`, every `@[AC]` has ≥1 `@[TC]`. A dangling US or AC returns to **Action**. A behavior that belongs to a different category returns to **Thought** and is moved, not duplicated.
4. **Stop** — Exit when all four categories pass the gate and the SUT is declared. Report missing information as questions, and recommend `UT_reviewFuncTestsSkeleton` before implementation.

### Worked Example

Designing the full P0 set from a gateway interface:

```text
/UT_designFuncTestsSkeleton
interface_or_protocol_file: services/payment/gatewayPort.h
feature_name: payment gateway retry
target_test_file: services/payment/SysTests/UT_Gateway.ts
```

Expected result:

- **Thought/Action (Typical)**: normal authorize/capture paths → US-01 with AC-01, AC-02, each carrying one TC. `SUT: gatewayPort` declared in the file overview.
- **Observation**: gate passes.
- **Thought/Action (Edge)**: zero-amount and max-amount authorizations drafted.
- **Observation**: AC-04 was written with no TC → dangling AC → back to **Action** → TC-EDGE-004 added.
- **Thought (Misuse)**: "gateway returns malformed JSON" was drafted here, but that is an *external* failure, not invalid caller usage → back to **Thought** → moved to Fault, not duplicated in both.
- **Stop**: four categories, all passing the cardinality gate, no executable test code written. Reported `next_command = UT_reviewFuncTestsSkeleton`.

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

## Conflict Guard

This command designs P0 Functional coverage only. It should not design P1/P2 categories or implement tests.
Do not leave partially mapped skeletons where any US lacks AC links or any AC lacks TC links.

ONE-MORE-THING: ask developer if something not sure