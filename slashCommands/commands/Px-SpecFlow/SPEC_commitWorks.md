# SPEC_commitWorks

## Purpose

Prepare and commit completed work after story, tests, product code, and review pass.

## CoT Pattern

**Linear** — Direct execution. Given verified changed files and the active story, this command determines commit scope and creates the commit message deterministically. If scope ambiguity is found, the observation stops and asks the developer before committing.

## Inputs

- `staged_files`: staged files to commit, preferred when present.
- `doingUS_related_files`: current active-story files under `.catdd/spec/doingUS/`, used when staged files do not fully define scope.
- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `verification_summary`: evidence from tests, lint, build, review, or CI preparation.
- `branch_context`: optional note describing whether committed work is on the target branch or a dedicated story branch.
- `auto_commit`: optional flag that allows committing without an approval step when explicitly requested.
- `recent_commit_messages`: latest 5 commit log messages from `git log`, used as the style reference for the new commit message.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)

## Output Contract

- Commit scope summary based first on staged files, then on current `doingUS`-related files, and exclude local gitignored `.catdd/spec/WorkingProcessLog.md`.
- Draft the commit message first, using explicit `WHAT` / `HOW` / `WHY` sections:
  - `WHAT`: concise summary of what was completed for the active story.
  - `HOW`: key technical changes (files, tests, implementation approach).
  - `WHY`: rationale for design/implementation choices, not a restatement of `HOW`.
- Keep the commit message concise but informative, and aligned with the latest 5 commit messages in tone, tense, capitalization, and scope format.
- Do not commit automatically unless the user has approved the draft or `auto_commit` is explicitly enabled.
- Next-command checkpoint after commit:
  - Continue to `SPEC_closeUserStory`.
  - If work is on a dedicated story branch and integration is still required, `SPEC_closeUserStory` should hand off to `SPEC_mergeWorks` (or the repository's merge step) after close.
  - If no dedicated story branch was used, merge/integration is auto-skipped.

## Prompt Template

Ask the assistant to verify scope by checking staged files first, then current `doingUS`-related files, exclude unrelated changes, review the latest 5 commit log messages, and always draft the commit message before any commit. The commit message must follow the recent style while staying tied to the active story. Record whether branch integration will be required after `SPEC_closeUserStory`.

When drafting the commit message, use this structure unless the repository's recent style requires a different but equivalent layout:

```text
<subject line in recent repo style>

WHAT
- ...

HOW
- ...

WHY
- ...
```

`WHAT` should capture scope/result, `HOW` should capture technical execution, and `WHY` should capture decision rationale and trade-offs.

When drafting the commit message, match the recent message style in tone, tense, capitalization, and scope format. If the recent commit history is ambiguous or inconsistent, stop and ask the developer before committing. Only proceed to commit after the draft is approved, unless `auto_commit` is explicitly enabled.

## Conflict Guard

Do not commit unrelated changes. Ask the developer before including ambiguous files.
Do not claim the lifecycle is fully complete when the committed story branch still needs merge/integration after close.

ONE-MORE-THING: ask developer if something not sure
