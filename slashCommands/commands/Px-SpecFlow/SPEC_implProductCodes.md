# SPEC_implProductCodes

## Purpose

Implement product code for the active story after selected unit tests exist.

## CoT Pattern

**Linear** — Direct execution. Given failing tests and the detail design, this command writes the minimum product code needed to satisfy the tests. If scope ambiguity is found, the observation routes to `SPEC_updateDetailDesign` instead of widening implementation scope.

## Inputs

- `failing_tests`: selected tests or test output.
- `production_files`: product code files to create or update.
- `detail_design`: reviewed design and acceptance criteria.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Product code changes scoped to the active story and intended for commit when review passes.
- Traceability from implementation to tests and acceptance criteria.
- Known verification result or reason verification was not run.

## Prompt Template

Ask the assistant to write minimal product code needed for selected tests and preserve existing behavior.

## Conflict Guard

Do not broaden scope beyond the active story. Route design gaps to `SPEC_updateDetailDesign`.

ONE-MORE-THING: ask developer if something not sure
