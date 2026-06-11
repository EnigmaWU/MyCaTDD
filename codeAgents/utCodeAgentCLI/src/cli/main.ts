declare function require(moduleName: string): any;
declare const process: {
	argv: string[];
	stderr: { write(text: string): void };
	exitCode?: number;
};

const { validateInvocation } = require("./invocationValidator.ts");

const result = validateInvocation(process.argv.slice(2));

if (result.stderr !== "") {
	process.stderr.write(`${result.stderr}\n`);
}

process.exitCode = result.exitCode;