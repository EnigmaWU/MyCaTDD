# SPEC_importWorkItem

## Purpose

Import an issue, feature request, bug report, or developer request into `pendingNews/` as raw SpecCoding input.

## Inputs

- `work_item_source`: issue URL, copied issue text, feature request, bug report, or chat summary.
- `projectContext_file`: optional project context.
- `target_pending_file`: optional file name under `pendingNews/`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A pending work item file under `pendingNews/`.
- Preserved source text or a traceable summary.
- Clear labels for issue, feature, bug, refactor, or research input.

## Prompt Template

Ask the assistant to preserve source intent, normalize metadata, and avoid analysis beyond lightweight classification.

## Conflict Guard

Importing is not analysis. Do not generate user stories or acceptance criteria in this command.

ONE-MORE-THING: ask developer if something not sure
