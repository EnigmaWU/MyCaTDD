# HARNESS_evolveHarness

## Purpose

Learn from verified CaTDD successes and failures, then evolve the correct canonical artifact at the smallest justified depth. One command supports lightweight evidence-backed refinement and heavier trace-driven restructuring without changing model weights or silently mutating source.

## Command Type

HarnessKits learning and evolution tool-point command. It routes reusable lessons to their narrowest canonical owner and may improve the CaTDD command, adapter, execution, diagnostic, specification, method, project-memory, or skill surface through the owning workflow. It does not move SpecFlow lifecycle state.

## When to Invoke

Invoke `HARNESS_evolveHarness` when:

- A meaningful coding task, VibeCoding session, user-story closure, or CodeAgent chat has objective success evidence and may contain a reusable lesson.
- Repeated `HARNESS_verifyInstallation` or `HARNESS_diagnoseInstallation` runs reveal the same harness-layer failure pattern (wrapper drift, stale installer, broken adapter rule, missing skill mapping, etc.).
- A newly installed CaTDD target project repeatedly fails one or more verification checks and the root cause is in the harness, not in product code or CaTDD method semantics.
- A `scripts/test_*.sh` harness test fails persistently and the fix belongs to the harness (installer, wrapper, verifier) rather than to a user story.
- You have collected run artifacts or execution traces that show how a harness command, wrapper, or installer misbehaves in practice.

Do **not** invoke `HARNESS_evolveHarness` when:

- Verification is incomplete or the only evidence is a `SUCCESS` label with no observable result.
- The problem is a missing feature, product bug, unclear requirement, or method-semantic change with an already-known owner -- delegate to the corresponding `SPEC_*` workflow instead of editing it directly here.
- You want a one-off quick fix without reviewing the diff -- `dry_run=true` is the default for a reason.

## CoT Pattern

**ReACT + Observe-Classify-Propose-Judge** -- inspect evidence, extract reusable lessons, route each lesson to its canonical owner, select the smallest justified evolution mode, and judge proposals with explicit validation. `restructure` adds the TTHE parallel-candidate population loop; `refine` does not.

## Inputs

- `target_project_repo`: project repository whose successful session, failure evidence, or harness traces will be analyzed.
- `evolution_mode`: optional depth selector. Default: `auto`.
  - `auto`: choose `refine` for one bounded lesson with a clear owner and focused validation; choose `restructure` only for repeated/systemic evidence or competing structural alternatives.
  - `refine`: propose one minimal owner-scoped update without branch-population search.
  - `restructure`: run the TTHE Observe-Propose-Judge population loop for a harness-level structural change.
- `learning_source`: optional completed session summary, closed story, commit, review, issue resolution, verification report, or execution trace.
- `learning_evidence`: objective outcome evidence and, when available, contribution and reuse evidence.
- `trace_source`: optional trace source selector. Default: `auto`.
  - `auto`: discover traces from `.catdd/spec/WorkingProcessLog.md`, verification reports, and recent test-script runs.
  - `run_artifacts_dir`: read from a directory produced by `HARNESS_collectRunArtifacts`.
  - `verification_report`: read from a previous `HARNESS_verifyInstallation` output.
  - `manual`: developer-supplied trace snippets or failure observations.
- `candidate_scope`: optional canonical-owner filter. Default: `all`.
  - `all`: classify across project context, product specification, method, slash commands, harness, and reusable skills.
  - `project-context`, `product-spec`, `method`, `skill`: delegate accepted lessons to the corresponding canonical owner and governed workflow.
  - `slashCommands`: portable command files under `.catdd/slashCommands/commands/`.
  - `wrappers`: native adapter wrappers such as `.github/prompts/*.prompt.md`.
  - `installers`: installation scripts under `.catdd/scripts/` or project-root `scripts/installCaTDD*.sh`.
  - `tests`: harness test scripts under `scripts/test_*.sh`.
- `branches_G`: optional number of parallel branch lineages. Default: `3`. TTHE shows that parallel lineages outperform a single lineage because they preserve diverse candidates for the judge.
- `rounds_R`: optional number of proposal rounds per batch. Default: `3`. Search is non-monotonic; more rounds help only when multiple lineages exist.
- `batch_size_B`: optional number of trace events grouped into one adaptation batch. Default: `10`.
- `branch_roles`: optional role assignment for each branch. Default: `conservative-repair, exploratory, adversarial`.
  - `conservative-repair`: fix observed failures with minimal changes.
  - `exploratory`: add new verification, grounding, or recovery logic motivated by traces.
  - `adversarial`: challenge current assumptions and probe edge cases.
