---
name: user-story-centered-spec-coding
description: 'Use when: driving a user story through SpecCoding from issue or feature input to detail design, acceptance criteria, testing, implementation, review, commit, CI, and closure. Helps with: user-story-centered SpecCoding using Px-SpecFlow lifecycle artifacts such as pendingNews, todoUS, doingUS, and doneUS. Applies to: feature delivery, bug repair, work-item analysis, story-centered design, SpecFlow orchestration, and CodeAgent-guided implementation. CaTDD is the default UnitTesting method, but typical TDD or project-specific testing methods may be used when requested.'
---

# User-Story-Centered SpecCoding

## Who

Developers and CodeAgents who need to drive work from an issue, feature request, or user story through a traceable SpecCoding lifecycle.

Use this skill when the work should move through explicit story artifacts, design artifacts, test artifacts, implementation, review, commit, CI, and closure rather than staying as hidden chat state.

## What

Apply the user-story-centered SpecCoding flow implemented by `Px-SpecFlow`.

This skill orchestrates delivery around a user story lifecycle:

```text
pendingNews -> todoUS -> doingUS -> doneUS
```

It owns lifecycle orchestration, not CaTDD method semantics.

- `comment-alive-test-driven-development` is CaTDD.
- `user-story-centered-spec-coding` is the SpecCoding flow.
- CaTDD is the default UnitTesting method inside this SpecCoding flow.
- Typical TDD or another project-specific testing method may be used when the user or project asks for it.
- CaTDD does not depend on this SpecCoding flow; it may be used by this flow, another SpecCoding flow, or non-SpecCoding testing work.

## When

Use this skill when:

- The user wants to import an issue, bug, feature request, or product idea into a structured workflow.
- The user asks for SpecCoding, Px-SpecFlow, story-centered delivery, or story lifecycle orchestration.
- A work item needs project context, user story analysis, detail design, acceptance criteria, tests, implementation, review, commit, CI, and closure.
- A CodeAgent needs to preserve team-shared SpecCoding artifacts instead of relying on transient chat memory.
- UnitTesting should default to CaTDD unless the project asks for typical TDD or another testing method.

Do not use this skill for one-off test design without a story lifecycle. Use `comment-alive-test-driven-development` directly for CaTDD-only test creation.

## Where

Use this skill in repositories that have, or want to create, SpecCoding artifacts under:

```text
.catdd/spec/
  projectContext.md
  pendingNews/
  todoUS/
  doingUS/
  doneUS/
  WorkingProcessLog.md
```

Project-root SPEC docs may include:

```text
README.md
README_ArchDesign.md
README_UserStories.md
README_UserGuide.md
README_DetailDesign.md
README_ErrorDesign.md
README_ResourceDesign.md
README_StateDesign.md
README_PerfDesign.md
README_CompatDesign.md
README_DiagnosisDesign.md
README_VerifyDesign.md
```

Packaged resources include `slashCommands/flows/Px-SpecFlow.md`, `slashCommands/commands/Px-SpecFlow/`, and `slashCommands/templates/README_*Template.md` for first-time project-root README SPEC docs.

## Why

SpecCoding makes the delivery lifecycle explicit and traceable.

It helps developers and CodeAgents:

- Preserve project context and work-item history.
- Convert incoming work into user stories with acceptance criteria.
- Keep design, testing, implementation, and review connected to a story.
- Route quality failures back to design, tests, product code, or refactoring.
- Close work only after review, commit, CI, and artifact movement are complete.

The result is less hidden chat state and more durable project knowledge.

## Inputs

- Issue, bug, feature request, product idea, or existing user story.
- Project context or constraints, if available.
- Relevant project-root README SPEC docs, if they exist.
- Preferred testing method, if different from CaTDD.
- Repository rules for commits, CI, and artifact persistence.

## Output

Depending on the lifecycle phase, this skill produces or updates:

- `.catdd/spec/projectContext.md`
- `.catdd/spec/pendingNews/*.md`
- `.catdd/spec/todoUS/*-UserStory.md`
- `.catdd/spec/doingUS/*-UserStory.md`
- `.catdd/spec/doneUS/*-UserStory.md`
- Project-root README SPEC docs as needed.
- Test design and implementation artifacts.
- Product code changes.
- Review notes, commit summary, CI result, and closure record.

## Constraints

