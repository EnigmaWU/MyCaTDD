declare function require(moduleName: string): any;
declare const module: { exports: Record<string, unknown> };

const fs = require("node:fs");

const VALID_LOG_LEVELS = ["error", "warn", "info", "debug"];

type InvocationResult = {
	exitCode: number;
	stderr: string;
	dispatchedBehavior?: string;
};

type ParsedArgs = {
	goal?: string;
	target?: string;
	behave?: string;
	goalStory?: string;
	goalStoryFile?: string;
	input?: string;
	inputFile?: string;
	references: string[];
	extraPrompts: string[];
	configFile?: string;
	logLevel?: string;
	diagMethodPrompts: boolean;
	diagSlashCommands: boolean;
	diagCats: boolean;
	diagModelTier: boolean;
	interactiveSlashCommands: boolean;
};

const VALID_BEHAVIORS = [
	// NOTE: Static allowlist for US-USER-01 scope.
	// Future feature: resolve supported behaviors dynamically from effective methodPrompts and slashCommands.
	"designAllSkeleton",
	"designFuncTestsSkeleton",
	"designTypicalSkeleton",
	"designEdgeSkeleton",
	"designMisuseSkeleton",
	"designFaultSkeleton",
	"reviewFuncTestsSkeleton",
	"tellMeNextImplTest",
	"implTestCase",
	"implTestFile",
	"reviewImplTestCase",
	"reviewImplTestFile",
	"designAndImplTest",
];

function fail(stderr: string): InvocationResult {
	return { exitCode: 1, stderr };
}

function parseArgs(argv: string[]): ParsedArgs | InvocationResult {
	const parsed: ParsedArgs = { references: [], extraPrompts: [], diagMethodPrompts: false, diagSlashCommands: false, diagCats: false, diagModelTier: false, interactiveSlashCommands: false };

	for (let i = 0; i < argv.length; i += 1) {
		const flag = argv[i];
		if (!flag.startsWith("--")) {
			continue;
		}

		if (flag == "--diagMethodPrompts") { parsed.diagMethodPrompts = true; continue; }
		if (flag == "--diagSlashCommands") { parsed.diagSlashCommands = true; continue; }
		if (flag == "--diagCats") { parsed.diagCats = true; continue; }
		if (flag == "--diagModelTier") { parsed.diagModelTier = true; continue; }
		if (flag == "--interactive-slash-commands") { parsed.interactiveSlashCommands = true; continue; }

		const next = argv[i + 1];
		if (next == null || next.startsWith("--")) {
			return fail(`Argument ${flag} requires a value.`);
		}

		switch (flag) {
			case "--goal":
				parsed.goal = next;
				i += 1;
				break;
			case "--target":
				parsed.target = next;
				i += 1;
				break;
			case "--behave":
				parsed.behave = next;
				i += 1;
				break;
			case "--goalStory":
				parsed.goalStory = next;
				i += 1;
				break;
			case "--goalStoryFile":
				parsed.goalStoryFile = next;
				i += 1;
				break;
			case "--input":
				parsed.input = next;
				i += 1;
				break;
			case "--inputFile":
				parsed.inputFile = next;
				i += 1;
				break;
			case "--reference":
				parsed.references.push(...next.split(",").map(function(s) { return s.trim(); }));
				i += 1;
				break;
			case "--extra-prompt":
				parsed.extraPrompts.push(...next.split(",").map(function(s) { return s.trim(); }));
				i += 1;
				break;
			case "--config-file":
				parsed.configFile = next;
				i += 1;
				break;
			case "--log-level":
				parsed.logLevel = next;
				i += 1;
				break;
			default:
				return fail(`Unknown argument ${flag}.`);
		}
	}

	return parsed;
}

function firstMissingPath(parsed: ParsedArgs): { flag: string; value: string } | undefined {
	const pathChecks: Array<{ flag: string; value?: string }> = [
		{ flag: "--inputFile", value: parsed.inputFile },
		{ flag: "--goalStoryFile", value: parsed.goalStoryFile },
		{ flag: "--config-file", value: parsed.configFile },
		...parsed.references.map((value) => ({ flag: "--reference", value })),
		...parsed.extraPrompts.map((value) => ({ flag: "--extra-prompt", value })),
	];

	for (const check of pathChecks) {
		if (check.value != null && check.value != "" && !fs.existsSync(check.value)) {
			return { flag: check.flag, value: check.value };
		}
	}

	return undefined;
}

function validateInvocation(argv: string[]): InvocationResult {
	const parsed = parseArgs(argv);
	if ("exitCode" in parsed) {
		return parsed;
	}

	if (parsed.goal != null && parsed.goal.trim() == "") { return fail("--goal cannot be empty."); }

	const required: Array<{ flag: string; present: boolean; reason: string }> = [
		{ flag: "--goal", present: Boolean(parsed.goal), reason: "it describes what the CLI should do" },
		{ flag: "--target", present: Boolean(parsed.target), reason: "it identifies the test scope" },
		{ flag: "--behave", present: Boolean(parsed.behave), reason: "it selects the execution behavior" },
	];

	const missing = required.find((item) => !item.present);
	if (missing != null) {
		return fail(`${missing.flag} is required because ${missing.reason}.`);
	}

	if (parsed.goalStory != null && parsed.goalStoryFile != null) {
		return fail("--goalStory and --goalStoryFile cannot be used together (exclusive pair conflict).");
	}

	if (parsed.input != null && parsed.inputFile != null) {
		return fail("--input and --inputFile cannot be used together (exclusive pair conflict).");
	}

	if (!VALID_BEHAVIORS.includes(parsed.behave as string)) {
		return fail(
			`--behave value '${parsed.behave}' is not recognized. Supported values: ${VALID_BEHAVIORS.join(", ")}.`
		);
	}

	let warnOut = "";
	if (parsed.input == "") warnOut += "Warning: --input is empty, ignoring.\n";
	for (var ri=0;ri<parsed.references.length;ri++) if (parsed.references[ri]=="") warnOut += "Warning: --reference value "+(ri+1)+" is empty, ignoring.\n";
	for (var ei=0;ei<parsed.extraPrompts.length;ei++) if (parsed.extraPrompts[ei]=="") warnOut += "Warning: --extra-prompt value "+(ei+1)+" is empty, ignoring.\n";

	if (parsed.logLevel != null && VALID_LOG_LEVELS.indexOf(parsed.logLevel) == -1) { return fail("--log-level not recognized. Supported: error, warn, info, debug"); }

	if (parsed.target != null && (parsed.target + "").indexOf("::") >= 0 && ["designAllSkeleton","designFuncTestsSkeleton"].indexOf(parsed.behave as string) >= 0) { return fail("--target TestCase with skeleton behave mismatch -- invalid combination"); }

	const missingPath = firstMissingPath(parsed);
	if (missingPath != null) {
		return fail(`${missingPath.flag} path not found: ${missingPath.value}`);
	}

	return {
		exitCode: 0,
		stderr: warnOut,
		dispatchedBehavior: parsed.behave,
	};
}

module.exports = { validateInvocation };
