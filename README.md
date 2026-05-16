# MyCaTDD

MyCaTDD is a repository that productizes the CaTDD methodology step by step, with the goal of evolving "method usage" from manual execution to automated and intelligent execution.

CaTDD is the methodology invented by EnigmaWU. IOC is a PlayKata module and proving ground that helped CaTDD evolve from idea to real reusable methodology.

Core slogan:

> Comments is Verification Design. LLM Generates Code. Iterate Forward Together.

## What Your Diagram Means (Mapped to This Repository)

Your diagram expresses a four-layer evolution path:

1. [methodPrompts](methodPrompts/README.md)（方法提示词）
2. [slashCommands](slashCommands/README.md)（提示词命令）
3. [utCodeAgentCLI](utCodeAgentCLI/README.md)（单元测试代码智能体）
4. [agentSkill](agentSkill/README.md)（智能体技能包）

It also includes a bidirectional improvement loop:

- [1] is applied into [2] and [3]
- [4] packages [1] into reusable agent capabilities
- Practices from [2] and [3] feed improvements back into [1]
- Task planning and reflection in [3] further improve [2]

This README is organized around that main storyline.

## Four Layers of Assets and Responsibilities

### [1] [methodPrompts](methodPrompts/README.md) (method prompts)

Brief: the language-agnostic source-of-truth methodology layer for CaTDD. It defines comment-alive design skeletons, category method prompts, user-guide materials, and implementation templates.

Read more: [methodPrompts/README.md](methodPrompts/README.md).

Current repository contents:

- `methodPrompts/CaTDD_methodPrompt.md`
- `README_UserGuide.md`
- `methodPrompts/CaTDD-UserGuide-PPT.md`
- `methodPrompts/CaTDD-UserGuide-PPT-ZH_CN.md`
- `methodPrompts/CaTDD_ImplTemplate.cxx`

Source note: these materials were initially imported from
`https://github.com/EnigmaWU/MyIOC_inTDD_withGHC/tree/main/LLM`
(some relative paths in examples still point to the original repository layout).

### [2] [slashCommands](slashCommands/README.md) (prompt commands)

Brief: the code-agent-agnostic commandization layer. It turns stable CaTDD method steps into small triggerable prompt commands for Copilot, Cline, Continue, or similar assistants.

Read more: [slashCommands/README.md](slashCommands/README.md).

### [3] [utCodeAgentCLI](utCodeAgentCLI/README.md) (code agent)

Brief: this repository's CaTDD-native CLI agent layer. Developers define goals, then the agent plans, executes, collects traces, and reflects using [1] and [2].

Read more: [utCodeAgentCLI/README.md](utCodeAgentCLI/README.md).

### [4] [agentSkill](agentSkill/README.md) (skill package)

Brief: the reusable capability packaging layer. It wraps CaTDD method knowledge into triggerable skills and keeps skill references aligned with the canonical method files.

Read more: [agentSkill/README.md](agentSkill/README.md).

`agentSkill/comment-alive-test-driven-development` packages CaTDD into a triggerable skill:

- `agentSkill/comment-alive-test-driven-development/SKILL.md`
  - Skill definition: trigger conditions, input/output, constraints, phased workflow
- `agentSkill/comment-alive-test-driven-development/README.md`
  - Human-readable guide: US/AC/TC hierarchy, priority framework, usage examples
- `agentSkill/comment-alive-test-driven-development/references/`
  - Bundled references: User Guide / method prompt / Template / PPT

This asset layer can be seen as the key bridge from [1] to [2]/[3].

## Three Collaboration Modes (Aligned with the Diagram)

### Mode A: Manual Developer Mode

- Input: `methodPrompts`
- Method: manually read and execute method steps
- Output: verifiable test design and implementation

### Mode B: Developer + Code Assistant (GUI)

- Input: `methodPrompts` + (future) `slashCommands`
- Method: invoke method or command fragments on demand
- Focus: method decomposition and workflow automation

### Mode C: Developer + Code Agent (CLI)

- Input: `methodPrompts` + `slashCommands` + goal definition
- Method: the agent performs task planning, execution, and reflection
- Focus: intelligent method application and closed-loop optimization

## Iteration Loop (Recommended Execution Path)

1. First, make the method in [1] clear and stable.
2. In [2], commandize high-frequency steps to reduce invocation cost.
3. In [3], hand complete tasks to the agent for execution.
4. Feed issues exposed by [3] back into [2] and [1] for continuous improvement.

## Quick Start

1. Read `README_UserGuide.md` first for the full picture.
2. Use `methodPrompts/CaTDD_ImplTemplate.cxx` to create a new test-file skeleton.
3. Follow `agentSkill/comment-alive-test-driven-development/SKILL.md` to execute with a skill-based workflow.
4. Run `bash agentSkill/makeSkill.sh` to package skill references and links.
5. Gradually complete `slashCommands` and CLI code-agent integration in your toolchain.
