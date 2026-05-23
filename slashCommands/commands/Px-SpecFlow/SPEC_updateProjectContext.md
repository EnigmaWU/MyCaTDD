# SPEC_updateProjectContext

## Purpose

Refresh `.catdd/spec/projectContext.md` when project facts, constraints, conventions, or decisions change.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the change source and the existing context, reason about what is confirmed vs. uncertain, apply the minimum change to the context artifact, and verify that assumptions remain separated from stable facts.

## Inputs

- `projectContext_file`: existing project context.
- `change_source`: commit, discussion, issue, architecture decision, review result, or new project document.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Updated `.catdd/spec/projectContext.md` team-shared persistent artifact with only confirmed changes.
- A short change log describing what changed and why.
- Open questions for uncertain project intent.

## Prompt Template

Ask the assistant to merge stable facts into context, preserve useful existing context, and separate assumptions from confirmed project rules.

## Conflict Guard

Do not use project context to override CaTDD method rules; update `methodPrompts` first if the method itself changes.

ONE-MORE-THING: ask developer if something not sure
