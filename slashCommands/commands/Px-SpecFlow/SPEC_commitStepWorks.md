# SPEC_commitStepWorks

## Purpose

Commit exactly one verified lifecycle step inside the `SPEC_openUserStory -> SPEC_closeUserStory` story span.

`SPEC_commitStepWorks` is the step-scoped checkpoint of Px-SpecFlow. It commits only the files a single step produced, only when that step passed its own gate, and only at the step boundaries [SPEC_makePlan](SPEC_makePlan.md) marked committable. It exists so a later failing step can be bisected or reverted without discarding the whole story.

## CoT Pattern

**Linear** — Direct execution. Given the active story, the recorded commit plan, and the just-finished step's verification evidence, this command resolves the step scope deterministically and commits it. If the step is not planned as committable, or if its gate did not pass, the observation stops and asks the developer.

### Linear Execution

Run these steps once, in order. There is no retry loop; an unplanned or unverified step stops and asks the developer.

1. Read the commit plan recorded by `SPEC_makePlan` in the paired `.catdd/spec/doingUS/*-UserStory-Tasks.md`. If no commit plan exists, stop and route to `SPEC_makePlan`.
2. Locate the current step entry and read its recorded decision:
   - `commit_step = yes`: the step is committable in both modes; continue.
   - `commit_step = optional`: the step is committable only when the developer explicitly invokes this command in `manualMode`. Continue on that explicit invocation and keep the draft-approval step; when the developer did not invoke it, skip the boundary and leave the work for `SPEC_commitStoryWorks`.
   - `commit_step = no` because the step changes no file, or the step is absent from the plan: stop and ask instead of committing.
3. Require the step's own gate to be satisfied: `PASS` or `GREEN` verification, review, or lint evidence for this step. Never commit failed, blocked, partial, or unverified step output.
4. Resolve scope: only files produced or changed by this step. Stop and ask when in-scope files include another step's output, story-level lifecycle or meta artifacts, or unrelated changes.
5. Read `recent_commit_messages` (latest 5) and extract tone, tense, capitalization, and scope format.
6. Draft the message with `WHAT` / `HOW` / `WHY` sections in that style, plus `Story: <story id>` and `Step: <SPEC command>` trace lines.
7. In `manualMode`, present the draft and commit only after approval. In `autonomousMode`, commit immediately at a planned step boundary after the step gate passed; `autonomousMode` never overrides a failed or blocked gate.
8. Report `step_commit_ref`, the remaining planned step commits, and the next command declared by the plan.

### Worked Example

`SPEC_implProductCodes` finished GREEN inside an implementation-oriented story whose plan marked the step committable:

```text
/SPEC_commitStepWorks
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
tasks_file: .catdd/spec/doingUS/20260904-payment-retry-UserStory-Tasks.md
step_command: SPEC_implProductCodes
step_verification_summary: 38/38 unit tests GREEN; lint clean
```

Expected result:

1. Commit plan records `commit_step = yes` for `SPEC_implProductCodes` → the step is committable.
2. Gate passed → the step may be committed.
3. Scope is only the product-code files this step changed.
4. Draft presented, then committed after approval:

```text
Implement bounded retry for payment authorizations

WHAT
- Retry authorization up to 3 times with exponential backoff

HOW
- retry.ts wraps the gateway call; test_payment_gateway_funcValidTypical.ts covers TC-RETRY-001..003

WHY
- Fixed backoff caused thundering-herd retries against the gateway under outage

Story: US-07
Step: SPEC_implProductCodes
```

- Reported: `step_commit_ref = 3b7e910`, remaining planned step commits listed, `next_command = SPEC_reviewProductCodes`.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `tasks_file`: paired `.catdd/spec/doingUS/*-UserStory-Tasks.md` artifact holding the commit plan.
- `commit_plan`: the step-boundary commit decisions recorded by `SPEC_makePlan`.
- `step_command`: the lifecycle step that just finished, for example `SPEC_implUnitTests` or `SPEC_implProductCodes`.
- `step_files`: files produced or changed by that step.
- `step_verification_summary`: gate evidence for that step, such as tests, lint, build, or review result.
- `recent_commit_messages`: latest 5 commit log messages from `git log`, used as the style reference for the new commit message.
- `execution_mode`: optional `manualMode | autonomousMode` (default: `manualMode`). In `autonomousMode`, planned step commits are the default checkpoint behavior.
- `auto_commit`: optional flag that allows committing without an approval step when explicitly requested.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [SPEC_makePlan](SPEC_makePlan.md)
- [SPEC_slashCommandTemplate](../../SPEC_slashCommandTemplate.md)

## Output Contract

- Step-scoped commit that contains only the finished step's files, and only when the step gate passed.
- Draft commit message using explicit `WHAT` / `HOW` / `WHY` sections, plus:
  - `Story: <story id>`
  - `Step: <SPEC command>`
- Mode behavior:
  - `manualMode`: optional command the developer may run at any `commit_step = yes` or `commit_step = optional` boundary, or skip to leave the work for `SPEC_commitStoryWorks`.
  - `autonomousMode`: default checkpoint at each planned step boundary; the flow auto-advances after the step commit.
- Reported `step_commit_ref`, the remaining planned step commits, and the plan's next command.
- Explicit statement of which boundaries were skipped: `commit_step = no` boundaries because they changed no file, and `commit_step = optional` boundaries the developer declined.
- Non-blocking post-success learning hook:
  - Report `success_learning_checkpoint = recommended`.
  - Preserve the plan's next command as `next_command`, and report `learning_command = /HARNESS_evolveHarness` separately.
  - Report `next_command = /HARNESS_evolveHarness` with `suggested_evolution_mode = auto` only when no lifecycle command has precedence.

## Conflict Guard

Do not commit a step whose gate is failed, blocked, partial, or unverified.
Do not commit a step that `SPEC_makePlan` did not mark committable; ask the developer instead of adding an unplanned commit boundary.
Do not include story-level lifecycle or meta artifacts such as `.catdd/spec/doingUS/` moves, `README_UserStories.md` ledger sync, or project-context updates; those belong to `SPEC_commitStoryWorks`.
Do not include another step's output in this commit.
Do not auto-commit in `manualMode` unless `auto_commit` is explicitly enabled.
Do not claim the story span is complete because a step commit exists.
Do not include unadopted VibeCoding excursion edits in the step commit; they enter story work only after a `SPEC_*` step re-adopts them or they are reverted.

ONE-MORE-THING: ask developer if something not sure