- `proxy_signals`: optional list of execution-derived signals the judge may use. Default: `execution_health, script_pass_rate, diff_reduce`.
  - `execution_health`: candidate runs without error and returns well-formed output.
  - `round_trip_consistency`: output can be inverted back into the original intent and matches the input.
  - `script_pass_rate`: fraction of affected `scripts/test_*.sh` that pass.
  - `install_verify_pass`: installer and `HARNESS_verifyInstallation` succeed on a temp target.
  - `diff_reduce`: failure or warning inventory shrinks compared to baseline.
  - `manual`: developer provides the acceptance signal.
- `dry_run`: optional flag to produce candidate proposals without applying the winner. Default: `true`.
- `apply_approved`: optional explicit developer approval to apply a selected `refine` proposal. Default: `false`.
- `base_branch`: optional branch used as the safe starting point. Default: `main`.
- `target_branch`: optional non-default branch where the committed improvement is written. Required when `dry_run=false`.
- `budget`: optional guardrail set. Default: `{ max_wall_minutes: 60, max_candidates: 50, exclude_malformed: true }`.

## Mode Selection Gate

Use `refine` when all of these are true:

- One bounded lesson is supported by observable evidence.
- Its canonical owner is clear.
- The proposed change is minimal and a focused check can falsify it.
- Parallel alternatives would add cost without improving the decision.

Use `restructure` when any of these are true:

- Repeated traces reveal a systemic harness problem.
- The current command or adapter structure cannot express the required behavior cleanly.
- Multiple plausible structural candidates must be executed and compared.
- The change crosses harness modules or materially changes orchestration.

When `auto` lacks enough evidence to choose safely, return `ASK`; do not default upward to `restructure`. A valid run may return `no reusable learning`.

## Ownership Router

| Candidate lesson | Canonical owner | Evolution action |
| --- | --- | --- |
| Stable project-wide fact, constraint, or routing rule | `.catdd/spec/projectContext.md` | Delegate through `SPEC_updateProjectContext`; do not append session history. |
| Product behavior, acceptance criterion, edge case, or design decision | User story or project/module `README*` SPEC document | Delegate through the narrowest SpecFlow command. |
| CaTDD category meaning, US/AC/TC semantics, or method rule | `methodPrompts/` | Require a reviewed method-level story. |
| Portable CodeAgent workflow or slash-command contract | `slashCommands/commands/` or `slashCommands/flows/` | Refine directly when bounded; restructure only with systemic evidence. |
| Installer, wrapper, verification, or execution behavior | Harness command or `scripts/` | Refine or restructure according to the Mode Selection Gate. |
| Reusable cross-project procedure with clear triggers | Agent skill | Delegate to the governed skill workflow. |
| One-session tactic, preference, or incidental detail | None | Discard as transient. |

If a lesson fits multiple owners, choose the narrowest source of truth. Never duplicate the same lesson across owners.

## Evidence Gate

- **Outcome evidence** proves the task or correction succeeded.
- **Contribution evidence** connects the candidate lesson to that result.
- **Reuse evidence** shows recurrence, transfer, or a defensible general rule.

One verified occurrence may justify a dry-run `refine` proposal, but not automatic persistence. `restructure` requires repeated/systemic traces or concrete competing structural alternatives.

## Preflight Mapping Checklist

Before evolution starts, print and confirm:

1. `target project`: exact absolute path being analyzed.
2. `trace source`: what execution traces or artifacts are available.
3. `canonical owner`: where accepted learning would be remembered.
4. `evolution mode`: `refine` or `restructure`, with evidence-based rationale.
5. For `restructure`, `branches_G`, `rounds_R`, `batch_size_B`, `branch_roles`, and proxy signals.
6. `budget`: wall-clock, candidate count, and malformed-candidate limits.
7. `mutation policy`: dry-run unless the mode-specific approval requirements are satisfied.

If trace source or target path is unclear, stop and ask the developer.

## Evolution Workflow

1. **Observe**: summarize the goal, meaningful actions, pivots, outcome, and available evidence.
2. **Extract and classify**: identify candidate lessons, discard transient details, and select one canonical owner per lesson.
3. **Select mode**: apply the Mode Selection Gate and report why `refine` or `restructure` is justified.
4. **Refine path**: propose one minimal owner-scoped patch, its risk, and a focused validation check. Apply only when `dry_run=false` and `apply_approved=true`; otherwise return the proposal.
5. **Restructure path**: initialize `branches_G` role-diverse lineages, run `rounds_R` Observe-Propose-Judge cycles on the same trace batch, expose raw traces and proxy signals, and select one winner. Apply only when `dry_run=false` and `target_branch` is a non-default branch.
6. **Persist or delegate**: write only through the canonical owner. For project context, product specification, method, or skill changes, hand off to the governed owning workflow.
7. **Stop**: return `no reusable learning` when no candidate passes the evidence and reuse gates.

## Proxy-Signal Rules

