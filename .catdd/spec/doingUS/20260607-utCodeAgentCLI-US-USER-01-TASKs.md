# TASKs for utCodeAgentCLI USER US-USER-01 Parse and Validate CLI Arguments

- [x] Active story: [20260607-utCodeAgentCLI-US-USER-01-UserStory.md](20260607-utCodeAgentCLI-US-USER-01-UserStory.md)
- [x] Requirement source traced to module `README_UserStory.md` plus paired `README_UserGuide.md`
- [x] Story is open in `.catdd/spec/doingUS/`
- [x] Requirement-oriented update needed: no, the imported story already carries the current requirement slice
- [x] Requirement review needed: no additional `SPEC_reviewUserStory` gate is required for this imported story slice
- [x] Architecture readiness present: `codeAgents/utCodeAgentCLI/README_ArchDesign.md`
- [x] Detail design readiness present: `codeAgents/utCodeAgentCLI/README_DetailDesign.md`
- [x] Prior design reviews already recorded in project context
- [ ] Open questions remain only if implementation discovers mismatch in argument contract details
- [ ] Next lifecycle command: `/SPEC_designUnitTests`

## Current Readiness

- Orientation: implementation-oriented work.
- Readiness: sufficient to begin unit-test design planning.
- Skipped prerequisite: no requirement rewrite needed.
- Skipped prerequisite: no new architecture or detail design gate is needed before the next step.

## Candidate Next Steps

- `/SPEC_designUnitTests` for the opened story.
- `/SPEC_reviewUserStory` only if the requirement slice changes.
- `/SPEC_updateUserStory` only if the module `README_UserStory.md` or `README_UserGuide.md` must change.

## Rejected Next Steps

- `/SPEC_clearStoryIntent` because the story intent is already clear from the imported slice.
- `/SPEC_updateUserStory` because the active story is a direct imported user-story slice, not a requirement-doc rewrite.
- `/SPEC_takeArchDesign` because architecture evidence already exists and this story is past initial design intake.
- `/SPEC_takeDetailDesign` because detail design evidence already exists and this story is past initial design intake.

## Rationale

The active story is an imported P0 user-story slice for CLI argument validation. Its requirement trace is already explicit, and the repository context already contains the utCodeAgentCLI architecture and detail design artifacts. The smallest correct next step is to begin unit-test design planning rather than reopening requirements or design intake.

## Checklist

- [x] Opened story identified.
- [x] Requirement trace documented.
- [x] Readiness assessed.
- [x] Candidate next steps compared.
- [x] Rejected next steps recorded.
- [x] Next command selected.