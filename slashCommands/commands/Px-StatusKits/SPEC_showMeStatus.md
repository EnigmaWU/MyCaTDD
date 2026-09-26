# SPEC_showMeStatus

## Purpose

Report the current SpecCoding status from the SPEC viewpoint: what sits in each `.catdd/spec/` lane, which story is actually active, which gate it is sitting behind, and which command should run next.

This command is read-only. It answers "where does SpecCoding stand right now?" without moving lifecycle state, editing artifacts, or committing anything.

## Command Type

StatusKits reporting command. It inventories SpecCoding lifecycle artifacts and reports them. It never moves a story between lanes, never edits a story or design document, and never replaces `SPEC_whatsNextTask`.

## When to Invoke

Invoke `SPEC_showMeStatus` when:

- a session resumes and the developer needs to know which story is open and how far it got
- the developer wants lane counts, active-story detail, and drift findings in one report
- work was paused, suspended, aborted, or partially closed and the current state is unclear
- a handoff, standup, or review needs a factual SpecCoding snapshot before decisions are made

Do not invoke `SPEC_showMeStatus` when:

- the goal is a single next-step recommendation with no full inventory — that is `SPEC_whatsNextTask`
- the goal is to diagnose project correctness, process discipline, and contract drift — that is `HARNESS_diagnoseProject`
- the goal is to move a story forward — use the owning `SPEC_*` lifecycle command
- the goal is to explain why the Flow cannot name what is wrong — that is `SPEC_whatsWrong`

## CoT Pattern

**ReACT** — Reasoning + Acting. SpecCoding status is spread across lanes, story files, dashboards, and local work state that can disagree with each other: a story can appear in two lanes, a tasks file can be missing, or AC totals can contradict the dashboard. The loop inspects, classifies, and gathers one more read-only signal until every lane is accounted for and every finding cites a path.

### ReACT Execution

Repeat until every `.catdd/spec/` lane and every active story is accounted for.

1. **Thought** — From the lanes and files already read, name what is still unexplained: an empty lane that should hold content, a story that appears in two lanes, an active story whose AC totals do not match its dashboard, or a referenced artifact that does not exist.
2. **Action** — Run the next read-only inspection: list lane contents, read the active story's status markers and task checklist, read `.catdd/spec/projectContext.md` for declared conventions, and read any story-level AC dashboard that exists.
3. **Observation** — Classify each lane and each finding as `current`, `empty`, `stale`, `drifting`, or `unknown`. Then read the Maturity Level ladder top-down and stop at the last level whose entry question is answered `YES` by cited evidence; Levels 4 and 5 additionally need the regeneration evidence and the published metrics, so they are never decided from lane state alone. A finding that cannot cite a file, lane, or artifact is unproven → return to **Thought** for one more read-only signal, or drop it.
4. **Stop** — Exit when every lane is classified, the maturity level plus `level_evidence` and `level_gap` are recorded, drift findings are ordered by risk, and exactly one next command is recommended for the active work.

### Worked Example

Status check on a repository mid-flow:

```text
/SPEC_showMeStatus
project_root: ~/work/acme-pay
```

Expected result:

- **Thought**: candidates — `pendingNews/` may hold unanalyzed intake, and a story file may exist in both `doingUS/` and `doneUS/` (stale copy or duplicate close).
- **Action**: list every lane, read `projectContext.md`, and read the active story plus its TASKs file.
- **Observation**: lane counts collected — `pendingNews` 3, `analyzedNews` 2, `todoUS` 5, `doingUS` 1, `suspendUS` 0, `abortUS` 1, `doneUS` 9. The duplicate story id is real and cited by path → `drifting`. The active story's AC totals match its dashboard → `current`. An empty `analyzedNews/` reference in the story cannot be confirmed → one more read confirms `analyzedNews/` exists and is unrelated → finding dropped.
- **Observation (grade)**: Level-1 passes (projectContext and all lanes exist, so the spec is written down). The Level-2 question fails — the same story id sits in two lanes. So `maturity_level: Level-1 (Spec-First)`, `level_evidence: lanes exist but one story id appears in both doingUS and doneUS`, `level_gap: resolve the duplicate placement to reach Level-2 (Organized)`.
- **Stop**: report `viewpoint: SPEC`, `status_signal: attention`, `maturity_level: Level-1`, active story and its current gate, the duplicate-close drift with both paths, and `next_command: SPEC_whatsNextTask`.

## Inputs

