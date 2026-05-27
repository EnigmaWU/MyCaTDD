# utCodeAgentCLI Usage Design

This document captures the CLI interface design for `utCodeAgentCLI`. It is based on [`slashCommands/templates/README_UsageDesignTemplate.md`](../../slashCommands/templates/README_UsageDesignTemplate.md).

- Story: Usage design for utCodeAgentCLI
- Source artifact: GitHub issue — "Usage design for utCodeAgentCLI"
- Related overview: [README.md](README.md)
- Related user guide: [README_UserGuide.md](README_UserGuide.md)

## CLI Interface

```text
utCodeAgentCLI [OPTIONS] --goal <FILE>

Options:
  --goal                    <FILE>    Goal file that drives the agent's task (required).
  --target                  <value>   Select the CaTDD work target.
  --behave                  <value>   Select the behavior to apply to the target.
  --reference               <FILEs>  Comma-separated list of reference files the agent should consult.
  --extra-prompt            <FILEs>  Comma-separated list of files whose content is appended as extra prompt text.
  --config-file             <FILE>   Path to the agent config file. Default: {PRJROOT}/CaTDD/utCodeAgentCLI/config.yaml.
  --log-level               <level>  Log verbosity. One of: debug | info | warn | error. Default: info.
  --interactive-slash-commands       Prompt for confirmation before executing each slash command. Default: false.
  --diagMethodPrompts                Emit DIAG log messages showing which method prompts the agent resolved.
  --diagSlashCommands                Emit DIAG log messages showing which slash commands the agent resolved.
```

## Argument Reference

### Core Argument Relationships: `--goal`, `--target`, and `--behave`

These three arguments work together to fully specify every invocation. Understanding their individual roles — and why they are separate — requires understanding how CaTDD organizes method meaning and slash commands.

#### Background: methodPrompts vs slashCommands

- **`methodPrompts/`** — defines *what CaTDD means*: the US/AC/TC skeleton contract, category semantics (Typical, Edge, Misuse, Fault, State, Capability, …), TDD status discipline, and risk-driven prioritization. This is the CaTDD method itself. It never changes when you run a different target or behavior.
- **`slashCommands/`** — defines *how to execute CaTDD steps*: portable command scripts (`UT_designCatSkeleton`, `UT_implTestCase`, `UT_reviewImplTestCase`, …) organized into flows (P0 FuncTestsFlow, P1 DesignTestsFlow, …). Each command calls on methodPrompts for category meaning but handles the step-by-step execution work.

`utCodeAgentCLI` orchestrates both layers. `--target` and `--behave` together tell the CLI which slashCommand(s) to invoke; `--goal` tells the CLI why it is running and provides the per-invocation context that neither layer owns.

#### Definitions

**`--goal <FILE>`** — The User Story file for this invocation's target.

> The goal file carries the **User Story (US)** that the agent will realize in the `--target` artifact. The `@[US]` comments embedded in the TestFile during a design step are derived directly from what the goal describes — the goal is the *source* of the User Story; the TestFile is its *destination* as a permanent design record.
> Each goal file is written as a User Story for one target (e.g. "As a logged-in user, I want to reset my password so that I can regain access to my account"). The agent reads it, interprets the US, and writes the corresponding `@[US]` / `@[AC]` / `@[TC]` comment blocks into the target file.

**`--target <value>`** — The CaTDD artifact the agent will operate on.

> `--target` does **not** say whether the work is design or implementation — that is `--behave`'s job. `--target` scopes *which kind of artifact* the agent reads, updates, or creates:
> - `TestCase` → a single TC inside a test file (used for TC-by-TC implementation)
> - `TestFile` → a whole test file (used for skeleton design or full-file implementation)
> - `InterfaceFile` → a header, API contract, or abstract class (used as the source to derive test skeletons)
> - `ProtocolFile` → a message format, IDL, or schema (same derivation purpose as InterfaceFile)

**`--behave <value>`** — The CaTDD workflow step to execute.

