# Issue: add SPEC_takeArchDesign portable slash command

Imported via SPEC_importIssue on 2026-05-31.

## Source

Gap discovered during utCodeAgentCLI UserStory review. SPEC Px-Flow has `SPEC_takeDetailDesign` but no architecture design step between requirements and detail design.

## Classification

- Type: missing asset / feature request.
- Area: `.catdd/slashCommands/commands/Px-SpecFlow/`.
- Severity: P0 — blocks the next planned step for utCodeAgentCLI (ArchDesign).

## Observed Behavior

Current SPEC flow: `analyzeIssue` → `openUserStory` → `takeDetailDesign` → `designUnitTests`. There is no architecture layer. For complex systems like utCodeAgentCLI, jumping from requirements straight to detail design is insufficient.

The utCodeAgentCLI project needs to produce `README_ArchDesign.md` as the next step, but no SPEC command supports this.

## Expected Behavior

`SPEC_takeArchDesign` should:

1. Input: `US-{ROLE}-{NN}` requirements (from `SPEC_assembleRequirements` or manual `README_UserStory.md`), project context, method prompts
2. Produce: `README_ArchDesign.md` containing:
   - Architecture decisions traced to specific US-* IDs
   - Component/module decomposition
   - Data flow and state management
   - Adapter boundaries and extension points
   - Trade-offs and rationale
3. Pipeline position: after `SPEC_assembleRequirements` (requirements), before `SPEC_takeDetailDesign` (detail)
4. Output contract: a reviewable architecture document that bridges requirements to implementation detail

## Related

- `SPEC_assembleRequirements` — upstream (produces requirements consumed by ArchDesign)
- `SPEC_takeDetailDesign` — downstream (consumes ArchDesign decisions)
- utCodeAgentCLI `README_UserStory.md` — current requirements ready for ArchDesign

## Next Recommended Command

`/SPEC_openUserStory`
