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
  --input                   <STRING>  WHAT source or context the agent should use, as an inline selector.
  --inputFile               <FILE>    WHAT source or context from a file, as an alternative to --input.
  --target                  <value>   Select the TestCase/TestFile scope to create, update, or implement.
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

### Core Argument Relationships: `--goal`, `--target`, `--input`/`--inputFile`, and `--behave`

These arguments work together to fully specify every invocation. Understanding their individual roles — and why they are separate — requires understanding how CaTDD organizes method meaning and slash commands.

#### Background: methodPrompts vs slashCommands

- **`methodPrompts/`** — defines *what CaTDD means*: the US/AC/TC skeleton contract, category semantics (Typical, Edge, Misuse, Fault, State, Capability, …), TDD status discipline, and risk-driven prioritization. This is the CaTDD method itself. It never changes when you run a different target or behavior.
- **`slashCommands/`** — defines *how to execute CaTDD steps*: portable command scripts (`UT_designCatSkeleton`, `UT_implTestCase`, `UT_reviewImplTestCase`, …) organized into flows (P0 FuncTestsFlow, P1 DesignTestsFlow, …). Each command calls on methodPrompts for category meaning but handles the step-by-step execution work.

`utCodeAgentCLI` orchestrates both layers. `--target` and `--behave` together tell the CLI which slashCommand(s) to invoke; `--goal` and `--input`/`--inputFile` provide the per-invocation context that neither layer owns.

The core model is:

```text
--goal   = what outcome the user wants from this run
--input  = what source or context the agent should use
--target = which TestCase/TestFile scope the agent should create, update, or implement
--behave = how the CLI should act on that target
```

#### Definitions

**`--goal <STRING>`** — **WHAT** the user wants, as an inline natural language string.

> This is the concrete task description for the invocation: what outcome the user wants the agent to produce. It is always a plain string, not a file path. Example: `"design Typical and Edge skeletons for the login interface"`.

**`--goalStory <STRING>`** — **WHY** the user wants the goal, as an inline natural language User Story string.

> This is the User Story that motivates the goal. Written in natural language (e.g. `"As a logged-in user I want to reset my password so that I can regain access to my account"`). The `@[US]` comments embedded in the TestFile during a design step are derived from this story — `--goalStory` is the *source* of the User Story; the TestFile is its *destination* as a permanent design record.
> Use `--goalStory` for short stories that fit comfortably on the command line.

**`--goalStoryFile <FILE>`** — **WHY** from a file; an alternative to `--goalStory` for longer User Stories.

> Path to a file containing the User Story. Use when the story is too long for inline use or is shared across multiple invocations. The file content is treated identically to the value passed via `--goalStory`. Providing both `--goalStory` and `--goalStoryFile` in the same invocation is an error.

**`--input <STRING>`** — **WHAT** source or context the agent should use, as an inline string.

> `--input` supplies the source material for the work. For design behaviors, it may name an interface, protocol, API, schema, draft, or short natural language source. For implementation behaviors, it may name related production source files or a short implementation context. Use `--input` for short selectors that fit comfortably on the command line.

**`--inputFile <FILE>`** — **WHAT** source or context from a file; an alternative to `--input`.

> Path to the source material for the work, such as an interface header, API spec, schema, protocol file, existing draft, or related production source file. Providing both `--input` and `--inputFile` in the same invocation is an error.

**`--target <value>`** — The CaTDD test-space scope the agent will create, update, or implement.

> `--target` does **not** say whether the work is design or implementation — that is `--behave`'s job. `--target` scopes the test artifact destination:

> - one TestCase in one TestFile → e.g. `tests/auth_login_test.cpp::TC-03`
> - one TestFile → e.g. `tests/auth_login_test.cpp`
> - some TestFiles → e.g. `tests/auth_test.cpp,tests/payment_test.cpp`

**`--behave <value>`** — The CaTDD slash-command behavior to execute or orchestrate.

> `--behave` is a behavior selector resolved against compatible unit-testing slash commands under `slashCommands/commands/`. It may be a portable UT slash-command name, such as `UT_designCatSkeleton`, `UT_reviewFuncTestsSkeleton`, `UT_tellMeNextImplTest`, or `UT_implTestCase`, when that command's input/output contract can be satisfied by `--goal`, `--input`/`--inputFile`, `--target`, and optional reference arguments.

> The CLI may also provide stable aliases for common multi-step or parameterized slash-command behaviors:

> - `designTypicalSkeleton` / `designEdgeSkeleton` / `designMisuseSkeleton` / `designFaultSkeleton` → invoke `UT_designCatSkeleton` with the matching P0 functional category. Produces a US/AC/TC skeleton; no executable test code.
> - `designStateSkeleton` / `designCapabilitySkeleton` / `designConcurrencySkeleton` → invoke the matching P1 DesignTestsFlow skeleton command. Produces a US/AC/TC skeleton; no executable test code.
> - `designPerformanceSkeleton` / `designRobustSkeleton` / `designCompatibilitySkeleton` / `designConfigurationSkeleton` → invoke the matching P2 QualityTestsFlow skeleton command. Produces a US/AC/TC skeleton; no executable test code.
> - `designAllSkeleton` → invoke category skeleton design for all P0/P1/P2 CaTDD categories: Typical, Edge, Misuse, Fault, State, Capability, Concurrency, Performance, Robust, Compatibility, and Configuration. Produces skeletons only; no executable test code.
> - `implTestCase` → invoke `UT_implTestCase`. Writes executable test code for one TC (RED stage).
> - `implTestFile` → invoke `UT_implTestCase` repeatedly across all TCs in the file.
> - `designAndImplTest` → run skeleton design, then implement selected or generated TCs by repeatedly invoking `UT_implTestCase` under CLI orchestration.

#### Relationship summary

| Argument | Question | Role |
| --- | --- | --- |
| `--goal` | **WHAT** — what outcome does the user want? | Inline natural language task description for the invocation |
| `--goalStory` / `--goalStoryFile` | **WHY** — what is the User Story behind the goal? | Source of the `@[US]` embedded in the TestFile; permanent design record |
| `--input` / `--inputFile` | **WHAT (source)** — what source or context should the agent use? | Supplies interface/protocol/source/draft material; `--inputFile` is the file-based alternative |
| `--target` | **WHAT (destination/scope)** — which test artifact scope is acted on? | Selects one TC in one TestFile, one TestFile, or some TestFiles |
| `--behave` | **HOW** — which slash-command behavior should run? | Selects or aliases slashCommand(s) from `slashCommands/commands/`; category meaning comes from `methodPrompts/` |

`--goal`, `--target`, and `--behave` are required and must be consistent with each other. Provide exactly one of `--input` or `--inputFile` when the behavior needs source material beyond the target test artifact.

#### Single-argument use (error cases)

Omitting any required argument causes the CLI to exit with an error:

```bash
# ERROR: --target and --behave are missing; agent cannot determine test scope or step
utCodeAgentCLI --goal "design Typical skeletons for login"

# ERROR: --goal and --behave are missing; agent has no task description or step
utCodeAgentCLI --target tests/auth_login_test.cpp

# ERROR: --goal and --target are missing; agent has no task description and no test scope
utCodeAgentCLI --behave designAllSkeleton

# ERROR: --goalStory and --goalStoryFile cannot both be provided
utCodeAgentCLI --goal "design login skeletons" --goalStory "As a user..." --goalStoryFile stories/login.md \
  --target tests/auth_login_test.cpp --behave designAllSkeleton

# ERROR: --input and --inputFile cannot both be provided
utCodeAgentCLI --goal "design login skeletons" \
  --input "AuthService" --inputFile src/auth/AuthService.h \
  --target tests/auth_login_test.cpp --behave designAllSkeleton
```

#### Typical use cases (proposed valid invocations)

```bash
# Design one P0 category skeleton into one test file from an interface file.
utCodeAgentCLI \
  --goal "design Typical skeletons for the auth interface" \
  --goalStory "As a logged-in user I want to reset my password so that I can regain access" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_login_test.cpp --behave designTypicalSkeleton

# Design all P0/P1/P2 category skeletons into one test file from a protocol file.
utCodeAgentCLI \
  --goal "design all skeletons for the payment protocol" \
  --goalStoryFile stories/payment-us.md \
  --inputFile src/payment/PaymentProtocol.proto \
  --target tests/payment_protocol_test.cpp --behave designAllSkeleton

# Implement one selected test case.
utCodeAgentCLI \
  --goal "implement TC-03 of the login test file" \
  --inputFile src/auth/AuthService.cpp \
  --target tests/auth_login_test.cpp::TC-03 --behave implTestCase

# Implement every TC in a test file by repeating the single-TC implementation step.
utCodeAgentCLI \
  --goal "implement all RED test cases in the login test file" \
  --inputFile src/auth/AuthService.cpp \
  --target tests/auth_login_test.cpp --behave implTestFile

# Design skeletons across several test files from one source interface.
utCodeAgentCLI \
  --goal "design auth service skeletons across API and error test files" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp,tests/auth_error_test.cpp --behave designAllSkeleton

# Design all skeletons and implement generated TCs in one step.
utCodeAgentCLI \
  --goal "design and implement auth interface tests" \
  --goalStory "As an API consumer I want typed auth errors so that I can handle failures reliably" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp --behave designAndImplTest

# Run a portable slash command directly as the behavior.
utCodeAgentCLI \
  --goal "review the functional skeletons before implementation" \
  --target tests/auth_api_test.cpp --behave UT_reviewFuncTestsSkeleton
```

