# HARNESS_diagnoseProject

## Purpose

Diagnose the health of a project across two critical axes:

A. correctness and consistency of the project itself
B. whether the project is following the intended SpecCoding and CaTDD process discipline, including Px-SpecFlow and the canonical project rules

This command inspects repo evidence, active artifacts, process state, and contract consistency without mutating source by default. It is a project-diagnostics command, not a lifecycle completion command.

## Command Type

HarnessKits operational diagnosis command. It inspects project state, process adherence, contract drift, and configuration consistency. It does not move user-story lifecycle state or commit changes unless a repair step is explicitly approved later.

## When to Invoke

Invoke `HARNESS_diagnoseProject` when:

- the project feels “off” but no single product bug clearly owns the problem
- there is drift among README files, workflow artifacts, lifecycle folders, or command inventories
- a project has repeated documentation, process, or harness inconsistencies
- the developer wants a fast answer to whether the repo is correct, coherent, and aligned with the intended CaTDD / Px-SpecFlow flow
- a feature or refactor is finished and the team wants a health check before declaring the project stable

Do not invoke `HARNESS_diagnoseProject` when:

- a specific user story or product bug already has a precise owning `SPEC_*` command
- work is blocked on a concrete missing requirement or design decision that should be routed through the relevant lifecycle command
- the developer needs a direct repair or code change rather than a diagnosis

## CoT Pattern

**Observe -> Classify -> Rank -> Recommend** — inspect evidence, classify it into correctness, consistency, and SpecCoding drift, rank likely risks, and recommend the smallest next action.

## Inputs

- `target_project_repo`: repository to diagnose.
- `focus`: optional scope filter. Default: `all`.
  - `all`: inspect everything
  - `correctness`: focus on implementation, validation, and repository correctness
  - `consistency`: focus on naming, docs, command contracts, folder/asset alignment, and stale evidence
  - `speccoding`: focus on lifecycle adherence, story state, review gates, and CaTDD workflow drift
- `evidence_sources`: optional list of files, directories, or command outputs to include.
  - Common defaults: `README*`, `.catdd/spec/`, `methodPrompts/`, `slashCommands/`, `codeAgents/`, `scripts/`, recent `git status`, recent verification outputs
- `allow_repair`: optional flag. Default: `false`. Diagnosis is read-only unless explicitly enabled.
- `developer_notes`: optional mission context or suspected drift.

## Preflight Mapping Checklist

Before diagnosing, print and confirm:

1. `target project`: exact repo path being inspected.
2. `focus`: chosen analysis scope.
3. `evidence sources`: concrete files or directories included in the run.
4. `mutation policy`: read-only diagnosis unless `allow_repair=true`.

If the target path or evidence base is unclear, stop and ask the developer.

## Diagnosis Workflow

1. Confirm repository root and active lifecycle state.
2. Inspect project correctness:
   - code and docs still match the stated intent
   - generated files, command wrappers, and project files are coherent
   - verification signals and project artifacts agree with the current state
3. Inspect project consistency:
   - README mirror status
   - command inventory alignment
   - naming/path consistency
   - stale or duplicate story copies across lanes
   - inconsistent status markers or mismatched references
4. Inspect SpecCoding / CaTDD health:
   - whether `.catdd/spec/` state reflects actual flow progress
   - whether open/doing/done/abort lanes are coherent
   - whether review, update, design, and implementation gates were followed
   - whether project-level rules and canonical source-of-truth boundaries are respected
   - whether the same story or command is bouncing across lifecycle artifacts, task checkboxes, or review passes with no state progress (deadloop-risk, per the `Px-SpecFlow` Loop Guard)
5. Classify findings into these buckets:
   - `correctness-risk`
   - `consistency-risk`
   - `speccoding-drift`
   - `deadloop-risk`
   - `healthy`
6. Rank findings by severity and traceability.
7. Recommend the smallest next command or action for each risk.

## Risk Catalog

| Risk type | What it means | Typical next action |
| --- | --- | --- |
| correctness-risk | project behavior or state does not match the intended contract | run the relevant product/test or verification command |
| consistency-risk | docs, commands, or filesystem state disagree with each other | fix the drift and re-check the contract |
| speccoding-drift | lifecycle or CaTDD rules are being skipped, duplicated, or misapplied | route to the narrowest `SPEC_*` or `HARNESS_*` command |
| deadloop-risk | the same story or command bounces across lifecycle artifacts, task checkboxes, or review passes with no state progress (see `Px-SpecFlow` Loop Guard) | route to `SPEC_abortUserStory`, `SPEC_whatsNextTask`, or `ASK`; do not continue the same rework loop |
| healthy | no strong evidence of project drift | continue with the current task |

## Method References

- [Px-HarnessKits](../../kits/Px-HarnessKits.md)
- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- Diagnosis verdict: `HEALTHY`, `WATCHLIST`, `RISKY`, `BLOCKED`, or `INSUFFICIENT_EVIDENCE`.
- Summary of evidence reviewed.
- Findings grouped into:
  - `project_correctness`
  - `project_consistency`
  - `speccoding_drift`
  - `deadloop_risk`
- Each finding should include:
  - `severity`
  - `evidence_ref`
  - `why_it_matters`
  - `likely_owner`
  - `recommended_next_command`
- Recommended next command(s):
  - the most direct `SPEC_*` command for lifecycle issues
  - the relevant `HARNESS_*` command for harness or installation issues
  - a focused verification script when the issue is correctness-related
  - `no_action_required` when the project is healthy
- Non-blocking learning checkpoint:
  - if evidence supports a reusable improvement, report `learning_command = /HARNESS_evolveHarness` and keep it non-blocking

## Prompt Template

Ask the assistant to inspect the repository and classify project health across correctness, consistency, and SpecCoding discipline, ranking risks and recommending the smallest next command without modifying source unless a repair step is explicitly approved.

## Conflict Guard

Do not mutate source or lifecycle state in this diagnostic command.
Do not invent product requirements or story changes while diagnosing.
Do not confuse a project-health issue with a product bug unless the evidence clearly points to that ownership boundary.
Do not skip the canonical source-of-truth checks for `methodPrompts/`, `slashCommands/`, and `.catdd/spec/`.
Do not treat a missing command or stale doc as proof of a product bug without checking the evidence.
Do not claim the project is healthy without explicit evidence from the repository state or verification output.
Do not move a story or generate a close/abort action as part of diagnosis.

ONE-MORE-THING: ask developer if something not sure
