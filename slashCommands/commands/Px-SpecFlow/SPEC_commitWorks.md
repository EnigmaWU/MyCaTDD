# SPEC_commitWorks

## Purpose

Generate a repository-style commit log message for any staged or recently modified change, and commit it after approval.

`SPEC_commitWorks` is the general, story-agnostic commit command. It does not require an open SpecFlow story, does not read the active `*-UserStory-Tasks.md` commit plan, and does not advance SpecFlow lifecycle state. Use the span-scoped commit commands when the commit should belong to a SpecFlow span:

- [SPEC_commitPreStoryWorks](SPEC_commitPreStoryWorks.md): commit the pre-story intake/analysis span before `SPEC_openUserStory`.
- [SPEC_commitStepWorks](SPEC_commitStepWorks.md): commit exactly one verified lifecycle step inside the open-to-close story span.
- [SPEC_commitStoryWorks](SPEC_commitStoryWorks.md): commit the whole `SPEC_openUserStory -> SPEC_closeUserStory` span as the just-done-story commit.

## CoT Pattern

**Linear** — Direct execution. Given the working tree state and the repository's recent commit style, this command resolves scope deterministically (staged first, most recently modified second), drafts the message, and commits only after approval. If the resolved scope does not describe one coherent change, the observation stops and asks the developer.

### Linear Execution

Run these steps once, in order. There is no retry loop; an ambiguous scope stops and asks the developer.

1. Resolve scope: use `staged_files` when non-empty; otherwise use `modified_files` ordered by most recent modification time, newest first.
2. If the resolved scope is empty, report `commit_scope = empty` and stop. Never create an empty commit.
3. Exclude local work state such as `.catdd/spec/WorkingProcessLog.md` and generated adapter output that the repository ignores.
4. Stop and ask when in-scope files belong to more than one coherent change, or when a file's purpose is unclear. One commit describes one change.
5. Read `recent_commit_messages` (latest 5) and extract tone, tense, capitalization, and scope format.
6. Draft the message with `WHAT` / `HOW` / `WHY` sections in that style.
7. Present the draft. Commit only after approval, or immediately when `auto_commit` is set.
8. Report the commit reference and state plainly that no SpecFlow lifecycle state advanced. Report `next_command = no_command` unless the developer named a next command explicitly, and report the learning hook separately as `learning_command` so it never overwrites the lifecycle handoff.

### Worked Example

A developer staged a documentation fix outside any active story:

```text
/SPEC_commitWorks
staged_files: README_UserGuide.md, scripts/installCaTDD.sh
recent_commit_messages: <latest 5 commits>
```

Expected result:

- Scope comes from staged files. No story artifact and no commit plan are consulted.
- Recent commits use imperative subjects with no scope prefix, so the draft matches that.
- Draft presented, not committed:

```text
Document the Codex install path in the slashCommands user guide

WHAT
- Add the Codex installer example and the generated adapter asset list

HOW
- README_UserGuide.md gained the Codex section; installCaTDD.sh help text documents --codex-prompts-dir

WHY
- Codex users had no documented install path after the Codex profile was added
```

- Reported: `commit_ref = 4f2c1ab`, `lifecycle_advanced = no`, `next_command = no_command`.

## Inputs

- `staged_files`: staged files to commit, preferred when non-empty.
- `modified_files`: fallback scope when nothing is staged; files ordered by most recent modification time.
- `recent_commit_messages`: latest 5 commit log messages from `git log`, used as the style reference for the new commit message.
- `message_style`: optional explicit style override when the recent history is inconsistent.
- `execution_mode`: optional `manualMode | autonomousMode` (default: `manualMode`). `SPEC_commitWorks` behaves the same in both modes because it is never an automatic checkpoint; the span-scoped commit commands own mode-default behavior.
- `auto_commit`: optional flag that allows committing without an approval step when explicitly requested.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../SPEC_slashCommandTemplate.md](../../SPEC_slashCommandTemplate.md)

## Output Contract

- Scope summary that names which tier resolved the scope: staged files first, most recently modified files second.
- Draft commit message first, using explicit `WHAT` / `HOW` / `WHY` sections:
  - `WHAT`: concise summary of the change.
  - `HOW`: key technical changes such as files, behavior, and tests.
  - `WHY`: rationale for the change, not a restatement of `HOW`.

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
- Commit created only after developer approval, or immediately when `auto_commit` is explicitly enabled.
- Reported `commit_ref`, resolved scope tier, and `next_command = no_command` unless the developer named a specific next command.
- Explicit statement that no SpecFlow lifecycle state advanced, so a general commit is never mistaken for a span commit.
- Non-blocking post-success learning hook:
  - Report `success_learning_checkpoint = recommended`.
  - Report `learning_command = /HARNESS_evolveHarness` with `suggested_evolution_mode = auto`.
  - Keep `next_command = no_command`; the learning command is never reported as `next_command`, because a general commit has no lifecycle successor.

## Conflict Guard

Do not commit unrelated changes together. Ask the developer before including ambiguous files.
Do not create an empty commit when the resolved scope is empty.
Do not read, write, or resolve scope from `.catdd/spec/doingUS/` story artifacts; span-scoped commits belong to `SPEC_commitPreStoryWorks`, `SPEC_commitStepWorks`, and `SPEC_commitStoryWorks`.
Do not advance SpecFlow lifecycle state, and do not claim an active story is committed because a general commit happened.
Do not commit `.catdd/spec/WorkingProcessLog.md` or other gitignored local work state.
Do not commit unadopted VibeCoding excursion edits as a general commit while a story is open; route them through the owning `SPEC_*` step or revert them first.

ONE-MORE-THING: ask developer if something not sure
