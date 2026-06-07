# TASKs for methodPrompts rename design+impl template and add TypeScript counterpart

- [x] Active story: [20260608-methodPrompts-template-rename-and-typescript-design-and-impl-UserStory.md](20260608-methodPrompts-template-rename-and-typescript-design-and-impl-UserStory.md)
- [x] Requirement source traced to archived issue: `../analyzedNews/20260608-rename-CaTDD-ImplTemplate-and-add-ts-template-Issue.md`
- [x] Story is open in `.catdd/spec/doingUS/`
- [x] Intent is clear enough; no `SPEC_clearStoryIntent` gate needed before planning
- [x] Requirement-oriented update needed: no module `README_UserStory.md` or paired `README_UserGuide.md` rewrite is required for this story
- [x] Requirement review needed: no `SPEC_reviewUserStory` gate is required before design/test planning
- [x] Architecture readiness needed: no architecture command is required for this path-level template rename/add story
- [x] Detail design readiness needed: no dedicated detail-design command is required before test design for this story
- [x] Verification design produced in the test-design step
- [x] Lifecycle command completed: `/SPEC_designUnitTests`
- [x] Lifecycle command completed: `/SPEC_implUnitTests`
- [x] Lifecycle command completed: `/SPEC_commitWorks`
- [x] Lifecycle command completed: `/SPEC_closeUserStory`
- [ ] Next lifecycle command: `/SPEC_analyzeIssue`

## Current Readiness

- Orientation: implementation-oriented work with documentation/template artifacts.
- Readiness: requirements are stable and scoped; design docs do not require a new take/update cycle for this change.
- Skipped prerequisite: no requirement rewrite gate needed.
- Skipped prerequisite: no architecture/detail design gate needed.

## Candidate Next Steps

- `/SPEC_analyzeIssue` to pull one pending issue into the next story cycle.
- `/SPEC_whatsNextTask` when story queue priority must be re-evaluated from current artifacts.
- `/SPEC_importIssue` if new work should be added into pendingNews first.

## Rejected Next Steps

- `/SPEC_clearStoryIntent` because product intent and expected behavior are explicit in AC-01..AC-03.
- `/SPEC_updateUserStory` because this story does not currently require module `README_UserStory.md`/`README_UserGuide.md` requirement edits.
- `/SPEC_takeArchDesign` because the change is a localized methodPrompts template rename/addition, not architecture work.
- `/SPEC_updateArchDesign` because no existing architecture gap is being addressed by this story.
- `/SPEC_designUnitTests` as immediate next step because this step is now completed.
- `/SPEC_implUnitTests` as immediate next step because implementation closure is completed.

## Selected Next Step

- [x] Next lifecycle command selected: `/SPEC_analyzeIssue`.

## Rationale

This story is a scoped template-path rename/addition change derived from an analyzed issue. Implementation and reference-alignment updates were completed and committed in `69f5b31`, with packaging and standalone-guide checks passing. After closure, the smallest correct next command is `SPEC_analyzeIssue` to continue pending queue intake.

## Parallel-Ready Implementation Checklist

- [x] Slice A (AC-01 / TC-MP-001): rename C++ template path from `CaTDD_ImplTemplate.cxx` to `CaTDD_designAndImplTemplate.cxx` and update references.
- [x] Slice B (AC-02 / TC-MP-002): add `methodPrompts/CaTDD_designAndImplTemplate.ts` with design+implementation skeleton intent.
- [x] Slice C (AC-03 / TC-MP-003): align intent wording across new C++ and TypeScript templates and ensure non-conflict with `CaTDD_methodPrompt.md`.
- [x] Checkpoint 1: `bash scripts/test_makeSkill.sh` passes after template rename/add.
- [x] Checkpoint 2: `bash scripts/test_methodPrompts_standalone_user_guide.sh` passes and reference scans no longer require `methodPrompts/CaTDD_ImplTemplate.cxx`.

## Checklist

- [x] Opened story identified.
- [x] Requirement trace documented.
- [x] Readiness assessed.
- [x] Candidate next steps compared.
- [x] Rejected next steps recorded.
- [x] Next command selected.
- [x] P0 CaTDD skeletons designed.
- [x] Verification design artifact updated.
- [x] Close normalization completed in done artifact.
