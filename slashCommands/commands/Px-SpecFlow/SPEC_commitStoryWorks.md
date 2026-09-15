# SPEC_commitStoryWorks

## Purpose

Commit the whole `SPEC_openUserStory -> SPEC_closeUserStory` story span as one story-scoped unit, and serve both story-scope commit checkpoints.

`SPEC_commitStoryWorks` is the "just done UserStory" commit. It is the story-span counterpart to the pre-story span ([SPEC_commitPreStoryWorks](SPEC_commitPreStoryWorks.md)) and to individual step commits ([SPEC_commitStepWorks](SPEC_commitStepWorks.md)), and it replaces the story-scoped role the pre-close commit used to play. It runs at three checkpoints:

- `commit_checkpoint = pre_close`: commit the span so `SPEC_closeUserStory` receives a `commit_ref` and its close gates pass.
- `commit_checkpoint = post_close`: finalize the close-generated lifecycle/meta changes so `close_commit_required` is satisfied before closure is complete.
- `commit_checkpoint = span_end`: finalize a span that ended by another terminal transition — abort, suspend, or partial close — so the `abortUS/`, `suspendUS/`, or accepted-`doneUS/` lifecycle moves are committed instead of left dirty.

## CoT Pattern

**Linear** — Direct execution. Given the story span, the planned commit granularity, and the verification evidence, this command resolves the span scope deterministically, drafts the message, and commits it. If in-scope files belong to another story, to unrelated work, or to unresolved review findings, the observation stops and asks the developer.

### Linear Execution

Run these steps once, in order. There is no retry loop; an ambiguous or unverified span stops and asks the developer.

1. Identify the span endpoint: the active story in `.catdd/spec/doingUS/` for `pre_close`; the closed story in `.catdd/spec/doneUS/` for `post_close`; or the terminal lane written by `SPEC_abortUserStory`, `SPEC_suspendUserStory`, or `SPEC_partialCloseUserStory` for `span_end`. Require the paired `*-UserStory-Tasks.md` artifact when the story was planned.
2. Resolve the span scope: story and tasks artifacts, product code and test files, project-root `README*` SPEC docs, and the terminal lifecycle/meta changes — the `doingUS -> doneUS` or `doingUS -> abortUS` or `doingUS -> suspendUS` moves, the accepted/rejected split artifacts for partial close, story-link normalization, `README_UserStories.md` TODO/DONE/AC sync, and project-context updates.
3. Exclude `.catdd/spec/WorkingProcessLog.md` and generated adapter output. Stop and ask when in-scope files belong to another story, to unrelated work, or to a review finding that is still unresolved.
4. Apply the commit policy recorded by `SPEC_makePlan`:
   - `single_story_commit = yes`: squash the span into one story commit, list the step commit refs that are absorbed, and confirm with the developer in `manualMode` before rewriting history.
   - Otherwise: commit the remaining uncommitted span changes and record the span commit refs already in history, including step commits.
5. Read `recent_commit_messages` (latest 5) and extract tone, tense, capitalization, and scope format.
6. Draft the message with `WHAT` / `HOW` / `WHY` sections in that style, plus `Story: <story id>`, `Span: SPEC_openUserStory -> SPEC_closeUserStory`, and the verification and step-commit trace.
7. In `manualMode`, present the draft and commit only after approval. In `autonomousMode`, this is the default story-span checkpoint at completion.
8. Report the checkpoint result:
   - `pre_close`: report `commit_ref` and `next_command = SPEC_closeUserStory`.
   - `post_close`: report `close_commit_ref`, then the merge checkpoint — `next_command = SPEC_mergeWorks` when a dedicated story branch is still unintegrated, otherwise `next_command = SPEC_whatsNextTask`.
   - `span_end`: report `span_commit_ref` and the terminal command's own follow-up — `next_command = SPEC_analyzeAbortedUserStory` or `SPEC_importIssue` after abort, `next_command = SPEC_resumeUserStory` after suspend, and `next_command = SPEC_whatsNextTask` after partial close.

### Worked Example

An implementation-oriented story passed test and product-code review; step commits already captured the code, and the story now needs its pre-close span commit:

```text
/SPEC_commitStoryWorks
commit_checkpoint: pre_close
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
step_commit_refs: 3b7e910, 55ac2d1
single_story_commit: no
verification_summary: 38/38 unit tests GREEN; lint clean; reviews passed
branch_context: on branch feat/payment-retry, not yet merged
```

Expected result:

1. Span endpoint is the active `doingUS/` story with its tasks artifact present.
2. Span scope covers the remaining uncommitted span changes: story and tasks artifact, the `README_UserStories.md` ledger row, and the updated architecture/detail design docs.
3. Step commits `3b7e910` and `55ac2d1` are already in history, so this commit covers what remains rather than squashing them.
4. Draft presented, not committed:

