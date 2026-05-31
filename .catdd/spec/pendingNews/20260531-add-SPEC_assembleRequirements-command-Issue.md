# Issue: add SPEC_assembleRequirements portable slash command

Imported via SPEC_importIssue on 2026-05-31.

## Source

Gap discovered during utCodeAgentCLI UserStory review. SPEC Px-Flow has `SPEC_analyzeIssue` → `SPEC_openUserStory` → `SPEC_takeDetailDesign`, but no command to produce structured `US-{ROLE}-{NN}` requirements with `US-{ROLE}-{NN}-AC-{MM}` acceptance criteria.

## Classification

- Type: missing asset / feature request.
- Area: `.catdd/slashCommands/commands/Px-SpecFlow/`.
- Severity: P1 — blocks structured requirement traceability in SPEC flow.

## Observed Behavior

Current SPEC flow jumps from analyzed intent (pendingNews → analyzedNews) directly to SpecKit-style user stories (todoUS/doingUS/doneUS). There is no step that produces the structured requirements format:

```
US-USER-01 [P0] — Parse and validate CLI arguments
  AC-01: Missing required argument exits with error
  AC-02: Mutually exclusive arguments are rejected
  ...
```

The utCodeAgentCLI UserStory documents were assembled manually over multiple sessions. This should be a SPEC command.

## Expected Behavior

`SPEC_assembleRequirements` should:

1. Input: analyzed issue/feature, project context, method prompts
2. Produce: `README_UserStory.md` (master) and role-specific sub-files (`README_UserStory4USER.md`, etc.) with:
   - `US-{ROLE}-{NN}` requirements with priorities and dependencies
   - `US-{ROLE}-{NN}-AC-{MM}` acceptance criteria in Given/When/Then format
   - UserStory Status tracking checklist (`- [ ]`)
   - Requirement dependency graph
3. Pipeline position: after `SPEC_analyzeIssue` / `SPEC_analyzeFeature`, before `SPEC_takeArchDesign` (if added) or `SPEC_takeDetailDesign`
4. Output contract: a complete, reviewable requirements mandate that drives downstream architecture and design

## Related

- `SPEC_analyzeIssue` — upstream input
- `SPEC_takeArchDesign` — downstream consumer (proposed separately)
- `SPEC_takeDetailDesign` — downstream consumer
- `SPEC_verifyRequirement` — verification counterpart
- utCodeAgentCLI UserStory documents — reference implementation of the output format

## Next Recommended Command

`/SPEC_openUserStory`
