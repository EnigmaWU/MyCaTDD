# SPEC_designUnitTests

## Purpose

Design CaTDD unit test skeletons for the active user story after story and detail design review pass.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the active story and design artifacts, reason about the required P0/P1/P2 test categories and coverage surfaces, draft or update CaTDD US/AC/TC skeletons, and verify that skeletons are traceable to acceptance criteria and design docs before finalizing. The reasoning loop promotes P1/P2 categories only after P0 Functional coverage exists.

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
- `category_scope`: P0 first, then P1/P2 if design or quality requires it.
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
- Category labels, priority gates, and initial TC status markers.
- Next recommended command: `SPEC_implUnitTests` or a specific `UT_*` command.

## Category Command Routing

`SPEC_designUnitTests` is the story-level orchestration command. It must identify needed CaTDD categories from the active story and reviewed design, then inspect existing `slashCommands/commands/**/UT_design*Skeleton.md` command contracts before drafting skeletons directly.

- If the active story requires the full P0 Functional set, use the `UT_designFuncTestsSkeleton` contract for Typical, Edge, Misuse, and Fault skeleton design.
- If the active story requires one P0 Functional category, use the matching existing command contract: `UT_designTypicalSkeleton`, `UT_designEdgeSkeleton`, `UT_designMisuseSkeleton`, or `UT_designFaultSkeleton`.
- If the active story requires P1 Design categories, use matching existing command contracts such as `UT_designStateSkeleton`, `UT_designCapabilitySkeleton`, or `UT_designConcurrencySkeleton`.
- If the active story requires P2 Quality categories, use matching existing command contracts such as `UT_designPerformanceSkeleton`, `UT_designRobustSkeleton`, `UT_designCompatibilitySkeleton`, or `UT_designConfigurationSkeleton`.
- If no matching `UT_designXYZ` command exists, record the missing command as an explicit gap and fall back to category `methodPrompts` only when category intent is clear. Ask the developer when product or category intent is unclear.

The matching `UT_*` command owns the category skeleton mechanics; `SPEC_designUnitTests` owns lifecycle orchestration, cross-category coverage selection, traceability, and handoff to the next SpecFlow step.

## Language Template Selection

When creating or redesigning test files, infer the target language from `language`, `target_test_files`, or explicit story metadata. If a matching language-specific CaTDD design+implementation template exists in `methodPrompts/`, use it as the structural template source and record that provenance in the output. Do not apply a template from another language when a matching target-language template exists.

## Prompt Template

Ask the assistant to enter P0/P1/P2 test design flows as needed, use matching `UT_designXYZ` command contracts before direct skeleton drafting, preserve story-to-test traceability and source-command provenance, select the correct language-specific CaTDD template when available, and leave a parallel-ready implementation checklist for the next execution step.

## Conflict Guard

Do not skip P0 Functional coverage before promoting design or quality categories. Do not handcraft a category skeleton directly when a matching `UT_designXYZ` command contract exists.
Do not finish with dangling traceability: reject outputs where any US has no AC or any AC has no TC.
Do not omit SUT declaration in designed test-file overview comments.

ONE-MORE-THING: ask developer if something not sure
