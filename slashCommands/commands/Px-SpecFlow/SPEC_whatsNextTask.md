# SPEC_whatsNextTask

## Purpose

Recommend the next SpecCoding task when a developer is new to the flow or resuming paused work.

## CoT Pattern

**ToT** — Tree of Thoughts. This command must inspect all current lifecycle artifacts, generate the candidate next commands that could advance the work, evaluate each against the SpecFlow lifecycle rules and artifact state, and select exactly one recommendation. Multiple next-step paths may be valid simultaneously; ToT allows the assistant to reason over them before committing to one.

### ToT Execution

1. **Generate** — Inventory every `.catdd/spec/` lane that is non-empty and list the command each lane could justify. Produce at least two candidates whenever more than one lane has content.
2. **Evaluate** — For each candidate, name the artifact that proves it is runnable now. A candidate whose required input is missing or inconsistent is rejected, not deferred.
3. **Select** — Choose the candidate that advances the furthest-along work without skipping a gate. Never select a closing or destructive step on inconsistent state — stop and ask instead.
4. **Execute** — Report exactly one command, its rationale, and the inputs to prepare.
5. **Verify** — Confirm no earlier required gate was skipped. If one was, return to **Select**.

### Worked Example

A developer returns to a repository mid-flow:

```text
/SPEC_whatsNextTask
projectContext_file: .catdd/spec/projectContext.md
```

Expected result:

- **Generate**: `pendingNews/` has 1 issue → `SPEC_analyzeIssue`. `doingUS/` has 1 story → `SPEC_whatsNextTask` on its tasks file. `suspendUS/` has 1 story → `SPEC_resumeUserStory`. Three candidates.
- **Evaluate**: `SPEC_analyzeIssue` is runnable but starts *new* work. The `doingUS` story's tasks file shows detail design reviewed and TC-002 unimplemented → `SPEC_implUnitTests` runnable. The suspended story's `resume_ref` branch no longer exists → rejected, not deferred.
- **Select**: `SPEC_implUnitTests` — it advances the furthest-along work rather than opening a new front.
- **Verify**: skeleton review passed and product code has not been written → no gate skipped → selection stands.
- Reported: `SPEC_implUnitTests`, plus a note that the suspended story needs a new `resume_ref` before it can move.

## Inputs

- `projectContext_file`: optional `.catdd/spec/projectContext.md`.
- `pending_news_files`: optional `.catdd/spec/pendingNews/*.md`.
- `todo_user_story_files`: optional `.catdd/spec/todoUS/*-UserStory.md`.
- `doing_user_story_files`: optional `.catdd/spec/doingUS/*-UserStory.md`.
- `suspended_user_story_files`: optional `.catdd/spec/suspendUS/*-UserStory.md`.
- `done_user_story_files`: optional `.catdd/spec/doneUS/*-UserStory.md`.
- `working_log`: optional `.catdd/spec/WorkingProcessLog.md`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Exactly one recommended next command based on current SpecCoding artifacts.
- A short rationale describing current lifecycle stage and why this command is next.
- Required input artifacts to prepare before running the recommended command.
- If no reliable recommendation is possible, explicit blockers and questions for the developer.

## Conflict Guard

Do not invent missing story or design state. If required artifacts are missing or inconsistent, stop and ask the developer before selecting a destructive or closing step.

ONE-MORE-THING: ask developer if something not sure
