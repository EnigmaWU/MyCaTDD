# SPEC_importUserStory

## Purpose

Import an existing structured user story, requirement slice, or acceptance-criterion slice directly into `.catdd/spec/todoUS/` as ready-to-open SpecCoding input.

Use this when the source already has `US-*`, `AC-*`, role, priority, dependency, or checklist structure, such as `README_UserStory.md`, `README_UserStoryStatus.md`, a PRD user-story table, or an exported backlog item.

Default convention: for each module or submodule, treat its `README_UserStory.md` as the formalized requirement source, coupled with `README_UserGuide.md` usage context. Imported user stories from this command are the trace source for downstream `README_ArchDesign.md` and `README_DetailDesign.md` updates.

## CoT Pattern

**Linear** -- Direct execution. This command performs a deterministic import and normalization step. Given a user-story source and selected slice, it preserves the existing requirement intent and writes a todo user-story artifact without creating new requirements or re-analyzing acceptance criteria.

## Inputs

- `user_story_source`: existing user story, requirement document, AC checklist, backlog export, copied story text, or chat summary.
- `source_convention`: when available, prefer `<module-or-submodule>/README_UserStory.md` plus sibling `README_UserGuide.md` as the source pair.
- `slice_id`: optional `US-*`, `AC-*`, role, range, or heading to import from the source.
- `granularity`: optional `US-by-US` or `AC-by-AC`; default is `US-by-US`.
- `projectContext_file`: optional project context.
- `target_todo_file`: optional file name under `.catdd/spec/todoUS/`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Import Granularity

- `US-by-US` is the default. Create one todo user-story artifact for one selected `US-*` requirement and preserve its related ACs, priority, dependency notes, status notes, and source links.
- `AC-by-AC` is allowed when one acceptance criterion is independently valuable, risky, or small enough to analyze and implement alone. Create one todo user-story artifact for one selected `AC-*` slice and preserve its parent `US-*` trace.
- If the developer explicitly requests batch import, create one todo artifact per selected US or AC. Do not merge unrelated requirements into one todo artifact unless the source explicitly treats them as one deliverable.

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user-story artifact ready for `SPEC_openUserStory`.
- Preserved source text, exact requirement IDs, acceptance-criterion IDs, priority, dependency hints, and status/checklist markers when present.
- Clear labels for structured user story, requirement slice, AC slice, backlog item, refactor requirement, research requirement, or documentation requirement input.
- Source trace to the original document path, URL, or copied source text.
- When the source is module/submodule `README_UserStory.md`, include explicit trace to the paired `README_UserGuide.md` and keep IDs stable for downstream `README_ArchDesign.md` and `README_DetailDesign.md` derivation.

## Subagent Recommendation

When invoked during an active chat conversation -- for example, when a developer points at a large `README_UserStory.md` and asks to import one US or AC slice -- prefer delegating this command to a subagent so the current conversation context is not occupied.

- Capture the user-story source text or path, selected `slice_id`, requested `granularity`, and relevant project context from the current session.
- Pass them as inputs to the subagent.
- Let the subagent write the todo artifact or artifacts and report the output file name on completion.
- Continue the current conversation without waiting for the subagent to finish unless the imported artifact is immediately needed.

## Prompt Template

Ask the assistant to preserve existing US/AC intent, normalize metadata, keep parent/child requirement traceability, and avoid design or implementation analysis beyond lightweight classification.

## Conflict Guard

Importing is not analysis. Do not invent new user stories, acceptance criteria, dependencies, priorities, implementation details, or verification results in this command.

This command is for already structured/formalized user-story input. If the source is issue-level or feature-level raw intent, use `SPEC_importIssue` or `SPEC_importFeature` and follow with analysis.

If module/submodule source conventions are unclear (for example missing `README_UserStory.md` or unclear pairing with `README_UserGuide.md`), ask the developer before writing.

If the requested `slice_id` cannot be found, or if `US-by-US` versus `AC-by-AC` is ambiguous and changes the artifact boundary, stop and ask the developer before writing.

ONE-MORE-THING: ask developer if something not sure