- Expose raw traces together with proxy signals to the proposer and judge; do not collapse them into a single scalar to be maximized.
- Cross-sample agreement is not correctness; candidates can share the same systematic error.
- A candidate that passes public tests may still fail hidden ones; treat pass rates as incomplete evidence.
- When signals conflict, the judge must record the conflict and choose based on the most trustworthy signal for the observed failure mode.

## Coverage and Selection Guardrails

- **Coverage gap**: no candidate may ever generate a valid fix for some observed failure. Report uncovered failures explicitly so the developer can add method knowledge or broaden candidate scope.
- **Selection regret**: the judge may commit a worse candidate over a better one due to proxy miscalibration. Report branch ranks and near-miss candidates when evidence is close.
- **Non-monotonic search**: increasing `rounds_R` or `branches_G` can hurt. Stop when the best proxy signal plateaus or when the budget is exhausted.
- **Malformed exclusion**: candidates that fail to load, do not terminate, or violate harness-layer boundaries are excluded and fall back to the parent.

## Method References

- [Px-HarnessKits](../../kits/Px-HarnessKits.md)
- [TTHE: Test-Time Harness Evolution](https://arxiv.org/abs/2607.08124) -- Nie et al., arXiv:2607.08124 [cs.SE], 2026. Source paper for the Observe-Propose-Judge population loop, harness-as-adaptation-state, and label-free proxy-signal design.
- [HARNESS_collectRunArtifacts](HARNESS_collectRunArtifacts.md) -- future command for trace collection.
- [HARNESS_verifyInstallation](HARNESS_verifyInstallation.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- Evidence synopsis with goal, outcome, and observed contribution.
- Candidate table with lesson, evidence, reuse rationale, canonical owner, mode, and decision (`PROPOSE`, `DISCARD`, or `ASK`).
- Duplicate and conflict check against the canonical owner.
- Mode selection and rationale.
- For `refine`: one minimal dry-run patch, risk note, and focused validation command.
- For `restructure`: branch population table, proxy-signal matrix, winner, coverage gaps, and selection-regret notes.
- Coverage gaps: observed failures that no candidate addressed.
- If `dry_run=true`: a commit-ready diff or patch artifact for the winner.
- If `dry_run=false`: branch name, final verification result, and exact committed files.
- Risk notes: conflicts, generated-wrapper drift, portability gaps, batch specialization, and side effects on non-harness files.
- Recommended next action:
  - `refine` with `dry_run=true`: review the proposal, then rerun with `dry_run=false` and `apply_approved=true`.
  - `restructure` with `dry_run=true`: review the winner, then rerun with `dry_run=false` and a `target_branch`.
  - `dry_run=false`: run `HARNESS_verifyInstallation` in the target project and consider `HARNESS_patchCaTDDSource` if the fix should move upstream.
  - Coverage gap: broaden `candidate_scope`, add method knowledge, or file a spec-level story instead of a harness patch.

## Prompt Template

Ask the assistant to inspect verified success or failure evidence, extract reusable lessons, route each to its canonical owner, and select `refine` or `restructure` using the Mode Selection Gate. For `refine`, propose one minimal validated update. For `restructure`, run the bounded TTHE parallel-candidate loop. Default to dry-run, permit `no reusable learning`, and never mutate the wrong owner.

## CodeAgent Integration Hook

After every meaningful verified success, report:

```text
success_learning_checkpoint = recommended
next_command = /HARNESS_evolveHarness
suggested_evolution_mode = auto
```

If a lifecycle, commit, merge, or safety command has precedence, preserve it as `next_command` and report `learning_command = /HARNESS_evolveHarness` separately.

## Usage Example

For a successful session with one bounded lesson:

```text
/HARNESS_evolveHarness
learning_source: current successful chat session
learning_evidence: focused command contract passed
evolution_mode: auto
dry_run: true
```

Expected result: `auto` selects `refine`, routes the lesson to one canonical owner, and returns one reviewable patch or `no reusable learning`. It does not start branch-population search unless evidence justifies `restructure`.

## Conflict Guard

Do not modify product code, user stories, acceptance criteria, or SpecFlow lifecycle state.
Do not directly evolve product or method semantics; delegate accepted lessons to their governed owner.
Do not commit directly to the default branch; use a non-default `target_branch` when `dry_run=false`.
Do not treat generated adapter wrappers as source-of-truth when portable command files are available.
Do not propose destructive changes that overwrite newer source content.
Do not run unbounded evolution; respect `branches_G`, `rounds_R`, and the `budget` guardrails.
Do not fabricate trace events; only propose candidates grounded in observed execution traces.
Do not collapse proxy signals into a single maximized scalar; expose raw traces and signal conflicts.
Do not train a separate adaptation model or update model weights.
Do not run `restructure` when a bounded `refine` proposal and focused check are sufficient.
Do not treat `no reusable learning` as failure.

ONE-MORE-THING: ask developer if something not sure
