# HARNESS_showMeStatus

## Purpose

Report the current harness status from the HARNESS viewpoint: what CaTDD installation, generated adapters, instruction surfaces, diagnostics, and evolution state exist around this project, and which harness command should run next.

This command is read-only. It answers "is the harness around this project healthy and current?" without repairing, regenerating, or patching anything.

## Command Type

StatusKits operational reporting command. It inventories harness surfaces and reports their state. It does not verify an installation to a PASS/WARN/FAIL verdict, does not diagnose a failure, and never mutates source or adapters.

## When to Invoke

Invoke `HARNESS_showMeStatus` when:

- the developer wants one status view across `.catdd/`, generated adapters, and instruction surfaces
- a fresh install or refresh just finished and its surface inventory should be reported before use
- the project may have drifted from the CaTDD source it was installed from
- a session resumes and it is unclear which adapters exist for which code agents
- before a release or handoff, to report harness currency without running a full verification

Do not invoke `HARNESS_showMeStatus` when:

- a PASS/WARN/FAIL installation verdict is required — that is `HARNESS_verifyInstallation`
- an installation is known to be broken and a root cause is needed — that is `HARNESS_diagnoseInstallation`
- project correctness, process discipline, and contract drift must be judged — that is `HARNESS_diagnoseProject`
- a verified lesson should be routed or the harness should evolve — that is `HARNESS_evolveHarness`

## CoT Pattern

**ReACT** — Reasoning + Acting. Harness evidence is heterogeneous: installed identity, per-agent adapters, instruction surfaces, source drift, and prior diagnostic or evolution results each describe a different part of the harness, and any surface may be absent, per-user, or stale. The loop inspects, classifies, and gathers one more read-only signal until every surface is classified.

### ReACT Execution

Repeat until every harness surface in scope is classified.

1. **Thought** — From the surfaces already read, name what is still unexplained: an installed version that cannot be compared to any source, a generated adapter tree with no matching portable command set, a per-user surface that cannot be confirmed from the repository, or a diagnostic result with no date.
2. **Action** — Run the next read-only inspection: read the install marker and manifest, count generated adapters against the portable command set, check instruction surfaces, compare installed version against the CaTDD source when a source path is available, and read prior verification, diagnosis, or evolution records when present.
3. **Observation** — Classify each surface as `healthy`, `attention`, `unknown`, or `not-installed`. Then read the Integrity Level ladder top-down and stop at the last level whose entry question is answered `YES` by cited evidence. A surface that cannot be confirmed from evidence is reported `unknown` with the reason → return to **Thought** for one more read-only signal, or stop and report the gap.
4. **Stop** — Exit when every surface is classified, the integrity level plus `level_evidence` and `level_gap` are recorded, findings are ordered by risk, and exactly one next harness command is recommended.

### Worked Example

Status check on an installed target project whose source has moved on:

```text
/HARNESS_showMeStatus
project_root: ~/work/acme-pay
```

Expected result:

- **Thought**: candidates — the install marker may not match the CaTDD source version, and the generated adapter count may not match the portable command count.
- **Action**: read `.catdd/CaTDD_INSTALL.md` and `.catdd/CaTDD_INSTALL.manifest`, count `.catdd/slashCommands/commands/**`, count generated wrappers, and read `.catdd/spec/projectContext.md`.
- **Observation**: install identity is `20260101.01` for target agent `Copilot`, and a source repository is available at `20260201.03` → `attention` (source drift). Adapter count matches the portable command count → `healthy`. The Codex per-user prompt directory cannot be confirmed from the repository → `unknown`, with the reason stated instead of guessed. No verification, diagnosis, or evolution record is present → `unknown`.
- **Observation (grade)**: Level-1 passes (an install marker exists and adapters are generated). The Level-2 question passes — adapter count equals the portable command count, the manifest baseline is coherent, and the managed-file reconciliation ratio is 1.0. The Level-3 question fails — the installed version trails the source with no recorded pin. So `integrity_level: Level-2 (Consistent)`, `level_evidence: reconciliation ratio 1.0; adapter count matches the portable command count; installed 20260101.01 vs source 20260201.03`, `level_gap: refresh the install to the source version, or record why it is pinned, to reach Level-3 (Current)`.
- **Stop**: report `viewpoint: HARNESS`, `status_signal: attention`, `integrity_level: Level-2`, the surface table, the source-drift finding with both versions, and `next_command: HARNESS_verifyInstallation` after the refresh.

