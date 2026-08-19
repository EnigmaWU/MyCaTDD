# HARNESS_learnFromSuccess

## Purpose

Learn from a meaningfully successful coding task, VibeCoding problem-solving session, user-story closure, or CodeAgent chat by extracting evidence-backed reusable lessons and routing each lesson to its narrowest canonical owner.

Reflection runs after success, but source mutation does not. A successful result proves that an approach worked in one observed context; this command persists a change only when the lesson is reusable, non-duplicative, correctly owned, and independently verifiable.

## Command Type

HarnessKits reflection tool-point command. It may propose improvements to project memory, specifications, CaTDD method sources, portable slash commands, adapters, scripts, or reusable skills. It does not move SpecFlow lifecycle state and does not silently edit any target.

## Who, When, and Where

- **Who**: developers and CodeAgents that have just completed a meaningful task successfully.
- **When**: after objective success evidence exists, such as passing tests, accepted review, a closed story, a validated fix, or a user-confirmed useful workflow.
- **Where**: run in the project where the success occurred so repository evidence and canonical owners can be inspected.

Do not invoke this command for routine success that produced no new reusable knowledge, while verification is incomplete, or as a substitute for diagnosing a failure.

## CoT Pattern

**Observe-Extract-Classify-Judge-Propose** -- inspect the goal, execution evidence, pivots, and successful outcome; extract candidate lessons; classify ownership; reject weak or duplicate lessons; and propose the smallest verifiable update. Default to a no-write dry run.

## Inputs

- `success_source`: completed chat/session summary, closed story, commit, review, issue resolution, execution trace, or developer description of the successful outcome.
- `success_evidence`: objective proof such as focused test output, CI result, accepted review, before/after behavior, or explicit developer confirmation.
- `candidate_scope`: optional owner filter. Default: `all`. Supported values: `project-context`, `product-spec`, `method`, `slash-command`, `harness`, `skill`, `all`.
- `dry_run`: optional flag. Default: `true`. When true, produce proposals without changing files.
- `apply_approved`: optional explicit approval to apply selected proposals. Default: `false`.
- `validation_command`: optional focused executable check for an approved change.

## Learning Workflow

1. **Observe**: summarize the original goal, meaningful actions, pivots or recovery steps, final outcome, and objective success evidence.
2. **Extract**: identify only lessons that materially contributed to success, such as a missing command step, decision rule, validation gate, recovery tactic, handoff, or reusable workflow.
3. **Classify**: assign every candidate lesson to exactly one canonical owner using the Ownership Router.
4. **Judge**: accept a candidate only when evidence connects it to the outcome, it is likely useful beyond this single task, it does not duplicate or contradict an existing rule, and a focused validation can disconfirm the proposed improvement.
5. **Propose**: produce the smallest owner-scoped patch and explain the evidence, expected reuse, risks, and validation check. Default to `dry_run=true`.
6. **Persist**: only when `dry_run=false` and `apply_approved=true`, apply the approved patch, run focused validation, and report the changed canonical artifacts.
7. **Stop**: return `no reusable learning` when no candidate passes the judge. This is a successful and preferred no-op outcome.

## Ownership Router

| Candidate lesson | Canonical owner | Required action |
| --- | --- | --- |
| Stable project-wide fact, constraint, or routing rule | `.catdd/spec/projectContext.md` | Delegate through `SPEC_updateProjectContext`; do not append session history. |
| Product behavior, acceptance criterion, edge case, or design decision | User story or project/module `README*` SPEC document | Update the narrowest owning specification through SpecFlow. |
| CaTDD category meaning, US/AC/TC semantics, or method rule | `methodPrompts/` | Require a reviewed method-level story; do not redefine semantics in a command. |
| Portable CodeAgent workflow or slash-command contract | `slashCommands/commands/` or `slashCommands/flows/` | Patch the portable source and validate generated adapters. |
| Installer, wrapper, verification, or execution-harness behavior | Harness command or `scripts/` | Keep product requirements and method semantics unchanged. |
| Reusable cross-project procedure with clear triggers | Agent skill | Create or improve the skill through its governed skill workflow. |
| One-session tactic, preference, or incidental detail | None | Classify as transient and discard. |

If a candidate fits multiple owners, select the narrowest source of truth. Split genuinely independent lessons instead of duplicating one lesson across artifacts.

## Success Evidence Gate

A session being pleasant, fast, or labeled `SUCCESS` is not sufficient by itself. Require at least one observable result tied to the original goal. Explicitly distinguish:

- **Outcome evidence**: proves the requested task succeeded.
- **Contribution evidence**: shows why the candidate lesson plausibly helped.
- **Reuse evidence**: shows recurrence, transfer to another context, or a clear general rule. A first occurrence may produce a proposal, but should not be auto-applied solely because it succeeded once.

Reject candidates based only on hindsight narration, unsupported causal claims, personal style with no engineering effect, or facts already owned elsewhere.

## CodeAgent Integration Hook

CodeAgents should add this non-blocking checkpoint after every meaningful successful task or session:

```text
success_learning_checkpoint = recommended
next_command = /HARNESS_learnFromSuccess
```

The checkpoint is a reminder to reflect, not permission to mutate files. Omit it only when `HARNESS_learnFromSuccess` already ran for the same success or when the developer explicitly disables the reminder. If another lifecycle command is the immediate `next_command`, preserve that command and report the learning hook separately as `learning_command = /HARNESS_learnFromSuccess`.

## Output Contract

- Success synopsis with goal, outcome, and evidence.
- Candidate table containing lesson, evidence, reuse rationale, classification, canonical owner, and decision (`PROPOSE`, `DISCARD`, or `ASK`).
- Duplicate and conflict check against the current canonical owner.
- For each `PROPOSE`, a minimal dry-run patch, risk note, and focused validation command.
- Applied-file and validation summary only when mutation was explicitly approved.
- Final status: `proposal ready`, `applied and validated`, `needs developer decision`, or `no reusable learning`.
- CodeAgent hook guidance for carrying `success_learning_checkpoint` into the relevant completion contract.

## Usage Example

After a successful coding session whose focused tests pass, run:

```text
/HARNESS_learnFromSuccess
success_source: current successful chat session
success_evidence: bash scripts/test_slashcommands_complete.sh passed
candidate_scope: slash-command
dry_run: true
```

Expected result: candidate lessons are routed and judged; any reusable command improvement is returned as a reviewable patch with a focused validation command. If the session revealed nothing durable, the result is `no reusable learning` and no file changes are made.

## Conflict Guard

Do not infer reusable causality from a success label alone.
Do not edit files when `dry_run=true`, `apply_approved=false`, evidence is incomplete, or ownership is ambiguous.
Do not place session narratives or reproducible operational state in `projectContext.md`.
Do not redefine CaTDD method semantics outside `methodPrompts/`.
Do not duplicate the same lesson across project context, specifications, commands, and skills.
Do not let the reflection checkpoint replace an immediate lifecycle, commit, merge, or safety action.
Do not treat `no reusable learning` as failure.

ONE-MORE-THING: ask developer if something not sure
