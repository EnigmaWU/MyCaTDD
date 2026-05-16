# UT_slashCommandTemplate

Use this template before creating any concrete `UT_*` slash command.

The template is intentionally plain Markdown so it can be used by Copilot, Cline, Continue, `utCodeAgentCLI`, or any assistant that can consume prompt text. It must not depend on one editor, one model provider, one programming language, or one tool runtime.

A slash command is a connector to an existing CodeAgent invocation surface. It uses CaTDD methods defined in `methodPrompts`; it must not redefine CaTDD category semantics, priority order, or design skeleton rules.

Compared with `methodPrompts`, a slash command should be more flow-first and automation-friendly: it tells a CodeAgent what step to run now, what to read, what to produce, and what command should come next.

## Command Header

- `Command`: `UT_<verb><Object>`
- `Flow`: `P0 FuncTestsFlow`, `P1 DesignTestsFlow`, `P2 QualityTestsFlow`, or future flow name
- `CaTDD Class`: `P0 Functional`, `P1 Design`, `P2 Quality`, or `P3 Addons`
- `Category`: `Typical`, `Edge`, `Misuse`, `Fault`, `State`, `Capability`, `Concurrency`, `Performance`, `Robust`, `Compatibility`, `Configuration`, or `Demo/Example`
- `Source of truth`: method prompt files under `methodPrompts/`
- `Adapter target`: Copilot prompt, Cline command/rule, Continue command, `utCodeAgentCLI` command, or another existing CodeAgent surface

## WHO

State who invokes this command and who should act on it.

- Primary user: Developer
- Assistant consumer: Copilot, Cline, Continue, `utCodeAgentCLI`, or compatible CodeAgent
- Ownership rule: the developer owns uncertain product intent; `methodPrompts` owns CaTDD method semantics; the assistant owns faithful execution of the command contract

## WHAT

State exactly what this command does.

- Name the single workflow step this command performs.
- Name the expected artifact it creates, updates, reviews, or reports.
- Keep the command small enough to be invoked independently.

## WHEN

State when to use this command.

- Describe valid starting conditions.
- Describe when not to use it.
- Name the previous or next command when the command belongs to a flow.

## WHERE

State where the command reads and writes.

- Input files or folders
- Output files or folders
- Related `methodPrompts` references
- Related flow document under `slashCommands/flows/`
- Previous and next commands in the automation flow, when applicable

## WHY

State why this command exists.

- Explain the developer value.
- Explain the CaTDD method reason.
- Explain how it reduces ambiguity or repeated manual effort.

## HOW

State the execution procedure.

1. Read the listed inputs and method references.
2. Preserve existing CaTDD comment skeletons, US/AC/TC traceability, category labels, and status markers.
3. Perform only the command's requested step.
4. Report assumptions, conflicts, missing information, and next recommended command.
5. Avoid product-specific, editor-specific, model-specific, or language-specific behavior unless it is explicitly supplied as input.

## Input Contract

List command parameters using portable placeholders:

- `{{feature_name}}`
- `{{category}}`
- `{{source_files}}`
- `{{test_files}}`
- `{{language}}`
- `{{test_framework}}`
- `{{developer_goal}}`

## Output Contract

Define the expected response shape:

- Summary of action taken or proposed
- Files or sections touched
- CaTDD class/category used
- US/AC/TC traceability changes
- Verification or review result
- Next recommended command

## CodeAgent Compatibility

- Use plain Markdown and explicit parameters.
- Do not rely on a specific slash-command engine.
- Do not assume a specific tool name, editor API, model vendor, or programming language.
- Keep command intent parseable by humans and CodeAgents.
- Treat native Copilot, Cline, Continue, and `utCodeAgentCLI` forms as adapters over this command intent.
- When command behavior conflicts with `methodPrompts`, treat `methodPrompts` as source of truth.

ONE-MORE-THING: ask developer if something not sure