> `--behave` maps directly to slashCommand operations from `slashCommands/commands/`:
> - `designTypical` / `designEdge` → invoke `UT_designCatSkeleton` with the matching category (`Cat=Typical`, `Cat=Edge`). Produces a US/AC/TC comment skeleton; no executable test code.
> - `designTypicalSkeleton` / `designEdgeSkeleton` / `designAllSkeleton` → produce only the skeleton structure for the selected category set. Behave like `UT_designCatSkeleton` but without generating category narrative.
> - `implTestCase` → invoke `UT_implTestCase`. Writes executable test code for one TC (RED stage).
> - `implTestFile` → invoke `UT_implTestCase` repeatedly across all TCs in the file.
> - `designAndImplTest` → run skeleton design followed by `UT_implTestCase` in one step.

#### Relationship summary

| Argument | Question | Maps to |
| --- | --- | --- |
| `--goal` | **What (US)** — which User Story should the agent realize in the target? | Source of the UserStory; US/AC/TC comments placed in the TestFile are derived from the goal |
| `--target` | **What artifact** — which CaTDD artifact is being acted on? | Input artifact type; determines which files the agent reads/writes |
| `--behave` | **Which step** — design skeleton, implement test code, or both? | Selects the slashCommand(s) from `slashCommands/commands/`; category meaning comes from `methodPrompts/` |

All three are required and must be consistent with each other.

#### Single-argument use (error cases)

Each argument is only meaningful as part of the required triple. Omitting any one causes the CLI to exit with an error:

```bash
# ERROR: --target and --behave are missing; agent cannot determine artifact or step
utCodeAgentCLI --goal goals/impl-login-test.md

# ERROR: --goal and --behave are missing; agent has no task context or step
utCodeAgentCLI --target TestCase

# ERROR: --goal and --target are missing; agent has no context and no artifact to act on
utCodeAgentCLI --behave implTestCase
```

#### Combination use (correct invocations)

```bash
# Design the Typical skeleton from an interface file.
# --goal: what to produce.  --target: read the interface.  --behave: run UT_designCatSkeleton(Cat=Typical).
utCodeAgentCLI --goal goals/design-auth-typical.md --target InterfaceFile --behave designTypical

# Design all functional skeletons (Typical + Edge + Misuse + Fault) in a test file.
# --behave designAllSkeleton runs UT_designCatSkeleton for each applicable category.
utCodeAgentCLI --goal goals/design-all-skeletons.md --target TestFile --behave designAllSkeleton

# Implement one test case (RED stage).
# --target TestCase scopes to a single TC; --behave implTestCase runs UT_implTestCase.
utCodeAgentCLI --goal goals/impl-login-tc03.md --target TestCase --behave implTestCase

# Design all skeletons AND implement all TCs in one step.
# Combines UT_designCatSkeleton + UT_implTestCase across the whole file.
utCodeAgentCLI --goal goals/design-and-impl-auth.md --target InterfaceFile --behave designAndImplTest
```

The goal file provides the **User Story** that anchors the run. `--target` names the artifact the US will be realized in. `--behave` names the CaTDD step that transforms the goal's US into structured `@[US]`/`@[AC]`/`@[TC]` comments and/or executable test code in that artifact. Together they form a traceable CaTDD execution record that can be replayed or reviewed.

| Argument | Type | Values | Required | Description |
| --- | --- | --- | --- | --- |
| `--goal` | file path | Any readable file | yes | Path to the goal file that contains the UserStory for this invocation's target. The US/AC/TC comments placed in the TestFile are derived from this file. |
| `--target` | string | `TestCase` \| `TestFile` \| `InterfaceFile` \| `ProtocolFile` | yes | Selects the CaTDD artifact or scope the agent should act on. |
| `--behave` | string | `implTestCase` \| `implTestFile` \| `designTypical` \| `designEdge` \| `designTypicalSkeleton` \| `designEdgeSkeleton` \| `designAllSkeleton` \| `designAndImplTest` | yes | Selects the CaTDD workflow behavior the agent applies to the target. |
| `--reference` | string | Comma-separated file paths | no | One or more reference files the agent should consult when generating output. Multiple files are separated by commas. Paths may be absolute or relative to the repository root. |
| `--extra-prompt` | string | Comma-separated file paths | no | One or more files whose content is appended verbatim as extra prompt text for this invocation. Multiple files are separated by commas. |
| `--config-file` | file path | Any readable YAML file | no | Path to the agent configuration file. Default: `{PRJROOT}/CaTDD/utCodeAgentCLI/config.yaml`. |
| `--log-level` | string | `debug` \| `info` \| `warn` \| `error` | no | Sets the log verbosity for this invocation. Default: `info`. |
| `--interactive-slash-commands` | flag | — | no | When set, the agent prompts for confirmation before executing each resolved slash command. Default: false. |
| `--diagMethodPrompts` | flag | — | no | Emits DIAG-class log messages listing the method prompts the agent resolved for this invocation. Confirms correct CaTDD methodPrompt selection at runtime. |
| `--diagSlashCommands` | flag | — | no | Emits DIAG-class log messages listing the slash commands the agent resolved for this invocation. Confirms correct CaTDD slashCommand selection at runtime. |

