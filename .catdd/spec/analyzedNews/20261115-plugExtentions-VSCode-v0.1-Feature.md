# Feature: CaTDD VS Code Extension v0.1 (`plugExtentions/VSCode:v0.1`)

Imported by `/SPEC_importFeature` and analyzed by `/SPEC_analyzeFeature` on 2026-11-15.

## Metadata

- `status`: `analyzed`
- `input_type`: `feature`
- `imported_by`: `SPEC_importFeature`
- `imported_on`: `2026-11-15`
- `analyzed_by`: `SPEC_analyzeFeature`
- `analyzed_on`: `2026-11-15`
- `analysis_mode`: `BRAINSTORM`
- `execution_mode`: `manualMode`
- `metaspec_root`: `.catdd/spec`
- `target_area`: `plugExtentions/VSCode/`
- `version_tag`: `v0.1`
- `generated_todo_story`: `.catdd/spec/todoUS/20261115-plugExtentions-VSCode-v0.1-UserStory.md`
- `project_story_ledger`: `README_UserStories.md`
- `story_id`: `US-vscodeDeveloper-manageCatddAndViewStatusInVscode`
- `story_id_alias`: `US-261115.105903`

## Source Trace

- Source type: developer command argument + workspace design sketch + chat session context on 2026-11-15.
- Command argument preserved verbatim:
  - `"plugExtentions/VSCode:v0.1"`
- Preceding chat prompts preserved verbatim:
  - `"did you see our: SPEC/TEST/HARNESS_showMeStatus"`
  - `"yes, run them first"`
  - `"then did you see this: plugExtentions/VSCode/README.md"`
- Linked workspace sketch files preserved verbatim:
  - [plugExtentions/README.md](../../../plugExtentions/README.md):

    ```markdown
    # CaTDD::plugExtentions
    ```

  - [plugExtentions/VSCode/README.md](../../../plugExtentions/VSCode/README.md):

    ```markdown
    # CaTDD::plugExtentions::VSCode

    - Visual Studio Code extension for CaTDD
    - Features
      - install/update/diagnose CaTDD
      - display `STATUS` of CaTDD, including SPEC/TEST/HARNESS
    ```

## Classification

- Label: `feature`
- Lifecycle state: `analyzed` (raw input archived in `.catdd/spec/analyzedNews/`; ready user story generated in `.catdd/spec/todoUS/20261115-plugExtentions-VSCode-v0.1-UserStory.md`).
- Related CaTDD assets:
  - Status reporting contracts: `slashCommands/kits/Px-StatusKits.md`, `slashCommands/commands/Px-StatusKits/SPEC_showMeStatus.md`, `slashCommands/commands/Px-StatusKits/TEST_showMeStatus.md`, `slashCommands/commands/Px-StatusKits/HARNESS_showMeStatus.md`
  - Installation & diagnosis assets: `scripts/installCaTDD.sh`, `slashCommands/commands/Px-HarnessKits/HARNESS_diagnoseInstallation.md`
  - Project context & story ledger: `.catdd/spec/projectContext.md`, `README_UserStories.md`

## Stated User Value and Refined Intent

The developer wants a cohesive `v0.1` VS Code extension walking skeleton under `plugExtentions/VSCode/` providing two capabilities:

1. `install/update/diagnose CaTDD`
2. `display STATUS of CaTDD, including SPEC/TEST/HARNESS`

Through two interactive `BRAINSTORM` rounds during `SPEC_analyzeFeature`, the developer established the exact `v0.1` product and architectural boundaries:

1. **Single `v0.1` Walking-Skeleton Story**: Keep `install/update/diagnose` and `SPEC/TEST/HARNESS` status in one thin-UI walking-skeleton story (`US-vscodeDeveloper-manageCatddAndViewStatusInVscode` / `US-261115.105903`).
2. **Thin UI Delegating to Chat / CLI**: Do not re-implement CaTDD semantic grading or diagnosis logic in TypeScript inside the extension.
3. **VS Code UI Surfaces**: Provide an Activity Bar Sidebar `TreeView` (`SPEC`, `TEST`, `HARNESS` sections + inline actions), a `StatusBarItem` summary badge, and Command Palette commands.
4. **Canonical Folder & Source Resolution**: Keep exact directory spelling `plugExtentions/VSCode`; locate `MyCaTDD` source via `catdd.sourcePath` setting (auto-detecting the open workspace when it is `MyCaTDD` itself).
5. **Snapshot File Bridge for `STATUS`**: Because VS Code `workbench.action.chat.open` does not return Chat reply text and `specCodeAgentCLI` is currently design-only, `Refresh Status` dispatches `SPEC_showMeStatus`, `TEST_showMeStatus`, and `HARNESS_showMeStatus` via `catdd.cliCommand` or Copilot Chat to write gitignored `.catdd/status/{spec,test,harness}.report` files; a `FileSystemWatcher` parses the `Px-StatusKits` `Status Report Shape` into `TreeView` and `StatusBarItem`.
6. **Exact Action Mapping**: `Install` / `Update` invoke `scripts/installCaTDD.sh --yes` (with target agent picker / reuse of `.catdd/CaTDD_INSTALL.md`), and `Diagnose` triggers the single `HARNESS_diagnoseInstallation` action via Chat or CLI.
7. **Completion Deliverable (`EPIC E3.4`)**: Deliver SPEC/design docs, runnable TypeScript VS Code extension under `plugExtentions/VSCode/`, and P0 CaTDD tests passing at `mockSysRtm` (`testPassOnMock`).

