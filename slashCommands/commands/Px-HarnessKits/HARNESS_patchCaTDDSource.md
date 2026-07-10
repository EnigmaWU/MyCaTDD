# HARNESS_patchCaTDDSource

## Purpose

Patch effective CaTDD meta-file improvements from an installed project back to the original CaTDD source repository.

## Command Type

HarnessKits tool-point command. This command maintains CaTDD source, installed command assets, and adapter-facing prompt files; it does not move a user story through SpecFlow lifecycle state.

## CoT Pattern

**ReACT** -- Reasoning + Acting. This command must inspect downstream modifications, evaluate whether they are portable and method-consistent, build an allowlisted patch, and report upstream-ready outcomes with explicit safety gates.

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
- `evidence_of_effectiveness`: optional tests, usage evidence, or review notes proving the downstream changes are useful.
- `dry_run`: optional flag to produce patch preview only before applying.

## Preflight Mapping Checklist

Before any copy or patch action, print and confirm both sides:

1. `installed source`: exact absolute source directories.
2. `CaTDD source target`: exact absolute target directories.
3. `direction`: must be installed project -> CaTDD source repository.
4. `safety`: non-default `target_branch`, allowlist active, and no destructive overwrite.

If path mapping is unclear, stop and ask the developer.

## Method References

- [Px-HarnessKits](../../kits/Px-HarnessKits.md)
- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- Direction-confirmed patch summary: installed project -> CaTDD source repository.
- Allowlisted changed-file inventory with rationale for each included path.
- Patch artifact or equivalent commit-ready diff for `target_branch`.
- Risk notes for conflicts, generated wrappers, portability gaps, and local-only traces.
- Recommended next action: review and commit the diff in `catdd_source_repo`, or return to the active SPEC command if this tool was invoked inside a story workflow.

## Prompt Template

Ask the assistant to first resolve path mapping (`installed .catdd` -> `CaTDD source PROJECT_ROOT` by default), inspect installed-project CaTDD modifications, keep only portable and effective upstream-worthy changes, generate an allowlisted patch toward the CaTDD source repository on a non-default branch, and report what was included or excluded.

## Conflict Guard

Do not run this command as CaTDD source -> installed project sync; this command is only for installed project -> CaTDD source patch-back.
Do not patch directly to the source repository default branch.
Do not include unrelated project business code, secrets, or local-only traces.
Do not treat generated adapter wrappers as source-of-truth when their portable source files are available.
Do not apply destructive overwrite when source-repository conflicts are unresolved.
Do not assume the source target path is `.catdd`; default target is the CaTDD source repository `PROJECT_ROOT` (`methodPrompts/` and `slashCommands/`) unless developer explicitly selects `source_dot_catdd`.
Do not overwrite newer source content blindly; prefer selective hunk-level merge when installed content is older or semantically narrower.

ONE-MORE-THING: ask developer if something not sure