# SPEC_updateProjectContext

## Purpose

Refresh `.catdd/spec/projectContext.md` when project facts, constraints, conventions, or decisions change.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the change source and the existing context, reason about what is confirmed vs. uncertain, apply the minimum change to the context artifact, and verify that assumptions remain separated from stable facts.

## Inputs

- `projectContext_file`: existing project context.
- `change_source`: commit, discussion, issue, architecture decision, review result, or new project document.
- `lifecycle_dirs`: optional `.catdd/spec/pendingNews`, `.catdd/spec/analyzedNews`, `.catdd/spec/todoUS`, `.catdd/spec/doingUS`, `.catdd/spec/suspendUS`, `.catdd/spec/doneUS`, and `.catdd/spec/abortUS` directories when refreshing SpecFlow lifecycle state.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Updated `.catdd/spec/projectContext.md` team-shared persistent artifact with only confirmed changes.
- If `SpecFlow Lifecycle State` is updated, evidence that current lifecycle directories were read from the filesystem before editing, for example `ls -lrt .catdd/spec/pendingNews .catdd/spec/analyzedNews .catdd/spec/todoUS .catdd/spec/doingUS .catdd/spec/suspendUS .catdd/spec/doneUS .catdd/spec/abortUS` or an equivalent directory listing.
- A short change log describing what changed and why.
- Open questions for uncertain project intent.

## Lifecycle Inventory Rule

When the update touches `SpecFlow Lifecycle State`, do not rely on chat memory, prior projectContext bullets, or previous terminal scrollback as the source of truth. First inspect the actual lifecycle directories, then record a concise lifecycle summary and the command developers can rerun for the current file lists.

Recommended command:

```bash
ls -lrt .catdd/spec/pendingNews .catdd/spec/analyzedNews .catdd/spec/todoUS .catdd/spec/doingUS .catdd/spec/suspendUS .catdd/spec/doneUS .catdd/spec/abortUS
```

If one of those directories does not exist, record the absence explicitly instead of inventing an empty or populated state. Do not paste exhaustive pending, analyzed, todo, doing, done, or abort file lists into `projectContext.md`; those lists drift and should come from the live directory command. Preserve stable project facts that are not lifecycle inventory.

## Prompt Template

Ask the assistant to merge stable facts into context, preserve useful existing context, separate assumptions from confirmed project rules, and use filesystem-backed lifecycle inventory before changing `SpecFlow Lifecycle State`.

## Conflict Guard

Do not use project context to override CaTDD method rules; update `methodPrompts` first if the method itself changes.
Do not update pending, analyzed, todo, doing, done, or abort lifecycle state without first inspecting the corresponding `.catdd/spec/` directories. Do not turn `projectContext.md` into a duplicated lifecycle file index.

ONE-MORE-THING: ask developer if something not sure