`--goal` states **what** the run produces. `--input`/`--inputFile` names **what source** the CLI should use. `--target` names **which test artifact scope** the CLI should create, update, or implement. `--behave` names **which CaTDD step** runs. `--goalStory`/`--goalStoryFile` carry the **why** for design steps whose `@[US]`/`@[AC]`/`@[TC]` structure will be written into a TestFile. Together they form a traceable CaTDD execution record that can be replayed or reviewed.

| Argument | Type | Values | Required | Description |
| --- | --- | --- | --- | --- |
| `--goal` | string | Any natural language string | yes | **WHAT** the user wants — inline task description for this invocation. |
| `--goalStory` | string | Any natural language string | no | **WHY** — inline User Story that motivates the goal. Source of `@[US]` comments placed in the TestFile. Mutually exclusive with `--goalStoryFile`. |
| `--goalStoryFile` | file path | Any readable file | no | **WHY** from a file — path to a User Story file. Treated identically to `--goalStory`. Mutually exclusive with `--goalStory`. |
| `--input` | string | Source/context selector | no | **WHAT (source)** — inline source material or context, such as `AuthService`, `PaymentProtocol`, or `src/auth/AuthService.cpp`. Mutually exclusive with `--inputFile`. |
| `--inputFile` | file path | Any readable file | no | **WHAT (source)** from a file — interface file, protocol file, schema, API spec, draft test material, or related production source. Mutually exclusive with `--input`. |
| `--target` | string | Test target selector | yes | Selects the test-space target: one TC in one TestFile (`tests/auth_test.cpp::TC-03`), one TestFile (`tests/auth_test.cpp`), or some TestFiles (`tests/a_test.cpp,tests/b_test.cpp`). |
| `--behave` | string | Slash-command behavior selector | yes | Selects the CaTDD behavior to apply to the target. Accepts compatible portable slash-command names from `slashCommands/commands/` plus stable CLI aliases such as `designAllSkeleton`, `implTestFile`, and `designAndImplTest`. |
| `--reference` | string | Comma-separated file paths | no | One or more reference files the agent should consult when generating output. Multiple files are separated by commas. Paths may be absolute or relative to the repository root. |
| `--extra-prompt` | string | Comma-separated file paths | no | One or more files whose content is appended verbatim as extra prompt text for this invocation. Multiple files are separated by commas. |
| `--config-file` | file path | Any readable YAML file | no | Path to the agent configuration file. Default: `{PRJROOT}/CaTDD/utCodeAgentCLI/config.yaml`. |
| `--log-level` | string | `debug` \| `info` \| `warn` \| `error` | no | Sets the log verbosity for this invocation. Default: `info`. |
| `--interactive-slash-commands` | flag | — | no | When set, the agent prompts for confirmation before executing each resolved slash command. Default: false. |
| `--diagMethodPrompts` | flag | — | no | Emits DIAG-class log messages listing the method prompts the agent resolved for this invocation. Confirms correct CaTDD methodPrompt selection at runtime. |
| `--diagSlashCommands` | flag | — | no | Emits DIAG-class log messages listing the slash commands the agent resolved for this invocation. Confirms correct CaTDD slashCommand selection at runtime. |

### `--target` selector forms

| Form | Meaning |
| --- | --- |
| `tests/auth_test.cpp::TC-03` | One TestCase inside one TestFile. Use with `implTestCase`. |
| `tests/auth_test.cpp` | One TestFile. Use with skeleton design, full-file implementation, or combined design and implementation. |
| `tests/auth_test.cpp,tests/payment_test.cpp` | Some TestFiles. Use when the same behavior should be applied across multiple test files. |

### `--behave` selector forms

| Form | Meaning |
| --- | --- |
| `UT_implTestCase` | Direct portable slash-command name. The CLI runs the matching command when its input/output contract is compatible with `--goal`, `--input`, and `--target`. |
| `UT_reviewFuncTestsSkeleton` | Direct review command name. Useful when the target is one TestFile or some TestFiles containing CaTDD skeletons. |
| `UT_tellMeNextImplTest` | Direct next-step command name. Useful when the target TestFile already contains skeleton TCs and the CLI should select the next implementation candidate. |
| `designTypicalSkeleton` | Stable CLI alias. The CLI resolves it to `UT_designCatSkeleton` with `Cat=Typical`. |
| `designAllSkeleton` | Stable CLI aggregate alias. The CLI resolves it to the applicable P0/P1/P2 skeleton-design command sequence. |

