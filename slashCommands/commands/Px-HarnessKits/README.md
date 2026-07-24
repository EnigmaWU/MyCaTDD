# Px-HarnessKits Command Templates

This directory contains `HARNESS_*` command templates for CaTDD Harness Engineering tool-point work.

`HARNESS_*` commands are operational commands, not user-story lifecycle commands. They help a developer or CodeAgent maintain the CaTDD command, adapter, execution, diagnostic, and patch-back harness around the method source.

## Command Map

| Command | Purpose |
| --- | --- |
| [HARNESS_patchCaTDDSource.md](HARNESS_patchCaTDDSource.md) | Patch effective installed-project CaTDD improvements back to the original CaTDD source repository. |
| [HARNESS_verifyInstallation.md](HARNESS_verifyInstallation.md) | Verify an installed CaTDD target project has complete `.catdd` assets, native wrappers, rules, skills, and source-of-truth links before use. |
| [HARNESS_diagnoseInstallation.md](HARNESS_diagnoseInstallation.md) | Diagnose a failed or misworking CaTDD installation and recommend safe repair actions. |
| [HARNESS_newTaskSession.md](HARNESS_newTaskSession.md) | Capture and preserve important session context when finishing the current task and starting a new session, so the next CodeAgent session can resume without re-investigation. |

## Contract

HarnessKits commands should follow [../../kits/Px-HarnessKits.md](../../kits/Px-HarnessKits.md) and stay tool-point oriented.

They may inspect files, compare generated or installed assets, validate operational safety, and prepare guarded patches. They must not redefine CaTDD category meaning, SpecFlow lifecycle rules, or product requirements.

ONE-MORE-THING: ask developer if something not sure
