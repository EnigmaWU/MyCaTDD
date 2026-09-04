# SPEC_patchOriginalCaTDD

## Purpose

Patch effective CaTDD meta-file improvements from an installed project back to the original CaTDD source repository.

## CoT Pattern

**ReACT** -- Reasoning + Acting. This command must inspect downstream modifications, evaluate whether they are portable and method-consistent, build an allowlisted patch, and report upstream-ready outcomes with explicit safety gates.

### ReACT Execution

Repeat per candidate change. Safety gates are checked before any file is touched.

1. **Thought** — Pass the Branch Selection Gate and the Preflight Mapping Checklist first. Then, for each downstream modification, decide whether it is portable upstream or project-specific.
2. **Action** — Add only portable, allowlisted paths to the patch, targeting the confirmed non-default `target_branch`. Honor `dry_run` when set.
3. **Observation** — Check the direction is installed → original, that no business code, secret, or local-only trace entered the patch, and that generated adapter wrappers were not taken where portable sources exist. Any violation returns to **Thought** and the path is excluded.
4. **Stop** — Exit when the inventory is final. Report included and excluded paths with rationale, conflict risks, and `next_command = SPEC_commitWorks` in the original repository.

### Worked Example

Patching improvements back upstream:

```text
/SPEC_patchOriginalCaTDD
installed_project_repo: ~/work/acme-pay
original_catdd_repo: ~/VSCode/MyCaTDD
target_branch: patchOriginalCaTDD-20260904
patch_scope_allowlist: slashCommands/, methodPrompts/
dry_run: true
```

Expected result:

- **Thought**: `target_branch` is non-default and matches the required `patchOriginalCaTDD-YYYYMMDD` pattern → gate passes. Preflight prints source `~/work/acme-pay/.catdd/slashCommands` → target `~/VSCode/MyCaTDD/slashCommands`, direction installed → original → confirmed.
- **Action**: three candidates — an improved `UT_implTestCase.md`, a new project-specific `SPEC_deployToAcme.md`, and a regenerated Copilot wrapper.
- **Observation**: `UT_implTestCase.md` is portable → included. `SPEC_deployToAcme.md` is acme-specific → excluded. The Copilot wrapper is generated and its portable source is already in the patch → excluded.
- **Observation**: no secrets or business code present; allowlist held.
- **Stop**: `dry_run` → preview only, 1 file included, 2 excluded with rationale. Reported `next_command = SPEC_commitWorks` after developer review.

## Inputs

- `installed_project_repo`: project repository that already installed CaTDD and contains effective local modifications.
- `original_catdd_repo`: upstream/original CaTDD source repository that should receive the patch.
- `target_branch`: required non-default upstream branch used for patch submission; if not already chosen, ask the developer to create or select one before any patch work.
- `installed_source_layout`: optional source layout selector. Default: `installed_dot_catdd`.
  - `installed_dot_catdd`: read from `installed_project_repo/.catdd/methodPrompts` and `installed_project_repo/.catdd/slashCommands`.
- `original_target_layout`: optional target layout selector. Default: `project_root_sources`.
  - `project_root_sources`: patch `original_catdd_repo/methodPrompts` and `original_catdd_repo/slashCommands`.
  - `original_dot_catdd`: patch `original_catdd_repo/.catdd/*` only when developer explicitly requests self-install test sync.
- `patch_scope_allowlist`: optional allowed paths (for example `methodPrompts/`, `slashCommands/`, `scripts/`, docs) to prevent accidental unrelated sync.
- `base_branch`: upstream comparison branch, usually `main`.
- `evidence_of_effectiveness`: optional tests, usage evidence, or review notes proving the downstream changes are useful.
- `dry_run`: optional flag to produce patch preview only before applying.

## Branch Selection Gate

If `target_branch` is missing or still default (`main`), stop immediately and ask the developer to first create or select a non-default branch. When creating a new branch, the required naming pattern is `patchOriginalCaTDD-YYYYMMDD`.

Do not continue until the developer answers with one of these options:

1. select an existing non-default branch, or
2. create a new patch branch using the required naming pattern `patchOriginalCaTDD-YYYYMMDD`.

Do not continue to preflight mapping or patch construction until `target_branch` is confirmed.

## Preflight Mapping Checklist

Before any copy or patch action, print and confirm both sides:

1. `installed source`: exact absolute source directories.
2. `original target`: exact absolute target directories.
3. `direction`: must be installed -> original.
4. `safety`: non-default `target_branch`, allowlist active, and no destructive overwrite.

If path mapping is unclear, stop and ask the developer.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- Direction-confirmed patch summary: installed project -> original CaTDD.
- Allowlisted changed-file inventory with rationale for each included path.
- Patch artifact or equivalent commit-ready diff for `target_branch`.
- Risk notes for conflicts, generated wrappers, and portability gaps.
- Recommended next command: `SPEC_commitWorks` in the original CaTDD repository after review.

## Conflict Guard

Do not run this command as original -> installed sync; this command is only for installed project -> original CaTDD patch-back.
Do not patch directly to the upstream default branch.
Do not continue without a confirmed non-default `target_branch`.
Do not include unrelated project business code, secrets, or local-only traces.
Do not treat generated adapter wrappers as source-of-truth when their portable source files are available.
Do not apply destructive overwrite when upstream conflicts are unresolved.
Do not assume original target path is `.catdd`; default target is original repository `PROJECT_ROOT` (`methodPrompts/` and `slashCommands/`) unless developer explicitly selects `original_dot_catdd`.
Do not overwrite newer upstream content blindly; prefer selective hunk-level merge when installed content is older or semantically narrower.

ONE-MORE-THING: ask developer if something not sure
