# UT_showMeStatus

## Purpose

Report the current unit-test status from the UT viewpoint: what is designed, what is RED, GREEN, TODO, BROKEN_TEST, BLOCKED, or carrying ISSUES, and which UT command should run next.

This command is read-only. It answers "where do my tests stand right now?" without implementing, refactoring, selecting a test case, or moving any marker.

## Command Type

StatusKits reporting command. It aggregates the status markers already written in CaTDD test skeletons and reports them. It never repairs, implements, promotes, or certifies a marker.

## When to Invoke

Invoke `UT_showMeStatus` when:

- the developer wants one status view across a test file, a story scope, or a whole repository
- a session resumes and the current TC state is unknown
- the developer is about to run `UT_tellMeNextImplTest` and wants to confirm a valid candidate set exists first
- a batch of `UT_implTestCase` runs finished and the markers should be reconciled against what was actually executed
- a report is needed before a commit, review, or handoff

Do not invoke `UT_showMeStatus` when:

- the goal is to choose the next TC to implement — that is `UT_tellMeNextImplTest`
- the goal is to prove an implementation passes — that is `UT_reviewImplTestCase` plus the project test runner
- the goal is whole-project or process health across all viewpoints — that is `HARNESS_showMeStatus` or `HARNESS_diagnoseProject`
- the goal is to repair a broken test or a stale marker — that is `UT_implTestCase`, `UT_refactTestCase`, or the owning design command

## CoT Pattern

**Linear** — Direct execution. The scan is exhaustive and deterministic: read every status marker in scope, count it, and report it. There is no candidate selection, no ranking decision, and no retry loop.

### Linear Execution

Run these steps once, in order. There is no retry loop.

1. **Scope** — Read `test_file_or_files`. When it is omitted, discover CaTDD test files inside `ut_scope` by finding files that carry US/AC/TC comment skeletons. Record the exact scope being reported, and never widen it silently.
2. **Collect** — Extract every TC tracking entry with its marker (`TODO`/`PLANNED`, `RED`/`FAILING`, `GREEN`/`PASSED`, `BROKEN_TEST`, `ISSUES`, `BLOCKED`), its `@AC` and `@US` linkage, and its file path. Preserve each marker exactly as written.
3. **Cross-check** — Read the design-gate evidence for the scanned scope when it exists: `discovery_status` (`PASS`/`GAPS`/`BLOCKED`), `ready_for_implementation` (`yes`/`no`), and the `discovery_ledger` disposition counts per class (`DESIGNED`, `GAP`, `QUESTION`, `EXCLUDED`, `REFERRED`). When the scope is story-based, also read the story-level AC status dashboard if one exists.
4. **Count** — Aggregate totals by marker, by CaTDD priority class (P0 Functional, P1 Design, P2 Quality, P3 Addons), and by file.
5. **Grade** — Read the Completeness Level ladder top-down and stop at the last level whose entry question is answered `YES` by cited evidence. The upper levels are class-scoped: Level-3 needs every P0 Functional obligation `CLOSED`, Level-4 needs P1 Design, P2 Quality, and P3 Addons `CLOSED` as well, and Level-5 needs the coverage number over P0-P3 with every uncovered obligation carrying a recorded disposition. Record `level_evidence` (what decided it) and `level_gap` (the one decisive thing blocking the next level).
6. **Report** — Emit the Status Report Shape below, order findings by risk (BROKEN_TEST, then RED, then BLOCKED, then ISSUES, then TODO), and recommend exactly one next command.
7. **Stop** — Stop after reporting. Do not edit files, do not move markers, and do not run the test suite unless the developer explicitly asked for fresh execution evidence.

### Worked Example

Status check on one story-scoped test file with mixed markers:

```text
/UT_showMeStatus
test_file_or_files: services/payment/SysTests/UT_Gateway.ts
focus: US-PAY-03
```

Expected result:

- **Scope**: one file, US-PAY-03 scope, 12 TC entries found.
- **Collect**: `TC-001..TC-008` GREEN, `TC-EDGE-004` TODO, `TC-FAULT-009` BLOCKED (missing sandbox credential), `TC-MISUSE-011` BROKEN_TEST (fails on a harness import error, not on the semantic assertion), `TC-PERF-012` RED.
- **Cross-check**: the file carries `discovery_status: PASS` and `ready_for_implementation: yes` for this scope, so marker-based status is meaningful and no design re-review is forced by this report.
- **Count**: 8 GREEN, 1 RED, 1 TODO, 1 BROKEN_TEST, 1 BLOCKED, 0 ISSUES; P0 Functional 10, P2 Quality 1, P1 Design 1.
- **Grade**: Level-2 questions pass — every TC carries a marker and a US/AC link, and the design gate is recorded. The Level-3 question fails — P0 Functional is not closed: `TC-EDGE-004` is TODO and `TC-MISUSE-011` is BROKEN_TEST. So `completeness_level: Level-2 (Tracked)`, `level_evidence: 100% marker coverage plus a recorded discovery_status and ready_for_implementation`; `level_gap: close P0 Functional - clear 1 TODO and 1 BROKEN_TEST - to reach Level-3 (P0 Closed)`.
- **Report**: `viewpoint: UT`, `status_signal: blocked`. The signal follows the marker model, not the level — a BROKEN_TEST and a RED are present, so the scope is not safe to act on even though the bookkeeping is sound. Highest risk first — `TC-MISUSE-011` BROKEN_TEST must be repaired before any production code is written for it; `TC-FAULT-009` is blocked on an execution prerequisite, not on a design question.
- **Next command**: recommended `UT_reviewImplTestCase` for `TC-MISUSE-011` after harness repair, with `UT_implTestCase` for `TC-PERF-012` and `UT_tellMeNextImplTest` noted as the resumption point afterwards. P1 Design and P2 Quality obligations are untouched in this scope, so Level-4 is far away and is not the next decision.

