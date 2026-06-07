# SPEC_slashCommandTemplate

Use this template before creating any concrete `SPEC_*` slash command.

The template is intentionally plain Markdown so it can be used by Copilot, Cline, Continue, `utCodeAgentCLI`, or any assistant that can consume prompt text. It must not depend on one editor, one model provider, one programming language, or one tool runtime.

A `SPEC_*` command drives one SpecCoding lifecycle step. It uses CaTDD methods defined in `methodPrompts` and lifecycle rules defined in `flows/Px-SpecFlow.md`; it must not redefine CaTDD category semantics or SpecFlow lifecycle rules.

Compared with `methodPrompts`, a `SPEC_*` command should be more flow-first and automation-friendly: it tells a CodeAgent what lifecycle step to run now, what to read, what artifact to produce, what gate to apply, and what command should come next.

A `SPEC_*` command operates on lifecycle artifacts — project context, pending news, user stories, design docs, tests, product code, and commit/CI state — not on test categories or category skeletons directly.

## Command Header

- `Command`: `SPEC_<verb><Object>`
- `Flow`: `Px SpecFlow`
- `CaTDD Method Source`: `methodPrompts/README.md` and method-specific prompts as needed
- `SpecCoding Lifecycle Source`: `flows/Px-SpecFlow.md`
- `Adapter target`: Copilot prompt, Cline command/rule, Continue command, `utCodeAgentCLI` command, or another existing CodeAgent surface

## CoT Pattern

State which Chain-of-Thought reasoning pattern this command uses and why.

Choose one based on the command's decision complexity:

- **ReACT** — Reasoning + Acting (capitalization follows the original research convention emphasizing *Re*asoning + *Act*ing): Use when the command must inspect current lifecycle state, decide what to do, act, and observe the result iteratively. Suitable for analysis, design, and review commands that may encounter incomplete or ambiguous inputs.
- **ToT** — Tree of Thoughts: Use when the command must generate multiple candidate artifacts or approaches, evaluate each against quality criteria, and select the best. Suitable for commands that compare design alternatives, story quality options, or competing next-step paths.
- **Linear** — Direct execution: Use when the command's action is deterministic given complete and valid inputs and no branching is expected. Suitable for simple artifact movement, context initialization, or atomic commit and CI steps.

State the chosen pattern here and explain why it fits this command's decision structure.

## WHO

State who invokes this command and who should act on it.

- Primary user: Developer
- Assistant consumer: Copilot, Cline, Continue, `utCodeAgentCLI`, or compatible CodeAgent
- Ownership rule: the developer owns product intent and story acceptance criteria; `methodPrompts` owns CaTDD method semantics; `Px-SpecFlow` owns lifecycle rules; the assistant owns faithful execution of the command contract

## WHAT

State exactly what this command does.

- Name the single lifecycle step this command performs.
- Name the expected artifact it creates, updates, reviews, or moves.
- Keep the command small enough to be invoked independently.

## WHEN

State when to use this command.

- Describe valid starting conditions and required preconditions.
- Describe when not to use it.
- Name the previous and next commands in the SpecCoding lifecycle.

## WHERE

State where the command reads and writes.

- Input artifacts: `.catdd/spec/` lifecycle files, project-root `README*` SPEC docs, test files, product code files
- Output artifacts: same category as inputs, updated by this command
- Related `methodPrompts` references
- Related flow document: `flows/Px-SpecFlow.md`
- Previous and next commands in the lifecycle

## WHY

State why this command exists.

- Explain the developer value.
- Explain the SpecCoding lifecycle reason.
- Explain how it reduces ambiguity or repeated manual effort.

## HOW

State the execution procedure using the chosen CoT pattern.

### ReACT Execution (when CoT Pattern = ReACT)

Repeat until the output artifact is complete and the output contract is satisfied:

1. **Thought**: Inspect the listed input artifacts and method references. Identify current lifecycle state, gaps, conflicts, or missing information.
2. **Action**: Perform the specific operation this command owns — create, update, review, or move the named artifact.
3. **Observation**: Verify the output artifact meets the output contract. Check for missing traceability, unresolved questions, or quality failures.
4. If the observation reveals a quality issue or missing information, surface it as a question or assumption and stop instead of inventing requirements.
5. Report the artifact produced, assumptions made, conflicts found, and the next recommended command.

### ToT Execution (when CoT Pattern = ToT)

1. **Generate**: Produce two or more candidate approaches, artifact outlines, or next-step options from the input artifacts.
2. **Evaluate**: Assess each candidate against the quality criteria in the output contract and the lifecycle rules in `Px-SpecFlow`.
3. **Select**: Choose the best candidate. If no candidate is clearly best, present the top options and ask the developer to choose.
4. **Execute**: Apply the selected candidate to produce the output artifact.
5. **Verify**: Confirm the output artifact meets the output contract. Report the decision rationale, assumptions, and next recommended command.

### Linear Execution (when CoT Pattern = Linear)

1. Read the listed inputs and method references.
2. Preserve existing lifecycle artifact traceability, status markers, and naming conventions.
3. Perform only this command's requested step.
4. Report the artifact produced, assumptions made, and next recommended command.
5. Avoid product-specific, editor-specific, model-specific, or language-specific behavior unless explicitly supplied as input.

## Subagent Recommendation

Include this section when the command is suitable for background delegation during an active conversation.

State whether this command should be delegated to a subagent and explain when delegation is preferable:

- **When to delegate**: describe the mid-conversation trigger (for example, a new issue or idea surfaces while other work is in progress).
- **What to capture**: list the context the caller should pass as subagent inputs (for example, source text or URL and relevant project context).
- **What to expect back**: describe what the subagent reports on completion (for example, the output file name).
- **Caller behavior**: state that the main conversation may continue without waiting for the subagent to finish.

Omit this section for commands that must run synchronously or whose output is immediately needed by the next step in the flow.

## Input Contract

List command parameters using portable placeholders:

- `{{doing_user_story}}`: active user story file under `.catdd/spec/doingUS/`
- `{{todo_user_story}}`: selected user story under `.catdd/spec/todoUS/`
- `{{pending_file}}`: pending issue, feature, or imported user-story input under `.catdd/spec/pendingNews/`
- `{{analyzed_file}}`: archived raw issue, feature, or imported user-story input under `.catdd/spec/analyzedNews/`
- `{{projectContext_file}}`: `.catdd/spec/projectContext.md`
- `{{readme_spec_files}}`: one or more project-root `README*.md` SPEC docs
- `{{related_docs}}`: optional architecture, design, test, or reproduction notes
- `{{developer_goal}}`: optional developer intent or context that is not captured in artifacts

## Output Contract

Define the expected response shape:

- Artifact created, updated, reviewed, or moved
- Lifecycle state change applied
- Assumptions made and questions surfaced
- Conflicts or quality failures found and reported
- Next recommended command

## CodeAgent Compatibility

- Use plain Markdown and explicit artifact paths.
- Do not rely on a specific slash-command engine.
- Do not assume a specific tool name, editor API, model vendor, or programming language.
- Keep command intent parseable by humans and CodeAgents.
- Treat native Copilot, Cline, Continue, and `utCodeAgentCLI` forms as adapters over this command intent.
- When command behavior conflicts with `methodPrompts` or `Px-SpecFlow`, treat those as source of truth.

ONE-MORE-THING: ask developer if something not sure
