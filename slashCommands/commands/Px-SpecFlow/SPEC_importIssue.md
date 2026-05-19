# SPEC_importIssue

## Purpose

Import an issue, bug report, defect, or support problem into `.catdd/spec/pendingNews/` as raw SpecCoding input.

## Inputs

- `issue_source`: issue URL, copied issue text, bug report, support note, or developer-reported problem.
- `projectContext_file`: optional project context.
- `target_pending_file`: optional file name under `.catdd/spec/pendingNews/`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/pendingNews/*-Issue.md` team-shared persistent issue artifact.
- Preserved source text or a traceable summary.
- Clear labels for issue, bug, defect, regression, refactor, or research input.

## Prompt Template

Ask the assistant to preserve issue intent, normalize metadata, capture observed/expected behavior when available, and avoid analysis beyond lightweight classification.

## Conflict Guard

Importing is not analysis. Do not generate user stories or acceptance criteria in this command.

ONE-MORE-THING: ask developer if something not sure
