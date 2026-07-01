# SPEC_importIssue

## Purpose

Import an issue, bug report, defect, or support problem into `.catdd/spec/pendingNews/` as raw SpecCoding input.

## CoT Pattern

**Linear** — Direct execution. This command performs a deterministic import and normalization step. Given an issue source, it preserves intent, classifies the input, and writes the pending artifact without branching or multi-path analysis.

## Inputs

- `issue_source`: issue URL, copied issue text, bug report, support note, or developer-reported problem.
- `projectContext_file`: optional project context.
- `target_pending_file`: optional file name under `.catdd/spec/pendingNews/`.
- `import_mode`: optional `inline | subagent | auto` (default: `auto`).

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/pendingNews/*-Issue.md` team-shared persistent issue artifact.
- Preserved source text or a traceable summary.
- Clear labels for issue, bug, defect, regression, refactor, or research input.
- Output file path and the selected execution mode (`inline` or `subagent`).

## Execution Mode Selection

Use the following routing policy:

- `import_mode=inline`: execute in current agent.
- `import_mode=subagent`: delegate to subagent.
- `import_mode=auto`: choose by size/complexity.

`auto` selection rules:

- Prefer `subagent` when any of these are true:
	- issue source is long-form (roughly >120 lines or >8KB)
	- multiple source artifacts are included (URL + logs + pasted report)
	- active conversation context is already heavy and preserving working memory is more important than latency
- Prefer `inline` when:
	- issue source is short and deterministic
	- import is a simple single-file write with no bulky attachments

Cost note:

- Subagent reduces main-context pressure, but can add orchestration overhead.
- Inline is usually cheaper/faster for small issue imports.

If `subagent` is selected:

- Capture issue source and relevant project context.
- Delegate import-only work to subagent.
- Return output file path and mode used.

## Prompt Template

Ask the assistant to preserve issue intent, normalize metadata, capture observed/expected behavior when available, select execution mode by policy, and avoid analysis beyond lightweight classification.

## Conflict Guard

Importing is not analysis. Do not generate user stories or acceptance criteria in this command.
In subagent mode, keep the same boundary: import-only, no story synthesis.

ONE-MORE-THING: ask developer if something not sure