### Common `--behave` aliases

| Value | Meaning |
| --- | --- |
| `implTestCase` | Implement a single test case in the target, following the RED step of CaTDD. Adds executable test code. |
| `implTestFile` | Implement all test cases in a target test file, following the RED step of CaTDD. Adds executable test code. |
| `designTypicalSkeleton` | Design a test file of the CaTDD **Typical** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designEdgeSkeleton` | Design a test file of the CaTDD **Edge** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designMisuseSkeleton` | Design a test file of the CaTDD **Misuse** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designFaultSkeleton` | Design a test file of the CaTDD **Fault** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designStateSkeleton` | Design a test file of the CaTDD **State** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designCapabilitySkeleton` | Design a test file of the CaTDD **Capability** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designConcurrencySkeleton` | Design a test file of the CaTDD **Concurrency** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designPerformanceSkeleton` | Design a test file of the CaTDD **Performance** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designRobustSkeleton` | Design a test file of the CaTDD **Robust** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designCompatibilitySkeleton` | Design a test file of the CaTDD **Compatibility** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designConfigurationSkeleton` | Design a test file of the CaTDD **Configuration** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designAllSkeleton` | Design skeletons for all P0/P1/P2 CaTDD categories: Typical, Edge, Misuse, Fault, State, Capability, Concurrency, Performance, Robust, Compatibility, and Configuration. US/AC/TC comments are placed in the target test file, but **no implementation test code** is written. |
| `designAndImplTest` | Design all category skeletons **and** implement their test cases in one combined step. Both US/AC/TC structure and executable test code are produced. |

> These aliases are not the complete behavior set. Almost any compatible UT slash command in `slashCommands/commands/` may be used as `--behave` when it fits the selected test-space `--target` and the provided source/context. Use `--diagSlashCommands` to confirm which portable command(s) the CLI resolved at runtime.

### `--log-level` values

| Value | Meaning |
| --- | --- |
| `debug` | Emit all log messages including internal agent state transitions. |
| `info` | Emit informational messages about execution progress. This is the default. |
| `warn` | Emit only warnings and errors. |
| `error` | Emit only error messages. |

## Behavior Matrix

| `--target` shape | `--behave` | Expected behavior |
| --- | --- | --- |
| one TestCase in one TestFile | `implTestCase` | Implement one selected test case. Adds executable test code. Preserves CaTDD comment skeleton and RED status. |
| one TestFile | `implTestFile` | Implement all test cases in the file by repeatedly invoking the single-TC implementation step. Preserves CaTDD status discipline. |
| one TestFile | `designTypicalSkeleton` | Place a Typical-category-only US/AC/TC skeleton in the test file. No implementation test code. |
| one TestFile | `designEdgeSkeleton` | Place an Edge-category-only US/AC/TC skeleton in the test file. No implementation test code. |
| one TestFile | `designMisuseSkeleton` | Place a Misuse-category-only US/AC/TC skeleton in the test file. No implementation test code. |
| one TestFile | `designFaultSkeleton` | Place a Fault-category-only US/AC/TC skeleton in the test file. No implementation test code. |
| one TestFile | P1 category skeleton behavior | Place a State, Capability, or Concurrency US/AC/TC skeleton in the test file. No implementation test code. |
| one TestFile | P2 category skeleton behavior | Place a Performance, Robust, Compatibility, or Configuration US/AC/TC skeleton in the test file. No implementation test code. |
| one TestFile | `designAllSkeleton` | Place US/AC/TC skeletons for all P0/P1/P2 CaTDD categories in the test file. No implementation test code. |
| one TestFile | `designAndImplTest` | Design all category skeletons and implement them. Produces both US/AC/TC structure and executable test code. |
| one TestFile | compatible `UT_review*` behavior | Review the selected skeleton or implementation artifact without changing unrelated files. |
| one TestFile | `UT_tellMeNextImplTest` | Select or recommend the next TC to implement from the target test file. |
| some TestFiles | `implTestFile` | Repeat full-file implementation across each selected test file. |
| some TestFiles | any skeleton design behavior | Apply the selected skeleton design behavior across each selected test file. |
| some TestFiles | compatible review behavior | Review each selected test file according to the chosen slash-command contract. |
| some TestFiles | `designAndImplTest` | Design skeletons and implement generated TCs across each selected test file. |

## Invocation Examples

```bash
# Design all P0/P1/P2 category skeletons for an interface — with inline story
utCodeAgentCLI \
  --goal "design all skeletons for the auth interface" \
  --goalStory "As an API consumer I want typed auth errors so that I can handle failures reliably" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp --behave designAllSkeleton