## Chat History (`chatHistory`)

| Turn # | Speaker / Prompt | Question or Proposal | Developer Answer / Decision | Impact on Story / Scope |
| --- | --- | --- | --- | --- |
| 1 | Developer | Asked `"did you see our: SPEC/TEST/HARNESS_showMeStatus"` and `"yes, run them first"`. | Inspected `Px-StatusKits` and ran `HARNESS_showMeStatus`, `SPEC_showMeStatus`, and `TEST_showMeStatus` on `MyCaTDD`. | Established the exact `Status Report Shape` (`viewpoint`, `status_signal`, `*_level`, `level_evidence`, `level_gap`, `findings`, `next_command`) that the VS Code extension must consume. |
| 2 | Developer | Asked `"then did you see this: plugExtentions/VSCode/README.md"` and ran `/SPEC_importFeature "plugExtentions/VSCode:v0.1"`. | Imported raw feature into `.catdd/spec/pendingNews/20261115-plugExtentions-VSCode-v0.1-Feature.md`. | Preserved raw `v0.1` feature bullets verbatim before starting `SPEC_analyzeFeature`. |
| 3 | CodeAgent (`BRAINSTORM` Q1: Story Slice Strategy) | Asked whether to split `plugExtentions/VSCode:v0.1` into 2–3 P0 stories, start design-first, or keep one `v0.1` walking-skeleton story. | Selected: `Single v0.1 walking-skeleton story`. | Kept `install/update/diagnose` + `SPEC/TEST/HARNESS` status together in `US-vscodeDeveloper-manageCatddAndViewStatusInVscode` (`US-261115.105903`), deferring `v0.2+` enhancements to `Sub-UserStory Candidates`. |
| 4 | CodeAgent (`BRAINSTORM` Q2: Status & Diagnose Engine) | Asked whether `v0.1` should run a local TS semantic scanner, pure TS+shell offline checks, or act as a thin UI delegating to Chat / CLI. | Selected: `Thin UI delegating to Chat / CLI`. | Defined `RULE-03` and `BR-01`: extension delegates semantic status and diagnosis to Chat/CLI and never re-implements CaTDD grading heuristics. |
| 5 | CodeAgent (`BRAINSTORM` Q3: VS Code UI Surfaces) | Asked which VS Code UI surfaces `v0.1` should expose (`TreeView` + `StatusBar` + Commands vs Webview vs Commands only). | Selected: `Sidebar TreeView + Status Bar + Commands (Recommended)`. | Defined `CaTDD Sidebar TreeView`, `CaTDD StatusBarItem`, and Command Palette commands in Input/Output Dictionary and `AC-Typical-01..03`. |
| 6 | CodeAgent (`BRAINSTORM` Q4: CaTDD Source & Folder Name) | Asked whether to keep `plugExtentions/VSCode` spelling or rename to `plugExtensions`, and how to locate `MyCaTDD` source assets. | Selected: `Keep plugExtentions + catdd.sourcePath setting`. | Preserved `plugExtentions/VSCode` spelling (`BR-05`) and defined `catdd.sourcePath` + `MyCaTDD` auto-detection (`RULE-02`, `AC-Typical-01`, `AC-Edge-01`, `AC-Misuse-01`). |
| 7 | CodeAgent (`BRAINSTORM` Q5: TreeView & Status Bar Data Bridge) | Flagged that `workbench.action.chat.open` does not return Chat reply text and `specCodeAgentCLI` is currently design-only; proposed watched `.catdd/status/*.report` snapshot files vs `vscode.lm` API vs launcher-only TreeView. | Selected: `Chat/CLI trigger + watched status snapshot file (Recommended)`. | Resolved Model Gap #1: `Refresh Status` dispatches `*_showMeStatus` to write gitignored `.catdd/status/{spec,test,harness}.report` files, watched and parsed into `TreeView` + `StatusBarItem` (`RULE-03`, `RULE-04`, `RULE-06`, `AC-Typical-02`, `AC-Edge-02`, `AC-Fault-02`). |
| 8 | CodeAgent (`BRAINSTORM` Q6: Install / Update / Diagnose Mapping) | Asked whether `Diagnose` should expose a multi-command picker or a single `HARNESS_diagnoseInstallation` action alongside `installCaTDD.sh --yes`. | Selected: `installCaTDD.sh + single HARNESS_diagnoseInstallation action`. | Bound `Install`/`Update` to `scripts/installCaTDD.sh --yes` (`RULE-01`, `AC-Typical-01`) and `Diagnose` to `HARNESS_diagnoseInstallation` (`RULE-05`, `AC-Typical-03`), deferring multi-command `HARNESS_*` pickers to `v0.2`. |
| 9 | CodeAgent (`BRAINSTORM` Q7: v0.1 Completion Deliverable) | Asked whether this story closes on runnable TS extension + P0 `mockSysRtm` tests or design docs only. | Selected: `Runnable TS extension + P0 CaTDD tests (Recommended)`. | Locked `## Story Completion Conditions` (`EPIC E3.4`) to require SPEC/design docs + runnable TS extension + all 9 P0 CaTDD-ACs `CLOSED` at `mockSysRtm` (`testPassOnMock`). |

## Next Recommended Command

`/SPEC_commitPreStoryWorks` (optional pre-story intake/analysis commit checkpoint per `Px-SpecFlow.md`) or `/SPEC_openUserStory` on `.catdd/spec/todoUS/20261115-plugExtentions-VSCode-v0.1-UserStory.md`.
