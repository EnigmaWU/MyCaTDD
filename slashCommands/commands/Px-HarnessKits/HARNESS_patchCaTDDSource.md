# HARNESS_patchCaTDDSource

## Metaspec Workspace

Before reading or writing any SpecCoding artifact, follow [Metaspec Workspace Resolution](../../MetaspecWorkspaceResolution.md). Use `projectContext.md` to declare or retrieve `metaspec_root`; supported roots are `.catdd/metaspec`, `.agents/metaspec`, and legacy `.catdd/spec`.

## Purpose

Patch effective CaTDD meta-file improvements from an installed project back to the original CaTDD source repository.

This is the promotion path for `Base + Evolved Patch` files: an installed project keeps its local slash-command learning in `<Name>Evolved.md` patches beside untouched canonical `<Name>.md` files (or as standalone new evolved commands), and this command merges or promotes approved evolved files into canonical `<Name>.md` upstream.

## Command Type

HarnessKits tool-point command. This command maintains CaTDD source, installed command assets, and adapter-facing prompt files; it does not move a user story through SpecFlow lifecycle state.

## CoT Pattern

**ReACT** -- Reasoning + Acting. This command must inspect downstream modifications, evaluate whether they are portable and method-consistent, build an allowlisted patch, and report upstream-ready outcomes with explicit safety gates.

### ReACT Execution

Repeat per candidate change. Safety gates run before any file is touched.

1. **Thought** — Complete the Preflight Mapping Checklist first. Then, for each downstream modification, decide whether it is portable to the CaTDD source or specific to the installed project.
2. **Action** — Add only portable, allowlisted paths to the patch, targeting the confirmed non-default branch.
3. **Observation** — Verify the direction is installed → source, that no project business code, secret, or local-only trace entered the patch, and that generated wrappers were not taken where their portable sources exist. Any violation returns to **Thought** and the path is excluded.
4. **Stop** — Exit when the inventory is final. Report included and excluded paths with rationale, plus conflict risks.

### Worked Example

Pushing a local command improvement back to the CaTDD source:

```text
/HARNESS_patchCaTDDSource
installed_project_repo: ~/work/acme-pay
catdd_source_repo: ~/VSCode/MyCaTDD
patch_scope_allowlist: slashCommands/
```

Expected result:

- **Thought**: preflight prints source `~/work/acme-pay/.catdd/slashCommands` → target `~/VSCode/MyCaTDD/slashCommands`, direction installed → source → confirmed. Three local modifications found.
- **Action**: an evolved overlay `TEST_reviewImplTestCaseEvolved.md` is portable → included, and mapped to canonical `TEST_reviewImplTestCase.md`.
- **Observation**: a second change hardcodes `acme-pay` paths → not portable → back to **Thought** → excluded. A third is a regenerated Copilot wrapper whose portable source is already included → excluded.
- **Stop**: 1 included, 2 excluded with rationale; no secrets or business code present.

## Inputs

- `installed_project_repo`: project repository that already installed CaTDD and contains effective local modifications.
- `catdd_source_repo`: upstream/original CaTDD source repository that should receive the patch.
- `installed_source_layout`: optional source layout selector. Default: `installed_dot_catdd`.
  - `installed_dot_catdd`: read from `installed_project_repo/.catdd/methodPrompts` and `installed_project_repo/.catdd/slashCommands`.
- `catdd_target_layout`: optional target layout selector. Default: `project_root_sources`.
  - `project_root_sources`: patch `catdd_source_repo/methodPrompts` and `catdd_source_repo/slashCommands`.
  - `source_dot_catdd`: patch `catdd_source_repo/.catdd/*` only when developer explicitly requests self-install test sync.
- `patch_scope_allowlist`: optional allowed paths, such as `methodPrompts/`, `slashCommands/`, `scripts/`, or docs, to prevent accidental unrelated sync.
- `target_branch`: non-default source-repository branch used for patch submission.
- `base_branch`: source-repository comparison branch, usually `main`.
- `evolved_command_suffix`: optional suffix that marks a locally evolved command overlay. Default: `Evolved`.
- `evidence_of_effectiveness`: optional tests, usage evidence, or review notes proving the downstream changes are useful.
- `dry_run`: optional flag to produce patch preview only before applying.

