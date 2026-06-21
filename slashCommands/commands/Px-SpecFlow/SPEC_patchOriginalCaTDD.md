# SPEC_patchOriginalCaTDD

## Purpose

Patch effective CaTDD meta-file improvements from an installed project back to the original CaTDD source repository.

## CoT Pattern

**ReACT** -- Reasoning + Acting. This command must inspect downstream modifications, evaluate whether they are portable and method-consistent, build an allowlisted patch, and report upstream-ready outcomes with explicit safety gates.

## Inputs

- `installed_project_repo`: project repository that already installed CaTDD and contains effective local modifications.
- `original_catdd_repo`: upstream/original CaTDD source repository that should receive the patch.
- `patch_scope_allowlist`: optional allowed paths (for example `methodPrompts/`, `slashCommands/`, `scripts/`, docs) to prevent accidental unrelated sync.
- `target_branch`: non-default upstream branch used for patch submission.
- `base_branch`: upstream comparison branch, usually `main`.
- `evidence_of_effectiveness`: optional tests, usage evidence, or review notes proving the downstream changes are useful.
- `dry_run`: optional flag to produce patch preview only before applying.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- Direction-confirmed patch summary: installed project -> original CaTDD.
- Allowlisted changed-file inventory with rationale for each included path.
- Patch artifact or equivalent commit-ready diff for `target_branch`.
- Risk notes for conflicts, generated wrappers, and portability gaps.
- Recommended next command: `SPEC_commitWorks` in the original CaTDD repository after review.

## Prompt Template

Ask the assistant to inspect installed-project CaTDD modifications, keep only portable and effective upstream-worthy changes, generate an allowlisted patch toward the original CaTDD repository on a non-default branch, and report what was included or excluded.

## Conflict Guard

Do not run this command as original -> installed sync; this command is only for installed project -> original CaTDD patch-back.
Do not patch directly to the upstream default branch.
Do not include unrelated project business code, secrets, or local-only traces.
Do not treat generated adapter wrappers as source-of-truth when their portable source files are available.
Do not apply destructive overwrite when upstream conflicts are unresolved.

ONE-MORE-THING: ask developer if something not sure
