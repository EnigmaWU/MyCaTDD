# HARNESS_verifyInstallation

## Purpose

Verify that an installed CaTDD target project contains complete, consistent, and thin adapter assets generated from the portable CaTDD source before the developer trusts the installation.

## Command Type

HarnessKits tool-point command. This command validates an installed CaTDD harness; it does not move a user story through SpecFlow lifecycle state and does not repair files by default.

## CoT Pattern

**Checklist + ReACT** -- Validate fixed installation invariants first, then inspect failed checks to explain risk and next action. This command must keep verification read-only unless the developer explicitly asks for repair.

## Inputs

- `target_project_repo`: installed project repository to verify.
- `code_agent`: target adapter surface to verify. Allowed values: `copilot`, `continue`, `cline`, `custom`, `antigravity`, or `auto`.
- `custom_adapter_dir`: optional custom adapter directory when `code_agent=custom`. Default: `.customCodeAgent`.
- `expected_command_families`: optional command family list. Default: `UT_*`, `SPEC_*`, and `HARNESS_*`.
- `expected_source_repo`: optional CaTDD source repository used as the reference command inventory.
- `strict_mode`: optional flag. When true, fail on missing optional docs, stale generated wrappers, or unexpected wrapper files.
- `report_only`: optional flag. Default: true; produce findings without modifying files.

## Preflight Mapping Checklist

Before verification, print and confirm:

1. `target project`: exact absolute path being verified.
2. `installed CaTDD root`: expected `target_project_repo/.catdd` path.
3. `adapter surface`: selected `code_agent` and native wrapper locations.
4. `reference source`: installed `.catdd/slashCommands/commands` unless `expected_source_repo` is provided.
5. `mutation policy`: read-only verification unless developer explicitly requests repair.

If the target path or adapter surface is unclear, stop and ask the developer.

## Verification Checklist

### Core CaTDD Assets

- `.catdd/methodPrompts/README.md` exists.
- `.catdd/slashCommands/README_UserGuide.md` exists.
- `.catdd/slashCommands/commands/` contains portable `UT_*`, `SPEC_*`, and `HARNESS_*` command files.
- `.catdd/slashCommands/kits/Px-HarnessKits.md` exists when any `HARNESS_*` command exists.
- `.catdd/spec/analyzedNews`, `.catdd/spec/suspendUS`, and `.catdd/spec/abortUS` exist.
- `.catdd/CaTDD_INSTALL.md` exists and records the installed version when available.

### Command Inventory

- Count portable command files for `UT_*`, `SPEC_*`, and `HARNESS_*`.
- For wrapper-based adapters, count generated native wrappers and compare with the portable command count.
- Verify `HARNESS_patchCaTDDSource` and `HARNESS_verifyInstallation` are present in both portable command source and native wrapper surfaces when the adapter supports wrappers.

### Adapter Surfaces

- `copilot`: verify `.github/instructions/catdd.instructions.md` plus `.github/prompts/*.prompt.md` wrappers.
- `continue`: verify `.continue/rules/catdd.md` plus `.continue/prompts/*.prompt` wrappers.
- `cline`: verify `.clinerules/catdd.md` plus `.cline/skills/*/SKILL.md`; ensure `HARNESS_verifyInstallation` maps to `harness-verify-installation`.
- `custom`: verify the configured custom rule and prompt directories, using Continue-format prompt wrappers.
- `antigravity`: verify `.antigravityrules/catdd.md`; no native prompt wrapper count is expected unless the installation adds one later.
- `auto`: infer the adapter surfaces that exist and verify each detected surface.

### Wrapper Fidelity

- Native wrappers point to installed portable command paths under `.catdd/slashCommands/commands/`.
- Native wrappers point to installed method source under `.catdd/methodPrompts/README.md`.
- Native wrappers identify themselves as thin adapters and do not redefine CaTDD category semantics.
- Wrapper metadata names the same command as the portable command filename.
- `HARNESS_*` wrappers include the HarnessKits source command path and remain operational tool-point commands.

## Method References

- [Px-HarnessKits](../../kits/Px-HarnessKits.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- Installation verdict: `PASS`, `WARN`, or `FAIL`.
- Verified target path, adapter surfaces, and command inventory counts.
- Checklist results grouped by core assets, command inventory, adapter surfaces, and wrapper fidelity.
- Failure inventory with exact missing, stale, or inconsistent paths.
- Recommended next action:
  - `PASS`: use the installed CaTDD commands.
  - `WARN`: review optional or strict-mode findings before daily use.
  - `FAIL`: run or create `HARNESS_diagnoseInstallation` to identify root cause and repair options.

## Prompt Template

Ask the assistant to verify the installed CaTDD target project in read-only mode, compare portable command inventory against generated adapter surfaces, confirm `HARNESS_*` commands are installed and exposed correctly, and report a clear PASS/WARN/FAIL verdict with exact failing paths.

## Conflict Guard

Do not modify files unless the developer explicitly asks for repair.
Do not treat generated adapter wrappers as source-of-truth when portable command files are available.
Do not fail Antigravity installations for missing prompt wrappers unless Antigravity wrapper generation is explicitly added later.
Do not move SpecFlow lifecycle state or create `.catdd/spec/doingUS/` entries.
Do not verify against a different source repository unless `expected_source_repo` is explicitly provided.

ONE-MORE-THING: ask developer if something not sure