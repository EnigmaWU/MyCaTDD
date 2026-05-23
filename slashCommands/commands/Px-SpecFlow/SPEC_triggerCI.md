# SPEC_triggerCI

## Purpose

Trigger, monitor, or summarize CI after committed work.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect CI state, reason about which checks are required and whether they pass, act to trigger or summarize CI, and observe the result. If CI fails, the reasoning loop surfaces actionable routing (refactor or ask developer) instead of closing the story.

## Inputs

- `commit_ref`: commit or branch to verify.
- `ci_system`: CI provider or local equivalent.
- `verification_expectations`: required checks.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)

## Output Contract

- CI trigger or verification summary for committed team-shared work.
- Failing checks and suggested routing if CI fails.
- Next recommended command: `SPEC_closeUserStory` if CI passes, otherwise `SPEC_refactorIssue`.

## Prompt Template

Ask the assistant to run or inspect CI when tools are available, then summarize only actionable results.

## Conflict Guard

Do not close a user story when required CI checks fail or are unknown.

ONE-MORE-THING: ask developer if something not sure
