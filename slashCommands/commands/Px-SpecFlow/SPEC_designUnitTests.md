# SPEC_designUnitTests

## Purpose

Design CaTDD unit test skeletons for the active user story after story and detail design review pass. For P0, this means designing the CaTDD Functional skeleton set `Typical`, `Edge`, `Misuse`, and `Fault` first; promote to `P1-DesignTestsFlow` or `P2-QualityTestsFlow` only when their gates are satisfied.

## CoT Pattern

**ReACT** — Reasoning + Acting with observable checkpoints. This command must inspect the active story and design artifacts, summarize the category-routing decision, act by drafting or updating CaTDD US/AC/TC skeletons, observe traceability and design-source gaps, then decide the next flow step. The loop is priority locked: complete the P0 Functional skeleton decision before any P1/P2 promotion, and promote P1/P2 only with explicit design-source evidence.

Use concise public reasoning summaries, not hidden chain-of-thought transcripts.

Example ReACT trace for P0-first unit-test design:

1. `Reason`: The active story has functional CLI behavior. P0 Functional applies and must be represented as `ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)`.
2. `Act`: Inspect `P0-FuncTestsFlow.md`, `UT_designFuncTestsSkeleton.md`, and the four category prompts for `Typical`, `Edge`, `Misuse`, and `Fault`.
3. `Observe`: ACs map to normal success, valid boundary, invalid caller usage, and external/file/config fault surfaces. Existing skeletons are missing or stale.
4. `Act`: Create or update the four P0 design skeletons with US/AC/TC comments, SUT, category labels, `@[SourceSPEC]`, `@[SourceUT]`, and template provenance.
5. `Observe`: Each US has at least one AC, each AC has at least one TC, and no P1/P2 design source is required yet.
6. `Decide`: Recommend `UT_reviewFuncTestsSkeleton`, then hand off ready P0 TC slices to `SPEC_implUnitTests`.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `detail_design`: reviewed design and acceptance criteria, usually from project-root `README_DetailDesign.md`.
- `error_design`: optional project-root `README_ErrorDesign.md` for error taxonomy, fault handling, recovery, degradation, or user-visible failure semantics.
- `resource_design`: optional project-root `README_ResourceDesign.md` for finite resources, allocation policy, memory, CPU, power, handle, or contention behavior.
- `state_design`: optional project-root `README_StateDesign.md` for state-machine, concurrency, buffer, or lifecycle behavior.
- `perf_design`: optional project-root `README_PerfDesign.md` for real-time, latency, throughput, memory, CPU, power, or media quality constraints.
- `compat_design`: optional project-root `README_CompatDesign.md` for supported versions, platforms, protocols, formats, toolchains, or integration boundaries.
- `diagnosis_design`: optional project-root `README_DiagnosisDesign.md` for symptoms, logs, counters, traces, debug hooks, and root-cause evidence.
- `verify_design`: optional project-root `README_VerifyDesign.md` to create or update, using `slashCommands/templates/README_VerifyDesignTemplate.md` when first created.
- `target_test_files`: test files to create or update.
- `category_scope`: P0 Functional first; then P1 Design or P2 Quality only if the active story, accepted design, or risk surface requires it.
- `existing_skeletons`: optional existing P0/P1/P2 skeleton files and their current TC status markers.
- `review_status`: optional prior `UT_reviewFuncTestsSkeleton`, `UT_reviewDesignTestsSkeleton`, or `UT_reviewQualityTestsSkeleton` result.
- `language`: optional target language or file extension for selecting a matching CaTDD design+implementation template.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- CaTDD US/AC/TC skeletons in committed test files, linked back to local gitignored active story context and project-root README SPEC docs.
- Enforced minimum traceability cardinality: each US has >=1 AC, and each AC has >=1 TC.
- Explicit SUT declaration in each designed test-file overview section.
- Updated project-root verification design in `README_VerifyDesign.md` when test strategy or category coverage changes.
- Error, resource, state, performance, compatibility, and diagnostic coverage linked to `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, or `README_DiagnosisDesign.md` when those design surfaces exist.
- First-time verification design should be based on `slashCommands/templates/README_VerifyDesignTemplate.md`.
- Evidence that existing `UT_design*Skeleton` command contracts were inspected before drafting category skeletons.
- Source-command provenance for each generated or redesigned category skeleton, including the orchestrating `SPEC_designUnitTests` command and the matching `UT_designXYZ` command when one exists.
- Language-template provenance when a matching `methodPrompts/CaTDD_designAndImplTemplate.<language>` file exists for the target test file language or extension.
- A parallel-ready implementation checklist that groups the next execution slices by US/AC/TC, notes dependencies, and highlights validation checkpoints before product-code work starts.
- A flow-coupling decision record that states the chosen P0 route, any P1/P2 promotion reason, the exact `UT_*` command contracts inspected, and the review command to run before implementation.
- Category labels, priority gates, and initial TC status markers.
- Next recommended command: `SPEC_implUnitTests` or a specific `UT_*` command.

## P0 Functional Skeleton Definition

In this command, P0 unit-test design means skeleton design, not executable test implementation.

CaTDD defines the P0 Functional skeleton set as:

```text
P0 Functional = ValidFunc + InvalidFunc
ValidFunc = Typical + Edge
InvalidFunc = Misuse + Fault
```

By default, `SPEC_designUnitTests` should route P0 work through `UT_designFuncTestsSkeleton` and produce or preserve all four category skeletons:

- `Typical`: core normal behavior.
- `Edge`: valid boundary values, limits, and mode variations.
- `Misuse`: invalid caller behavior or contract violations.
- `Fault`: external dependency, resource, filesystem, process, network, storage, or environment failures when the caller behaved correctly.

Use a single category-specific command only when the developer explicitly limits the scope or the story/design proves only one P0 category is relevant. Record the reason for any omitted P0 category.

## Flow Priority & Command Routing

`SPEC_designUnitTests` must couple to the category flows in this order and use the matching `UT_design*` command contracts when they exist.

| Priority | Flow | When to enter | Matching `UT_design*` command |
|---|---|---|---|
| 1st | `P0-FuncTestsFlow` | Always — classify every functional AC against `Typical`, `Edge`, `Misuse`, `Fault` | `UT_designFuncTestsSkeleton` (full set) or `UT_designTypicalSkeleton` / `UT_designEdgeSkeleton` / `UT_designMisuseSkeleton` / `UT_designFaultSkeleton` (explicit partial scope) |
| 2nd | `P1-DesignTestsFlow` | Only after P0 coverage exists or has an explicit non-applicable record; each skeleton must trace to a confirmed design source | `UT_designStateSkeleton` / `UT_designCapabilitySkeleton` / `UT_designConcurrencySkeleton` |
| 3rd | `P2-QualityTestsFlow` | Only after P0 exists and P1 is covered or explicitly not relevant; each skeleton must trace to the matching quality source | `UT_designPerformanceSkeleton` / `UT_designRobustSkeleton` / `UT_designCompatibilitySkeleton` / `UT_designConfigurationSkeleton` |

The SPEC command decides which flow to enter and which category to design; the matching `UT_design*` command owns the category skeleton mechanics. If no matching `UT_designXYZ` command exists, record the missing command as an explicit gap and fall back to category `methodPrompts` only when category intent is clear. Ask the developer when product or category intent is unclear.

## P0 Functional Coupling Gate

Before drafting or updating any P1/P2 skeleton, complete this P0 gate:

1. Read the active user story, acceptance criteria, detail design, and any existing P0 skeletons.
2. Map every functional AC to `Typical`, `Edge`, `Misuse`, `Fault`, or `P0 not applicable`.
3. Inspect `UT_designFuncTestsSkeleton` before drafting the default full P0 set. Inspect a category-specific command only for explicit partial P0 scope.
4. Draft or update skeleton comments for `Typical`, `Edge`, `Misuse`, and `Fault` in CaTDD order unless an omitted category has a recorded reason.
5. Preserve or create US/AC/TC traceability with `@[Class]`, `@[Category]`, `@[Priority]`, `@[Status]`, `@[SUT]`, `@[SourceSPEC]`, `@[SourceUT]`, and template provenance.
6. Recommend `UT_reviewFuncTestsSkeleton` before implementation if P0 skeletons were created or materially changed.

P0 is complete enough to promote only when core valid behavior and invalid caller/fault behavior are either covered or intentionally excluded with a design-backed reason.

## P1/P2 Promotion Gate

P1 and P2 skeletons are optional extensions, not substitutes for P0.

- Promote to P1 when lifecycle, capability boundary, or concurrency behavior is part of the accepted design and the required design source exists.
- Promote to P2 when measurable quality, robustness, compatibility, or configuration behavior is part of the accepted design and the required quality source exists.
- If the needed design source is missing, do not draft the skeleton from intuition. Record the gap and recommend the design command that should create or update the source.
- When P1 skeletons are created or materially changed, recommend `UT_reviewDesignTestsSkeleton`.
- When P2 skeletons are created or materially changed, recommend `UT_reviewQualityTestsSkeleton`.

## Handoff to SPEC_implUnitTests

The design output must leave `SPEC_implUnitTests` with a deterministic set of `tc_slices`:

- List candidate `tc_slices` by priority: P0 TCs first, then P1 TCs, then P2 TCs.
- For each slice, include US, AC, TC id, category, target file, dependency notes, and expected validation command.
- Mark independent slices that can be implemented in parallel without touching the same production behavior.
- State whether `UT_reviewFuncTestsSkeleton`, `UT_reviewDesignTestsSkeleton`, or `UT_reviewQualityTestsSkeleton` must run before implementation.
- Recommend `SPEC_implUnitTests` only when at least one TC is ready to implement and skeleton traceability is not dangling.

## Language Template Selection

When creating or redesigning test files, infer the target language from `language`, `target_test_files`, or explicit story metadata. If a matching language-specific CaTDD design+implementation template exists in `methodPrompts/`, use it as the structural template source and record that provenance in the output. Do not apply a template from another language when a matching target-language template exists.

## Prompt Template

Ask the assistant to use an observable ReACT loop: reason about category routing, act by reading the matching flow and `UT_*` command contracts, observe traceability/design-source gaps, and decide the next step. For P0, ask the assistant to design the CaTDD Functional skeleton set `Typical`, `Edge`, `Misuse`, and `Fault` through `UT_designFuncTestsSkeleton` by default, preserve story-to-test traceability and source-command provenance, select the correct language-specific CaTDD template when available, and leave a parallel-ready implementation checklist for the next execution step.

## Conflict Guard

Do not skip P0 Functional routing before promoting design or quality categories. Do not use P1/P2 skeletons to compensate for missing P0 coverage. Do not handcraft a category skeleton directly when a matching `UT_designXYZ` command contract exists.
Do not treat P0 design as only a Typical skeleton. P0 Functional means the four CaTDD design skeleton categories `Typical`, `Edge`, `Misuse`, and `Fault` unless explicit scope limits say otherwise.
Do not implement executable test bodies during `SPEC_designUnitTests`; this command designs skeletons and handoff slices only.
Do not finish with dangling traceability: reject outputs where any US has no AC or any AC has no TC.
Do not omit SUT declaration in designed test-file overview comments.
Do not recommend implementation until the required skeleton review command is either passed, explicitly not needed, or recorded as the next blocking step.

ONE-MORE-THING: ask developer if something not sure
