# Issue: add UT_reviewImplTestFile portable slash command

Imported by OpenCode following SPEC_importIssue on 2026-05-31.

## Source

CaTDD paired-review gap discovered during utCodeAgentCLI UserStory review.

## Classification

- Type: issue / missing asset.
- Area: `.catdd/slashCommands/commands/P0-FuncTestsFlow/`.
- Related flow: P0-FuncTestsFlow.
- Severity: P0 — blocks US-USER-10 requirement.

## Observed Behavior

The following paired-review assets exist under `.catdd/slashCommands/commands/`:

| Design/Implement | Paired Review |
|---|---|
| `UT_designFuncTestsSkeleton` (P0) | `UT_reviewFuncTestsSkeleton` |
| `UT_designDesignTestsSkeleton` (P1) | `UT_reviewDesignTestsSkeleton` (P1) |
| `UT_designQualityTestsSkeleton` (P2) | `UT_reviewQualityTestsSkeleton` (P2) |
| `UT_implTestCase` (per-TC) | `UT_reviewImplTestCase` (per-TC) |
| `UT_implTestFile` (file-level) | **MISSING** — no `UT_reviewImplTestFile` exists |

The `.github/prompts/` layer has no `UT_reviewImplTestFile.prompt.md` either.

## Expected Behavior

`UT_reviewImplTestFile.md` should exist under `.catdd/slashCommands/commands/P0-FuncTestsFlow/`, following the pattern of `UT_reviewImplTestCase.md` but operating at file level:

- Input: a target test file containing CaTDD TCs in RED or GREEN status
- Output: per-TC review for each implemented TC, plus a file-level summary (total RED, TCs with preserved skeletons, TCs with issues)
- Skip PLANNED TCs (not yet implemented)
- No file modification

A corresponding `.github/prompts/UT_reviewImplTestFile.prompt.md` thin Copilot adapter should also be created.

## Related Requirements

- `US-USER-10` (paired review of `US-USER-06 implTestFile`) depends on this command.
- `US-USER-08 designAndImplTest` also references it for post-hoc review.

## Next Recommended Command

`/SPEC_openUserStory`
