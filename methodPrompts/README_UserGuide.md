# CaTDD Standalone User Guide

Comment-alive Test-Driven Development for developers and CodeAgents using `methodPrompts/` without the rest of this repository.

CaTDD was invented by EnigmaWU. IOC is the PlayKata module and proving ground that helped CaTDD evolve from an idea into a reusable methodology.

## Who

Use this guide if you are one of these readers:

- A developer who copied only `methodPrompts/` into a target project.
- A CodeAgent that receives `methodPrompts/` as its method source of truth.
- A maintainer who wants to apply CaTDD manually before using `slashCommands` or installers.
- A team member learning how to turn comments into living verification design.

## What

CaTDD means Comment-alive Test-Driven Development.

The core idea is:

```text
Comments is Verification Design.
LLM Generates Code.
Iterate Forward Together.
```

In CaTDD, structured comments are not passive documentation. They are the verification design that humans and LLMs use to create, review, implement, and evolve tests.

The minimum design chain is:

```text
US: User Story -> why the behavior matters
AC: Acceptance Criteria -> what must be true
TC: Test Case -> how to verify it concretely
```

## When

Use standalone `methodPrompts/` when:

- You want to start CaTDD in a project without installing code-agent adapters.
- You need a stable method reference for manual design work.
- You want to give a CodeAgent enough method context to design US/AC/TC skeletons.
- You are writing new tests, converting existing tests, or reviewing test design quality.

Do not treat this guide as a replacement for project-specific product intent. If business behavior, acceptance criteria, or risk priority is unclear, ask the developer or product owner.

## Where

Place `methodPrompts/` at the root of the target project, or keep this directory somewhere the developer and CodeAgent can read.

Expected standalone layout:

```text
methodPrompts/
  README.md
  README_ZH.md
  README_UserGuide.md
  README_UserGuide_ZH.md
  CaTDD_methodPrompt.md
  CaTDD_methodPrompt4Cat-Typical.md
  CaTDD_methodPrompt4Cat-Edge.md
  CaTDD_methodPrompt4Cat-Misuse.md
  CaTDD_methodPrompt4Cat-Fault.md
  CaTDD_methodPrompt4Cat-State.md
  CaTDD_methodPrompt4Cat-Capability.md
  CaTDD_methodPrompt4Cat-Concurrency.md
  CaTDD_methodPrompt4Cat-Performance.md
  CaTDD_methodPrompt4Cat-Robust.md
  CaTDD_methodPrompt4Cat-Compatibility.md
  CaTDD_methodPrompt4Cat-Configuration.md
  CaTDD_methodPrompt4Cat-DemoExample.md
  CaTDD_designAndImplTemplate.cxx
```

## Why

Standalone `methodPrompts/` should be useful by itself.

A developer who only receives this directory should still be able to:

- Understand CaTDD's method intent.
- Pick the right category prompt.
- Draft US/AC/TC verification design.
- Ask an LLM to generate tests from comments.
- Keep comments alive as tests and production code evolve.

This file exists so users do not need the repo-level guide, slide deck, installers, `slashCommands`, or `agentSkills` package to begin using the method.

## How

Follow this workflow when starting a CaTDD test file.

1. Read `README.md` to choose the relevant method prompt.
2. Read `CaTDD_methodPrompt.md` for the full method contract.
3. Copy `CaTDD_designAndImplTemplate.cxx` or adapt its section structure to your language.
4. Capture Stage-0 free drafts: scenarios, examples, risks, and open questions.
5. Classify drafts into categories using the priority order below.
6. Write US/AC/TC comments inside the test file before implementing code.
7. Generate or write one failing test for the next TC.
8. Implement only enough production code to pass that TC.
9. Update TC status markers and keep the comments synchronized with behavior.
10. Repeat one TC at a time.

## Usage Example

Run these commands from a target project that contains `methodPrompts/`:

```bash
mkdir -p Test
# C++ target
cp methodPrompts/CaTDD_designAndImplTemplate.cxx Test/UT_YourFeature_Typical.cxx
# TypeScript target
cp methodPrompts/CaTDD_designAndImplTemplate.ts Test/UT_YourFeature_Typical.ts
```

Use `UT_<Feature>_<Category>.<ext>` for category-specific files, such as `UT_YourFeature_Typical.cxx`, `UT_YourFeature_Typical.ts`, or `UT_YourFeature_Edge.ts`.

Then ask your CodeAgent or use the method prompts manually:

```text
Read methodPrompts/README_UserGuide.md and methodPrompts/CaTDD_methodPrompt.md.
Use methodPrompts/CaTDD_methodPrompt4Cat-Typical.md to fill the Typical skeleton in Test/UT_YourFeature_Typical.cxx or Test/UT_YourFeature_Typical.ts.
Preserve US/AC/TC traceability and leave unclear product intent as questions.
```

Expected result:

- `Test/UT_YourFeature_Typical.cxx` or `Test/UT_YourFeature_Typical.ts` has an OVERVIEW section.
- It has a UNIT TESTING DESIGN section with US/AC/TC comments.
- It has a UNIT TESTING IMPLEMENTATION section ready for Red-Green TDD.
- It has TODO/TRACKING status markers for the selected TCs.

## Priority Framework

Use this default priority order unless project risk says otherwise.

| Priority | Class | Categories | Purpose |
| --- | --- | --- | --- |
| P0 | P0 Functional | Typical -> Edge -> Misuse -> Fault | Prove valid behavior works and invalid behavior fails well. |
| P1 | P1 Design | State -> Capability -> Concurrency | Prove lifecycle, capacity, and thread-safety design behavior. |
| P2 | P2 Quality | Performance -> Robust -> Compatibility -> Configuration | Prove quality attributes and environment variation. |
| P3 | P3 Addons | Demo/Example | Prove documentation-oriented examples and onboarding flows. |

## Method Prompt Map

| Need | Use |
| --- | --- |
| Learn the full method contract | `CaTDD_methodPrompt.md` |
| Design core happy-path behavior | `CaTDD_methodPrompt4Cat-Typical.md` |
| Design valid edge cases, limits, and boundary values | `CaTDD_methodPrompt4Cat-Edge.md` |
| Design invalid caller behavior or wrong API usage | `CaTDD_methodPrompt4Cat-Misuse.md` |
| Design dependency, resource, or environment failure handling | `CaTDD_methodPrompt4Cat-Fault.md` |
| Design lifecycle and finite-state-machine verification | `CaTDD_methodPrompt4Cat-State.md` |
| Design capacity and maximum ability verification | `CaTDD_methodPrompt4Cat-Capability.md` |
| Design thread-safety or race-condition verification | `CaTDD_methodPrompt4Cat-Concurrency.md` |
| Design latency, throughput, or resource-use checks | `CaTDD_methodPrompt4Cat-Performance.md` |
| Design stress, repetition, soak, or stability checks | `CaTDD_methodPrompt4Cat-Robust.md` |
| Design cross-platform, version, or integration checks | `CaTDD_methodPrompt4Cat-Compatibility.md` |
| Design feature-flag, configuration, or environment variation | `CaTDD_methodPrompt4Cat-Configuration.md` |
| Design documentation-oriented demos and examples | `CaTDD_methodPrompt4Cat-DemoExample.md` |
| Start a C++ test file from a complete skeleton | `CaTDD_designAndImplTemplate.cxx` |

## Comment Skeleton

Every category skeleton should preserve this minimum shape:

```text
//=================================================================================================
// [Class] / [Category] Design Skeleton
//=================================================================================================
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: What this category proves for this component
// @[UseWhen]: When this category applies
// @[AvoidWhen]: When to move the scenario to another category
// @[US]: User Story IDs covered by this category
// @[AC]: Acceptance Criteria IDs covered by this category
// @[TC]: Test Cases, status, and expected TDD next action
//=================================================================================================
```

## Status Markers

Use explicit status markers so humans and CodeAgents can continue work safely.

| Marker | Meaning | Next action |
| --- | --- | --- |
| TODO/PLANNED | Designed but not implemented | Write the failing test. |
| RED/IMPLEMENTED | Test exists and fails as expected | Implement production code. |
| GREEN/PASSED | Test passes | Refactor or pick next TC. |
| ISSUES | Known problem needs attention | Diagnose and fix before declaring done. |
| BLOCKED | Missing dependency or unclear product intent | Ask or unblock before implementing. |

## Quality Checklist

Before calling a CaTDD design complete, verify:

- Each TC links back to at least one AC and US.
- Category names match the method prompt map.
- P0 Functional coverage is addressed before optional P1/P2 expansion.
- Each implemented test follows SETUP -> BEHAVIOR -> VERIFY -> CLEANUP.
- Each test focuses on one behavior and uses a small number of key assertions.
- Comments and code agree after implementation.
- Open questions are explicit instead of silently guessed.

## Next Step

For manual work, continue with `CaTDD_methodPrompt.md` and the category-specific prompt that matches your next test design need.

For automated or semi-automated workflows, add the repository's `slashCommands/` layer later. It is useful, but not required for standalone `methodPrompts/` adoption.
