# HARNESS_evolveHarness

## Purpose

Evolve the CaTDD executable harness at test time using unlabeled execution traces, following the Test-Time Harness Evolution (TTHE) principle: the harness around the LLM is the state of adaptation, and improvements are proposed, judged, and persisted without changing model weights, requiring gold labels, or training a separate adaptation model.

## Command Type

HarnessKits tool-point command. This command improves the CaTDD command, adapter, execution, and diagnostic harness around the method source; it does not move a user story through SpecFlow lifecycle state.

## CoT Pattern

**ReACT + Observe-Propose-Judge** -- Reasoning + Acting with a candidate population. This command must collect execution traces, maintain parallel branch lineages, propose harness edits from trace evidence, judge them with execution-derived proxy signals, and commit the selected improvement with explicit safety gates.

## Inputs

- `target_project_repo`: project repository whose harness execution traces will be analyzed.
- `trace_source`: optional trace source selector. Default: `auto`.
  - `auto`: discover traces from `.catdd/spec/WorkingProcessLog.md`, verification reports, and recent test-script runs.
  - `run_artifacts_dir`: read from a directory produced by `HARNESS_collectRunArtifacts`.
  - `verification_report`: read from a previous `HARNESS_verifyInstallation` output.
  - `manual`: developer-supplied trace snippets or failure observations.
- `candidate_scope`: optional harness layer selector. Default: `all`.
  - `all`: consider command files, adapter wrappers, installer scripts, and verification scripts.
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
- `base_branch`: optional branch used as the safe starting point. Default: `main`.
- `target_branch`: optional non-default branch where the committed improvement is written. Required when `dry_run=false`.
- `budget`: optional guardrail set. Default: `{ max_wall_minutes: 60, max_candidates: 50, exclude_malformed: true }`.

## Preflight Mapping Checklist

Before evolution starts, print and confirm:

1. `target project`: exact absolute path being analyzed.
2. `trace source`: what execution traces or artifacts are available.
3. `candidate scope`: which harness layers may be changed.
4. `branches_G`, `rounds_R`, `batch_size_B`, `branch_roles`: search topology.
5. `proxy signals`: how the judge will decide which candidate wins.
6. `budget`: wall-clock, candidate count, and malformed-candidate limits.
7. `mutation policy`: `dry_run` preview unless `dry_run=false` and `target_branch` is provided.

If trace source or target path is unclear, stop and ask the developer.

## Evolution Workflow

1. **Observe**: execute the current harness on the current batch of trace events and collect detailed execution traces -- command invocations, wrapper failures, verification findings, installer errors, stdout/stderr, intermediate artifacts, runtime states, recovery attempts, and probe results.
2. **Initialize branches**: create `branches_G` parallel branch lineages from the current harness, each assigned a role from `branch_roles`. Each branch owns its parent and edits only its own lineage.
3. **Propose (R rounds)**: for each round, every branch's proposer edits its own parent harness into a child harness while free to read the other branches' code and traces for context. An invalid or unloadable child falls back to its parent.
4. **Observe children**: execute each newly generated child harness on the same batch and collect fresh traces and proxy signals.
5. **Judge**: inspect the final-round branches' code, traces, and proxy signals. The judge may run additional probes or re-execute candidates. It commits one harness as the winner using only label-free evidence.
6. **Score (measurement only)**: report the committed harness against the batch using cached outputs. Do not use this score to alter the committed harness.
7. **Persist or preview**:
   - If `dry_run=true`: report the winner, its diff, proxy evidence, coverage/selection notes, but do not modify files.
   - If `dry_run=false`: write the winner to `target_branch`, run a final verification, and report the committed improvement.

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
- [HARNESS_collectRunArtifacts](HARNESS_collectRunArtifacts.md) -- future command for trace collection.
- [HARNESS_verifyInstallation](HARNESS_verifyInstallation.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- Trace summary: what was observed, grouped by harness layer and failure mode.
- Branch population table: each branch's role, changed files per round, parent-child lineage, validity status, and fallback events.
- Proxy-signal matrix: each final candidate's scores across the selected proxy signals, plus raw-trace highlights.
- Winner selection: selected candidate, proxy evidence, confidence level, and selection-regret notes.
- Coverage gaps: observed failures that no candidate addressed.
- If `dry_run=true`: a commit-ready diff or patch artifact for the winner.
- If `dry_run=false`: branch name, final verification result, and exact committed files.
- Risk notes: conflicts, generated-wrapper drift, portability gaps, batch specialization, and side effects on non-harness files.
- Recommended next action:
  - `dry_run=true`: review the winner, then rerun with `dry_run=false` and a `target_branch`.
  - `dry_run=false`: run `HARNESS_verifyInstallation` in the target project and consider `HARNESS_patchCaTDDSource` if the fix should move upstream.
  - Coverage gap: broaden `candidate_scope`, add method knowledge, or file a spec-level story instead of a harness patch.

## Prompt Template

Ask the assistant to collect execution traces from the selected source, initialize `branches_G` parallel lineages with distinct roles, run `rounds_R` Observe-Propose-Judge cycles, expose raw traces and proxy signals (not a single scalar) to the proposer and judge, commit one label-free winner, and either preview the diff or write it to a non-default branch. Respect budgets, exclude malformed candidates, report coverage gaps and selection regret, and never modify model weights, require gold labels, or drift into product user-story work.

## Conflict Guard

Do not modify product code, user stories, acceptance criteria, or SpecFlow lifecycle state.
Do not evolve CaTDD method semantics; only the harness around them may change.
Do not commit directly to the default branch; use a non-default `target_branch` when `dry_run=false`.
Do not treat generated adapter wrappers as source-of-truth when portable command files are available.
Do not propose destructive changes that overwrite newer source content.
Do not run unbounded evolution; respect `branches_G`, `rounds_R`, and the `budget` guardrails.
Do not fabricate trace events; only propose candidates grounded in observed execution traces.
Do not collapse proxy signals into a single maximized scalar; expose raw traces and signal conflicts.
Do not train a separate adaptation model or update model weights.

ONE-MORE-THING: ask developer if something not sure
