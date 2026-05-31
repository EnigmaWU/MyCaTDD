# Issue: add SPEC_updateRequirement portable slash command

Imported via SPEC_importIssue on 2026-05-31.

## Source

Gap discovered during utCodeAgentCLI UserStory review. The `UserStory Status` checklist in `README_UserStory.md` tracks requirement state, but no SPEC command can update it atomically.

## Classification

- Type: missing asset / feature request.
- Area: `.catdd/slashCommands/commands/Px-SpecFlow/`.
- Severity: P2 — workflow convenience, not structural.

## Observed Behavior

The `UserStory Status` section uses a checklist:

```
- [ ] US-USER-01 — Parse and validate CLI arguments
- [ ] US-USER-02 — Design CaTDD test skeletons
```

Manual editing of these checkboxes is error-prone and not traceable. No SPEC command currently reads or writes requirement status.

## Expected Behavior

`SPEC_updateRequirement` should:

1. Input: a `US-{ROLE}-{NN}` requirement ID and target status (`[/]` in-progress or `[x]` done)
2. Process: atomically update the checkbox in `README_UserStory.md`'s `UserStory Status` section
3. Output: updated status with optional commit message
4. Pipeline position: called at any point in the SPEC flow when a requirement's status changes
5. Should also verify that all prerequisite requirements (from dependency graph) are `[x]` before allowing a switch to `[/]` (in-progress)

## Related

- `SPEC_assembleRequirements` — creates the initial status checklist
- `SPEC_verifyRequirement` — the primary caller (sets `[x]` after verification)
- `SPEC_whatsNextTask` — should read the status to recommend next work
- utCodeAgentCLI `README_UserStory.md` `UserStory Status` section — reference format

## Next Recommended Command

`/SPEC_openUserStory`
