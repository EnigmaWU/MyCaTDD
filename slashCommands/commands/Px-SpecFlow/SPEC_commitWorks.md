# SPEC_commitWorks

## Purpose

Prepare and commit completed work after story, tests, product code, and review pass.

## CoT Pattern

**Linear** — Direct execution. Given verified changed files and the active story, this command determines commit scope and creates the commit message deterministically. If scope ambiguity is found, the observation stops and asks the developer before committing.

## Inputs

- `changed_files`: files to commit.
- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `verification_summary`: evidence from tests, lint, build, review, or CI preparation.
- `branch_context`: optional note describing whether committed work is on the target branch or a dedicated story branch.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)

## Output Contract

- Commit scope summary for team-shared artifacts, tests, and product code; include `.catdd/spec/doingUS/` updates when relevant and exclude local gitignored `.catdd/spec/WorkingProcessLog.md`.
- Structured commit message with what, how, and why.
- Next-command checkpoint after commit:
  - Continue to `SPEC_closeUserStory`.
  - If work is on a dedicated story branch and integration is still required, `SPEC_closeUserStory` should hand off to `SPEC_mergeWork` (or the repository's merge step) after close.
  - If no dedicated story branch was used, merge/integration is auto-skipped.

## Prompt Template

Ask the assistant to verify scope, exclude unrelated changes, create a commit message tied to the active story, and record whether branch integration will be required after `SPEC_closeUserStory`.

## Conflict Guard

Do not commit unrelated changes. Ask the developer before including ambiguous files.
Do not claim the lifecycle is fully complete when the committed story branch still needs merge/integration after close.

ONE-MORE-THING: ask developer if something not sure
