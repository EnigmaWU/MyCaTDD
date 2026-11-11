<!-- BEGIN CaTDD Codex instructions -->
## CaTDD Codex Instructions

This managed block is installed by `scripts/installCaTDD.sh` from MyCaTDD. Use it when working with CaTDD, SpecCoding, VibeCoding, comment-alive tests, US/AC/TC skeletons, or TEST_*, SPEC_*, and HARNESS_* commands.

This block is the CaTDD-owned region and projects the rules recorded in `<metaspec_root>/projectContext.md`; text outside these markers belongs to the project and is never rewritten by CaTDD.

### Installed Sources

- CaTDD method source: `.catdd/methodPrompts/`
- Portable slash command source: `.catdd/slashCommands/`
- Codex skill wrappers: `.agents/skills/` (invoke with `$test-*`, `$spec-*`, `$harness-*`, or from `/skills`)
- SpecCoding flow: `.catdd/slashCommands/flows/Px-SpecFlow.md`
- SpecCoding artifact workspace: the `metaspec_root` declared in `projectContext.md`, defaulting to `.catdd/metaspec/`
- Workspace migration helper: `.catdd/scripts/migrateCaTDDMetaspec.sh`
- Project-root README SPEC docs: `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_ArchVerifyDesign.md`, and `README_VerifyDesign.md` as needed.

### Codex Behavior

- Treat each Codex skill under `.agents/skills/` as a thin adapter over `.catdd/slashCommands/commands/`; read the portable command before acting.
- If a `<Name>Evolved.md` overlay exists beside the canonical `<Name>.md` command, flow, or kit, follow the overlay: it supersedes the canonical artifact locally. Local `*Evolved.md` files are kept across refresh and `--force-overwrite`.
- Treat `.catdd/methodPrompts/` as the source of truth for CaTDD category meaning, priority order, design skeleton rules, and method constraints.
- Codex skill names are lowercase and hyphenated: `test-convert-demo-to-typical` adapts `TEST_convertDemoToTypical`.
- Before reading or writing lifecycle state, follow `.catdd/slashCommands/MetaspecWorkspaceResolution.md`; supported roots are `.catdd/metaspec/`, `.agents/metaspec/`, and legacy `.catdd/spec/`.
- Keep SpecCoding lifecycle state under the resolved `metaspec_root`.
- Commit team-shared artifacts such as `projectContext.md`, `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, `doneUS/`, and project-root `README*` SPEC docs under the resolved `metaspec_root`.
- Keep local work state such as `WorkingProcessLog.md` gitignored in every supported workspace.
- Use `/HARNESS_migrateMetaspec` to reconcile or migrate workspaces; never merge populated roots during normal command execution.
- Prefer explicit SpecFlow intake commands: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_importUserStory`, `SPEC_analyzeIssue`, and `SPEC_analyzeFeature`.
- After every meaningful verified success, report `success_learning_checkpoint = recommended` and remind the developer to run `/HARNESS_evolveHarness` with `evolution_mode=auto`. Keep the hook non-blocking, preserve any required lifecycle/commit/merge/safety command as the immediate next action, and never auto-apply an evolution proposal. While running `HARNESS_evolveHarness`, suppress this hook for the command's own completion or the same evidence; only materially new verified evidence may trigger another checkpoint.
- Ask the developer when product intent, acceptance criteria, or test behavior is unclear.

ONE-MORE-THING: ask developer if something not sure
<!-- END CaTDD Codex instructions -->
