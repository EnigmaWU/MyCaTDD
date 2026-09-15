# SPEC_commitPreStoryWorks

## Purpose

Commit the pre-story span: the intake, analysis, and planning-input artifacts produced before `SPEC_openUserStory`, so the story span starts from a committed baseline.

`SPEC_commitPreStoryWorks` is the first commit checkpoint of Px-SpecFlow. It covers only work that exists before the story is opened and never commits story-span work; once the story moves into `.catdd/spec/doingUS/`, the story span belongs to [SPEC_commitStoryWorks](SPEC_commitStoryWorks.md) and [SPEC_commitStepWorks](SPEC_commitStepWorks.md).

## CoT Pattern

**Linear** — Direct execution. Given the queued story and the pre-story artifacts produced since the last commit, this command resolves scope deterministically, drafts the message, and commits only after approval. If the story already opened, or if in-scope files are unrelated to the analyzed work, the observation stops and asks the developer.

### Linear Execution

Run these steps once, in order. There is no retry loop; an ambiguous or already-opened span stops and asks the developer.

1. Verify the target story still lives in `.catdd/spec/todoUS/`. If it already moved to `.catdd/spec/doingUS/`, stop and route to `SPEC_commitStoryWorks`, because the story span has already started.
2. Resolve the pre-story scope: `.catdd/spec/pendingNews/` removals and moves, `.catdd/spec/analyzedNews/` archive additions, `.catdd/spec/todoUS/` story artifacts, `README_UserStories.md` ledger rows, and project-context updates produced since the last commit.
3. Exclude `.catdd/spec/WorkingProcessLog.md` and generated adapter output. Stop and ask when an in-scope file is unrelated to the imported or analyzed work.
4. Read `recent_commit_messages` (latest 5) and extract tone, tense, capitalization, and scope format.
5. Draft the message with `WHAT` / `HOW` / `WHY` sections in that style, plus a `Span: pre-story -> SPEC_openUserStory` trace line and the issue/feature source trace.
6. In `manualMode`, present the draft and commit only after approval. When the intake ran headless with `analysis_mode: AUTONOMOUS`, this checkpoint is the default and commits without a per-step approval pause, while the universal stop rule still halts on any unresolved question. `execution_mode: autonomousMode` never applies to the pre-story span, because the flow restricts autonomous execution to `implementation-oriented` story work.
7. Hand off with `next_command = SPEC_openUserStory` for the selected story.

### Worked Example

An issue was imported and analyzed, and the resulting story is queued but not yet opened:

```text
/SPEC_commitPreStoryWorks
todo_user_story: .catdd/spec/todoUS/20260904-payment-retry-UserStory.md
analysis_mode_context: analysis_mode: AUTONOMOUS
branch_context: on the integration branch, no story branch yet
```

Expected result:

- Story still in `todoUS/` → the pre-story span is still open.
- Scope: `pendingNews/` removal, `analyzedNews/` archive addition, the new `todoUS/` story, and the `README_UserStories.md` TODO row.
- Draft presented (manualMode is not set, but no `auto_commit` was given), then committed after approval:

```text
Import and analyze the payment retry issue

WHAT
- Add US-07 payment-retry story to the todo backlog

HOW
- pendingNews issue moved to analyzedNews; todoUS story created; README_UserStories.md TODO row added

WHY
- Keep raw intake archived and open the story span from a committed backlog baseline
```

- Reported: `pre_story_commit_ref = 8c1d4e2`, `next_command = SPEC_openUserStory`.

## Inputs

- `todo_user_story`: queued `.catdd/spec/todoUS/*-UserStory.md` story selected for opening next.
- `pending_news_files`: optional `.catdd/spec/pendingNews/*.md` inputs consumed by analysis.
- `analyzed_news_files`: optional `.catdd/spec/analyzedNews/*.md` archive additions produced by analysis.
- `todo_us_files`: optional `.catdd/spec/todoUS/*-UserStory.md` stories created or revised by intake and analysis.
- `project_user_stories_doc`: project-root `README_UserStories.md` ledger rows added or changed by intake and analysis.
- `project_context_file`: optional `.catdd/spec/projectContext.md` updated because intake changed project facts or constraints.
- `analysis_mode_context`: optional note recording whether the intake ran with `analysis_mode: BRAINSTORM` or `analysis_mode: AUTONOMOUS`.
- `recent_commit_messages`: latest 5 commit log messages from `git log`, used as the style reference for the new commit message.
- `execution_mode`: optional `manualMode | autonomousMode` (default: `manualMode`). The pre-story span always runs in `manualMode`; its automatic checkpoint is driven by `analysis_mode: AUTONOMOUS` on the intake, not by `execution_mode`.
- `auto_commit`: optional flag that allows committing without an approval step when explicitly requested.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [SPEC_slashCommandTemplate](../../SPEC_slashCommandTemplate.md)

## Output Contract

- Pre-story commit that covers intake, analysis, and planning-input artifacts produced before `SPEC_openUserStory`.
- Explicit statement that no story-span file was committed, and that no story moved out of `.catdd/spec/todoUS/`.
- Draft commit message using explicit `WHAT` / `HOW` / `WHY` sections, plus:
  - `Span: pre-story -> SPEC_openUserStory`
  - Source trace to the imported issue, feature, or imported user-story input.
- Mode behavior:
  - `manualMode`: optional command the developer invokes when the pre-story phase should be committed before opening.
  - Headless intake (`analysis_mode: AUTONOMOUS`): default pre-story checkpoint; commit without a per-step approval pause, and still halt on any `ONE-MORE-THING` condition.
  - `execution_mode: autonomousMode`: not applicable to the pre-story span; if it is requested here, halt and force `manualMode` per the flow's implementation-oriented boundary.
- Reported `pre_story_commit_ref` and `next_command = SPEC_openUserStory`.
- Non-blocking post-success learning hook:
  - Report `success_learning_checkpoint = recommended`.
  - Preserve any required lifecycle command as `next_command`, and report `learning_command = /HARNESS_evolveHarness` separately.
  - Report `next_command = /HARNESS_evolveHarness` with `suggested_evolution_mode = auto` only when no lifecycle command has precedence.

## Conflict Guard

Do not run after the story moved to `.catdd/spec/doingUS/`; route to `SPEC_commitStoryWorks` instead.
Do not commit story-span work such as opened-story artifacts, test skeletons, product code, or review results.
Do not commit unrelated files; ask the developer before including ambiguous files.
Do not treat this checkpoint as mandatory in `manualMode`; it is an option the developer chooses.
Do not run this checkpoint under `execution_mode: autonomousMode`; the pre-story span is driven by `analysis_mode` and stays in `manualMode`.
Do not claim the story span started or finished because the pre-story span was committed.
Do not commit `.catdd/spec/WorkingProcessLog.md` or other gitignored local work state.

ONE-MORE-THING: ask developer if something not sure
