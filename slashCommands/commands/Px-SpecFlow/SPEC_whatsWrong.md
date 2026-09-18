# SPEC_whatsWrong

## Purpose

Switch the session from SpecCoding into VibeCoding when something is wrong but no gate or owning command can name it yet, so the problem can be investigated freely, then reconcile the result back into the Flow.

`SPEC_whatsWrong` is the third rung of the Px-SpecFlow escalation ladder:

1. Bounded rework inside the failing gate (`maxStepRetry`, `maxRunCorrectionLoop`).
2. `ONE-MORE-THING` stop rule, when the problem can be stated as a question.
3. `SPEC_whatsWrong`, when the problem cannot yet be stated as a question.

It is not a findings reporter and not a repair command. The Flow is frozen while VibeCoding runs, lifecycle state does not move, and nothing found during the excursion becomes story work until a `SPEC_*` step re-adopts it.

## Command Type

SpecFlow discipline-mode switch command. It freezes SpecCoding state, opens a bounded VibeCoding investigation, records the excursion in local work state, and routes every finding back to its owning command. It does not move lanes, does not repair, and does not advance the lifecycle.

## CoT Pattern

**Linear** — Direct execution. The switch itself is a deterministic sequence: classify the trigger, verify the execution mode, freeze the Flow, record the excursion, declare VibeCoding. The investigation happens inside VibeCoding, outside this command, so no candidate-selection tree and no in-command evidence loop are needed here.

### Linear Execution

Run these steps once, in order. There is no retry loop; a trigger that belongs to an existing owning command stops and routes instead of switching.

1. Classify the trigger against the allowed list:
   - Contradictory evidence between artifacts and observed reality, such as reviews passing while the same behavior keeps failing.
   - Plan drift: a `*-UserStory-Tasks.md` artifact whose checked tasks have no gate evidence behind them, or whose commit plan disagrees with the commits actually taken.
   - A bounded rework loop that exhausted `maxStepRetry` or `maxRunCorrectionLoop` with no observable progress, in `manualMode`. A headless `autonomousMode` run cannot switch discipline; it halts and lets the developer choose `ASK`, abort, or the switch.
   - A problem for which no owning `SPEC_*` or `UT_*` command can be named.
   - Escalation after a `ONE-MORE-THING` halt that could not be answered immediately.

   If an owning command plainly exists, stop and route there. Do not switch to avoid a gate, a requirement, or an acceptance criterion.
2. Verify `execution_mode = manualMode`. VibeCoding is manual-only. In `autonomousMode`, halt, force `manualMode`, and report `discipline_switch = forbidden_autonomous`; the agent may propose the switch, but it can never perform it headlessly.
3. Freeze SpecCoding state: record the resume hint — active story, paired `*-UserStory-Tasks.md`, interrupted step, and candidate next command — and assert the frozen classes stay untouched:
   - Frozen during VibeCoding: `.catdd/spec/**` except `WorkingProcessLog.md`, `README_UserStories.md`, `projectContext.md`, and the paired `*-UserStory-Tasks.md`.
   - Allowed but unadopted: product code, tests, and design docs, which the excursion may read or edit experimentally.
   - Local always: `.catdd/spec/WorkingProcessLog.md`.
4. Write one excursion entry to `.catdd/spec/WorkingProcessLog.md` (gitignored local work state) recording the trigger, the hypotheses, the investigation scope, the resume hint, and `adoption_status = unadopted`.
5. Declare `discipline_mode = VibeCoding` and hand over to free, method-guided exploration. `ONE-MORE-THING` remains binding inside VibeCoding. Exploratory writes are allowed, but every one of them stays `unadopted` until a `SPEC_*` step re-adopts it.
6. On return from the excursion: report findings and route each one to its owning command, report `learning_command = /HARNESS_evolveHarness` with `evolution_mode=auto` as a non-blocking hook, and report `resume_command` as any `SPEC_doXYZ` the developer chooses, defaulting to `SPEC_whatsNextTask`. Never auto-apply a repair, and never treat the excursion as a story-span commit.

### Worked Example

An implementation-oriented story keeps failing the same intermittent test while every review gate passes:

```text
/SPEC_whatsWrong
trigger_reason: SPEC_reviewImplUnitTests passes, but the same TC fails intermittently after each GREEN run
hypothesis: the fake clock advances real time somewhere in the fixture
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
execution_mode: manualMode
```

Expected result:

1. Trigger classified as contradictory evidence; no owning command can be named because both the review and the test report contradictory facts.
2. `manualMode` confirmed, so the switch is allowed.
3. Flow frozen at `SPEC_reviewImplUnitTests`; resume hint recorded; no lane moved.
4. Excursion entry written to `.catdd/spec/WorkingProcessLog.md` with `adoption_status = unadopted`.
5. VibeCoding session finds that the shared fixture seeds a real timer while the test assumes a fake clock.
6. Reported: `discipline_mode = VibeCoding`, finding routed to `SPEC_reviewImplUnitTests` (test-side fixture drift) with a secondary note for `SPEC_updateDetailDesign` (the design never declared clock control), `learning_command = /HARNESS_evolveHarness` with `evolution_mode=auto`, and `resume_command = SPEC_whatsNextTask`.

## Inputs

- `trigger_reason`: the observed contradiction, exhausted loop, unowned problem, or unresolved `ONE-MORE-THING` halt that justifies the switch.
- `hypothesis`: optional starting suspicion to explore first.
- `doing_user_story`: optional active story under `.catdd/spec/doingUS/`.
- `doing_tasks_file`: optional paired `.catdd/spec/doingUS/*-UserStory-Tasks.md` artifact holding the interrupted step.
- `working_log`: optional `.catdd/spec/WorkingProcessLog.md` local trace that receives the excursion entry.
- `investigation_scope`: optional statement of what the excursion may read or touch, so the session stays bounded.
- `resume_command`: optional explicit `SPEC_doXYZ` to resume with; defaults to `SPEC_whatsNextTask`.
- `execution_mode`: optional `manualMode | autonomousMode` (default: `manualMode`). VibeCoding is supported only in `manualMode`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)
- [SPEC_whatsNextTask.md](SPEC_whatsNextTask.md)
- [../Px-HarnessKits/HARNESS_evolveHarness.md](../Px-HarnessKits/HARNESS_evolveHarness.md)

## Output Contract

- Declared `discipline_mode = VibeCoding` with the classified trigger, so the switch is explicit rather than an implicit drop out of the Flow.
- Frozen-state assertion: which story, tasks file, and interrupted step were preserved, and confirmation that no lane moved and no lifecycle/team artifact was written.
- Excursion record path and contents: trigger, hypotheses, investigation scope, resume hint, and `adoption_status = unadopted`.
- Findings, each routed to its owning `SPEC_*` or `UT_*` command; `no_findings` is a valid outcome when the excursion disproves the suspicion.
- Frozen-state assertion that names the frozen classes: `.catdd/spec/**` except `WorkingProcessLog.md`, `README_UserStories.md`, `projectContext.md`, and the paired tasks file, with confirmation that no lane moved inside them.
- Adoption rule: exploratory edits to product code, tests, or design docs stay unadopted until a `SPEC_*` step re-adopts them, and no story-span commit covers an excursion. Every unadopted edit must be reverted or re-adopted before SpecCoding resumes.
- Non-blocking post-excursion learning hook:
  - Report `success_learning_checkpoint = recommended` when the excursion produced reusable tactics.
  - Report `learning_command = /HARNESS_evolveHarness` with `suggested_evolution_mode = auto`.
  - Keep the lifecycle command as `resume_command`; the learning command never displaces it.
- Resume contract: `resume_command` may be any `SPEC_doXYZ` the developer chooses, including `SPEC_whatsNextTask`, and the recorded resume hint makes that choice possible without re-deriving state.
- Autonomous refusal path: report `discipline_switch = forbidden_autonomous` and force `manualMode` instead of switching.

## Conflict Guard

Do not use `SPEC_whatsWrong` to avoid a gate, a missing requirement, an acceptance criterion, or write verification.
Do not run the switch in `autonomousMode`; halt and force `manualMode` instead, because unbounded exploration cannot be headless.
Do not treat `autonomousMode` as able to switch discipline at all: a headless run has no human intent source, so it halts and lets the developer choose `ASK`, abort, or the switch.
Do not move lifecycle lanes, rewrite story artifacts, or claim story progress during the switch.
Do not write into the frozen classes during VibeCoding: `.catdd/spec/**` except `WorkingProcessLog.md`, `README_UserStories.md`, `projectContext.md`, and the paired tasks file.
Do not treat exploratory edits as adopted story work; they become story work only after a `SPEC_*` step re-adopts them.
Do not commit an excursion as a story-span commit; span commits cover adopted Flow work only.
Do not suspend `ONE-MORE-THING` inside VibeCoding; the stop rule stays binding when an answer is genuinely unknown.
Do not let the agent switch discipline on its own; the agent may propose the switch and the developer confirms it in `manualMode`.
Do not let a diagnosed finding skip its owning command; route instead of repairing here.

ONE-MORE-THING: ask developer if something not sure
