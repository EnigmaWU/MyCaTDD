# codeAgents

`codeAgents/` is the shared container for agent-focused CLI layers in this repository.

## Agents

- `specCodeAgentCLI` (**active unified CLI**): based on Px-SpecFlow, `methodPrompts`, and `slashCommands`, focused on module-level SpecCoding flow from input to output (including `SPEC_*`, orchestrated `TEST_*`, and status/harness checks) with no dependency on `utCodeAgentCLI`. As a flow driver it runs Px-SpecFlow in `autonomousMode` by default, inside the orientation boundary that halts non-implementation work to `manualMode`. Its layer README is [`./specCodeAgentCLI/README.md`](./specCodeAgentCLI/README.md).
- `utCodeAgentCLI` (**deprecated**): historical unit-testing CLI prototype based on CaTDD, retained as archived reference and regression artifacts in [`./utCodeAgentCLI/`](./utCodeAgentCLI/). Active CLI development is unified in `specCodeAgentCLI`.
