# Issue: refactor unit testing of UT_US-USER-01 under CaTDD

Imported via SPEC_importIssue on 2026-06-12.

## Source

"refactor unit testing of UT_US-USER-01 of utCodeAgentCLI: A) fully follow P0-Functional of methodPrompts and slashCommands of CaTDD; B) redesign ALL test case for each AC, which means each US has >=1xAC, each AC has >=1xTC; C) set 'utCodeAgentCLI' program as unit testing SUT"

## Classification

- Type: refactor and verification design alignment issue.
- Area: utCodeAgentCLI unit-test design, CaTDD P0-Functional compliance, US/AC/TC traceability.
- Severity: P1 - impacts verification correctness and lifecycle consistency.

## Observed Behavior

Current UT_US-USER-01 unit testing may not fully satisfy expected CaTDD P0-Functional structure and complete AC-to-TC redesign intent.

## Expected Behavior

1. UT_US-USER-01 fully follows CaTDD P0-Functional method definitions from methodPrompts and slashCommands.
2. Test design is rebuilt so each US has at least one AC, and each AC has at least one TC.
3. The `utCodeAgentCLI` program is explicitly treated as the unit-testing SUT in design artifacts and tests.

## Related

- `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts`
- `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts`
- `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts`
- `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`
- `slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md`
- `methodPrompts/README.md`

## Open Clarification

- Should the redesign scope apply only to `US-USER-01`, or should the same AC/TC completeness rule be propagated immediately to all existing UT_US-* files in `utCodeAgentCLI`?
- Which AC source is authoritative for `US-USER-01` if multiple references exist (story artifact, readme, or in-test comments)?

## Next Recommended Command

`/SPEC_analyzeIssue`
