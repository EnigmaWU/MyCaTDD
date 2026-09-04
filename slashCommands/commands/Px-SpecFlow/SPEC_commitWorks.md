# SPEC_commitWorks

## Purpose

Prepare and commit completed work after story, tests, product code, and review pass.

## CoT Pattern

**Linear** — Direct execution. Given verified changed files and the active story, this command determines commit scope and creates the commit message deterministically. If scope ambiguity is found, the observation stops and asks the developer before committing.

### Linear Execution

Run these steps once, in order. There is no retry loop; any failed step stops and asks the developer.

1. Determine scope: use `staged_files` if non-empty, otherwise `doingUS_related_files`. Exclude `.catdd/spec/WorkingProcessLog.md`.
2. Stop and ask if any in-scope file is unrelated to `doing_user_story`.
3. Read `recent_commit_messages` (latest 5) and extract tone, tense, capitalization, and scope format.
4. Draft the message with `WHAT` / `HOW` / `WHY` sections in that style.
5. Present the draft. Commit only after approval, or immediately if `auto_commit` is set.
6. Report whether a branch merge is still required, then hand off to `SPEC_closeUserStory`.

### Worked Example

After `SPEC_reviewProductCodes` passed on a story branch:

```text
/SPEC_commitWorks
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
verification_summary: 38/38 unit tests GREEN; lint clean
branch_context: on branch feat/payment-retry, not yet merged
```

Expected result:

- Scope taken from staged files: `services/payment/retry.ts`, `services/payment/SysTests/UT_Retry-Typical.ts`. `WorkingProcessLog.md` excluded.
- Recent 5 commits use imperative subject lines with no scope prefix, so the draft matches that.
- Draft presented, not committed:

```text
Add bounded retry for failed payment authorizations

WHAT
- Retry authorization up to 3 times with exponential backoff

HOW
- retry.ts wraps the gateway call; UT_Retry-Typical.ts covers TC-RETRY-001..003

WHY
- Fixed backoff caused thundering-herd retries against the gateway under outage
```

- Reported: merge into `main` still required after `SPEC_closeUserStory`.

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

  Use this structure unless the repository's recent style requires a different but equivalent layout:

  ```text
  <subject line in recent repo style>

  WHAT
  - ...

  HOW
  - ...

  WHY
  - ...
  ```

- Keep the commit message concise but informative, and aligned with the latest 5 commit messages in tone, tense, capitalization, and scope format. If the recent commit history is ambiguous or inconsistent, stop and ask the developer before committing.
- Do not commit automatically unless the user has approved the draft or `auto_commit` is explicitly enabled.
- Next-command checkpoint after commit:
  - Continue to `SPEC_closeUserStory`.
  - If work is on a dedicated story branch and integration is still required, `SPEC_closeUserStory` should hand off to `SPEC_mergeWorks` (or the repository's merge step) after close.
  - If no dedicated story branch was used, merge/integration is auto-skipped.

## Conflict Guard

Do not commit unrelated changes. Ask the developer before including ambiguous files.
Do not claim the lifecycle is fully complete when the committed story branch still needs merge/integration after close.

ONE-MORE-THING: ask developer if something not sure
