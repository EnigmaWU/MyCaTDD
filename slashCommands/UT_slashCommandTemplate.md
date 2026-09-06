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

## CoT Pattern

State which Chain-of-Thought reasoning pattern this command uses and why, then write the matching `### <Pattern> Execution` subsection. A pattern may not be declared without its executable loop.

- **ReACT** — Reasoning + Acting: use when the command must inspect current skeleton or test state, act, check the result against a CaTDD gate, and iterate. Suitable for skeleton design, implementation, refactor, and review commands.
- **ToT** — Tree of Thoughts: use when the command must compare several candidates and commit to one. Suitable for selection commands.
- **Linear** — Direct execution: use when the step is deterministic given complete inputs and no branching is expected.

### ReACT Execution (when CoT Pattern = ReACT)

Repeat until the output artifact satisfies the Output Contract:

1. **Thought**: Inspect the listed inputs and method references. Identify the CaTDD class/category in play and what is missing or stale.
2. **Action**: Perform this command's single step, preserving existing comment skeletons, US/AC/TC traceability, category labels, and status markers.
3. **Observation**: Check the result against this command's CaTDD gate — traceability cardinality, phase layout, category fit, or status honesty. Name the condition that sends execution back to **Thought** or **Action**.
4. **Stop**: Exit on a stable result. Report assumptions, conflicts, missing information, and the next recommended command.

### ToT Execution (when CoT Pattern = ToT)

1. **Generate**: List the candidate TCs, categories, or next steps the current state allows.
2. **Evaluate**: Score each against CaTDD category priority, status, dependencies, and risk. Reject candidates whose preconditions are unmet.
3. **Select**: Choose exactly one. If two candidates tie, present both and ask the developer.
4. **Execute**: Report the selection and its rationale.
5. **Verify**: Confirm no higher-priority candidate was skipped. Name the condition that returns to **Select**.

### Linear Execution (when CoT Pattern = Linear)

Run these steps once, in order. State explicitly that there is no retry loop.

1. Read the listed inputs and method references.
2. Preserve existing CaTDD comment skeletons, US/AC/TC traceability, category labels, and status markers.
3. Perform only the command's requested step.
4. Report assumptions, conflicts, missing information, and next recommended command.

### Worked Example

Walk the loop above through one concrete, realistic invocation. Required in every command.

1. Show the invocation as a `text` block with actual input values.
2. Walk each named step, showing what it concludes on this input.
3. Show at least one step failing its own CaTDD gate where the pattern allows it, so the loop condition is visible rather than decorative.
4. End with the next recommended command.

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

The execution procedure lives in the `### <Pattern> Execution` subsection under `## CoT Pattern`, so the declared pattern and its loop cannot drift apart. Do not restate that procedure here or in a separate prompt-template section.

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

ONE-MORE-THING: ask developer if something not sure (Universal Stop Rule: MUST halt and ask developer in both manualMode and autonomousMode)