# Implement a single test case
utCodeAgentCLI \
  --goal "implement TC-03 of the login test file" \
  --inputFile src/auth/AuthService.cpp \
  --target tests/auth_login_test.cpp::TC-03 --behave implTestCase

# Design and implement tests from an interface file — story from file
utCodeAgentCLI \
  --goal "design and implement auth interface tests" \
  --goalStoryFile stories/auth-us.md \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp --behave designAndImplTest

# Design skeletons for a protocol — story from file, protocol from file
utCodeAgentCLI \
  --goal "design all skeletons for the payment protocol" \
  --goalStoryFile stories/payment-us.md \
  --inputFile src/payment/PaymentProtocol.proto \
  --target tests/payment_protocol_test.cpp --behave designAllSkeleton \
  --reference docs/payment-spec.md

# Consult multiple reference files (comma-separated) when designing skeletons
utCodeAgentCLI \
  --goal "design all skeletons for the order service" \
  --input "OrderService" \
  --target tests/order_api_test.cpp --behave designAllSkeleton \
  --reference docs/api.md,docs/schema.md

# Append extra prompt content from a file
utCodeAgentCLI \
  --goal "implement TC-01 of the login test file" \
  --inputFile src/auth/AuthService.cpp \
  --target tests/auth_login_test.cpp::TC-01 --behave implTestCase \
  --extra-prompt prompts/style-guide.md

# Use a custom config file and set log level to debug
utCodeAgentCLI \
  --goal "implement TC-01 of the login test file" \
  --inputFile src/auth/AuthService.cpp \
  --target tests/auth_login_test.cpp::TC-01 --behave implTestCase \
  --config-file ~/.catdd/config.yaml --log-level debug

# Interactively confirm each slash command before execution
utCodeAgentCLI \
  --goal "design all skeletons for the auth interface" \
  --input "AuthService" \
  --target tests/auth_api_test.cpp --behave designAllSkeleton \
  --interactive-slash-commands

# Emit DIAG log messages showing resolved method prompts and slash commands
utCodeAgentCLI \
  --goal "design and implement auth interface tests" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp --behave designAndImplTest \
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
- `--target` cannot be parsed as one TestCase, one TestFile, or some TestFiles -> Print supported selector forms and exit with a non-zero status code.
- `--behave` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--target` selecting one TestCase combined with a skeleton design behavior -> Unsupported combination. Print error and exit; skeleton behaviors require one TestFile or some TestFiles.
- `--reference` given a path that does not exist -> Print the missing path and exit with a non-zero status code.
- `--reference` given an empty string or only commas -> Treat as if `--reference` was not provided; emit a warning.
- `--extra-prompt` given a path that does not exist -> Print the missing path and exit with a non-zero status code.
- `--extra-prompt` given an empty string or only commas -> Treat as if `--extra-prompt` was not provided; emit a warning.
- `--config-file` given a path that does not exist -> Print the missing path and exit with a non-zero status code.
- `--config-file` given a file that is not valid YAML -> Print a parse error and exit with a non-zero status code.
- `--log-level` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--diagMethodPrompts` and `--diagSlashCommands` both provided -> Emit DIAG log messages for both during execution.

## Open Questions

- Should `--input` accept a comma-separated list of source names for batch operations?
- Should `--target` use comma-separated test file paths, repeated `--target` flags, or a target file list for some-TestFiles operations?
- Should `--log-level` support a `trace` level below `debug` for raw prompt/response logging?
- Should `--interactive-slash-commands` support a timeout for unattended runs?

## Usage Example

Run from the repository root to inspect this usage design without changing source files:

```bash
TMP_DOC="$(mktemp -d)/README_UsageDesign.md"
cp codeAgents/utCodeAgentCLI/README_UsageDesign.md "$TMP_DOC"
printf '%s\n' "$TMP_DOC"
grep -E '^##|--goal|--goalStory|--goalStoryFile|--input|--target|--behave|--reference|--extra-prompt|--config-file|--log-level|--interactive|--diag' "$TMP_DOC"
```

Expected result: the temporary file path is printed, and the grep output shows all CLI argument names and section headings.

## Review Checklist

- Every argument has a type, value set, and clear description.
- Every supported combination in the behavior matrix has an expected outcome.
- Unsupported combinations have explicit error behavior.
- Open questions are visible before implementation begins.
- No runnable CLI implementation is claimed before it exists.