## Inputs

- `test_file_or_files`: optional list of CaTDD test files to scan.
- `ut_scope`: optional module, story, or directory scope. Defaults to the repository's CaTDD test files.
- `focus`: optional user story, feature, or category to prioritize in the summary. It never narrows the scan silently.
- `include_execution_evidence`: optional. When `yes`, cite the last known test-run evidence path separately from marker status. Defaults to `no`.

## Completeness Level Model

`completeness_level` answers one question: **how much of the designed test obligation is actually designed, implemented, and closed?**

Read the ladder top-down and stop at the last level whose entry question is answered `YES` by cited evidence. A level is earned only when every level below it is also earned — never skip, never award a level from intention.

| Level | Name | In one line | Entry question (must be YES to earn this level) | Blocks this level |
| --- | --- | --- | --- | --- |
| Level-0 | Absent | The scope is readable, and nothing is designed. | Is the scope readable and free of CaTDD skeletons? | Any US/AC/TC comment exists in scope. |
| Level-1 | Sketched | Skeletons exist but are unmarked or ungated. | Do US/AC/TC comment skeletons exist for the scope? | Marker coverage is complete and the design gate is recorded — that is Level-2, not Level-1. |
| Level-2 | Tracked | Every designed TC is marked, linked, and gated. | Does every TC carry a marker and a US/AC link, with `discovery_status` and `ready_for_implementation` recorded? | Any TC is unmarked, unlinked, or sits without a design gate. |
| Level-3 | P0 Closed | Every P0 Functional obligation is `CLOSED`. | Is every P0 Functional TC (Typical, Edge, Misuse, Fault) `CLOSED`, with no TODO, RED, BROKEN_TEST, or unresolved ISSUES among them? | Any P0 TC is open for a reason other than a cited prerequisite. |
| Level-4 | All Classes Closed | Level-3 holds, and every P1 Design, P2 Quality, and P3 Addons obligation is itself `CLOSED`. | Is every TC in the whole declared scope `CLOSED` across P0, P1, P2, and P3? | Any in-scope class still has an open obligation. |
| Level-5 | Quantified | Coverage is counted, not estimated, and nothing in scope is unexplained. | Is obligation coverage computed over P0-P3 from the `discovery_ledger`, with zero `GAP` and every uncovered in-scope obligation carrying an `EXCLUDED`, `REFERRED`, or `QUESTION` reason? | Any `GAP`, any uncovered obligation without a recorded reason, or any dangling link. |

`CLOSED` is a predicate on one test case: designed, US/AC-linked, and passing at `@[TestScope]: mockSysRtm` at its declared `@[TestLevel]`, with the `Anti-Test-Theater` Rule satisfied. Its evidence token is `testPassOnMock`. Closure never depends on a provisioned runtime environment: `mockSysRtm` is the first scope, always attempted first, and it earns closure at every level. `realSysRtm` is the second scope, which adds evidence; where a verification is meaningful only against the real runtime, leaving it unrun is a recorded unknown rather than a silent pass.

Reading the ladder quickly:

- **Level-0 → Level-1** is about *existence*: did anyone write the skeleton?
- **Level-1 → Level-2** is about *bookkeeping*: is every TC marked, linked, and gated?
- **Level-2 → Level-3** is about *closing the core*: are the P0 obligations closed on evidence rather than declared?
- **Level-3 → Level-4** is about *closing the scope*: are the design, quality, and addon classes closed too?
- **Level-4 → Level-5** is about *coverage*: is anything in scope still uncovered or unexplained?

Rules:

- Report `completeness_level: unknown` only when the scope could not be read. An empty but readable scope is `Level-0`.
- A missing design gate caps the report at Level-1 even when most TCs are GREEN, because the work is not traceable to a reviewed design.
- A marker alone never earns a level. `GREEN` without a `testPassOnMock` result at `mockSysRtm` is not `CLOSED`.
- Level-5 counts `DESIGNED` rows only. `QUESTION`, `EXCLUDED`, `REFERRED`, and `GAP` are never summed into coverage; they are reported separately as the reasons an obligation is not covered.
- `level_gap` always names the single decisive blocker for the next level, so the next action is obvious.

## Status Model

Marker vocabulary follows `methodPrompts`. The `CLOSED` predicate, the `disposition` vocabulary, and `TestScope` are defined in [README_UbiLang.md](../../../README_UbiLang.md).

