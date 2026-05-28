# utCodeAgentCLI Usage Design

This document captures the CLI interface design for `utCodeAgentCLI`. It is based on [`slashCommands/templates/README_UsageDesignTemplate.md`](../../slashCommands/templates/README_UsageDesignTemplate.md).

- Story: Usage design for utCodeAgentCLI
- Source artifact: GitHub issue — "Usage design for utCodeAgentCLI"
- Related overview: [README.md](README.md)
- Related user guide: [README_UserGuide.md](README_UserGuide.md)

## CLI Interface

```text
utCodeAgentCLI [OPTIONS] --goal <STRING> --target <value> --behave <value>

Options:
  --goal                    <STRING>  WHAT the user wants — natural language task description (required).
  --goalStory               <STRING>  WHY the user wants the goal — inline User Story in natural language.
  --goalStoryFile           <FILE>    WHY in a file — path to a User Story file (alternative to --goalStory).
  --input                   <STRING>  WHAT interface or protocol to be tested and implemented, as an inline string.
  --inputFile               <FILE>    WHAT from a file — path to a file describing the interface or protocol (alternative to --input).
  --target                  <value>   Select the CaTDD work target artifact type.
  --behave                  <value>   Select the behavior to apply to the target.
  --reference               <FILEs>   Comma-separated list of reference files the agent should consult.
  --extra-prompt            <FILEs>   Comma-separated list of files whose content is appended as extra prompt text.
  --config-file             <FILE>    Path to the agent config file. Default: {PRJROOT}/CaTDD/utCodeAgentCLI/config.yaml.
  --log-level               <level>   Log verbosity. One of: debug | info | warn | error. Default: info.
  --interactive-slash-commands        Prompt for confirmation before executing each slash command. Default: false.
  --diagMethodPrompts                 Emit DIAG log messages showing which method prompts the agent resolved.
  --diagSlashCommands                 Emit DIAG log messages showing which slash commands the agent resolved.
```

## Argument Reference

### Core Argument Relationships: goal group, `--input`/`--inputFile`, `--target`, and `--behave`

These arguments work together to fully specify every invocation. Understanding their individual roles — and why they are separate — requires understanding how CaTDD organizes method meaning and slash commands.

#### Background: methodPrompts vs slashCommands

- **`methodPrompts/`** — defines *what CaTDD means*: the US/AC/TC skeleton contract, category semantics (Typical, Edge, Misuse, Fault, State, Capability, …), TDD status discipline, and risk-driven prioritization. This is the CaTDD method itself. It never changes when you run a different target or behavior.
- **`slashCommands/`** — defines *how to execute CaTDD steps*: portable command scripts (`UT_designCatSkeleton`, `UT_implTestCase`, `UT_reviewImplTestCase`, …) organized into flows (P0 FuncTestsFlow, P1 DesignTestsFlow, …). Each command calls on methodPrompts for category meaning but handles the step-by-step execution work.

`utCodeAgentCLI` orchestrates both layers. `--target` and `--behave` together tell the CLI which slashCommand(s) to invoke; the goal group (`--goal`, `--goalStory`/`--goalStoryFile`) and `--input`/`--inputFile` provide the per-invocation context that neither layer owns.

#### Definitions

**`--goal <STRING>`** — **WHAT** the user wants, as an inline natural language string.

> This is the concrete task description for the invocation: what outcome the user wants the agent to produce. It is always a plain string, not a file path. Example: `"design Typical and Edge skeletons for the login interface"`.

**`--goalStory <STRING>`** — **WHY** the user wants the goal, as an inline natural language User Story string.

> This is the User Story that motivates the goal. Written in natural language (e.g. `"As a logged-in user I want to reset my password so that I can regain access to my account"`). The `@[US]` comments embedded in the TestFile during a design step are derived from this story — `--goalStory` is the *source* of the User Story; the TestFile is its *destination* as a permanent design record.
> Use `--goalStory` for short stories that fit comfortably on the command line.

**`--goalStoryFile <FILE>`** — **WHY** from a file; an alternative to `--goalStory` for longer User Stories.

> Path to a file containing the User Story. Use when the story is too long for inline use or is shared across multiple invocations. The file content is treated identically to the value passed via `--goalStory`. Providing both `--goalStory` and `--goalStoryFile` in the same invocation is an error.

**`--input <STRING>`** — **WHAT** interface or protocol to be tested and implemented, as an inline string.

> Identifies the specific interface or protocol that the agent should derive tests for. The value is a plain string identifier — a type name, a function signature, or a short natural language description. Example: `"AuthService"` or `"IAuthService::login"`. Do not pass raw file content here; use `--inputFile` to have the CLI read a file and supply its content.
> `--input` complements `--target`: `--target` says *what kind* of artifact (InterfaceFile, ProtocolFile, …); `--input` says *which specific* interface or protocol within that kind.
> Use `--input` for short identifiers that fit comfortably on the command line.

