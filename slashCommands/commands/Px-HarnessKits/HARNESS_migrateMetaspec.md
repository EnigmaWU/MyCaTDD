# HARNESS_migrateMetaspec

## Purpose

Diagnose and safely migrate a project's SpecCoding artifact workspace to the canonical `.catdd/metaspec` location while preserving support for `.agents/metaspec` and the legacy `.catdd/spec` location.

## Command Type

HarnessKits operational migration command. It maintains the CaTDD installation and workspace declaration. It does not open, move, close, or review a user story.

## Metaspec Workspace

Before acting, follow [Metaspec Workspace Resolution](../../MetaspecWorkspaceResolution.md). This command is the explicit reconciliation route when multiple populated workspaces or conflicting declarations are reported.

## CoT Pattern

**Linear** -- Direct execution. Discovery, dry run, confirmation, apply, and post-migration validation are fixed steps over a finite set of supported workspaces.

### Linear Execution

Run these steps once, in order.

1. Locate the project root and the three supported workspaces.
2. Prefer the installed helper at `.catdd/scripts/migrateCaTDDMetaspec.sh`; when it is unavailable in a source checkout, use `scripts/migrateCaTDDMetaspec.sh`.
3. Run the helper without `--apply` and report its selected root, proposed action, and conflicts.
4. If more than one populated workspace exists, stop. Present the exact populated roots and ask which workspace contains the authoritative state.
5. Ask the developer to confirm the reported move before applying it.
6. Run the helper with `--apply`.
7. Verify that the selected workspace exists, the lifecycle directories are present, `projectContext.md` declares the selected relative root, and no populated legacy workspace remains after migration.
8. Report the result and the next command.

### Worked Example

An existing project stores lifecycle artifacts under the legacy workspace:

```text
/HARNESS_migrateMetaspec
project_root: ~/work/acme-pay
```

Expected result:

1. Discovery reports `.catdd/spec=populated`, while `.catdd/metaspec` and `.agents/metaspec` are absent.
2. The dry run reports `move: .catdd/spec -> .catdd/metaspec`.
3. The developer confirms.
4. The helper moves the complete directory, creates any missing lifecycle lanes, and records `metaspec_root: .catdd/metaspec` in `projectContext.md`.
5. Verification confirms `.catdd/metaspec/pendingNews/` exists and `.catdd/spec` is absent.
6. The command reports `next_command = HARNESS_verifyInstallation`.

## Inputs

- `project_root`: optional. Defaults to the current workspace root.
- `metaspec_root`: optional explicit candidate when discovery is ambiguous. Must be `.catdd/metaspec`, `.agents/metaspec`, or `.catdd/spec`.
- `confirm_move`: required before migration. The command MUST obtain an explicit developer confirmation.
- `dry_run`: optional. Defaults to `true`; the first helper invocation MUST be a dry run.

## Safety Rules

- Preserve tracked, untracked, ignored, and locally evolved files.
- Move the directory; do not recreate artifacts file by file.
- Never merge two populated workspaces automatically.
- Never choose an alternate root silently when `projectContext.md` declares another root.
- Never create a second workspace merely because one already exists.
- Never delete lifecycle history, `WorkingProcessLog.md`, or local overlays.
- Record only a project-relative workspace path; do not write an absolute host path.

## Method References

- [Metaspec workspace resolution](../../MetaspecWorkspaceResolution.md)
- [Px-HarnessKits kit](../../kits/Px-HarnessKits.md)
- [Px-SpecFlow flow](../../flows/Px-SpecFlow.md)

## Output Contract

- Discovery result for all three supported workspaces.
- Selected workspace and its evidence.
- Dry-run action: `none`, `create`, or `migrate`.
- Confirmation status.
- Applied migration result and preserved-file statement.
- `projectContext.md` declaration update status.
- Post-migration validation verdict: `PASS`, `BLOCKED`, or `ASK`.
- `next_command = HARNESS_verifyInstallation` after a successful migration, or the precise command needed to reconcile an ambiguous workspace.

## Conflict Guard

Do not migrate when `.catdd/metaspec` and populated `.catdd/spec` both exist.
Do not migrate when `.agents/metaspec` is selected and another populated workspace also exists.
Do not overwrite a `projectContext.md` that declares a different physical workspace.
Do not move user stories between lifecycle lanes.
Do not run the helper with `--apply` before showing the dry-run report and receiving confirmation.

ONE-MORE-THING: ask developer if something not sure
