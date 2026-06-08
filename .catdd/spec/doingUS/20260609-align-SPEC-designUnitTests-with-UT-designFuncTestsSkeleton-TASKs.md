# TASKs for align SPEC_designUnitTests with UT_designFuncTestsSkeleton for US-USER-01

- [x] Active story: [20260609-align-SPEC-designUnitTests-with-UT-designFuncTestsSkeleton-UserStory.md](20260609-align-SPEC-designUnitTests-with-UT-designFuncTestsSkeleton-UserStory.md)
- [x] Requirement source traced to analyzed issues:
  - `../analyzedNews/20260608-why-SPEC-designUnitTests-not-UT-doXYZ-in-P0-FuncTestFlow-Issue.md`
  - `../analyzedNews/20260609-refactor-US-USER-01-with-UT-designFuncTestsSkeleton-Issue.md`
- [x] Story is open in `.catdd/spec/doingUS/`
- [x] Mutual intent cleared: SPEC orchestrates story lifecycle; UT owns category-level skeleton mechanics
- [x] Requirement-oriented update needed: no module `README_UserStory.md` or paired `README_UserGuide.md` rewrite is required before planning
- [x] Requirement review needed: no separate `SPEC_reviewUserStory` gate is required before initial detail design
- [x] Architecture readiness needed: no architecture command is required for this command-boundary/test-redesign story
- [ ] Detail design needed: define concrete SPEC-to-UT routing rules and TypeScript test redesign approach
- [ ] Verification-design location decision needed: decide whether `README_VerifyDesign.md` should be module-local for `utCodeAgentCLI` instead of project-root for this story class
- [ ] Lifecycle command pending: `/SPEC_takeDetailDesign`

## Current Readiness

- Orientation: design-oriented process/test-redesign work.
- Readiness: product intent and scope are clear enough for planning; implementation details are not yet safe to edit directly.
- Satisfied prerequisite: intent alignment is recorded in the active story.
- Skipped prerequisite: no requirement-doc update is needed because the story changes command contracts, flow docs, and test-file structure rather than user-facing module requirements.
- Skipped prerequisite: no architecture design is needed because this is not changing system boundaries, runtime ownership, or module dependencies.

## Candidate Next Steps

- `/SPEC_takeDetailDesign` to define the exact command-contract edits, category routing behavior, language-template selection behavior, and US-USER-01 test redesign strategy.
- `/SPEC_takeDetailDesign` to decide whether `SPEC_designUnitTests` should write module-local `README_VerifyDesign.md` for module-scoped stories and reserve root `README_VerifyDesign.md` for repository-wide verification strategy.
- `/SPEC_designUnitTests` after detail design if the redesigned test-file skeleton itself needs a fresh CaTDD test-design pass before implementation.
- `/SPEC_implUnitTests` or `/SPEC_implProductCodes` only after detail design clarifies the concrete edit plan and validation checkpoints.

## Rejected Next Steps

- `/SPEC_clearStoryIntent` because intent is already cleared and recorded with `Review result: CLEARED`.
- `/SPEC_updateUserStory` because no module/submodule `README_UserStory.md` or paired `README_UserGuide.md` requirement surface is currently the owned artifact.
- `/SPEC_reviewUserStory` because no requirement update has been made that needs review before detail design.
- `/SPEC_takeArchDesign` because the story does not introduce architecture-significant boundaries or runtime design.
- `/SPEC_designUnitTests` as the immediate next step because the story first needs detail decisions about how `SPEC_designUnitTests` should discover/use `UT_designXYZ` commands and language templates.
- `/SPEC_implUnitTests` as the immediate next step because planning must not jump directly into implementation.

## Selected Next Step

- [x] Next lifecycle command selected: `/SPEC_takeDetailDesign`.

## Rationale

This story is not a simple test-only refactor. It changes the documented behavior of `SPEC_designUnitTests`, clarifies the SPEC-vs-UT command boundary, requires language-template selection rules, and may fully redesign/reimplement a mature TypeScript GREEN test file. The smallest safe next lifecycle step is initial detail design, so implementation can later proceed with explicit routing rules, traceability expectations, and non-regression checkpoints.

## Detail Design Questions To Resolve

- [ ] How should `SPEC_designUnitTests` discover which `UT_designXYZ` commands exist for P0/P1/P2 categories?
- [ ] What exact fallback wording should be used when no matching `UT_designXYZ` command exists?
- [ ] Where should generated/refactored test files record the source `UT_*` command provenance?
- [ ] How much of `CaTDD_designAndImplTemplate.ts` should be applied verbatim to `cli_argument_validation.design.test.ts` versus adapted for readability?
- [ ] Should `TC-ARG-*` IDs be preserved exactly or replaced only with an explicit trace-equivalent mapping?
- [ ] Should module-scoped verification design move from project-root `README_VerifyDesign.md` to `codeAgents/utCodeAgentCLI/README_VerifyDesign.md`?
- [ ] If root `README_VerifyDesign.md` remains, should it become only a repository-wide verification index instead of owning module-specific US-USER-01 traceability?

## Future Implementation Checkpoints

- [ ] Checkpoint 1: command/flow docs explain SPEC orchestration versus UT category design.
- [ ] Checkpoint 2: `SPEC_designUnitTests` contract requires matching `UT_designXYZ` command use when available.
- [ ] Checkpoint 3: TypeScript test redesign uses `methodPrompts/CaTDD_designAndImplTemplate.ts` as the language template.
- [ ] Checkpoint 4: `node --test codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts` remains GREEN.
- [ ] Checkpoint 5: verification-design artifact ownership is explicit: module-scoped verification lives under the module; root verification design is repository-wide only when needed.

## Checklist

- [x] Opened story identified.
- [x] Requirement trace documented.
- [x] Readiness assessed.
- [x] Candidate next steps compared.
- [x] Rejected next steps recorded.
- [x] Next command selected.