# agentSkills 用户指南

面向将 CaTDD 与 SpecCoding 打包为可复用 agent skills 的开发者与 CodeAgent 的实践指南。

关于这一层 WHAT 是什么、WHY 为什么存在，请阅读 [README.md](README.md)。本指南聚焦 HOW 如何打包 skill、WHO 谁使用、WHEN 何时生成包，以及 WHERE 输出位于哪里。

## 使用者

如果你属于以下角色，请使用本指南：

- 编辑 CaTDD 或 SpecCoding 技能源码的维护者。
- 想为其他 agent 环境准备自包含技能包的开发者。
- 需要打包版 CaTDD 参考资料和命令流程的 CodeAgent。
- 验证生成包不包含源码树符号链接的工具作者。

## 内容

`agentSkills/` 将 CaTDD 与 SpecCoding 技能源码转化为自包含生成包。

生成包包含：

- 来自 authored `SKILL.md` 文件的技能元数据与行为。
- 人类可读的技能本地 README 内容。
- 从 `methodPrompts/` 复制的方法参考资料。
- 从 `slashCommands/` 复制的可移植命令流程。
- 不包含符号链接，也不依赖只存在于源码树中的路径。

## 使用时机

在以下情况生成或验证 agent skill package：

- 修改了技能源码行为。
- 修改了技能使用的 `methodPrompts` 参考资料。
- 修改了应随技能分发的 `slashCommands` 内容。
- 想将 CaTDD 或 user-story-centered SpecCoding 作为可复用 CodeAgent capability 分发。
- 发布或复制前需要确认生成包是自包含的。

不要把生成的 `agentSkills/dist/` 内容当作真理源来编辑。应从源码重新生成。

## 位置

技能源码位于：

```text
agentSkills/
  README.md
  README_ZH.md
  README_UserGuide.md
  README_UserGuide_ZH.md
  makeSkill.sh
  comment-alive-test-driven-development/
    SKILL.md
    README.md
  user-story-centered-spec-coding/
    SKILL.md
    README.md
```

默认生成输出位于：

```text
agentSkills/dist/comment-alive-test-driven-development/
  SKILL.md
  README.md
  references/
  slashCommands/
agentSkills/dist/user-story-centered-spec-coding/
  SKILL.md
  README.md
  references/
  slashCommands/
```

也可以通过 `--output` 将临时验证输出写到任意位置。

## 原因

技能包让 CodeAgent 获得紧凑、可复用的 CaTDD 与 SpecCoding capability，同时避免技能源码树暴露重复链接路径或不完整参考资料。

这样既保持日常仓库编辑清爽，又能生成包含方法指南、方法提示词、实现模板和斜杠命令流程的可分发产物。

## 方法

打包 skill 时，按以下流程执行。

1. 编辑对应 `agentSkills/<skill-name>/` 目录下的技能源码。
2. 将方法资产保留在 `methodPrompts/`，将命令资产保留在 `slashCommands/`。
3. 在仓库根目录运行 `bash agentSkills/makeSkill.sh` 或 `bash agentSkills/makeSkill.sh <skill-name>`。
4. 检查 `agentSkills/dist/` 或临时输出路径中的生成包。
5. 运行 `bash scripts/test_makeSkill.sh`，确认必需文件存在且没有符号链接。
6. 提交 authored source、打包脚本变更和测试。不要提交被忽略的生成输出。

## Usage Example

在仓库根目录运行以下命令，将默认 CaTDD 技能包生成到临时输出目录并验证关键文件：

```bash
OUT_ROOT="$(mktemp -d)"
bash agentSkills/makeSkill.sh --output "$OUT_ROOT"
test -f "$OUT_ROOT/comment-alive-test-driven-development/SKILL.md"
test -f "$OUT_ROOT/comment-alive-test-driven-development/references/README_UserGuide.md"
test -f "$OUT_ROOT/comment-alive-test-driven-development/slashCommands/README_UserGuide.md"
find "$OUT_ROOT/comment-alive-test-driven-development" -type l | wc -l
echo "$OUT_ROOT"
```

生成 user-story-centered SpecCoding 技能包：

```bash
OUT_ROOT="$(mktemp -d)"
bash agentSkills/makeSkill.sh user-story-centered-spec-coding --output "$OUT_ROOT"
test -f "$OUT_ROOT/user-story-centered-spec-coding/SKILL.md"
test -f "$OUT_ROOT/user-story-centered-spec-coding/slashCommands/flows/Px-SpecFlow.md"
test -f "$OUT_ROOT/user-story-centered-spec-coding/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md"
find "$OUT_ROOT/user-story-centered-spec-coding" -type l | wc -l
echo "$OUT_ROOT"
```

预期结果：

- `test` 命令成功退出。
- 符号链接数量输出 `0`。
- 输出的临时路径包含所选 skill 的自包含技能包。

## Supported Skills

| Skill | Package command | Purpose |
| --- | --- | --- |
| `comment-alive-test-driven-development` | `bash agentSkills/makeSkill.sh` | 将 CaTDD 打包为可复用验证与测试方法论技能。 |
| `user-story-centered-spec-coding` | `bash agentSkills/makeSkill.sh user-story-centered-spec-coding` | 打包以 user story 为中心的 SpecCoding 生命周期技能。 |

## 打包输出

每个生成包包含：

| Path | Purpose |
| --- | --- |
| `SKILL.md` | 机器可读的技能行为和触发说明。 |
| `README.md` | 人类可读的技能本地使用文档。 |
| `references/README_UserGuide.md` | 从 `methodPrompts/` 复制的 CaTDD 独立方法用户指南。 |
| `references/README_UserGuide_ZH.md` | 从 `methodPrompts/` 复制的中文 CaTDD 独立方法用户指南。 |
| `references/CaTDD_methodPrompt.md` | 从 `methodPrompts/` 复制的权威 CaTDD 方法契约。 |
| `references/CaTDD_ImplTemplate.cxx` | 从 `methodPrompts/` 复制的完整 CaTDD 测试文件模板。 |
| `slashCommands/` | 从 `slashCommands/` 复制的可移植命令流程和用户指南。 |

## 源码与生成包

区别对待这些路径：

| Path | Treat as |
| --- | --- |
| `agentSkills/comment-alive-test-driven-development/` | 技能源码。可以编辑并提交。 |
| `agentSkills/user-story-centered-spec-coding/` | 技能源码。可以编辑并提交。 |
| `agentSkills/makeSkill.sh` | 打包逻辑。打包规则变化时可以编辑并提交。 |
| `agentSkills/dist/` | 生成输出。在本源仓库中本地重建并保持忽略。 |

## 质量检查清单

在声明 agent skill 打包变更完成之前，检查：

- 生成包不包含符号链接。
- 打包参考资料来自 `methodPrompts/`，不是过时演示或重复文件。
- 打包后的 `slashCommands/` 包含可移植命令源和用户指南。
- 技能源码不暴露链接形式的 `references/` 或 `slashCommands/` 路径。
- `bash scripts/test_makeSkill.sh` 通过。
- README 镜像检查和文档契约测试通过。

## 下一步

理解方法含义时，阅读 `methodPrompts/README_UserGuide.md`。

执行命令流程时，阅读 `slashCommands/README_UserGuide.md`。

处理本层打包时，在提交前运行 `bash scripts/test_makeSkill.sh`。
