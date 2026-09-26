# Px-StatusKits Command Templates

This directory contains `*_showMeStatus` command templates for CaTDD status reporting.

`*_showMeStatus` commands are read-only reporting commands, not lifecycle or repair commands. Each one answers "where do we stand right now?" from a single viewpoint and then names the command that should act on the finding.

## Command Map

| Command | Viewpoint | Purpose |
| --- | --- | --- |
| [UT_showMeStatus.md](UT_showMeStatus.md) | UT | Report TC markers, CaTDD class distribution, design-gate currency, and the next UT command. |
| [SPEC_showMeStatus.md](SPEC_showMeStatus.md) | SPEC | Report `.catdd/spec/` lane counts, the active story and its gate, AC totals, and lane drift. |
| [HARNESS_showMeStatus.md](HARNESS_showMeStatus.md) | HARNESS | Report installation identity, generated adapters, instruction surfaces, source drift, and prior harness evidence. |

## Shared Report Contract

All three commands emit the same outer shape so a developer can read them together:

```text
viewpoint: UT | SPEC | HARNESS
status_signal: healthy | attention | blocked | unknown
level: Level-N (Name) | unknown
level_evidence: <what decided the level>
level_gap: <the one thing blocking the next level>
as_of: <date or evidence reference>
evidence: <paths inspected>
findings: <risk-ordered, each citing a path>
next_command: <one command>
```

Each command adds viewpoint-specific metrics — UT marker totals, SPEC lane counts, or the HARNESS surface table — and each one states the limits of what it inspected.

## Level Contract

Each viewpoint reports exactly one graded level from `Level-0` to `Level-5`, under its own field name:

| Command | Level field | Question it answers | Level-0 means | Level-5 means |
| --- | --- | --- | --- | --- |
| [UT_showMeStatus.md](UT_showMeStatus.md) | `completeness_level` | How much of the designed test obligation is designed, implemented, and `CLOSED`? | Nothing is designed. | Obligation coverage is counted over P0-P3, with every uncovered obligation explained. |
| [SPEC_showMeStatus.md](SPEC_showMeStatus.md) | `maturity_level` | How far has the spec become the source of truth, and how disciplined is the pipeline that keeps it true? | SpecCoding has not started. | The Spec-as-Source pipeline improves itself on a measured effect. |
| [HARNESS_showMeStatus.md](HARNESS_showMeStatus.md) | `integrity_level` | How present, consistent, current, proven, and spotless is the harness around this project? | CaTDD is not installed. | Nothing is stale, unknown, or half-finished. |

How to tell the three apart in one glance:

- `UT` grades *the tests themselves* — tracked, then P0 closed, then every class closed, then coverage counted.
- `SPEC` grades *the spec's authority* — written down, organized, anchored to gates, then the source of truth, then self-evolving.
- `HARNESS` grades *the surrounding installation* — present, consistent, current, proven, spotless.

`integrity_level` keeps *neatness* / *tidiness* as its mnemonic. The canonical definitions of the three field names, `status_signal`, `CLOSED`, `testPassOnMock`, `TestScope`, and the disposition vocabulary live in [README_UbiLang.md](../../../README_UbiLang.md); these commands own the reporting procedure, not the meaning of the terms.

Shared level rules, identical in all three commands:

1. Levels are ordinal and monotonic. Level-N requires Level-(N-1); a level is never awarded by skipping.
2. Levels are decided by evidence, not intent. The report always names `level_evidence` and the single `level_gap` blocking the next level.
3. Read the ladder top-down and stop at the last level whose entry question is answered `YES` by cited evidence.
4. Report `unknown` only when the scope could not be read; an empty but readable scope is `Level-0`.
5. Never inflate the level. A level without cited evidence is reported as the level below it.

`level` and `status_signal` are related but not interchangeable: the level says *how far along* the viewpoint is, while the signal says *whether the current state is safe to act on*. A high level can still carry `attention` findings, and a genuine `blocked` finding caps the signal no matter how high the level is.

## Contract

StatusKits commands should follow [../../kits/Px-StatusKits.md](../../kits/Px-StatusKits.md) and stay reporting-oriented.

They may read files, lanes, manifests, adapters, and prior evidence records. They must not:

- repair, regenerate, move, or commit anything
- promote a UT marker or certify an execution result
- move SpecCoding lifecycle state
- return a PASS/WARN/FAIL installation verdict in place of `HARNESS_verifyInstallation`
- redefine CaTDD category meaning, SpecFlow lifecycle rules, or product requirements

When a report finds a defect, it names the owning command instead of fixing it. A status report is evidence for a decision, never the decision.

ONE-MORE-THING: ask developer if something not sure
