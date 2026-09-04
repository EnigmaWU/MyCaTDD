# HARNESS_diagnoseInstallation

## Purpose

Diagnose a failed or misworking CaTDD installation by classifying installation-surface failures, identifying likely root causes, and recommending repair actions.

## Command Type

HarnessKits tool-point command. This command investigates an installed CaTDD harness after verification fails or a target project misworks; it does not move a user story through SpecFlow lifecycle state and does not repair files by default.

## CoT Pattern

**ReACT** -- Reasoning + Acting, with a fault-tree descent in the reasoning step. Inspect symptoms and verification evidence, classify the failing installation surface, rank likely root causes, and propose a safe repair plan. This command should reuse `HARNESS_verifyInstallation` evidence when available.

### ReACT Execution

Repeat until every failed surface has a ranked cause and a repair action.

1. **Thought** — Descend the fault tree: failing check → installation surface → candidate causes from the Root Cause Catalog. Assign a confidence to each candidate.
2. **Action** — Run the next read-only check from the Diagnosis Workflow that would discriminate between the top candidates. Never mutate the installation to test a hypothesis.
3. **Observation** — If the evidence does not separate the top two candidates, return to **Thought** with a narrower check. If a new surface fails, add it to the tree.
4. **Stop** — Exit when each failed surface has `expected`, `observed`, `evidence`, `likely cause`, `confidence`, and `repair action`. Order the repair plan least-destructive first, and close with `HARNESS_verifyInstallation`.

### Worked Example

A developer reports that `/SPEC_makePlan` is missing from the command palette:

```text
/HARNESS_diagnoseInstallation
target_project_root: ~/work/acme-pay
symptoms: SPEC_makePlan not offered in Copilot chat
```

Expected result:

- **Thought**: two surfaces could explain this — missing wrapper, or editor indexing lag. Both start at medium confidence.
- **Action**: read-only check — count wrappers under `.github/prompts/` vs portable commands under `.catdd/slashCommands/commands/`.
- **Observation**: 39 wrappers vs 40 commands → discriminating, but which command is missing is still unknown → back to **Thought** with a narrower check.
- **Action**: diff the two inventories by name.
- **Observation**: `SPEC_makePlan.prompt.md` absent → wrapper-count surface confirmed, editor-cache candidate dropped to low confidence.
- **Stop**: cause — stale wrappers, `--clean-prompts` skipped (high confidence). Repair plan, least destructive first: (1) regenerate wrappers, (2) if still failing, rerun installer with `--clean-prompts`, (3) reload the editor. Close with `HARNESS_verifyInstallation`.

## Inputs

- `target_project_repo`: installed project repository to diagnose.
- `code_agent`: target adapter surface to diagnose. Allowed values: `copilot`, `continue`, `cline`, `custom`, `antigravity`, or `auto`.
- `symptom`: observed misworking behavior, failed command, missing wrapper, broken rule, or failed verification output.
- `verification_report`: optional output from `HARNESS_verifyInstallation`.
- `failed_checks`: optional explicit failed check list from a previous verification run.
- `install_command`: optional installer command that produced the target installation.
- `custom_adapter_dir`: optional custom adapter directory when `code_agent=custom`. Default: `.customCodeAgent`.
- `expected_source_repo`: optional CaTDD source repository used as the reference command inventory.
- `allow_repair`: optional flag. Default: false; produce diagnosis and repair plan without modifying files.

## Preflight Mapping Checklist

Before diagnosis, print and confirm:

1. `target project`: exact absolute path being diagnosed.
2. `symptom`: exact failed command, missing file, broken wrapper, or user-visible behavior.
3. `adapter surface`: selected `code_agent` and native wrapper locations.
4. `verification evidence`: existing `HARNESS_verifyInstallation` report, or note that read-only verification must be run first.
5. `mutation policy`: read-only diagnosis unless developer explicitly sets `allow_repair=true`.

If the target path, symptom, or adapter surface is unclear, stop and ask the developer.

## Diagnosis Workflow

