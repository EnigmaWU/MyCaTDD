# UT_designPerformanceSkeleton

## Purpose

Design a CaTDD Performance skeleton from project-root `README_PerfDesign.md` and stable behavior.

Use this command after P0 functional coverage exists and performance behavior is part of product risk or acceptance.

## CoT Pattern

**ReACT** — Reasoning + Acting. A performance AC is worthless unless it is measurable, so the loop's gate is numeric: every AC must carry a metric, a measurement boundary, and a pass/fail threshold taken from the design source — never a threshold the assistant picked.

### ReACT Execution

Repeat until every AC is measurable and sourced.

1. **Thought** — Design-source gate first: check project-root `README_PerfDesign.md` exists. If it is missing, output a **WARNING** and stop before drafting anything. Then read it as the performance design source and read existing skeletons for behavior links.
2. **Action** — Draft only the Performance skeleton with the full `@[...]` metadata set. Preserve unrelated categories.
3. **Observation** — Check each AC states a metric, a measurement boundary, a load assumption, and a pass/fail threshold. A qualitative AC, or a threshold not present in the design source, returns to **Thought** — record it as a question rather than inventing a number.
4. **Stop** — Exit when every AC is measurable and sourced. Recommend another P2 category or `UT_reviewQualityTestsSkeleton`.

### Worked Example

Adding performance coverage:

```text
/UT_designPerformanceSkeleton
feature_name: payment authorization latency
target_test_file: services/payment/SysTests/UT_Gateway.ts
```

Expected result:

- **Thought**: `README_PerfDesign.md` exists → gate passes. It states p95 authorize latency < 500ms at 50 rps, measured at the port boundary.
- **Action**: US-08 drafted with AC-21 (p95 < 500ms at 50 rps, measured at the port).
- **Observation**: a second AC read "authorization should be fast under load" — no metric, no threshold → not measurable → back to **Thought** → the design source says nothing about sustained load, so it becomes an open question rather than an invented number.
- **Observation**: AC-21 carries metric, boundary, load, and threshold, all sourced → gate passes.
- **Stop**: one measurable AC, one open question. Recommended `UT_reviewQualityTestsSkeleton`.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `performance_design_doc`: required project-root `README_PerfDesign.md` with latency, throughput, jitter, memory, CPU, power, timing, or resource goals.

## Preconditions

- Project-root `README_PerfDesign.md` must exist before drafting the Performance skeleton.
- WARNING: If project-root `README_PerfDesign.md` is missing, stop before drafting the Performance skeleton and warn the developer.
- If `README_PerfDesign.md` is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../templates/README_PerfDesignTemplate.md](../../templates/README_PerfDesignTemplate.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md)

## Output Contract

- A Performance quality skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that make performance expectations measurable and bounded.
- Traceability to functional or design scenarios that must remain correct under performance constraints.

## Conflict Guard

This command designs Performance coverage only. It should not redefine Performance category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
