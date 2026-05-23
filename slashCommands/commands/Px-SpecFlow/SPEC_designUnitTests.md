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
- `diagnosis_design`: optional project-root `README_DiagnosisDesign.md` for symptoms, logs, counters, traces, debug hooks, and root-cause evidence.
- `verify_design`: optional project-root `README_VerifyDesign.md` to create or update, using `slashCommands/templates/README_VerifyDesignTemplate.md` when first created.
- `target_test_files`: test files to create or update.
- `category_scope`: P0 first, then P1/P2 if design or quality requires it.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- CaTDD US/AC/TC skeletons in committed test files, linked back to local gitignored active story context and project-root README SPEC docs.
- Updated project-root verification design in `README_VerifyDesign.md` when test strategy or category coverage changes.
- Error, resource, state, performance, and diagnostic coverage linked to `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, or `README_DiagnosisDesign.md` when those design surfaces exist.
- First-time verification design should be based on `slashCommands/templates/README_VerifyDesignTemplate.md`.
- Category labels, priority gates, and initial TC status markers.
- Next recommended command: `SPEC_implUnitTests` or a specific `UT_*` command.

## Prompt Template

Ask the assistant to enter P0/P1/P2 test design flows as needed, preserving story-to-test traceability.

## Conflict Guard

Do not skip P0 Functional coverage before promoting design or quality categories.

ONE-MORE-THING: ask developer if something not sure