```text
Close out the payment retry story span

WHAT
- Record the payment retry story, tasks, and README_UserStories ledger state

HOW
- Story and tasks artifacts updated; design docs aligned; step commits 3b7e910 and 55ac2d1 referenced

WHY
- Give SPEC_closeUserStory a verified commit_ref for the full open-to-close span

Story: US-07
Span: SPEC_openUserStory -> SPEC_closeUserStory
```

- Reported: `commit_ref = 9f8e7d6`, `next_command = SPEC_closeUserStory`.

## Inputs

- `commit_checkpoint`: `pre_close`, `post_close`, or `span_end`.
- `doing_user_story`: active story under `.catdd/spec/doingUS/` for `pre_close`.
- `closed_user_story`: closed story under `.catdd/spec/doneUS/` for `post_close`.
- `terminal_story_lane`: `.catdd/spec/abortUS/`, `.catdd/spec/suspendUS/`, or the accepted `.catdd/spec/doneUS/` artifact for `span_end`, plus the rejected `.catdd/spec/abortUS/` remainder when the span ended by partial close.
- `tasks_file`: paired `*-UserStory-Tasks.md` artifact for the story span and its commit plan.
- `span_files`: files that belong to the story span, including story artifacts, tests, product code, project-root `README*` SPEC docs, and close-generated lifecycle/meta changes.
- `step_commit_refs`: step commits already created by `SPEC_commitStepWorks` inside this span.
- `single_story_commit`: optional planned flag that squashes the span into one story commit.
- `verification_summary`: evidence from tests, lint, build, review, or CI preparation.
- `branch_context`: optional note describing whether committed work is on the target branch or a dedicated story branch.
- `recent_commit_messages`: latest 5 commit log messages from `git log`, used as the style reference for the new commit message.
- `execution_mode`: optional `manualMode | autonomousMode` (default: `manualMode`). In `autonomousMode`, this is the default story-span checkpoint at completion.
- `auto_commit`: optional flag that allows committing without an approval step when explicitly requested.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [SPEC_commitStepWorks](SPEC_commitStepWorks.md)
- [SPEC_closeUserStory](SPEC_closeUserStory.md)
- [SPEC_slashCommandTemplate](../../SPEC_slashCommandTemplate.md)

## Output Contract

- Story-span commit covering `SPEC_openUserStory -> SPEC_closeUserStory`, including the terminal lifecycle/meta changes when the checkpoint is `post_close` or `span_end`.
- Draft commit message first, using explicit `WHAT` / `HOW` / `WHY` sections, plus:
  - `Story: <story id>`
  - `Span: SPEC_openUserStory -> SPEC_closeUserStory`
  - Step-commit and verification trace.
- Span coverage statement that names which span files were committed in this commit and which were already committed by step commits.
- Squash record when `single_story_commit = yes`: the absorbed step commit refs and the resulting story commit ref.
- Mode behavior:
  - `manualMode`: optional command; the developer may use it as the single story commit, or alongside step commits, or skip it and commit manually through `SPEC_commitWorks`.
  - `autonomousMode`: default story-span checkpoint at completion.
- Checkpoint result:
  - `pre_close`: reported `commit_ref` and `next_command = SPEC_closeUserStory`.
  - `post_close`: reported `close_commit_ref`, then `next_command = SPEC_mergeWorks` when a dedicated story branch is still unintegrated, otherwise `next_command = SPEC_whatsNextTask`.
  - `span_end`: reported `span_commit_ref`, the terminal lane that received the story, and the terminal command's follow-up command.
- Non-blocking post-success learning hook:
  - Report `success_learning_checkpoint = recommended`.
  - Preserve any required lifecycle, commit, or merge command as `next_command`, and report `learning_command = /HARNESS_evolveHarness` separately.
  - Report `next_command = /HARNESS_evolveHarness` with `suggested_evolution_mode = auto` only when no lifecycle command has precedence.

## Conflict Guard

Do not commit a story span whose review, test, or verification evidence is missing or failing.
Do not commit another story's artifacts, unrelated changes, or files whose story ownership is unclear.
Do not squash step commits into one story commit without explicit developer confirmation in `manualMode`.
Do not treat the pre-close `commit_ref` as sufficient evidence for close-generated changes; the `post_close` checkpoint still applies.
Do not mark closure complete while post-close lifecycle/meta changes remain uncommitted.
Do not report the lifecycle as fully finished when branch integration is still required after close.
Do not leave an abort, suspend, or partial-close lane move uncommitted; those terminal transitions end the span and route here with `commit_checkpoint = span_end`.
Do not commit `.catdd/spec/WorkingProcessLog.md` or other gitignored local work state.

ONE-MORE-THING: ask developer if something not sure