## Inputs

- `project_root`: optional. Defaults to the current workspace root.
- `source_root`: optional path to the CaTDD source repository. When provided, installed-versus-source version drift is reported; when absent, currency is reported `unknown` instead of assumed.
- `focus`: optional surface or code agent to lead the summary. It never narrows the inventory silently.

## Integrity Level Model

`integrity_level` answers one question: **how present, consistent, current, proven, and spotless is the CaTDD harness around this project?** The mnemonic stays *neatness* or *tidiness*; the field name is integrity.

Read the ladder top-down and stop at the last level whose entry question is answered `YES` by cited evidence. A level is earned only when every level below it is also earned — never skip, never award a level from intention.

| Level | Name | In one line | Entry question (must be YES to earn this level) | Blocks this level |
| --- | --- | --- | --- | --- |
| Level-0 | Absent | The project is readable, and CaTDD is not installed. | Is the project root readable with no install marker? | `.catdd/CaTDD_INSTALL.md` or `.catdd/CaTDD_INSTALL.manifest` exists. |
| Level-1 | Present | Installed, but the adapters may be missing or stale. | Does an install marker exist, with generated adapters present for every declared target agent? | A declared target agent has no generated adapters. |
| Level-2 | Consistent | The harness agrees with itself. | Do the manifest managed-file count, the baseline, and the generated adapter counts reconcile with no unresolved drift? | Counts disagree, or unresolved drift or conflict is recorded. |
| Level-3 | Current | Aligned with the source it came from, with correct instruction surfaces. | Is the installed version current with the source, or deliberately pinned with a recorded reason, and are the instruction surfaces present with correct managed-region ownership? | The install trails the source with no recorded pin, or an instruction surface is missing or mis-owned. |
| Level-4 | Proven | A recent verification says the harness is trustworthy. | Is there current passing `HARNESS_verifyInstallation` evidence inside its freshness policy, with per-user surfaces explicitly confirmed and no unresolved WARN? | Verification is absent or stale, a WARN is unresolved, or a per-user surface was never confirmed. |
| Level-5 | Spotless | Nothing is stale, unknown, or half-finished. | Is every surface healthy with fresh evidence, with no `unknown` surface, no surface outside its freshness policy, and the last evolution or patch-back cycle closed? | Any surface is `unknown` or stale, or a harness cycle is left dangling. |

**Governed measures.** Two numbers decide the upper levels, and one count caps them. The **managed-file reconciliation ratio** is the managed files matching their manifest hash divided by the total managed files; Level-2 requires it to be 1.0. **Verification freshness** is the age of the last passing `HARNESS_verifyInstallation` result; Level-4 requires it to be inside its declared policy. Unconfirmed per-user surfaces are counted rather than scored: one unconfirmed surface caps the report at Level-4. Zero `unknown` surfaces is not a measure in itself, because an unknown surface is an epistemic gap, not a quantity.

Reading the ladder quickly:

- **Level-0 → Level-1** is about *installation*: is CaTDD there at all?
- **Level-1 → Level-2** is about *internal agreement*: do the manifest, baseline, and adapters reconcile?
- **Level-2 → Level-3** is about *currency*: is the install aligned with its source and its instruction surfaces?
- **Level-3 → Level-4** is about *proof*: has a verification actually passed recently?
- **Level-4 → Level-5** is about *finish*: is anything still unknown, stale, or left dangling?

Rules:

- Report `integrity_level: unknown` only when the project root or install marker could not be read. A readable root with no install is `Level-0`, never `unknown`.
- Per-user surfaces such as `$CODEX_HOME/prompts` cannot be confirmed from the repository, so an unconfirmed one caps the report at Level-4 and is the reason Level-5 is not claimed.
- A stale install is not a broken install: version drift is a Level-3 gap, not Level-2 drift.
- Level-4 and Level-5 are never claimed from the absence of complaints; name the verification evidence and the closed cycle.
- `level_gap` always names the single decisive blocker for the next level, so the next action is obvious.

## Status Model

Harness surfaces:

