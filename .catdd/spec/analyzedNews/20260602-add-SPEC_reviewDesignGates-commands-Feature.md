# Feature: Add SPEC_reviewArchDesign and SPEC_reviewDetailDesign portable slash commands

Imported by `/SPEC_importFeature` on 2026-06-02.

## Source Trace

- Source type: developer requests in chat.
- Raw source text: 
  - `each action must be reviewd as my experience in LLM era` (referring to introducing `SPEC_reviewArchDesign` after `SPEC_takeArchDesign`).
  - `also I want SPEC_reviewDetailDesign, you know` (introducing `SPEC_reviewDetailDesign` after `SPEC_takeDetailDesign`).
- Area: `.catdd/slashCommands/commands/Px-SpecFlow/`
- Related flow: Px SpecFlow.

## Classification

- Type: missing assets / pipeline feature request.
- Current lifecycle state: pending import, not yet analyzed.
- Expected next step: analyze into a todo User Story for establishing intermediate generative design review gates.

## Preserved Intent

The developer has a key architectural insight for the LLM era: in agent-driven development workflows, every generative step (such as drafting an architecture design or detailing a local module design) must be gated and reviewed immediately after it is taken to prevent downstream hallucination or design drift. 

To satisfy this "review each action" philosophy, we must introduce two new corresponding portable slash commands:
1. **`SPEC_reviewArchDesign`**: Acts as an explicit architectural review gate immediately following `SPEC_takeArchDesign`. It ensures the global architecture boundaries, `AgentSDK` separation, and runtime adaptations are sound and approved before detailed design begins.
2. **`SPEC_reviewDetailDesign`**: Acts as a specific detailed design review gate immediately following `SPEC_takeDetailDesign`. It ensures class/API signatures, concurrency state models, and local acceptance criteria are clear and complete before unit test skeletons are designed.

## Known Context

- `slashCommands/flows/Px-SpecFlow.md` defines the pipeline, which currently flows from `SPEC_takeArchDesign` directly into `SPEC_takeDetailDesign`, and then from `SPEC_takeDetailDesign` directly into `SPEC_reviewUserStory` (which previously acted as the sole design review gate).
- Introducing these separate gates will split the monolithic review step into two fast, focused review actions matching each generation action.

## Next Recommended Command

`/SPEC_analyzeFeature`
