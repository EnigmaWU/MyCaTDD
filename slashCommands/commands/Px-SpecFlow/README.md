# Px-SpecFlow Command Templates

This directory contains `SPEC_*` command templates for the CaTDD SpecCoding lifecycle.

`SPEC_*` commands orchestrate issue, story, design, test, implementation, review, CI, and closure work. They are flow commands, not CaTDD category definitions. Method semantics remain in `methodPrompts`.

Persist team-shared artifacts such as `.catdd/spec/projectContext.md`, `.catdd/spec/pendingNews/`, `.catdd/spec/analyzedNews/`, `.catdd/spec/todoUS/`, `.catdd/spec/doingUS/`, `.catdd/spec/doneUS/`, project-root `README*` SPEC docs, tests, and product code. Keep local-only traces such as `.catdd/spec/WorkingProcessLog.md` gitignored.

## Command Map

| Command | Purpose |
| --- | --- |
| [SPEC_initProjectContext.md](SPEC_initProjectContext.md) | Create initial project context. |
| [SPEC_updateProjectContext.md](SPEC_updateProjectContext.md) | Refresh project context after facts change. |
| [SPEC_importIssue.md](SPEC_importIssue.md) | Import issue, bug, defect, or support problem into pending work. |
| [SPEC_importFeature.md](SPEC_importFeature.md) | Import feature request, enhancement, or product idea into pending work. |
| [SPEC_analyzeIssue.md](SPEC_analyzeIssue.md) | Analyze pending issue input, archive raw input, and generate a repair-oriented user story. |
| [SPEC_analyzeFeature.md](SPEC_analyzeFeature.md) | Analyze pending feature input, archive raw input, and generate a value-oriented user story. |
| [SPEC_whatsNextTask.md](SPEC_whatsNextTask.md) | Recommend the next SpecCoding task from current lifecycle state. |
| [SPEC_openUserStory.md](SPEC_openUserStory.md) | Move a selected user story into active work. |
| [SPEC_takePlan.md](SPEC_takePlan.md) | Create the active story planning artifact and choose the next SPEC step. |
| [SPEC_clearStoryIntent.md](SPEC_clearStoryIntent.md) | Clear mutual developer and CodeAgent intent before design starts. |
| [SPEC_takeArchDesign.md](SPEC_takeArchDesign.md) | Produce high-level architecture design and module boundaries. |
| [SPEC_reviewArchDesign.md](SPEC_reviewArchDesign.md) | Review architecture quality before detailed design begins. |
| [SPEC_takeDetailDesign.md](SPEC_takeDetailDesign.md) | Produce detailed design and acceptance criteria. |
| [SPEC_reviewDetailDesign.md](SPEC_reviewDetailDesign.md) | Review detailed design quality before final story readiness review. |
| [SPEC_reviewUserStory.md](SPEC_reviewUserStory.md) | Review story, acceptance criteria, and design readiness. |
| [SPEC_updateDetailDesign.md](SPEC_updateDetailDesign.md) | Revise detail design after review feedback. |
| [SPEC_designUnitTests.md](SPEC_designUnitTests.md) | Design CaTDD unit test skeletons for the active story. |
| [SPEC_implUnitTests.md](SPEC_implUnitTests.md) | Implement selected test cases. |
| [SPEC_implProductCodes.md](SPEC_implProductCodes.md) | Implement product code to satisfy tests. |
| [SPEC_reviewProductCodes.md](SPEC_reviewProductCodes.md) | Review implementation quality and traceability. |
| [SPEC_refactorIssue.md](SPEC_refactorIssue.md) | Route failed quality back through design or implementation. |
| [SPEC_commitWorks.md](SPEC_commitWorks.md) | Prepare and commit completed work. |
| [SPEC_triggerCI.md](SPEC_triggerCI.md) | Trigger or verify CI after commit. |
| [SPEC_closeUserStory.md](SPEC_closeUserStory.md) | Move completed story to done state. |

## Contract

All commands should follow [../../SPEC_slashCommandTemplate.md](../../SPEC_slashCommandTemplate.md) and the lifecycle in [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md).

Each command should declare its CoT pattern (`ReACT`, `ToT`, or `Linear`) as described in the template.

ONE-MORE-THING: ask developer if something not sure
