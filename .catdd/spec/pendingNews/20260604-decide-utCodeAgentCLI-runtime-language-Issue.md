# Issue: decide utCodeAgentCLI runtime language and ADR

Imported via SPEC_importIssue on 2026-06-04.

## Source

Developer request: `utCodeAgentCLI use TypeScript or Python or Go, it SHOULD be an architectural decision, and with a fine ADR`

## Classification

- Type: architectural decision / research input.
- Area: `codeAgents/utCodeAgentCLI/`.
- Severity: P1 — blocks implementation stack selection and ADR capture.

## Observed Behavior

The current `utCodeAgentCLI` architecture and detail design are written around TypeScript as the implementation target, but the runtime-language decision itself has not been recorded as a dedicated import issue.

The developer is explicitly asking whether the implementation should be TypeScript, Python, or Go, and wants that choice documented as an architectural decision with a formal ADR.

## Expected Behavior

The repository should preserve this decision request as a raw pending issue so it can be analyzed into a user story or architecture decision artifact with traceable rationale.

The eventual analysis should determine:

1. Which runtime language should be preferred for `utCodeAgentCLI`.
2. Whether the answer is a single implementation language or a primary language with optional adapters.
3. What assumptions, tradeoffs, and non-goals belong in a dedicated ADR.
4. How the choice affects future CLI implementation and adapter design.

## Related

- `codeAgents/utCodeAgentCLI/README_ArchDesign.md`
- `codeAgents/utCodeAgentCLI/README_DetailDesign.md`
- `codeAgents/utCodeAgentCLI/README_UserStory.md`
- `slashCommands/flows/Px-SpecFlow.md`

## Next Recommended Command

`/SPEC_analyzeIssue`
