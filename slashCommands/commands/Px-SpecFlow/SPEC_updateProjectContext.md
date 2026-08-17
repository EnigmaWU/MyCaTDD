# SPEC_updateProjectContext

## Purpose

Refresh `.catdd/spec/projectContext.md` when project facts, constraints, conventions, or decisions change, while keeping it compact enough to serve as the always-loaded working memory for future `SPEC_*` commands.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the change source, existing context, and canonical project artifacts; classify each candidate memory; apply the minimum source-backed update; compact when needed; and verify that assumptions remain separate from stable facts without losing provenance.

## Inputs

- `projectContext_file`: existing project context.
- `change_source`: commit, discussion, issue, architecture decision, review result, or new project document.
- `sut_unit_convention`: optional updated SUT unit boundary for CaTDD unit tests (for example, switching from `class` to `module-interface`, refining a project-specific scope, or adding per-layer conventions). Only change this when the project has explicitly decided a different unit granularity.
- `lifecycle_dirs`: optional `.catdd/spec/pendingNews`, `.catdd/spec/analyzedNews`, `.catdd/spec/todoUS`, `.catdd/spec/doingUS`, `.catdd/spec/suspendUS`, `.catdd/spec/doneUS`, and `.catdd/spec/abortUS` directories when refreshing SpecFlow lifecycle state.
- `context_budget`: optional project-specific working-memory budget. Default soft limit: 200 lines or approximately 3,000 tokens.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- Updated `.catdd/spec/projectContext.md` team-shared persistent artifact containing compact, confirmed working memory and links to canonical detail.
- Updated `sut_unit_convention` when the change source includes a unit-boundary decision, including the new scope, rationale, and example SUT name.
- If `SpecFlow Lifecycle State` is updated, evidence that current lifecycle directories were read from the filesystem before editing, for example `ls -lrt .catdd/spec/pendingNews .catdd/spec/analyzedNews .catdd/spec/todoUS .catdd/spec/doingUS .catdd/spec/suspendUS .catdd/spec/doneUS .catdd/spec/abortUS` or an equivalent directory listing.
- A short change log describing what was added, replaced, linked, compacted, or discarded and why.
- A budget report with the resulting line count and, when available, approximate token count.
- Open questions for uncertain project intent.

## Project Memory Architecture

Treat `projectContext.md` as bounded working memory and a routing index, not as a complete project history or duplicated knowledge base.

| Tier | Source of truth | Read policy |
| --- | --- | --- |
| Working memory | `.catdd/spec/projectContext.md` | Read for every `SPEC_*` command. Keep only constitution-level guardrails and broadly reused project facts. |
| Semantic memory | Project-root and module `README*` SPEC docs, method docs, and stable configuration | Retrieve when the current story, module, or quality concern requires it. Keep only a concise link and routing description in project context. |
| Operational memory | Live `.catdd/spec/*News/` and `*US/` directories, repository state, and command output | Recompute from the filesystem when needed. Do not preserve snapshots as durable project context. |
| Episodic memory | ADRs, analyzed inputs, completed or aborted stories, review evidence, and Git history | Retrieve for rationale, diagnosis, or audit. Do not copy completed-work narratives into project context. |

## Memory Classification Rule

Before editing, classify every candidate item into exactly one class:

| Class | Meaning | Write action |
| --- | --- | --- |
| `CORE` | Stable project-wide identity, constraint, constitution-level guardrail, convention, or active decision needed by most future `SPEC_*` commands. | Add or update one concise entry in `projectContext.md`. |
| `REFERENCE` | Durable detail owned by a canonical requirement, architecture, detail-design, verification, usage, compatibility, or method artifact. | Keep the detail in its owning artifact; add or update only a short purpose-bearing link in `projectContext.md`. |
| `OPERATIONAL` | Reproducible current state such as lifecycle contents, branch status, generated files, latest test output, or next task. | Do not persist the snapshot; record the command or artifact location used to retrieve it. |
| `EPISODIC` | Historical event, completed story, superseded decision, review result, failure lesson, or commit evidence. | Keep it in an ADR, `analyzedNews/`, `doneUS/`, `abortUS/`, review artifact, or Git history; retain a context link only when it explains an active guardrail. |
| `TRANSIENT` | Temporary chat detail, exploration note, intermediate plan, or fact with no expected future use. | Do not write it to durable project context. |

If an item fits more than one class, choose the narrowest canonical owner. Promote it to `CORE` only when most future `SPEC_*` commands need it without first knowing the current story or module.

## Context Budget

