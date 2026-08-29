export type CatddPlannerModule = never;

declare const module: { exports: Record<string, unknown> };

type CatddInvocation = {
	goal: string;
	behaviorName: string;
	target: unknown;
};

function planCatddRun(invocation: CatddInvocation) {
	return {
		goal: invocation.goal,
		steps: [
			{
				id: `${invocation.behaviorName}-1`,
				invocation,
				target: invocation.target,
			},
		],
	};
}

module.exports = { planCatddRun };