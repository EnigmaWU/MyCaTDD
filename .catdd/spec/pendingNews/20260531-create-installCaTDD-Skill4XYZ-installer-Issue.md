# Issue: create installCaTDD-Skill4XYZ and installCaTDD-Agent installers

Imported via SPEC_importIssue on 2026-05-31.

## Source

Discovered during `installCaTDD4Antigravity` design discussions. The base `installCaTDD4XYZ.sh` installers should remain lightweight and focus strictly on deploying standard methodology assets (`methodPrompts/`, `slashCommands/`) and rules/prompts adapters.

Compiling and deploying `agentSkills` or CLI agents (`utCodeAgentCLI`, `specCodeAgentCLI`) should be decoupled into dedicated, specialized installer scripts.

## Classification

- Type: feature request / new asset design.
- Area: `scripts/` and `.catdd/spec/`.
- Severity: P1 — completes the modular packaging and installer separation.

## Observed Behavior

Currently, base `installCaTDD4XYZ.sh` scripts only target basic templates and adapters. There is no dedicated script to package and copy compiled skills (`agentSkills/dist/`) or runnable CLI agent layers (`codeAgents/`) to target projects. Putting skill compilation into base installers adds unnecessary execution weight and introduces files that target projects might not need.

## Expected Behavior

Create separate installer utilities:

1. **`scripts/installCaTDD-Skill4XYZ.sh`**:
   - Takes a target project directory (`--target DIR`).
   - Packages `comment-alive-test-driven-development` and `user-story-centered-spec-coding` skills using `agentSkills/makeSkill.sh`.
   - Deploys the compiled skill packages to `.catdd/agentSkills/dist/` in the target project.
   - Works across all supported integrations (Copilot, Cline, Continue, Antigravity).

2. **`scripts/installCaTDD-Agent.sh`**:
   - Compiles and deploys `codeAgents` CLI modules to target projects.

## Related

- `scripts/installCaTDD4Antigravity.sh` — base Antigravity adapter installer (keeps base lightweight).
- `agentSkills/makeSkill.sh` — compiler source for packaging skills.

## Next Recommended Command

`/SPEC_openUserStory` when this issue is prioritized for the next SpecFlow lifecycle.
