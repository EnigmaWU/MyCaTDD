# Px HarnessKits

`Px HarnessKits` is the cross-priority command kit for CaTDD Harness Engineering.

`Px` means this command kit is not a CaTDD category priority like `P0 Functional`, `P1 Design`, or `P2 Quality`. `HarnessKits` means commands are reusable tool points, not a strict story lifecycle state machine.

## Method Alignment

HarnessKits sits beside SpecFlow and the UT category flows:

```text
methodPrompts = CaTDD method and verification-design language
Px SpecFlow = repeatable SpecCoding lifecycle over product/story work
P0/P1/P2 flows = category-specific test design and implementation flows
Px HarnessKits = operational tool-point commands for CaTDD harness maintenance
```

`HARNESS_*` commands own operational tasks such as patch-back, installation verification, installation diagnosis, run artifact collection, policy checks, and harness repair gates. They may support SpecFlow, but they do not replace `SPEC_*` lifecycle commands.

## Developer Stories

- As a Developer, when an installed project proves a CaTDD method or slash-command improvement, I want to patch that improvement back to the original CaTDD source safely so that the reusable method evolves without copying unrelated project code.
- As a Developer, before trusting an installed CaTDD target project, I want a tool-point command that verifies installed assets, generated wrappers, and source-of-truth links so that installation problems are caught before daily use.
- As a Developer, when an installed CaTDD target project misworks, I want a tool-point command that diagnoses the failed installation surface and recommends repair without creating a fake product user story.

## Command Families

| Family | Purpose | Current command |
| --- | --- | --- |
| Source patch-back | Move effective installed-project CaTDD improvements back to source with allowlists and safety gates. | [HARNESS_patchCaTDDSource](../commands/Px-HarnessKits/HARNESS_patchCaTDDSource.md) |
| Installation verification | Prove an installed CaTDD target project has complete `.catdd` assets, native wrappers, rules, skills, and source-of-truth links before use. | [HARNESS_verifyInstallation](../commands/Px-HarnessKits/HARNESS_verifyInstallation.md) |
| Installation diagnosis | Second next command for investigating a misworking installed CaTDD target project and recommending repair from verification evidence. | Future `HARNESS_diagnoseInstallation` |
| Run diagnosis | Future commands for collecting run artifacts and diagnosing non-installation harness/test failures. | Future `HARNESS_collectRunArtifacts`, `HARNESS_diagnoseFailure` |
| Guard and policy | Future commands for checking execution isolation, policy compliance, and destructive-operation guards. | Future `HARNESS_checkPolicy` |
| Harness repair | Future commands for proposing and validating harness patches with regression gates. | Future `HARNESS_proposePatch`, `HARNESS_validatePatch` |

## Seed Flow

```mermaid
flowchart LR
    Installed["Installed project .catdd improvements"] --> Inspect["HARNESS_patchCaTDDSource"]
    Inspect --> Diff["Allowlisted source diff"]
    Diff --> Review["Developer review"]
    Review --> Commit["Commit to CaTDD source repo"]
```

## Command Sequence

1. Use [../commands/Px-HarnessKits/HARNESS_patchCaTDDSource.md](../commands/Px-HarnessKits/HARNESS_patchCaTDDSource.md) when an installed project has effective CaTDD meta-file improvements that should be patched back to the original CaTDD repository on a non-default branch.
2. Use [../commands/Px-HarnessKits/HARNESS_verifyInstallation.md](../commands/Px-HarnessKits/HARNESS_verifyInstallation.md) before trusting a fresh install, after installing into a real target project, or before releasing installer/generator changes.
3. Use future `HARNESS_diagnoseInstallation` only after verification fails or an installed target project misworks.

## Conflict Guard

- `HARNESS_*` commands are tool-point commands. Do not force them through `.catdd/spec/doingUS/` unless the developer deliberately wraps harness maintenance in a SpecFlow story.
- HarnessKits commands may read SpecFlow artifacts for context, but they must not move lifecycle state.
- Portable source files remain the source of truth; generated native wrappers are adapters.
- CaTDD category semantics must still come from `methodPrompts`.

ONE-MORE-THING: ask developer if something not sure