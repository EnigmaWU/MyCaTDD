export type MethodPromptResolverModule = never;

declare const module: { exports: Record<string, unknown> };

type CatddRunPlan = {
	steps: Array<{ invocation: { behaviorName: string } }>;
};

type InvocationAssetSession = {
	read(request: {
		kind: "method-prompt";
		name: string;
		relativePath: string;
	}): Promise<{ path: string; canonicalPath: string; content: string }>;
};

type DelegationEvidenceCollector = {
	record(kind: "prompt-read", assetName: string, assetPath: string): unknown;
};

const PROMPT_NAMES_BY_BEHAVIOR: Record<string, string[]> = {
	designEdgeSkeleton: [
		"CaTDD_methodPrompt4Cat-Edge.md",
		"CaTDD_methodPrompt-testStructure.md",
		"CaTDD_methodPrompt-workflow.md",
	],
};

async function resolveMethodPrompts(
	plan: CatddRunPlan,
	session: InvocationAssetSession,
	evidence: DelegationEvidenceCollector,
) {
	const behaviorName = plan.steps[0]?.invocation.behaviorName;
	const promptNames = PROMPT_NAMES_BY_BEHAVIOR[behaviorName];
	if (promptNames === undefined) {
		throw new Error(`No method-prompt registry exists for behavior: ${behaviorName}`);
	}

	const prompts = [];
	for (let index = 0; index < promptNames.length; index += 1) {
		const name = promptNames[index];
		const asset = await session.read({
			kind: "method-prompt",
			name,
			relativePath: name,
		});
		evidence.record("prompt-read", name, asset.path);
		prompts.push({
			name,
			...asset,
			reason: `required by ${behaviorName}`,
			order: index + 1,
		});
	}
	return prompts;
}

module.exports = { resolveMethodPrompts };