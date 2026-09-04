# SPEC_importIssue

## Purpose

Import an issue, bug report, defect, or support problem into `.catdd/spec/pendingNews/` as raw SpecCoding input.

## CoT Pattern

**Linear** — Direct execution. This command performs a deterministic import and normalization step. Given an issue source, it preserves intent, classifies the input, and writes the pending artifact without branching or multi-path analysis.

### Linear Execution

Run these steps once, in order. There is no retry loop; import never re-analyzes its own output.

1. Resolve `import_mode` through the Execution Mode Selection policy below.
2. Read `issue_source` and preserve the source text verbatim, or a traceable summary plus its link.
3. Classify the input with a lightweight label: issue, bug, defect, regression, refactor, or research. Do not go further.
4. Capture observed and expected behavior when the source states them. Do not infer them when it does not.
5. Write `.catdd/spec/pendingNews/*-Issue.md`.
6. Report the output path, the mode used, and `next_command = SPEC_analyzeIssue`.

### Worked Example

A bug report is pasted mid-conversation:

```text
/SPEC_importIssue
issue_source: https://github.com/acme/pay/issues/4471 (plus 300 lines of gateway logs)
import_mode: auto
```

Expected result:

1. `auto` → source is long-form and combines a URL with bulky logs → `subagent` selected.
2. Issue body preserved verbatim; the log excerpt kept with its source link.
3. Classified `bug` / `regression`.
4. Observed ("customer charged twice") and expected ("charged once") are stated in the report, so both are captured. Root cause is **not** guessed.
5. Written to `.catdd/spec/pendingNews/20260904-double-charge-on-retry-Issue.md`.
6. Reported: path + `mode = subagent` + `next_command = SPEC_analyzeIssue`. No user story or AC is created here.

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

## Conflict Guard

Importing is not analysis. Do not generate user stories or acceptance criteria in this command.
In subagent mode, keep the same boundary: import-only, no story synthesis.

ONE-MORE-THING: ask developer if something not sure