**`--inputFile <FILE>`** — **WHAT** from a file; an alternative to `--input` for larger or shared interface/protocol descriptions.

> Path to a file containing the full description of the interface or protocol (e.g., a header file, API spec, or schema). Use when the interface description is too long for inline use or is shared across multiple invocations. The file content is treated identically to the value passed via `--input`. Providing both `--input` and `--inputFile` in the same invocation is an error.

**`--target <value>`** — The CaTDD artifact *type* the agent will operate on.

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

| Argument | Question | Role |
| --- | --- | --- |
| `--goal` | **WHAT** — what outcome does the user want? | Inline natural language task description for the invocation |
| `--goalStory` / `--goalStoryFile` | **WHY** — what is the User Story behind the goal? | Source of the `@[US]` embedded in the TestFile; permanent design record |
| `--input` / `--inputFile` | **WHAT (specific)** — which interface or protocol to test? | Identifies the concrete interface/protocol artifact within the target type; `--inputFile` is the file-based alternative |
| `--target` | **WHAT (type)** — which CaTDD artifact kind is being acted on? | Artifact type selector; determines which files the agent reads/writes |
| `--behave` | **HOW** — design skeleton, implement test code, or both? | Selects the slashCommand(s) from `slashCommands/commands/`; category meaning comes from `methodPrompts/` |

`--goal`, `--target`, and `--behave` are required and must be consistent with each other. `--goalStory`/`--goalStoryFile` and `--input`/`--inputFile` are optional but strongly recommended when working with interface or protocol targets.

#### Single-argument use (error cases)

Omitting any required argument causes the CLI to exit with an error:

```bash
# ERROR: --target and --behave are missing; agent cannot determine artifact type or step
utCodeAgentCLI --goal "design Typical skeletons for login"

# ERROR: --goal and --behave are missing; agent has no task description or step
utCodeAgentCLI --target InterfaceFile

# ERROR: --goal and --target are missing; agent has no task description and no artifact type
utCodeAgentCLI --behave designAllSkeleton

# ERROR: --goalStory and --goalStoryFile cannot both be provided
utCodeAgentCLI --goal "design login skeletons" --goalStory "As a user..." --goalStoryFile stories/login.md \
  --target InterfaceFile --behave designAllSkeleton

# ERROR: --input and --inputFile cannot both be provided
utCodeAgentCLI --goal "design login skeletons" \
  --input "AuthService" --inputFile src/auth/AuthService.h \
  --target InterfaceFile --behave designAllSkeleton
```

#### Combination use (correct invocations)

```bash
# Design the Typical skeleton from an interface — inline goal and story.
utCodeAgentCLI \
  --goal "design Typical skeletons for the auth interface" \
  --goalStory "As a logged-in user I want to reset my password so that I can regain access" \
  --input "AuthService" \
  --target InterfaceFile --behave designTypical

# Design all functional skeletons using a shared story file and interface file.
utCodeAgentCLI \
  --goal "design all skeletons for the payment protocol" \
  --goalStoryFile stories/payment-us.md \
  --inputFile src/payment/PaymentProtocol.proto \
  --target ProtocolFile --behave designAllSkeleton

# Implement one test case — goal only (no story needed for impl step).
utCodeAgentCLI \
  --goal "implement TC-03 of the login test file" \
  --target TestCase --behave implTestCase

# Design all skeletons AND implement all TCs in one step.
utCodeAgentCLI \
  --goal "design and implement auth interface tests" \
  --goalStory "As an API consumer I want typed auth errors so that I can handle failures reliably" \
  --inputFile src/auth/AuthService.h \
  --target InterfaceFile --behave designAndImplTest
```

`--goal` states **what** the run produces. `--goalStory`/`--goalStoryFile` carry the **why** — the User Story whose `@[US]`/`@[AC]`/`@[TC]` structure will be written into the TestFile. `--input`/`--inputFile` names **which** interface or protocol (inline or from file); `--target` names **what kind** of artifact; `--behave` names **which CaTDD step** runs. Together they form a traceable CaTDD execution record that can be replayed or reviewed.