- Use a soft limit of 200 lines or approximately 3,000 tokens unless `context_budget` defines another limit.
- Measure the file before and after the update. A copy-exec line-count check is `wc -l .catdd/spec/projectContext.md`.
- Trigger compaction when the context exceeds the budget, contains duplicated or superseded entries, or accumulates operational or episodic detail.
- The budget is subordinate to correctness. If the file cannot fit without deleting an active guardrail, unresolved project-wide question, or source route, leave it over budget and ask the developer which information may be externalized.

## Compaction Procedure

1. Inventory headings and identify duplicate, stale, superseded, overly detailed, operational, and episodic entries.
2. Preserve every `CORE` item, unresolved project-wide question, and link needed to locate canonical detail.
3. Merge semantically equivalent entries into one concise statement without broadening their meaning.
4. Replace `REFERENCE` detail with a purpose-bearing link to the owning artifact.
5. Replace `OPERATIONAL` snapshots with the reproducible command or live artifact location.
6. Remove `EPISODIC` narratives only after confirming their evidence remains in an ADR, lifecycle artifact, review record, or Git history.
7. Remove `TRANSIENT` content and resolved assumptions or questions.
8. Re-read the compacted result against its sources and run the Lossless Compaction Gate.

Compaction must be idempotent: running this command again without new evidence should not rewrite, reorder, or further summarize the context.

## Supersession Rule

- Update an existing fact in place instead of appending a newer version of the same fact.
- Keep only the currently effective rule in working memory.
- Before removing an old decision, verify that the replacement source explicitly supersedes it.
- Preserve historical rationale in its ADR, story, review artifact, or Git history. Add a `supersedes` or `superseded by` link there when the owning format supports it.
- If two confirmed sources conflict and precedence is not explicit, do not choose silently. Keep the current context unchanged and ask the developer to resolve the conflict.

## Lifecycle Inventory Rule

When the update touches `SpecFlow Lifecycle State`, do not rely on chat memory, prior projectContext bullets, or previous terminal scrollback as the source of truth. First inspect the actual lifecycle directories. Report the observed state in the command result, but keep only the directory contract and rerunnable inventory command in `projectContext.md`.

Recommended command:

```bash
ls -lrt .catdd/spec/pendingNews .catdd/spec/analyzedNews .catdd/spec/todoUS .catdd/spec/doingUS .catdd/spec/suspendUS .catdd/spec/doneUS .catdd/spec/abortUS
```

If one of those directories does not exist, report the absence explicitly instead of inventing an empty or populated state. Persist the absence only when it reflects a confirmed project configuration rather than a temporary checkout condition. Do not paste exhaustive or summarized pending, analyzed, todo, doing, suspend, done, or abort file state into `projectContext.md`; those snapshots drift and should come from the live directory command. Preserve stable project facts that are not lifecycle inventory.

## Lossless Compaction Gate

Before completing the update, verify all of the following:

- Every retained statement is confirmed by the change source, repository state, or a linked canonical artifact.
- Every constitution-level guardrail and active project-wide constraint remains present and semantically unchanged.
- Every externalized detail has a valid source route; no summary is the sole surviving copy of a decision or its rationale.
- Superseded facts no longer appear as active rules, and conflicting facts were not resolved without explicit precedence.
- Lifecycle snapshots, completed-work narratives, and reproducible repository state are absent from working memory.
- Assumptions and open questions are still clearly distinguished from confirmed facts.
- The resulting context meets `context_budget`, or the over-budget exception and developer question are reported.
- A second run with no new evidence would produce no change.

## Prompt Template

Ask the assistant to classify candidate memory as `CORE`, `REFERENCE`, `OPERATIONAL`, `EPISODIC`, or `TRANSIENT`; update existing facts in place; preserve provenance; compact to the context budget without semantic loss; separate assumptions from confirmed project rules; and use filesystem-backed lifecycle inventory before changing `SpecFlow Lifecycle State`.

## Usage Example

After an architecture decision is recorded in an ADR, run:

```text
/SPEC_updateProjectContext
projectContext_file: .catdd/spec/projectContext.md
change_source: codeAgents/utCodeAgentCLI/ADRs/ADR_RuntimeLanguage.md
```

Expected result: the active project-wide runtime constraint is updated once as `CORE` or linked as `REFERENCE`; alternatives and historical rationale remain in the ADR; superseded wording is removed; and the result reports `wc -l .catdd/spec/projectContext.md` against the context budget.

## Conflict Guard

Do not use project context to override CaTDD method rules; update `methodPrompts` first if the method itself changes.
Do not update pending, analyzed, todo, doing, suspend, done, or abort lifecycle state without first inspecting the corresponding `.catdd/spec/` directories. Do not turn `projectContext.md` into a duplicated lifecycle file index.
Do not satisfy the budget by deleting provenance, unresolved project-wide questions, active guardrails, or the only surviving copy of a decision.

ONE-MORE-THING: ask developer if something not sure