| Marker | Meaning |
| --- | --- |
| `TODO` / `PLANNED` | Designed but not implemented. |
| `RED` / `FAILING` | Test written and failing for the expected semantic reason. |
| `GREEN` / `PASSED` | Test written and passing. |
| `BROKEN_TEST` | Failing for the wrong reason; repair the harness before writing production code. |
| `ISSUES` | Known problem needing attention. |
| `BLOCKED` | Cannot proceed because of a dependency or an unresolved source. |

Reported `status_signal` is one of:

- `healthy` — no BROKEN_TEST, RED, BLOCKED, or ISSUES findings in scope.
- `attention` — TODO or ISSUES findings only.
- `blocked` — at least one BROKEN_TEST, RED, or BLOCKED finding.
- `unknown` — the scope could not be read. A readable but empty scope is `Level-0`, never `unknown`.

Marker counts are not coverage. The report carries two axes:

- **Marker axis** — how many TCs sit at each marker, per class.
- **Disposition axis** — how many `discovery_ledger` rows are `DESIGNED`, `GAP`, `QUESTION`, `EXCLUDED`, and `REFERRED`, per class. Only `DESIGNED` rows count as coverage; the other four are the reasons an obligation is not covered, and that is what Level-5 reports.

## Status Report Shape

```text
viewpoint: UT
status_signal: healthy | attention | blocked | unknown
completeness_level: Level-N (Name) | unknown
level_evidence: <the artifact or count that decided the level>
level_gap: <the single decisive blocker for the next level, or "top level reached">
as_of: <date or evidence reference>
scope: <files, story, or paths inspected>
markers:
  green:
  red:
  todo:
  broken_test:
  issues:
  blocked:
distribution: P0 <n> | P1 <n> | P2 <n> | P3 <n>
closure: P0 <closed n>/<n> | P1 <closed n>/<n> | P2 <closed n>/<n> | P3 <closed n>/<n>
dispositions: DESIGNED <n> | GAP <n> | QUESTION <n> | EXCLUDED <n> | REFERRED <n>
test_scope: mockSysRtm <n> | realSysRtm <n>
design_gate: <discovery_status / ready_for_implementation, or "not present in scope">
findings:
  - <marker or disposition, TC id, path, owner, why it matters>
next_command: <one command>
note: marker-based status only; not execution evidence unless include_execution_evidence=yes
```

## Output Contract

- One Status Report Shape block for the declared scope.
- One `completeness_level` from Level-0 to Level-5, or `unknown` when the scope could not be read.
- `level_evidence` and `level_gap` that name a concrete artifact, count, or marker — never a feeling.
- Marker totals, the P0/P1/P2/P3 distribution, and the per-class closure count.
- Ledger dispositions and the `test_scope` split when a ledger or execution evidence is present, plus an explicit statement when either is absent.
- An explicit statement that Level-5 coverage counts `DESIGNED` rows only, so `GAP`, `QUESTION`, `EXCLUDED`, and `REFERRED` are visible as reasons rather than as coverage.
- Findings ordered by risk, each citing a marker, a TC or AC id, and a file path.
- Exactly one recommended next command, chosen from `UT_tellMeNextImplTest`, `UT_implTestCase`, `UT_refactTestCase`, `UT_reviewImplTestCase`, `SPEC_reviewImplUnitTests`, or the owning design/review command.
- An explicit statement when the scope has no markers, no design gate, or could not be fully read.

## Method References

- [P0-FuncTestsFlow](../../flows/P0-FuncTestsFlow.md)
- [P1-DesignTestsFlow](../../flows/P1-DesignTestsFlow.md)
- [P2-QualityTestsFlow](../../flows/P2-QualityTestsFlow.md)
- [Px-StatusKits kit](../../kits/Px-StatusKits.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)
- [CaTDD_methodPrompt-testStructure](../../../methodPrompts/CaTDD_methodPrompt-testStructure.md)
- [CaTDD_methodPrompt-testPointDiscovery](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md)

## Conflict Guard

- Never promote a marker. `GREEN` is claimed only from passing execution evidence, and this command does not certify it.
- Never read a missing marker as `GREEN`. Report `unknown` and name the file that lacks tracking.
- Never implement, refactor, or repair tests here. Report the finding and name the owning command.
- Never widen the reported scope to make totals look complete.
- Never inflate the completeness level. A level without cited evidence is reported as the level below it.
- Never let a `GREEN` marker alone award a class closure; closure requires the `CLOSED` predicate, and a `GREEN` without `testPassOnMock` evidence is reported as not closed.
- Never sum `QUESTION`, `EXCLUDED`, `REFERRED`, or `GAP` into coverage. They are the reasons an obligation is not covered, and Level-5 exists to report them.
- Never present a `mockSysRtm` result as system-verified. Report `test_scope` so the reader can see that only doubles were exercised.
- Preserve US/AC/TC traceability in the report and surface dangling linkage instead of hiding it.
- Category priority always comes from `methodPrompts`, never from file order.

ONE-MORE-THING: ask developer if something not sure
