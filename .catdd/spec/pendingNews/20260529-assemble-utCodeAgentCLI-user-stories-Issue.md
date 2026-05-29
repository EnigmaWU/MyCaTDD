# Issue: assemble UserStories for utCodeAgentCLI

Imported by `/SPEC_importIssue` on 2026-05-29.

## Source

```text
assemble UserStories for utCodeAgentCLI
```

## Classification

- Type: issue / planning request.
- Area: `codeAgents/utCodeAgentCLI/`.
- Related flow: Px SpecFlow.
- Current lifecycle state: analyzed into [../todoUS/20260530-assemble-utCodeAgentCLI-user-stories-UserStory.md](../todoUS/20260530-assemble-utCodeAgentCLI-user-stories-UserStory.md).

## Preserved Intent

The developer wants to assemble User Stories for `utCodeAgentCLI`.

This likely concerns the future CaTDD-native CLI execution layer documented under `codeAgents/utCodeAgentCLI/`, but this import step intentionally does not expand the request into user stories, acceptance criteria, or implementation tasks.

## Known Context

- `utCodeAgentCLI` is currently a documented future CLI layer, not a runnable CLI implementation.
- Its current UserGuide is intended to be the first/main startup document for users.
- Its current UsageDesign defines `--goal`, `--goalStory`/`--goalStoryFile`, `--input`/`--inputFile`, `--target`, and `--behave`.
- Stable CLI behavior aliases include `designFuncTestsSkeleton`, `designAllSkeleton`, `reviewFuncTestsSkeleton`, `tellMeNextImplTest`, `implTestCase`, and `implTestFile`.

## Missing Details For Analysis

- Which user roles should the assembled User Stories cover: developers, CodeAgents, maintainers, tooling authors, or all of them?
- Should the stories describe the current documentation/design-only CLI contract, the future runnable CLI, or both with separate priorities?
- Should the output live in `.catdd/spec/todoUS/`, project-root `README_UserStories.md`, or both after analysis?
- Which scope is expected first: minimum startup stories, full CLI lifecycle stories, or only the `--behave`/`--target`/`--input`/`--goal` usage model?

## Next Recommended Command

`/SPEC_openUserStory`