| Surface | Evidence |
| --- | --- |
| Installation identity | `.catdd/CaTDD_INSTALL.md`, `.catdd/CaTDD_INSTALL.manifest`, `.install-baseline/` |
| Portable method and command source | `.catdd/methodPrompts/`, `.catdd/slashCommands/` |
| Generated adapters | Per-agent wrapper trees such as `.github/prompts/`, `.continue/prompts/`, `.clinerules/`, `.antigravityrules/`, `.agents/skills/` |
| Per-user surfaces | Codex custom prompts under `$CODEX_HOME/prompts`; not shared through the repository |
| Instruction surfaces | `AGENTS.md` family and per-agent rule files, respecting managed-region ownership |
| Lifecycle workspace | `.catdd/spec/` lanes and `projectContext.md` |
| Prior harness evidence | Last `HARNESS_verifyInstallation`, `HARNESS_diagnoseProject`, `HARNESS_diagnoseInstallation`, or `HARNESS_evolveHarness` result |

Reported `status_signal` is one of:

- `healthy` — install identity is present, adapters match the portable command set, and no drift is found.
- `attention` — source drift, a missing or extra adapter, or stale harness evidence.
- `blocked` — the installation is incomplete or internally inconsistent and cannot be trusted for use.
- `unknown` — the project root or the install marker could not be read. A readable root with no install is `Level-0`, never `unknown`. A single surface that cannot be confirmed is reported `unknown` at the surface level and caps the level; that alone does not make the whole report `unknown`.

The canonical definitions of `integrity_level`, `status_signal`, the level model, and the HARNESS surface vocabulary live in [README_UbiLang.md](../../../README_UbiLang.md).

## Status Report Shape

```text
viewpoint: HARNESS
status_signal: healthy | attention | blocked | unknown
integrity_level: Level-N (Name) | unknown
level_evidence: <the artifact, count, or comparison that decided the level>
level_gap: <the single decisive blocker for the next level, or "top level reached">
as_of: <date or evidence reference>
project_root: <path>
install: version <v> | target_agent <agent> | managed_files <n>
source_compare: <source version and drift, or "no source_root provided">
surfaces:
  - <surface>: <healthy | attention | unknown | not-installed> — <evidence>
adapter_counts: <agent: generated n of portable m>
reconciliation: <managed files matching the manifest / total managed>
verification_freshness: <age of the last passing HARNESS_verifyInstallation, or "none recorded">
prior_evidence: <last verification/diagnosis/evolution result, or "none recorded">
findings:
  - <drift or gap, cited path, owning command, why it matters>
next_command: <one command>
note: read-only inventory; no verification verdict and no mutation
```

## Output Contract

- One Status Report Shape block covering every harness surface, including absent ones.
- One `integrity_level` from Level-0 to Level-5, or `unknown` when the project root or install marker could not be read.
- `level_evidence` and `level_gap` that cite a manifest, a count, a version comparison, or a verification record — never a feeling.
- Installed version, target agent, and managed-file count when an install marker exists.
- Adapter counts compared against the portable command set, per agent.
- The managed-file reconciliation ratio and the verification freshness whenever Level-2 or Level-4 is reported, or an explicit statement that the measure could not be taken.
- Per-user surfaces reported explicitly as unconfirmable from the repository rather than silently omitted.
- Findings ordered by risk, each citing a path.
- Exactly one recommended next command, chosen from `HARNESS_verifyInstallation`, `HARNESS_diagnoseInstallation`, `HARNESS_diagnoseProject`, `HARNESS_patchCaTDDSource`, `HARNESS_newTaskSession`, or `HARNESS_evolveHarness`.
- An explicit statement that this report is an inventory, not a PASS/WARN/FAIL verification verdict.

## Method References

- [Px-HarnessKits kit](../../kits/Px-HarnessKits.md)
- [Px-StatusKits kit](../../kits/Px-StatusKits.md)
- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)
- [CaTDD_methodPrompt-troubleshooting](../../../methodPrompts/CaTDD_methodPrompt-troubleshooting.md)

## Conflict Guard

- Never repair, regenerate, patch, or delete a harness surface from here. Report and route.
- Never report `healthy` for a surface that could not be read.
- Never inflate the integrity level. A level without cited evidence is reported as the level below it.
- Never let a per-user surface raise the level above Level-4 without explicit confirmation.
- Never claim a per-user surface such as `$CODEX_HOME/prompts` is shared through the repository; it is local to the machine.
- Never rewrite the hand-written region of any `AGENTS.md` file; ownership follows the region, not the file.
- Never present this inventory as `HARNESS_verifyInstallation` evidence; a verdict requires that command's checklist.
- `HARNESS_*` commands are tool-point commands and must not move SpecFlow lifecycle state.

ONE-MORE-THING: ask developer if something not sure