- Preserve the distinction between SpecCoding lifecycle and CaTDD testing methodology.
- Do not redefine CaTDD category semantics; use `methodPrompts` when CaTDD is selected.
- Do not replace `Px-SpecFlow` lifecycle rules with ad hoc chat decisions.
- Ask the developer when product intent, acceptance criteria, or completion criteria are unclear.
- Keep team-shared artifacts committed and local work-in-progress artifacts gitignored according to Px-SpecFlow policy.
- Move only reviewed and completed stories to `doneUS`.
- Do not claim CI success unless CI was actually run or verified.

## One More Thing

If the current lifecycle phase is unclear, first identify where the work item belongs: pending input, todo user story, active doing story, or completed done story.

If the testing method is unclear, default UnitTesting to CaTDD and explicitly note that typical TDD or project-specific testing can replace it when requested.

## How

### Phase 1: Establish Project Context

1. Read existing project context and root README SPEC docs.
2. If project facts are missing, use `SPEC_initProjectContext` or `SPEC_updateProjectContext` intent.
3. Record stable team-shared facts in `.catdd/spec/projectContext.md`.
4. Keep local working traces out of committed shared context unless they become durable decisions.

### Phase 2: Import Work Input

1. Determine whether the input is an issue/bug or feature/product idea.
2. Use `SPEC_importIssue` or `SPEC_importFeature` intent.
3. Store pending work under `.catdd/spec/pendingNews/`.
4. Preserve source links, raw facts, and unresolved questions.

### Phase 3: Analyze Into a User Story

1. Use `SPEC_analyzeIssue` or `SPEC_analyzeFeature` intent.
2. Convert pending input into a traceable user story under `.catdd/spec/todoUS/`.
3. Include role, capability, value, acceptance criteria candidates, risk, and open questions.
4. Do not invent product intent.

### Phase 4: Open and Design the Story

1. Use `SPEC_openUserStory` intent to move selected work into `.catdd/spec/doingUS/`.
2. Use `SPEC_takeDetailDesign` intent to produce detail design and acceptance criteria.
3. Create or update project-root README SPEC docs only when the project needs those shared surfaces; use `slashCommands/templates/README_*Template.md` when creating one for the first time.
4. Use `SPEC_reviewUserStory` to gate story and design readiness.
5. Use `SPEC_updateDetailDesign` when review finds missing or weak design.

### Phase 5: Design and Implement Tests

1. Use `SPEC_designUnitTests` intent to choose the testing method.
2. Default UnitTesting to CaTDD by invoking the `comment-alive-test-driven-development` method or packaged references.
3. Use typical TDD or another project-specific method when the project explicitly requests it.
4. Use `SPEC_implUnitTests` intent to implement selected test cases.
5. Preserve traceability from story to acceptance criteria to tests.

### Phase 6: Implement, Review, and Route Quality

1. Use `SPEC_implProductCodes` intent to implement product code that satisfies tests.
2. Use `SPEC_reviewProductCodes` intent to review implementation quality and traceability.
3. If quality fails, use `SPEC_refactorIssue` intent to route back to design, tests, product code, or refactoring.
4. Keep the active story open until quality gates are satisfied.

### Phase 7: Commit, CI, and Closure

1. Use `SPEC_commitWorks` intent to prepare and commit completed work.
2. Use `SPEC_triggerCI` intent to run or verify CI.
3. Use `SPEC_closeUserStory` intent to move reviewed completed work to `.catdd/spec/doneUS/`.
4. Record any reusable lessons that should feed back into `methodPrompts`, `slashCommands`, or `agentSkill`.

## Resources

- Packaged `slashCommands/flows/Px-SpecFlow.md` - Lifecycle flow for user-story-centered SpecCoding.
- Packaged `slashCommands/commands/Px-SpecFlow/` - Concrete `SPEC_*` command steps.
- Packaged `slashCommands/templates/README_*Template.md` - Templates for project-root README SPEC docs.
- Packaged `slashCommands/README_UserGuide.md` - Practical command-flow usage guide.
- Packaged `references/README_UserGuide.md` - CaTDD method user guide for default UnitTesting.
- Packaged `references/CaTDD_methodPrompt.md` - CaTDD method contract when CaTDD is selected.

## Validation

1. Verify the current work item has a clear lifecycle state: pending, todo, doing, or done.
2. Verify user story, acceptance criteria, design, tests, implementation, review, commit, CI, and closure artifacts are traceable when applicable.
3. Verify UnitTesting used CaTDD by default unless another testing method was explicitly selected.
4. Verify shared artifacts and local work-in-progress artifacts follow Px-SpecFlow persistence policy.
5. Verify quality failures route back to the correct lifecycle phase instead of being hidden.
6. Verify completed stories move to `doneUS` only after review, commit, and CI handling.
