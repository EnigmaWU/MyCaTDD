# SPEC_importFeature

## Purpose

Import a feature request, enhancement idea, product request, or developer proposal into `.catdd/spec/pendingNews/` as raw SpecCoding input.

## CoT Pattern

**Linear** — Direct execution. This command performs a deterministic import and normalization step. Given a feature source, it preserves intent, classifies the input, and writes the pending artifact without branching or multi-path analysis.

### Linear Execution

Run these steps once, in order. There is no retry loop; import never designs the feature.

1. Read `feature_source` and preserve the source text verbatim, or a traceable summary plus its link.
2. Classify the input with a lightweight label: feature, enhancement, experiment, refactor, or research.
3. Capture the stated user value when the source gives it. Do not invent a justification when it does not.
4. Write `.catdd/spec/pendingNews/*-Feature.md`.
5. Report the output path and `next_command = SPEC_analyzeFeature`.

### Worked Example

An idea surfaces mid-session and should not derail the current work:

```text
/SPEC_importFeature
feature_source: "Let users cap the retry count per merchant, some merchants want 1 attempt only"
projectContext_file: .catdd/spec/projectContext.md
```

Expected result:

1. Requester wording preserved verbatim, attributed to the chat session.
2. Classified `enhancement`.
3. Stated user value — "some merchants want 1 attempt only" — captured. No ACs, no design, no per-merchant config schema invented.
4. Written to `.catdd/spec/pendingNews/20260904-per-merchant-retry-cap-Feature.md`.
5. Reported: path + `next_command = SPEC_analyzeFeature`. Per the Subagent Recommendation below, this ran in a subagent so the active conversation continued uninterrupted.

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

## Conflict Guard

Importing is not analysis. Do not generate user stories or acceptance criteria in this command.

ONE-MORE-THING: ask developer if something not sure
