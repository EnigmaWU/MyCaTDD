# UT_tellMeNextImplTest

## Purpose

Select the next test case to implement from existing CaTDD skeletons.

Use this command when the developer already has Typical, Edge, Misuse, Fault, or later category skeletons and wants a clear next implementation step.

## Inputs

- `test_file_or_files`: files containing CaTDD skeletons.
- `current_status`: known TODO, RED, GREEN, ISSUES, or BLOCKED markers.
- `focus`: optional category or user story to prioritize.

## Method References

- [P0-FuncTestsFlow](../../flows/P0-FuncTestsFlow.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- One selected TC to implement next.
- Reason for selection based on category priority, risk, and current status.
- Required command to run next, usually `UT_implTestCase`.
- Preconditions or blockers if no TC is ready.

## Prompt Template

Ask the assistant to:

1. Read all TC status markers.
2. Prefer highest-priority unimplemented or RED TC.
3. Select exactly one TC unless the developer asks for a batch.
4. Explain why this TC is next.
5. Do not implement until the developer invokes or approves implementation.

## Conflict Guard

Selection follows CaTDD category priority from `methodPrompts`, not file order alone.
