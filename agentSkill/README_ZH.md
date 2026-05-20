# agentSkill

本目录存放技能源码与生成后的技能包，用于在智能体工作流中复用 CaTDD。

## 在四层模型中的角色

`agentSkill` 是能力封装层。

- 将方法知识封装为可触发技能。
- 定义技能范围、约束、输入与输出。
- 通过参考资料保证执行与 CaTDD 对齐。

## 典型内容

- 技能源码目录（例如 `comment-alive-test-driven-development/`）
- `SKILL.md` 文件（机器可读技能定义）
- 技能本地 `README.md`（人类可读用法）
- `dist/` 下生成的技能包，其中包含复制后的 `references/` 资产与 `slashCommands/`

## 上游 / 下游

- 上游输入：`methodPrompts`（权威方法定义）
- 下游消费方：
  - `utCodeAgentCLI`（智能体执行）
  - 调用特定技能的助手/聊天式工作流

## 维护规则

更新技能行为时，应编辑技能源码，并与 `methodPrompts` 保持一致。`dist/` 下的生成包属于构建输出，不应提交。

## 打包命令

在仓库根目录运行打包脚本：

```bash
bash agentSkill/makeSkill.sh
```

该脚本会在 `agentSkill/dist/comment-alive-test-driven-development/` 生成自包含技能包。生成包会复制 `methodPrompts` 参考资料与 `slashCommands`，因此日常仓库工作中的技能源码目录不会暴露重复的链接路径。

## Usage Example

在仓库根目录生成默认技能包：

```bash
bash agentSkill/makeSkill.sh
```

生成到临时输出目录以便验证：

```bash
bash agentSkill/makeSkill.sh --output /tmp/catdd-agent-skills
```

预期结果：输出目录中包含 `comment-alive-test-driven-development/SKILL.md`、复制后的 `references/` 与复制后的 `slashCommands/`，且不包含符号链接。
