export type AgentRunPlanBuilderModule = never;

declare const module: { exports: Record<string, unknown> };

type ResolvedAsset = {
	name: string;
	path: string;
	content: string;
	order: number;
};

type ResolvedRunStep = {
	id: string;
	invocation: { goal: string; behaviorName: string };
	slashCommand: ResolvedAsset;
	methodPrompts: ResolvedAsset[];
};

type ResolvedRunPlan = {
	goal: string;
	steps: ResolvedRunStep[];
};

function buildAgentRunPlan(plan: ResolvedRunPlan) {
	return {
		goal: plan.goal,
		steps: plan.steps.map((step) => {
			if (step.slashCommand === undefined) {
				throw new Error(`Run step has no instruction asset: ${step.id}`);
			}

			return {
				id: step.id,
				goal: step.invocation.goal,
				instruction: {
					name: step.slashCommand.name,
					path: step.slashCommand.path,
					content: step.slashCommand.content,
					role: "instruction",
				},
				context: [...step.methodPrompts]
					.sort((left, right) => left.order - right.order)
					.map((prompt) => ({
						name: prompt.name,
						path: prompt.path,
						content: prompt.content,
						role: "context",
					})),
				metadata: { behaviorName: step.invocation.behaviorName },
			};
		}),
		requiredTools: [],
		tracePolicy: {},
	};
}

module.exports = { buildAgentRunPlan };