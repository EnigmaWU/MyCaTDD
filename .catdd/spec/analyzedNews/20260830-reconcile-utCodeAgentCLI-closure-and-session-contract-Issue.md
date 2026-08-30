# Issue: Reconcile utCodeAgentCLI closure and canonical asset-session contract

status: analyzed
analyzed_by: SPEC_analyzeIssue
analyzed_on: 2026-08-30
analysis_mode: BRAINSTORM
analysis_depth: detailed
generated_todo_story:
  - `.catdd/spec/todoUS/20260830-utCodeAgentCLI-canonical-asset-session-repair-UserStory.md`
  - `.catdd/spec/todoUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md`
project_story_ledger: `codeAgents/utCodeAgentCLI/README_UserStoryStatus.md`
related_closed_story: `.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md`

Imported via `/SPEC_importIssue` on 2026-08-30.
Analyzed via `/SPEC_analyzeIssue` on 2026-08-30.

## Source

Read-only `/HARNESS_diagnoseProject` evidence for `codeAgents/utCodeAgentCLI` found that runtime checks pass, but the implemented canonical asset-session behavior, CaTDD test traceability, verification documentation, and archived SpecFlow state do not agree.

## Classification

- Origin: defect report.
- Type: defect / SpecCoding lifecycle inconsistency.
- Area: `codeAgents/utCodeAgentCLI/` and its `.catdd/spec/` lifecycle artifacts.
- Severity: high; the story closure and approved implementation contract are not supported by consistent evidence.

## Observed Behavior

1. `README_DetailDesign.md` specifies that `openAssetSession(context)` returns `Promise<InvocationAssetSession>` after canonicalizing and retaining immutable workspace, method-prompt, slash-command, and `commands/` roots. The current implementation returns a session synchronously and canonicalizes roots inside each `read()` call.
2. The symlink regression is implemented as an additional executable `TC-DELEGATE-001-SYMLINK` body instead of retargeting the existing `TC-DELEGATE-001`. It has no independent CaTDD TC metadata or lifecycle status.
3. `README_VerifyDesign.md` still points to a nonexistent `doingUS` story, reports PROD-REV-01 as pending/current, expects exactly one executable delegation test, and recommends `/SPEC_reviewDetailDesign`, even though the fix and story closure were committed.
4. `.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-INVENTOR-01-TASKs.md` still describes an active story and leaves detail review, test correction, product correction, reviews, commit, and close unchecked. Its paired story is marked DONE and closed.
5. `README_UserStoryStatus.md` leaves all 16 US-INVENTOR-01 ACs as TODO, while the story is archived under `doneUS/` and 15 of its 16 designed TCs remain PLANNED.
6. Two archived US-USER-01 generations exist. The 2026-06-28 task artifact is under `doneUS/` while product review, commit, and close remain unchecked.

## Verification Evidence

- All 43 Node-discovered tests passed, including the symlink regression and 38 CLI argument-validation cases.
- VS Code reported no diagnostics under `codeAgents/utCodeAgentCLI/src/` or `tests/`.
- README mirror, documentation contract, code-agent structure, and slash-command completeness scripts passed.
- `.catdd/spec/doingUS/` and `.catdd/spec/suspendUS/` were empty during diagnosis.
- Git history shows implementation commit `ddbd914` and story-closing commit `a6f6583` on `main`.

## Expected Behavior

- Product code and executable tests agree with the reviewed canonical asset-session contract.
- Every executable CaTDD test has unambiguous US/AC/TC identity and lifecycle status.
- Verification documents describe current implementation and review state and link to the correct lifecycle lane.
- A story enters `doneUS/` only when its AC status, TC status, reviews, task checklist, commit evidence, and close evidence are mutually consistent.
- Historical duplicate or superseded story artifacts state their authority and completion status without presenting stale next commands.

## BRAINSTORM Decisions

1. Split the issue into two independently testable stories: product/test contract repair and lifecycle/documentation reconciliation.
2. Treat the related INV-01 closure as partial: preserve AC-01 as accepted done evidence and preserve AC-02 through AC-16 as unfinished follow-up scope.
3. Preserve historical artifacts; label authority and supersession instead of deleting or fabricating evidence.

## Generated Artifacts

- `.catdd/spec/todoUS/20260830-utCodeAgentCLI-canonical-asset-session-repair-UserStory.md`
- `.catdd/spec/todoUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md`

## Evidence References

- `codeAgents/utCodeAgentCLI/src/catdd/invocationAssetSession.ts`
- `codeAgents/utCodeAgentCLI/tests/test_catdd_asset_delegation_funcValidTypical.ts`
- `codeAgents/utCodeAgentCLI/README_DetailDesign.md`
- `codeAgents/utCodeAgentCLI/README_VerifyDesign.md`
- `codeAgents/utCodeAgentCLI/README_UserStoryStatus.md`
- `.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md`
- `.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-INVENTOR-01-TASKs.md`
- `.catdd/spec/doneUS/20260628-utCodeAgentCLI-US-USER-01-UserStory.md`
- `.catdd/spec/doneUS/20260628-utCodeAgentCLI-US-USER-01-TASKs.md`
- `slashCommands/commands/Px-SpecFlow/SPEC_closeUserStory.md`

## Next Recommended Command

`/SPEC_openUserStory`