1. If `verification_report` is missing, run the checks from [HARNESS_verifyInstallation.md](HARNESS_verifyInstallation.md) in read-only mode first.
2. Group failed checks by installation surface:
   - Core `.catdd` assets.
   - Portable command inventory.
   - Native adapter rule files.
   - Native prompt wrappers or Cline skills.
   - Wrapper source-of-truth links.
   - Install marker and version drift.
   - Invocation or editor exposure issues.
3. For each failed surface, record `expected`, `observed`, `evidence`, `likely cause`, `confidence`, and `repair action`.
4. Rank root causes from most to least likely.
5. Produce a repair plan that starts with the least destructive action, such as rerunning the installer with `--clean-prompts`, regenerating wrappers, or refreshing the editor command surface.
6. Re-run or recommend `HARNESS_verifyInstallation` after repair to close the loop.

## Root Cause Catalog

| Failure surface | Likely causes | Typical repair |
| --- | --- | --- |
| Missing `.catdd/methodPrompts` or `.catdd/slashCommands` | Installer not run, wrong target path, interrupted copy, ignored target directory | Rerun the correct installer against the confirmed target path. |
| Missing `HARNESS_*` portable command | Source repo is older than expected, stale installed `.catdd`, partial copy | Update CaTDD source, rerun installer, then verify installation. |
| Wrapper count does not match portable command count | Generated wrappers are stale, `--clean-prompts` was skipped, wrong output directory | Regenerate wrappers or rerun installer with `--clean-prompts`. |
| Wrapper points to source repo instead of installed `.catdd` | Wrapper generated from source layout but installed incorrectly | Rerun adapter installer so native wrappers point at `.catdd/slashCommands`. |
| Cline skill slug missing or malformed | Slug conversion regression, old generated skill directory, skipped clean | Regenerate Cline skills and check expected slug, such as `harness-diagnose-installation`. |
| Rule file missing command-family guidance | Old installer version or overwritten native rule | Rerun installer and compare rule marker against current CaTDD source. |
| Antigravity prompt wrapper missing | Not a failure unless Antigravity wrapper generation is explicitly supported | Verify `.antigravityrules/catdd.md` and portable `.catdd` assets instead. |
| Command exists but editor cannot invoke it | Editor cache, extension reload needed, command palette indexing lag | Reload the editor or refresh the relevant CodeAgent command surface after file checks pass. |

## Method References

- [Px-HarnessKits](../../kits/Px-HarnessKits.md)
- [HARNESS_verifyInstallation](HARNESS_verifyInstallation.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- Diagnosis verdict: `CONFIRMED_INSTALLATION_FAILURE`, `LIKELY_INSTALLATION_FAILURE`, `NOT_INSTALLATION_FAILURE`, or `INSUFFICIENT_EVIDENCE`.
- Symptom summary and verified target path.
- Failed installation surfaces grouped by category.
- Ranked root-cause table with evidence and confidence.
- Safe repair plan with exact commands or file paths when available.
- Re-verification plan: run `HARNESS_verifyInstallation` after the proposed repair.
- Recommended next action:
  - If root cause is clear and repair is safe: apply the proposed repair only with developer approval, then verify.
  - If source-level CaTDD changes are needed: use `HARNESS_patchCaTDDSource` after proving the downstream fix.
  - If failure is not installation-related: hand off to the relevant SPEC, UT, or non-installation harness diagnosis workflow.

## Conflict Guard

Do not modify files unless the developer explicitly sets `allow_repair=true` or asks for a repair step.
Do not skip `HARNESS_verifyInstallation` evidence when the symptom is ambiguous.
Do not treat generated adapter wrappers as source-of-truth when portable command files are available.
Do not classify product-code, test-design, or SpecFlow lifecycle failures as installation failures unless installed CaTDD assets or adapter surfaces are inconsistent.
Do not fail Antigravity installations for missing prompt wrappers unless Antigravity wrapper generation is explicitly added later.
Do not move SpecFlow lifecycle state or create `.catdd/spec/doingUS/` entries.
Do not expose secrets from target project files in the diagnosis report.

ONE-MORE-THING: ask developer if something not sure
