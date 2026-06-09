---
description: "Use when working with CaTDD, comment-alive tests, US/AC/TC skeletons, or UT_* and SPEC_* slash commands."
---
# CaTDD Project Instructions

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- Copilot prompt wrappers: `.github/prompts/UT_*.prompt.md` and `.github/prompts/SPEC_*.prompt.md`
- Treat Copilot prompt files as thin adapters over `.catdd/slashCommands/`.
- Treat `.catdd/methodPrompts/` as the source of truth for category meaning, priority order, design skeleton rules, and CaTDD method constraints.
- Commit team-shared SpecCoding artifacts under `.catdd/spec/`, such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `abortUS/`, and `doneUS/`.
- Use project-root `README*` files for shared SPEC docs such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md` as needed.
- Keep local SpecCoding work state such as `.catdd/spec/WorkingProcessLog.md` gitignored.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.
