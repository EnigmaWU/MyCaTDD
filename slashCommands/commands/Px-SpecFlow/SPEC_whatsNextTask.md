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
- `execution_mode`: optional `manualMode | autonomousMode` (default: `manualMode`; `autonomousMode` must be explicit).

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Exactly one recommended next command based on current SpecCoding artifacts.
- A short rationale describing current lifecycle stage and why this command is next.
- Required input artifacts to prepare before running the recommended command.
- A mode decision: keep `manualMode`, or use developer-approved `autonomousMode` for the next flow advance.
- If no reliable recommendation is possible, explicit blockers and questions for the developer.

## Prompt Template

Ask the assistant to inspect current `.catdd/spec/` lifecycle artifacts, pick exactly one next `SPEC_*` command that best advances the active work without skipping required gates, and default to `manualMode` unless the developer explicitly requests `autonomousMode`. If the mode is not already explicit, ask whether the developer wants the next flow advance to remain in `manualMode` or switch to `autonomousMode`.

## Conflict Guard

Do not invent missing story or design state. If required artifacts are missing or inconsistent, stop and ask the developer before selecting a destructive or closing step.
Do not assume `autonomousMode`; it must be explicitly requested by the developer.

ONE-MORE-THING: ask developer if something not sure
