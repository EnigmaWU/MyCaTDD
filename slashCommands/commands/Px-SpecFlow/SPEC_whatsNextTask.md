# SPEC_whatsNextTask

## Purpose

Recommend the next SpecCoding task when a developer is new to the flow or resuming paused work.

## CoT Pattern

**ToT** — Tree of Thoughts. This command must inspect all current lifecycle artifacts, generate the candidate next commands that could advance the work, evaluate each against the SpecFlow lifecycle rules and artifact state, and select exactly one recommendation. Multiple next-step paths may be valid simultaneously; ToT allows the assistant to reason over them before committing to one.

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

## Prompt Template

Ask the assistant to inspect current `.catdd/spec/` lifecycle artifacts and pick exactly one next `SPEC_*` command that best advances the active work without skipping required gates.

## Conflict Guard

Do not invent missing story or design state. If required artifacts are missing or inconsistent, stop and ask the developer before selecting a destructive or closing step.

ONE-MORE-THING: ask developer if something not sure
