# MyCaTDD
My development methodology based on TDD and LLM friendly has: methodPrompts,slashCommands,utCodeAgentCLI,agentSkill etc.

## Method Prompts (initial import)

Initial method prompt materials are imported from:
https://github.com/EnigmaWU/MyIOC_inTDD_withGHC/tree/main/LLM

Note: some relative example paths inside imported documents point to the original source repository layout.

- `methodPrompts/CaTDD_DesignPrompt.md`
- `methodPrompts/CaTDD_UserGuide.md`
- `methodPrompts/CaTDD-UserGuide-PPT.md`
- `methodPrompts/CaTDD-UserGuide-PPT-ZH_CN.md`
- `methodPrompts/CaTDD_ImplTemplate.cxx`

## Agent Skills (initial import)

Agent skills package CaTDD methodology for reuse in AI-assisted development workflows.

### `agentSkill/comment-alive-test-driven-development`

Write new test files from scratch using CaTDD (Comment-alive Test-Driven Development), where structured comments define verification design before any code is written. Applicable to UnitTesting, SysTesting, and UserTesting in any language.

Key files:
- `agentSkill/comment-alive-test-driven-development/SKILL.md` — Skill definition (trigger conditions, inputs, outputs, constraints, and step-by-step workflow)
- `agentSkill/comment-alive-test-driven-development/README.md` — Human-readable overview of the skill, file structure, US/AC/TC hierarchy, priority framework, and usage examples
- `agentSkill/comment-alive-test-driven-development/references/` — Bundled reference materials (user guide, design prompt, C++ implementation template, PPT overview)