- `project_root`: optional. Defaults to the current workspace root.
- `focus`: optional story id, feature, or lane to lead the summary. It never narrows the inventory silently.
- `include_local_work_state`: optional. When `yes`, also report `.catdd/spec/WorkingProcessLog.md` state. That file is local, gitignored work state and is never treated as team-shared truth. Defaults to `no`.

## Maturity Level Model

`maturity_level` answers one question: **how far has the spec become the source of truth, and how disciplined is the pipeline that keeps it true?**

Read the ladder top-down and stop at the last level whose entry question is answered `YES` by cited evidence. A level is earned only when every level below it is also earned — never skip, never award a level from intention.

| Level | Name | In one line | Entry question (must be YES to earn this level) | Blocks this level |
| --- | --- | --- | --- | --- |
| Level-0 | Uninitialized | The project is readable, and SpecCoding has not started. | Is the project readable with no `.catdd/spec/` content? | `.catdd/spec/projectContext.md` exists. |
| Level-1 | Spec-First | The spec is written down before the code, but nothing keeps the two aligned. | Does `.catdd/spec/projectContext.md` exist with the lifecycle lanes readable? | A lifecycle lane is missing or unreadable. |
| Level-2 | Organized | Everything is in the right lane, once. | Is every artifact in exactly one lane that matches its state, with stable ids and paired TASKs files? | A story is duplicated across lanes, placed in the wrong lane, or missing its paired artifact. |
| Level-3 | Spec-Anchored | Gates connect the spec to the code, so drift is detected and must be resolved. | Does the active story show its gates in order (intent → design → review) with a current task checklist and AC status markers, and do closed stories carry verification evidence with AC totals reconciled against their story files? | A required gate is skipped or unrecorded, the markers are stale, a closed story lacks evidence, or AC totals disagree with the story file. |
| Level-4 | Spec-as-Source | The spec is the source and the code is derived from it through a verified pipeline. | Do the four preconditions hold — a complete spec, deterministic regeneration, verification of regenerated code, and no hand edits to generated files — with the governed metrics published? | Any precondition is unproven, regeneration evidence is absent, or the metrics are not published. |
| Level-5 | Self-evolving | The pipeline improves itself on top of Spec-as-Source. | Does Spec-as-Source hold, and has at least one verified lesson been routed and recorded with a measured effect, with no deadloop repeat and no backlog past the declared triage policy? | No lesson has been routed, a deadloop repeats, the effect is unmeasured, or intake exceeds the declared triage policy. |

Reading the ladder quickly:

- **Level-0 → Level-1** is about *existence*: is the spec written down at all?
- **Level-1 → Level-2** is about *placement*: is everything in the right lane, once?
- **Level-2 → Level-3** is about *anchoring*: do the gates detect drift, and is closed work evidenced and reconciled?
- **Level-3 → Level-4** is about *source of truth*: is the code derived from the spec and verified, rather than merely traced to it?
- **Level-4 → Level-5** is about *learning*: does the pipeline improve itself on a measured effect?

Rules:

- Report `maturity_level: unknown` only when `.catdd/spec/` could not be read. A readable project with no `.catdd/spec/` content is `Level-0`.
- Backlog sitting in `pendingNews/` is correct placement, not drift. Only a wrong lane, a duplicate, or a missing paired artifact fails Level-2.
- A story stalled behind an unrecorded gate caps the report at Level-2 however full the lanes look.
- Level-3 is where the method lives: SpecTDD is Spec-Anchored by design, so a repository legitimately tops out at Level-3. Level-4 is a direction, not a default target, and it is never claimed without regeneration evidence plus the published metrics.
- Level-5 is never claimed from good intentions; name the routed lesson, its measured effect, and the drift that was reconciled.
- `level_gap` always names the single decisive blocker for the next level, so the next action is obvious.

## Status Model

Lanes and their meaning follow `flows/Px-SpecFlow.md`:

| Lane | Meaning |
| --- | --- |
| `pendingNews/` | Intake recorded but not analyzed. |
| `analyzedNews/` | Analysis complete, not yet planned as stories. |
| `todoUS/` | Stories planned and waiting to be opened. |
| `doingUS/` | Stories currently open and being worked. |
| `suspendUS/` | Stories deliberately paused with a recorded reason. |
| `abortUS/` | Stories abandoned with a recorded reason. |
| `doneUS/` | Stories closed with evidence. |

Reported `status_signal` is one of:

