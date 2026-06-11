declare function require(moduleName: string): any;
declare const process: { cwd(): string; execPath: string };

const path = require("node:path");
const { spawnSync } = require("node:child_process");

const cliEntryPoint = path.resolve(process.cwd(), "codeAgents/utCodeAgentCLI/src/cli/main.ts");

function runUtCodeAgentCli(argv: string[]) {
	const result = spawnSync(process.execPath, [cliEntryPoint, ...argv], {
		encoding: "utf8",
	});

	return {
		exitCode: result.status ?? 1,
		stderr: result.stderr ?? "",
		stdout: result.stdout ?? "",
	};
}

module.exports = { runUtCodeAgentCli };