### `--target` values

| Value | Meaning |
| --- | --- |
| `TestCase` | A single test case (one test function or method inside a test file). |
| `TestFile` | A whole test file containing multiple test cases. |
| `InterfaceFile` | An interface declaration file (e.g., a header, API contract, or abstract class). |
| `ProtocolFile` | A protocol or message-format file (e.g., a network protocol definition, IDL, or schema). |

### `--behave` values

| Value | Meaning |
| --- | --- |
| `implTestCase` | Implement a single test case in the target, following the RED step of CaTDD. Adds executable test code. |
| `implTestFile` | Implement all test cases in a target test file, following the RED step of CaTDD. Adds executable test code. |
| `designTypical` | Design test cases using the CaTDD **Typical** category. Produces a category skeleton with US/AC/TC entries appropriate for core happy-path scenarios. Does **not** add implementation test code. |
| `designEdge` | Design test cases using the CaTDD **Edge** category. Produces a category skeleton with US/AC/TC entries for valid boundary values, limits, and mode variations. Does **not** add implementation test code. |
| `designTypicalSkeleton` | Design a test file of the CaTDD **Typical** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designEdgeSkeleton` | Design a test file of the CaTDD **Edge** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designAllSkeleton` | Design skeletons for all applicable CaTDD categories (Typical, Edge, and others). US/AC/TC comments for every category are placed in the target file, but **no implementation test code** is written. |
| `designAndImplTest` | Design all category skeletons **and** implement their test cases in one combined step. Both US/AC/TC structure and executable test code are produced. |

> **Key distinction**: `designTypical`, `designEdge`, and other category-named values use a specific CaTDD-defined category to drive the design content. `designTypicalSkeleton`, `designEdgeSkeleton`, and `designAllSkeleton` produce only the US/AC/TC skeleton structure for their respective categories without any implementation test code.

### `--log-level` values

| Value | Meaning |
| --- | --- |
| `debug` | Emit all log messages including internal agent state transitions. |
| `info` | Emit informational messages about execution progress. This is the default. |
| `warn` | Emit only warnings and errors. |
| `error` | Emit only error messages. |

## Behavior Matrix

| `--target` | `--behave` | Expected behavior |
| --- | --- | --- |
| `TestCase` | `implTestCase` | Implement one test case. Adds executable test code. Preserves CaTDD comment skeleton and RED status. |
| `TestFile` | `implTestFile` | Implement all test cases in the file. Adds executable test code. Preserves CaTDD status discipline. |
| `TestFile` | `designTypical` | Design Typical category content using the CaTDD Typical category definition. Places US/AC/TC for core happy-path scenarios. No implementation test code. |
| `TestFile` | `designEdge` | Design Edge category content using the CaTDD Edge category definition. Places US/AC/TC for boundary values and valid limits. No implementation test code. |
| `TestFile` | `designTypicalSkeleton` | Place a Typical-category-only US/AC/TC skeleton in the test file. No implementation test code. |
| `TestFile` | `designEdgeSkeleton` | Place an Edge-category-only US/AC/TC skeleton in the test file. No implementation test code. |
| `TestFile` | `designAllSkeleton` | Place US/AC/TC skeletons for all applicable CaTDD categories in the test file. No implementation test code. |
| `TestFile` | `designAndImplTest` | Design all category skeletons and implement them. Produces both US/AC/TC structure and executable test code. |
| `InterfaceFile` | `designAllSkeleton` | Place US/AC/TC skeletons for all interface functions or methods. No implementation test code. |
| `InterfaceFile` | `designAndImplTest` | Design all skeletons for interface functions and implement their test cases. |
| `ProtocolFile` | `designAllSkeleton` | Place US/AC/TC skeletons for all protocol message or field cases. No implementation test code. |
| `ProtocolFile` | `designAndImplTest` | Design all skeletons for protocol cases and implement their test cases. |

