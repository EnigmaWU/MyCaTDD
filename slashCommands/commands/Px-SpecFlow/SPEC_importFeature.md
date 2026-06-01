# SPEC_importFeature

## Purpose

Import a feature request, enhancement idea, product request, or developer proposal into `.catdd/spec/pendingNews/` as raw SpecCoding input.

## CoT Pattern

**Linear** — Direct execution. This command performs a deterministic import and normalization step. Given a feature source, it preserves intent, classifies the input, and writes the pending artifact without branching or multi-path analysis.

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

## Subagent Recommendation

When invoked during an active chat conversation — for example, when a new idea or feature request surfaces mid-session — prefer delegating this command to a subagent so the current conversation context is not occupied.

- Capture the feature source text or URL and the relevant project context from the current session.
- Pass them as inputs to the subagent.
- Let the subagent write the pending artifact and report the output file name on completion.
- Continue the current conversation without waiting for the subagent to finish.

## Prompt Template

Ask the assistant to preserve feature intent, normalize metadata, capture user value when available, and avoid design or implementation analysis beyond lightweight classification.

## Conflict Guard

Importing is not analysis. Do not generate user stories or acceptance criteria in this command.

ONE-MORE-THING: ask developer if something not sure
