# Issue: utCodeAgentCLI may support SKILL feature but must not use agentSkills

Imported via SPEC_importIssue on 2026-06-09.

## Source

"utCodeAgentCLI MAY support and have SKILL feature, BUT never will use SKILL in agentSkills, cause itself is avata of CaTDD"

## Classification

- Type: constraint clarification / policy issue.
- Area: `codeAgents/utCodeAgentCLI/`, `agentSkills/` boundary.
- Severity: P1 - important for scope and architecture boundary correctness.

## Observed Behavior

Project materials include both `codeAgents/utCodeAgentCLI/` and `agentSkills/` as CaTDD-related capability layers. Without an explicit boundary statement, implementations may incorrectly route utCodeAgentCLI SKILL behavior through `agentSkills/`.

## Expected Behavior

1. `utCodeAgentCLI` may expose or support SKILL-like features as part of its own CLI/runtime capability.
2. `utCodeAgentCLI` must not depend on, delegate to, or be implemented through `agentSkills/` SKILL packaging.
3. The reason is architectural identity: `utCodeAgentCLI` is the CaTDD-native avatar layer and should keep this boundary explicit in requirements and design docs.

## Related

- `codeAgents/utCodeAgentCLI/README_UserStory.md`
- `agentSkills/README.md`
- `methodPrompts/README.md`

## Open Clarification

- Confirm wording: should "avata" be normalized to "avatar" in downstream requirement/design docs?

## Next Recommended Command

`/SPEC_analyzeIssue`