# codeAgents

`codeAgents/` is the shared container for agent-focused CLI layers in this repository.

## Agents

- `utCodeAgentCLI`: based on CaTDD and focused on unit testing design and implementation. Its current detailed design docs remain in [`./utCodeAgentCLI/`](./utCodeAgentCLI/).
- `specCodeAgentCLI`: based on Px-SpecFlow and `utCodeAgentCLI`, focused on module-level flow from input to output. As a flow driver it runs Px-SpecFlow in `autonomousMode` by default, inside the orientation boundary that halts non-implementation work to `manualMode`. Its layer README is [`./specCodeAgentCLI/README.md`](./specCodeAgentCLI/README.md).