## Preflight Mapping Checklist

Before any copy or patch action, print and confirm both sides:

1. `installed source`: exact absolute source directories.
2. `CaTDD source target`: exact absolute target directories.
3. `direction`: must be installed project -> CaTDD source repository.
4. `safety`: non-default `target_branch`, allowlist active, and no destructive overwrite.

If path mapping is unclear, stop and ask the developer.

## Evolved Overlay Promotion

`HARNESS_evolveHarness` follows `Base + Evolved Patch`: it writes slash-command deltas to `<Name><evolved_command_suffix>.md` (for example `SPEC_implTestsEvolved.md` beside untouched `SPEC_implTests.md`, or a standalone `> New evolved command` when no canonical base exists) and never edits the canonical command in place. Promotion therefore resolves `Base + Evolved Patch` into canonical upstream `<Name>.md`:

1. Read `<Name><evolved_command_suffix>.md` together with its canonical base `<Name>.md` when a base exists (both installed `<Name>.md` / `based_on` provenance and `catdd_source_repo`'s current `<Name>.md`).
2. Confirm the evolved patch (or new command) is portable and method-consistent; keep the `based_on` provenance note in the patch report for the reviewer, while omitting local provenance headers from the canonical file.
3. Strip `<evolved_command_suffix>` and target canonical `<Name>.md` in `catdd_source_repo`:
   - For an **evolved patch** (`Evolved patch for <Name>.md` / legacy `Evolved overlay of <Name>.md`): selectively merge its section additions, refinements, and overrides into `catdd_source_repo`'s canonical `<Name>.md` without discarding newer upstream sections.
   - For a **brand-new evolved command** (`New evolved command`): promote the complete command body to the new canonical `<Name>.md` path.
4. Report the mapping in the changed-file inventory so the reviewer sees which canonical command each `<Name><evolved_command_suffix>.md` updates or creates.

Do not delete `<Name><evolved_command_suffix>.md` in the installed project as part of patch-back; local evolved patches remain the project's own learning until the canonical source absorbs them and the target refreshes.

## Method References

- [Px-HarnessKits kit](../../kits/Px-HarnessKits.md)
- [Px-SpecFlow flow](../../flows/Px-SpecFlow.md)
- [methodPrompts README](../../../methodPrompts/README.md)

## Output Contract

- Direction-confirmed patch summary: installed project -> CaTDD source repository.
- Allowlisted changed-file inventory with rationale for each included path.
- Evolved overlay mapping: each promoted `<Name>Evolved.md` paired with the canonical `<Name>.md` it becomes.
- Patch artifact or equivalent commit-ready diff for `target_branch`.
- Risk notes for conflicts, generated wrappers, portability gaps, and local-only traces.
- Recommended next action: review and commit the diff in `catdd_source_repo`, or return to the active SPEC command if this tool was invoked inside a story workflow.

## Conflict Guard

Do not run this command as CaTDD source -> installed project sync; this command is only for installed project -> CaTDD source patch-back.
Do not patch directly to the source repository default branch.
Do not include unrelated project business code, secrets, or local-only traces.
Do not promote an evolved overlay by copying it verbatim onto the canonical `<Name>.md` path; strip the `<evolved_command_suffix>` suffix and review the merge into the canonical command.
Do not delete local `<Name>Evolved.md` overlays from the installed project during patch-back.
Do not treat generated adapter wrappers as source-of-truth when their portable source files are available.
Do not apply destructive overwrite when source-repository conflicts are unresolved.
Do not assume the source target path is `.catdd`; default target is the CaTDD source repository `PROJECT_ROOT` (`methodPrompts/` and `slashCommands/`) unless developer explicitly selects `source_dot_catdd`.
Do not overwrite newer source content blindly; prefer selective hunk-level merge when installed content is older or semantically narrower.

ONE-MORE-THING: ask developer if something not sure
