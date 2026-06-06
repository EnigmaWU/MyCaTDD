# SPEC_clearStoryIntent

## Purpose

Clear the mutual intent between the developer and CodeAgent for an opened user story before architecture, detail design, test design, or implementation begins.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the active story and project context, restate the developer intent, state the CodeAgent intent, compare both against the story artifact, update the story only when the alignment is clear, and ask the developer when meaning, scope, non-goals, or success signals conflict.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `projectContext_file`: current project context.
- `developer_goal`: optional direct developer statement of desired outcome, priority, constraints, non-goals, or success signal.
- `codeagent_intent`: optional CodeAgent summary of what it believes it should do next.
- `related_docs`: optional issue, feature, README, architecture, design, test, or conversation notes relevant to intent.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `Mutual Intent Contract` recorded in the team-shared active story under `.catdd/spec/doingUS/`.
- The contract states developer intent, CodeAgent intent, in-scope work, out-of-scope work, success signal, assumptions, and open questions.
- Review result: `CLEARED`, `REVISE`, or `ASK`.
- If `CLEARED`: next recommended command is `SPEC_makePlan`, which decides whether the story needs architecture design, detail design, review, or can go directly to unit-test design.
- If `REVISE`: update the active story intent, scope, acceptance scenarios, or questions, then rerun `SPEC_clearStoryIntent`.
- If `ASK`: stop and ask the developer for the missing intent decision before design begins.

## Prompt Template

Ask the assistant to read the active story and project context, summarize the developer intent in plain language, summarize the CodeAgent intent as an execution commitment, compare both against the story artifact, and write a compact `Mutual Intent Contract` into the active story when they align. The contract should make clear what will be designed or implemented, what will not be touched, what evidence will prove success, and what questions still block design.

## Conflict Guard

Do not start architecture design, detail design, test skeleton design, or implementation when developer intent and CodeAgent intent are not aligned.

Do not use this command as the final story/design readiness gate. `SPEC_reviewUserStory` still runs after reviewed detail design to verify full story, design, acceptance-criteria, and CaTDD skeleton readiness.

ONE-MORE-THING: ask developer if something not sure