# SPEC_clearStoryIntent

## Purpose

Clear the mutual intent between the developer and CodeAgent for an opened user story before architecture, detail design, test design, or implementation begins.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the active story and project context, restate the developer intent, state the CodeAgent intent, compare both against the story artifact, update the story only when the alignment is clear, and ask the developer when meaning, scope, non-goals, or success signals conflict.

### ReACT Execution

Repeat until the review result is `CLEARED` or the loop stops on `REVISE`/`ASK`.

1. **Thought** — Read `doing_user_story` and `projectContext_file`. State the developer intent in plain language and the CodeAgent intent as an execution commitment. Keep them as two separate statements; do not merge them yet.
2. **Action** — Compare both against the story artifact across five axes: meaning, in-scope, out-of-scope, success signal, assumptions. Write the `Mutual Intent Contract` into the active story only when all five agree.
3. **Observation** — Classify the result. A conflict the story itself can settle → `REVISE`, update the story and return to **Thought**. A conflict only the developer can settle → `ASK`, stop. No conflict → `CLEARED`.
4. **Stop** — On `CLEARED`, report `next_command = SPEC_makePlan`. Design and implementation must not start from this command.

### Worked Example

Before design starts on a freshly opened story:

```text
/SPEC_clearStoryIntent
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
developer_goal: Stop duplicate charges. Do not touch the settlement path.
```

Expected result — two passes:

- **Thought**: developer intent = "prevent duplicate charges via bounded retry". CodeAgent intent = "add a retry wrapper around the gateway call and extend settlement reconciliation".
- **Action**: comparison across the five axes — meaning agrees, success signal agrees, but out-of-scope conflicts: the developer excluded the settlement path and the CodeAgent planned to change it.
- **Observation**: the story's non-goals section is silent on settlement, so the story can settle this → `REVISE`. Non-goals updated with "settlement reconciliation is out of scope" → back to **Thought**.
- **Thought/Action (pass 2)**: CodeAgent intent restated without the settlement change; all five axes agree → `Mutual Intent Contract` written.
- **Observation**: `CLEARED` → **Stop**, `next_command = SPEC_makePlan`.

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

## Conflict Guard

Do not start architecture design, detail design, test skeleton design, or implementation when developer intent and CodeAgent intent are not aligned.

Do not use this command as the final story/design readiness gate. `SPEC_reviewUserStory` still runs after reviewed detail design to verify full story, design, acceptance-criteria, and CaTDD skeleton readiness.

ONE-MORE-THING: ask developer if something not sure