# SPEC_importFeature

## Purpose

Import a feature request, enhancement idea, product request, or developer proposal into `.catdd/spec/pendingNews/` as raw SpecCoding input.

## Inputs

- `feature_source`: feature URL, copied request text, product note, design sketch, or chat summary.
- `projectContext_file`: optional project context.
- `target_pending_file`: optional file name under `.catdd/spec/pendingNews/`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/pendingNews/*-Feature.md` team-shared persistent feature artifact.
- Preserved source text or a traceable summary.
- Clear labels for feature, enhancement, experiment, refactor, or research input.

## Prompt Template

Ask the assistant to preserve feature intent, normalize metadata, capture user value when available, and avoid design or implementation analysis beyond lightweight classification.

## Conflict Guard

Importing is not analysis. Do not generate user stories or acceptance criteria in this command.

ONE-MORE-THING: ask developer if something not sure