- `healthy` — one or fewer active stories, no dangling rename, and no lane contradiction.
- `attention` — backlog movement, unanalyzed intake, or non-blocking drift findings.
- `blocked` — at least one active story is stalled behind an unresolved gate, missing artifact, or contradictory lane placement.
- `unknown` — `.catdd/spec/` could not be read. A readable project with no `.catdd/spec/` content is `Level-0`, never `unknown`.

**Governed metrics.** Levels 4 and 5 are decided by measurement as well as evidence, so report the four governed metrics and read them for movement at Level-5: `traceability coverage` (share of ACs with at least one GREEN TC), `first_pass_gate_rate` (share of reviews passing without rework), `drift_incidents` (divergences caught by a gate rather than by a customer), and `re_analysis_rate` (stories needing abort or partial close, and why). `SpecCoding share` is reported beside them: the fraction of production changes that trace to an open story, were preceded by a test failing for the expected reason, and passed a gate. It measures discipline, not correctness, so it is always read together with `drift_incidents`.

The canonical definitions of `maturity_level`, the three ladder terms Spec-First / Spec-Anchored / Spec-as-Source, and `SpecCoding share` live in [README_UbiLang.md](../../../README_UbiLang.md).

## Status Report Shape

```text
viewpoint: SPEC
status_signal: healthy | attention | blocked | unknown
maturity_level: Level-N (Name) | unknown
level_evidence: <the artifact or lane fact that decided the level>
level_gap: <the single decisive blocker for the next level, or "top level reached">
as_of: <date or evidence reference>
project_root: <path>
lanes: pendingNews <n> | analyzedNews <n> | todoUS <n> | doingUS <n> | suspendUS <n> | abortUS <n> | doneUS <n>
active_story: <story id, path, lane, current command or gate>
ac_totals: pending <n> | todo <n> | doing <n> | done <n> | suspend <n> | abort <n>
metrics: traceability_coverage <..> | first_pass_gate_rate <..> | drift_incidents <n> | re_analysis_rate <..>
spec_share: <fraction, or "not measured">
regeneration: <spec-as-source evidence, or "not applicable at this level" | "unknown">
findings:
  - <drift or stall, cited path, owning command, why it matters>
next_command: <one command>
note: team-shared artifacts only unless include_local_work_state=yes
```

## Output Contract

- One Status Report Shape block covering every lane, including empty lanes.
- One `maturity_level` from Level-0 to Level-5, or `unknown` when `.catdd/spec/` could not be read.
- `level_evidence` and `level_gap` that cite a lane, a path, or a reconciliation result — never a feeling.
- Lane counts, active story detail with its current gate, and AC totals when a dashboard or story markers exist.
- Drift findings each citing paths: a story in two lanes, a missing TASKs file, a dangling story reference, or lane/AC totals that contradict the story files.
- The four governed metrics and `SpecCoding share` when they are recorded, and an explicit statement when they are not measured rather than a silent omission.
- `regeneration` evidence whenever Level-4 or Level-5 is reported, or an explicit statement that the project does not claim those levels.
- Exactly one recommended next command, normally `SPEC_whatsNextTask`, or the owning `SPEC_*` command when a specific stall already identifies one.
- An explicit statement when a lane is empty, a dashboard is absent, or `projectContext.md` has not been initialized.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [Px-StatusKits kit](../../kits/Px-StatusKits.md)
- [Px-HarnessKits kit](../../kits/Px-HarnessKits.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)
- [CaTDD_methodPrompt-workflow](../../../methodPrompts/CaTDD_methodPrompt-workflow.md)

## Conflict Guard

- This command never moves lifecycle state. It reports lane placement; it does not change it.
- Never rewrite, rename, or relocate a story, tasks file, or dashboard from here.
- Never treat `.catdd/spec/WorkingProcessLog.md` as team-shared truth; it is local work state and stays gitignored.
- Report lane drift; do not silently pick the "correct" lane. A story in two lanes is reported with both paths and routed to its owning command.
- Never inflate the maturity level. A level without cited evidence is reported as the level below it.
- Never confuse amount of work with maturity: a full backlog in the wrong lanes is still Level-1.
- Never claim Level-4 without regeneration evidence and the published metrics. A source-of-truth pipeline asserted from intent is reported at Level-3.
- Never read `SpecCoding share` as a quality score. It measures how much of the work went through the flow, not whether the result is correct, so it is always reported with `drift_incidents`.
- Never claim Level-5 without a measured effect; a routed lesson with no measurable movement is a Level-4 finding, not a Level-5 one.
- Do not invent next-step options that the artifact state cannot justify; an unprovable candidate is dropped, not reported as possible.

ONE-MORE-THING: ask developer if something not sure
