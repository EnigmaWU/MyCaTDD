export type SlashCommandResolverModule = never;

declare const module: { exports: Record<string, unknown> };

type ResolvedBehavior = {
	commandNames: string[];
};

type InvocationAssetSession = {
	read(request: {
		kind: "slash-command";
		name: string;
		relativePath: string;
	}): Promise<{ path: string; canonicalPath: string; content: string }>;
};

async function resolveSlashCommands(
	behavior: ResolvedBehavior,
	session: InvocationAssetSession,
) {
	const commands = [];
	for (let index = 0; index < behavior.commandNames.length; index += 1) {
		const name = behavior.commandNames[index];
		const asset = await session.read({
			kind: "slash-command",
			name,
			relativePath: `commands/P0-FuncTestsFlow/${name}`,
		});
		commands.push({
			name,
			...asset,
			flow: "P0",
			order: index + 1,
		});
	}
	return commands;
}

module.exports = { resolveSlashCommands };