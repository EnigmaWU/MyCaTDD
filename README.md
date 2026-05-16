# MyCaTDD

MyCaTDD is a repository that productizes the CaTDD methodology step by step, with the goal of evolving "method usage" from manual execution to automated and intelligent execution.

Core slogan:

> Comments is Verification Design. LLM Generates Code. Iterate Forward Together.

## What Your Diagram Means (Mapped to This Repository)

Your diagram expresses a three-stage evolution path:

1. `methodPrompts`（方法提示词）
2. `slashCommands`（提示词命令）
3. `utCodeAgentCLI`（代码智能体）

It also includes a bidirectional improvement loop:

- [1] is applied into [2] and [3]
- Practices from [2] and [3] feed improvements back into [1]
- Task planning and reflection in [3] further improve [2]

This README is organized around that main storyline.

## Three Layers of Assets and Responsibilities

### [1] methodPrompts (method prompts)

Positioning: source files of the methodology, defining "how to do it".

Applicable mode: manual developer mode (method-valid).

Current repository contents:

- `methodPrompts/CaTDD_DesignPrompt.md`
- `methodPrompts/CaTDD_UserGuide.md`
- `methodPrompts/CaTDD-UserGuide-PPT.md`
- `methodPrompts/CaTDD-UserGuide-PPT-ZH_CN.md`
- `methodPrompts/CaTDD_ImplTemplate.cxx`

Source note: these materials were initially imported from
`https://github.com/EnigmaWU/MyIOC_inTDD_withGHC/tree/main/LLM`
(some relative paths in examples still point to the original repository layout).

### [2] slashCommands (prompt commands)

Positioning: package method prompts into command-style entries that can be triggered on demand, reducing adoption cost.

Applicable mode: developer + code assistant GUI mode.

Note: this layer is currently reserved at the architecture level (as shown in the diagram). High-frequency method workflows can be consolidated into a standard command set in later iterations.

### [3] utCodeAgentCLI (code agent)

Positioning: in CLI scenarios, developers define goals and the agent plans and executes tasks automatically.

Applicable mode: developer + code agent CLI mode.

Characteristics: relies on method constraints from [1] and command abstractions from [2], focusing on task planning, execution loops, and process reflection.

## Assets Already Landed

### agentSkill: package the method as reusable capability

`agentSkill/comment-alive-test-driven-development` packages CaTDD into a triggerable skill:

- `agentSkill/comment-alive-test-driven-development/SKILL.md`
	- Skill definition: trigger conditions, input/output, constraints, phased workflow
- `agentSkill/comment-alive-test-driven-development/README.md`
	- Human-readable guide: US/AC/TC hierarchy, priority framework, usage examples
- `agentSkill/comment-alive-test-driven-development/references/`
	- Bundled references: User Guide / Design Prompt / Template / PPT

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

1. Read `methodPrompts/CaTDD_UserGuide.md` first for the full picture.
2. Use `methodPrompts/CaTDD_ImplTemplate.cxx` to create a new test-file skeleton.
3. Follow `agentSkill/comment-alive-test-driven-development/SKILL.md` to execute with a skill-based workflow.
4. Gradually complete `slashCommands` and CLI code-agent integration in your toolchain.
