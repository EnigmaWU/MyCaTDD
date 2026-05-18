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

Relationship diagram:

```mermaid
flowchart LR
  L1["[1] methodPrompts<br/>CaTDD method source"]
  L2["[2] slashCommands<br/>Flow command units"]
  L3["[3] utCodeAgentCLI<br/>CaTDD-native CLI agent"]
  L4["[4] agentSkill<br/>Reusable skill package"]

  L1 -->|method steps| L2
  L1 -->|method constraints| L3
  L1 -->|canonical references| L4
  L2 -->|reusable commands| L3
  L4 -->|packaged capability| L2
  L4 -->|packaged capability| L3
  L2 -.->|practice feedback| L1
  L3 -.->|execution feedback| L1
  L3 -.->|planning feedback| L2
```

This README is organized around that main storyline.

## Four Layers of Assets and Responsibilities

### [1] [methodPrompts](methodPrompts/README.md) (method prompts)

Brief: the language-agnostic source-of-truth methodology layer for CaTDD. It defines comment-alive design skeletons, category method prompts, user-guide materials, and implementation templates. It is method-first and manual-friendly.

Read more: [methodPrompts/README.md](methodPrompts/README.md).

### [2] [slashCommands](slashCommands/README.md) (prompt commands)

Brief: the code-agent-agnostic flow connector layer. It turns stable CaTDD method steps from `methodPrompts` into small triggerable prompt commands and execution flows for Copilot, Cline, Continue, or similar assistants. It is flow-first and automation-friendly. It adapts CaTDD to existing CodeAgents; it does not define CaTDD method semantics itself.

Read more: [slashCommands/README.md](slashCommands/README.md).

### [3] [utCodeAgentCLI](utCodeAgentCLI/README.md) (code agent)

Brief: this repository's CaTDD-native CLI agent layer. Developers define goals, then the agent plans, executes, collects traces, and reflects using [1] and [2].

Read more: [utCodeAgentCLI/README.md](utCodeAgentCLI/README.md).

### [4] [agentSkill](agentSkill/README.md) (skill package)

Brief: the reusable capability packaging layer. It wraps CaTDD method knowledge into triggerable skills and keeps skill references aligned with the canonical method files.

Read more: [agentSkill/README.md](agentSkill/README.md).

## CaTDD Spec-Driven Flow

`slashCommands` is CaTDD's Spec-Driven Development-style flow layer over `methodPrompts`.

In this repository, the spec is not a separate product-spec DSL. The spec is comment-alive verification design: US/AC/TC skeletons, CaTDD category coverage, priority gates, and test-case status. `methodPrompts` defines that method/spec language; `slashCommands` turns it into repeatable CodeAgent workflow steps; native prompt files are only agent-specific adapters.

For the CaTDD terms **VibeCoding** and **SpecCoding**, see [slashCommands/README.md](slashCommands/README.md).

## Three Collaboration Modes (Aligned with the Diagram)

### Mode A: Manual Developer Mode

- Input: `methodPrompts`
- Method: manually read and execute method steps from the method itself
- Output: verifiable test design and implementation

### Mode B: Developer + Code Assistant (GUI)

- Input: `methodPrompts` + (future) `slashCommands`
- Method: invoke flow-oriented command fragments on demand
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

## Install / Refresh into a Copilot Project

Install or refresh CaTDD into an existing Copilot-enabled project with:

```bash
scripts/installCaTDD4Copilot.sh --target /path/to/project --clean-prompts
```

For a new target directory, add `--init`:

```bash
scripts/installCaTDD4Copilot.sh --target /path/to/new-project --init --clean-prompts
```

The installer creates or refreshes these target-project assets:

- `.catdd/methodPrompts/`: installed CaTDD method source for manual reading and method truth.
- `.catdd/slashCommands/`: installed portable flow-command source for automation.
- `.github/prompts/UT_*.prompt.md`: Copilot-native thin adapters generated from `slashCommands`.
- `.github/instructions/catdd.instructions.md`: Copilot instruction file that points agents back to `.catdd/`.

In this source repository, generated `.github/prompts/UT_*.prompt.md` files are temporary adapter output and are intentionally ignored. Commit `methodPrompts`, `slashCommands`, scripts, and docs; regenerate native prompt wrappers for target projects when needed.

## Quick Start

1. Read `README_UserGuide.md` first for the full picture.
2. Read [methodPrompts/README.md](methodPrompts/README.md) when you need the method prompt map.
3. Read [slashCommands/README.md](slashCommands/README.md) when you want to commandize stable method steps.
4. Read [agentSkill/README.md](agentSkill/README.md) when you want reusable skill packaging.
5. Read [utCodeAgentCLI/README.md](utCodeAgentCLI/README.md) when you want CLI agent execution.