| Argument | Type | Values | Required | Description |
| --- | --- | --- | --- | --- |
| `--goal` | string | Any natural language string | yes | **WHAT** the user wants — inline task description for this invocation. |
| `--goalStory` | string | Any natural language string | no | **WHY** — inline User Story that motivates the goal. Source of `@[US]` comments placed in the TestFile. Mutually exclusive with `--goalStoryFile`. |
| `--goalStoryFile` | file path | Any readable file | no | **WHY** from a file — path to a User Story file. Treated identically to `--goalStory`. Mutually exclusive with `--goalStory`. |
| `--input` | string | Interface/protocol name or identifier | no | **WHAT (specific)** — inline identifier of the interface or protocol to be tested and implemented (e.g. `"AuthService"` or `"IAuthService::login"`). Do not pass a raw file path here; use `--inputFile` instead. Mutually exclusive with `--inputFile`. |
| `--inputFile` | file path | Any readable file | no | **WHAT (specific)** from a file — path to a file describing the interface or protocol. Treated identically to `--input`. Mutually exclusive with `--input`. |
| `--target` | string | `TestCase` \| `TestFile` \| `InterfaceFile` \| `ProtocolFile` | yes | Selects the CaTDD artifact *type* the agent should act on. |
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
# Design all test skeletons for an interface — with inline story
utCodeAgentCLI \
  --goal "design all skeletons for the auth interface" \
  --goalStory "As an API consumer I want typed auth errors so that I can handle failures reliably" \
  --input "AuthService" \
  --target InterfaceFile --behave designAllSkeleton

# Implement a single test case — goal only
utCodeAgentCLI \
  --goal "implement TC-03 of the login test file" \
  --target TestCase --behave implTestCase

# Design and implement tests from an interface file — story from file
utCodeAgentCLI \
  --goal "design and implement auth interface tests" \
  --goalStoryFile stories/auth-us.md \
  --inputFile src/auth/AuthService.h \
  --target InterfaceFile --behave designAndImplTest

# Design skeletons for a protocol — story from file, interface from file
utCodeAgentCLI \
  --goal "design all skeletons for the payment protocol" \
  --goalStoryFile stories/payment-us.md \
  --inputFile src/payment/PaymentProtocol.proto \
  --target ProtocolFile --behave designAllSkeleton \
  --reference docs/payment-spec.md

# Consult multiple reference files (comma-separated) when designing skeletons
utCodeAgentCLI \
  --goal "design all skeletons for the order service" \
  --input "OrderService" \
  --target InterfaceFile --behave designAllSkeleton \
  --reference docs/api.md,docs/schema.md

# Append extra prompt content from a file
utCodeAgentCLI \
  --goal "implement TC-01 of the login test file" \
  --target TestCase --behave implTestCase \
  --extra-prompt prompts/style-guide.md

# Use a custom config file and set log level to debug
utCodeAgentCLI \
  --goal "implement TC-01 of the login test file" \
  --target TestCase --behave implTestCase \
  --config-file ~/.catdd/config.yaml --log-level debug

# Interactively confirm each slash command before execution
utCodeAgentCLI \
  --goal "design all skeletons for the auth interface" \
  --input "AuthService" \
  --target InterfaceFile --behave designAllSkeleton \
  --interactive-slash-commands

# Emit DIAG log messages showing resolved method prompts and slash commands
utCodeAgentCLI \
  --goal "design and implement auth interface tests" \
  --inputFile src/auth/AuthService.h \
  --target InterfaceFile --behave designAndImplTest \
  --diagMethodPrompts --diagSlashCommands
```

## Error and Edge Handling

- `--goal` missing -> Print usage and exit with a non-zero status code.
- `--goal` given an empty string -> Print usage and exit with a non-zero status code.
- `--goalStory` and `--goalStoryFile` both provided -> Print error (mutually exclusive) and exit with a non-zero status code.
- `--goalStoryFile` given a path that does not exist -> Print the missing path and exit with a non-zero status code.
- `--input` and `--inputFile` both provided -> Print error (mutually exclusive) and exit with a non-zero status code.
- `--input` given an empty string -> Treat as if `--input` was not provided; emit a warning.
- `--inputFile` given a path that does not exist -> Print the missing path and exit with a non-zero status code.
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

- Should `--input` accept a comma-separated list of interface names for batch operations?
- Should `--target` accept a file path argument in addition to the type selector?
- Should `--log-level` support a `trace` level below `debug` for raw prompt/response logging?
- Should `--interactive-slash-commands` support a timeout for unattended runs?

## Usage Example

Run from the repository root to inspect this usage design without changing source files:

```bash
TMP_DOC="$(mktemp -d)/README_UsageDesign.md"
cp codeAgents/utCodeAgentCLI/README_UsageDesign.md "$TMP_DOC"
grep -E '^##|--goal|--goalStory|--goalStoryFile|--input|--target|--behave|--reference|--extra-prompt|--config-file|--log-level|--interactive|--diag' "$TMP_DOC"
```

Expected result: the temporary file path is printed, and the grep output shows all CLI argument names and section headings.

## Review Checklist

- Every argument has a type, value set, and clear description.
- Every supported combination in the behavior matrix has an expected outcome.
- Unsupported combinations have explicit error behavior.
- Open questions are visible before implementation begins.
- No runnable CLI implementation is claimed before it exists.
