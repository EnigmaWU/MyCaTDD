# Issue: add SPEC_verifyRequirement portable slash command

Imported via SPEC_importIssue on 2026-05-31.

## Source

Gap discovered during utCodeAgentCLI UserStory review. SPEC Px-Flow has `SPEC_reviewUserStory` and `SPEC_reviewProductCodes` but no per-AC verification command that checks individual acceptance criteria against implementation.

## Classification

- Type: missing asset / feature request.
- Area: `.catdd/slashCommands/commands/Px-SpecFlow/`.
- Severity: P1 — blocks structured requirement verification.

## Observed Behavior

Current SPEC flow reviews happen at the SpecKit story level (`doingUS/`), not at the per-requirement acceptance criterion level. The `US-{ROLE}-{NN}-AC-{MM}` checklist format allows granular verification:

```
- [ ] US-USER-01-AC-01  Missing --goal → exit 1, stderr names it
```

But no SPEC command reads this checklist and verifies each AC against implementation or tests.

## Expected Behavior

`SPEC_verifyRequirement` should:

1. Input: a `US-{ROLE}-{NN}` requirement or set of requirements, plus implementation/test artifacts
2. Process: for each `AC-{MM}`, verify whether the implementation satisfies the Given/When/Then contract
3. Output:
   - Updated `UserStory Status` checklist (`- [ ]` → `- [x]` for verified ACs)
   - Verification report: which ACs passed, which failed, which are untestable
4. Pipeline position: after `SPEC_implUnitTests` / `SPEC_implProductCodes`, before `SPEC_reviewUserStory`
5. Output contract: traceable per-AC verification report linked back to requirement IDs

## Related

- `SPEC_assembleRequirements` — produces the AC checklist consumed by verifyRequirement
- `SPEC_reviewUserStory` — story-level review (verifyRequirement is the per-AC precursor)
- `SPEC_reviewProductCodes` — code-level review
- `SPEC_updateRequirement` — updates checklist status (proposed separately)
- utCodeAgentCLI UserStory documents — reference implementation of the AC checklist format

## Next Recommended Command

`/SPEC_openUserStory`
