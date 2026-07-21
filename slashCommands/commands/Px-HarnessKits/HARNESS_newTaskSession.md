# HARNESS_newTaskSession

## Purpose

Capture and preserve important session context when a developer finishes the current task and starts a new session, so the next CodeAgent session does not lose key decisions, in-progress work, environment facts, or CaTDD lifecycle state.

## Command Type

HarnessKits tool-point command. This command produces a session handoff summary; it does not move a user story through SpecFlow lifecycle state and does not modify product code or test skeletons.

## CoT Pattern

**Checklist + ReACT** -- Collect session facts first, then reason over what is worth preserving for the next session. Surface only the details the next session needs to continue without re-discovering them. Prefer structure over prose so the handoff note can be pasted directly into the next session as context.

## Inputs

- `current_session_goal`: the task or user story the developer was working on this session.
- `code_agent`: the CodeAgent in use. Allowed values: `copilot`, `continue`, `cline`, `custom`, or `auto`.
- `scope`: optional scope of facts to capture. Allowed values: `full` (default), `spec_only`, `code_only`, or `decisions_only`.
- `target_file`: optional path to write the handoff note. When provided, write or append the handoff note to this path. When omitted, print the handoff note in the response only and do not write to `.catdd/spec/WorkingProcessLog.md`.
- `include_file_inventory`: optional flag. When true, list key changed or open files. Default: true.
- `include_pending_tasks`: optional flag. When true, list unchecked tasks from the active `.catdd/spec/doingUS/*-TASKs.md` artifact. Default: true.

## Preflight Mapping Checklist

Before collecting session facts, print and confirm:

1. `current goal`: the task or user story the developer was working on.
2. `lifecycle state`: active story ID and checked or unchecked tasks from `.catdd/spec/doingUS/` if any.
3. `code agent`: selected adapter surface.
4. `output target`: response-only, or write to `target_file` when specified.
5. `scope`: which categories of facts to collect.

If the current goal or lifecycle state is unclear, ask the developer before collecting facts.

## Session Handoff Workflow

1. **Collect lifecycle state**

   - Find the active story and its tasks artifact in `.catdd/spec/doingUS/`.
   - Record completed tasks (`[x]`) and pending tasks (`[ ]`).
   - Note the last `SPEC_*` command invoked: check `.catdd/spec/WorkingProcessLog.md` first, then ask the developer if it cannot be determined from the log or git history.

2. **Collect code and file context**

   - List key files touched, created, or left open during this session.
   - Note any in-progress or uncommitted changes.
   - Record relevant file paths, module names, and design doc references.

3. **Collect decisions and constraints**

   - Summarize key design decisions, trade-offs accepted, or blockers encountered.
   - Note conventions applied (naming, patterns, architecture choices) that are not yet documented.
   - Record any workarounds or known issues discovered.

4. **Collect environment facts**

   - Record relevant tool versions, configuration flags, or environment variables that affected this session.
   - Note any custom adapter paths, build steps, or test commands that are non-obvious.

5. **Compose handoff note**

   - Format the collected facts as a structured Markdown handoff note with clear headings.
   - Keep it dense but scannable: the next CodeAgent session must be able to paste it as context and resume without re-investigation.
   - Include a `## Next Action` section that names the exact next recommended command and its inputs.

6. **Output the handoff note**

   - Print the handoff note in the response.
   - If `target_file` is specified, write or append the note there.
   - Remind the developer to paste the note at the start of the next session.

## Handoff Note Template

The composed handoff note should follow this structure:

```markdown
## Session Handoff — <date> — <current_session_goal>

### Active Story
- Story ID: <id>
- Story file: <path>
- Tasks artifact: <path>

### Completed Tasks (this session)
- [x] <task>

### Pending Tasks (next session)
- [ ] <task>

### Key Files
- <path>: <one-line description>

### Decisions and Constraints
- <decision or constraint>

### Environment Facts
- <tool/config/env note>

### Next Action
- Command: <next SPEC_* or UT_* or HARNESS_* command>
- Inputs: <command inputs>
- Why: <one-line rationale>
```

## Method References

- [Px-HarnessKits](../../kits/Px-HarnessKits.md)
- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- A structured Markdown session handoff note with the sections defined in the Handoff Note Template.
- Lifecycle state summary: active story ID, completed tasks, and pending tasks.
- Key file inventory when `include_file_inventory=true`.
- Decision and constraint summary.
- A `Next Action` section naming the next recommended command and its inputs.
- When `target_file` is specified: confirmation that the note was written or appended.
- Reminder to the developer to paste the note at the start of the next session.

## Prompt Template

Ask the assistant to collect the current session facts — active SpecFlow lifecycle state, key touched files, design decisions, and environment notes — compose a structured handoff note using the Handoff Note Template, print the note in the response, optionally write it to the target file, and close with a clear next-action recommendation so the next session can resume without re-investigation.

## Conflict Guard

Do not modify product code, test skeletons, or SpecFlow lifecycle artifacts as part of this command.
Do not move the active user story or update task checkbox status; this command reads lifecycle state, it does not update it.
Do not include secrets, credentials, tokens, or sensitive personal data in the handoff note.
Do not invent decisions or constraints that were not observed during this session.
Do not fail silently when the active story or tasks artifact is missing; note the absence and ask the developer to confirm current goals.
Do not skip the `Next Action` section even when the next command is obvious.

ONE-MORE-THING: ask developer if something not sure