## Invocation Examples

```bash
# Design all test skeletons for a test file
utCodeAgentCLI --goal goals/design-all-skeletons.md --target TestFile --behave designAllSkeleton

# Implement a single test case
utCodeAgentCLI --goal goals/impl-one-testcase.md --target TestCase --behave implTestCase

# Design and implement tests from an interface file
utCodeAgentCLI --goal goals/impl-interface.md --target InterfaceFile --behave designAndImplTest

# Consult one reference file when implementing a test case
utCodeAgentCLI --goal goals/impl-one-testcase.md --target TestCase --behave implTestCase --reference docs/api-contract.md

# Consult multiple reference files (comma-separated) when designing skeletons
utCodeAgentCLI --goal goals/design-all-skeletons.md --target TestFile --behave designAllSkeleton --reference docs/api.md,docs/schema.md

# Append extra prompt content from a file
utCodeAgentCLI --goal goals/impl-one-testcase.md --target TestCase --behave implTestCase --extra-prompt prompts/style-guide.md

# Use a custom config file and set log level to debug
utCodeAgentCLI --goal goals/impl-one-testcase.md --target TestCase --behave implTestCase --config-file ~/.catdd/config.yaml --log-level debug

# Interactively confirm each slash command before execution
utCodeAgentCLI --goal goals/design-all-skeletons.md --target TestFile --behave designAllSkeleton --interactive-slash-commands

# Emit DIAG log messages showing resolved method prompts during execution
utCodeAgentCLI --goal goals/design-all-skeletons.md --target TestFile --behave designAllSkeleton --diagMethodPrompts

# Emit DIAG log messages showing resolved slash commands during execution
utCodeAgentCLI --goal goals/design-all-skeletons.md --target TestFile --behave designAndImplTest --diagSlashCommands
```

## Error and Edge Handling

- `--goal` missing -> Print usage and exit with a non-zero status code.
- `--goal` given a path that does not exist -> Print the missing path and exit with a non-zero status code.
- `--target` missing -> Print usage and exit with a non-zero status code.
- `--behave` missing -> Print usage and exit with a non-zero status code.
- `--target` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--behave` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--target TestCase` combined with `--behave designTypicalSkeleton`, `designEdgeSkeleton`, or `designAllSkeleton` -> Unsupported combination. Print error and exit; skeleton behaviors require a file-level target.
- `--reference` given a path that does not exist -> Print the missing path and exit with a non-zero status code.
- `--reference` given an empty string or only commas -> Treat as if `--reference` was not provided; emit a warning.
- `--extra-prompt` given a path that does not exist -> Print the missing path and exit with a non-zero status code.
- `--extra-prompt` given an empty string or only commas -> Treat as if `--extra-prompt` was not provided; emit a warning.
- `--config-file` given a path that does not exist -> Print the missing path and exit with a non-zero status code.
- `--config-file` given a file that is not valid YAML -> Print a parse error and exit with a non-zero status code.
- `--log-level` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--diagMethodPrompts` and `--diagSlashCommands` both provided -> Emit DIAG log messages for both during execution.

## Open Questions

- Should `--target` accept a file path argument in addition to the type selector?
- Should `--log-level` support a `trace` level below `debug` for raw prompt/response logging?
- Should `--interactive-slash-commands` support a timeout for unattended runs?

## Usage Example

Run from the repository root to inspect this usage design without changing source files:

```bash
TMP_DOC="$(mktemp -d)/README_UsageDesign.md"
cp codeAgents/utCodeAgentCLI/README_UsageDesign.md "$TMP_DOC"
grep -E '^##|--goal|--target|--behave|--reference|--extra-prompt|--config-file|--log-level|--interactive|--diag' "$TMP_DOC"
```

Expected result: the temporary file path is printed, and the grep output shows all CLI argument names and section headings.

## Review Checklist

- Every argument has a type, value set, and clear description.
- Every supported combination in the behavior matrix has an expected outcome.
- Unsupported combinations have explicit error behavior.
- Open questions are visible before implementation begins.
- No runnable CLI implementation is claimed before it exists.
