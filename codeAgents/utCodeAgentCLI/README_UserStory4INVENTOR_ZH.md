# utCodeAgentCLI 需求 —— INVENTOR

> 主索引、状态模型与快速参考 AC 清单：[README_UserStory_ZH.md](README_UserStory_ZH.md)

**作为** INVENTOR："我定义了 CaTDD。CLI 必须编排我的方法 —— 绝不破坏、内联或绕过它。"

---

### US-INVENTOR-01 [P0] — 将所有 CaTDD 语义委托给 methodPrompts

**作为** INVENTOR，**我希望** CLI 不拥有任何 CaTDD 方法知识，**以便** 我可以演进 category、discipline 规则和 prompt 契约，而无需触碰或重新发布 CLI。

> US-INVENTOR-01（设计委托）与 US-INVENTOR-03（诊断可见性）构成一对：I01 是架构保证；I03 是委托确实发生的运行时证明。

#### AC-01：Category 定义绝不硬编码在 CLI 中
- **Given** CLI 需要生成一个 Edge 类别的 TC skeleton
- **When** 它解析 Edge category 的含义
- **Then** 它从 `methodPrompts/` 下的文件读取 —— 绝不从 CLI 源码中的硬编码字符串、枚举或模板读取
- **And** 如果所需的 methodPrompt 文件缺失或不可读，CLI 退出并报错，指明缺失的文件

#### AC-02：Slash-command 行为委托给 slashCommands
- **Given** CLI 解析 `--behave designFuncTestsSkeleton`
- **When** 它执行该行为
- **Then** 它调用 `slashCommands/commands/` 下对应的可移植命令
- **And** 不内联或复制该命令的逻辑

#### AC-03：输出中所有 CaTDD 工件均由委托层生成
- **Given** 任何会修改测试文件的 CLI 调用
- **When** 输出中出现 CaTDD 特定内容（`@[US]`、`@[AC]`、`@[TC]`、`@[Category]`、`@[Status]`）
- **Then** 该内容由 methodPrompt 或 slashCommand 生成 —— 绝不由 CLI 自身从硬编码字符串或模板生成

---

### US-INVENTOR-02 [P0] — 生成机器可读的执行 trace

**作为** INVENTOR，**我希望** 每次 CLI 运行留下结构化 trace，**以便** 我可以审计方法合规性、重放调用、检测意图与执行结果之间的偏差。

#### AC-01：成功执行时写入 trace
- **Given** 一个有效的 CLI 调用成功完成
- **When** CLI 退出
- **Then** 在可发现位置存在 trace 工件
- **And** trace 包含：时间戳、完整调用字符串、解析后的参数、解析后的 slash 命令（含文件路径）、已修改的文件、受影响的 TC-ID 及其前后 status、退出码和执行时长

#### AC-02：执行失败时也写入 trace
- **Given** 一个有效的 CLI 调用在执行期间（非参数解析期间）失败
- **When** CLI 以退出码 1 退出
- **Then** trace 工件依然存在
- **And** 它记录失败点：哪个 step 正在执行、错误信息、以及失败前已完成哪些 step

#### AC-03：Trace 格式可被机器解析
- **Given** CLI 写入的任何 trace 工件
- **When** 被标准 JSON 或 YAML 解析器解析
- **Then** 解析成功，所有字段符合文档化的 schema

---

### US-INVENTOR-03 [P1] — 方法解析过程的可诊断可见性

**作为** INVENTOR，**我希望** `--diagMethodPrompts` 和 `--diagSlashCommands` 能揭示 CLI 解析了哪些具体 prompt 和命令，**以便** 我可以验证 CLI 没有替换、跳过或绕过任何 CaTDD 资产。

#### AC-01：--diagMethodPrompts 记录已解析的 prompt
- **Given** 任意带 `--diagMethodPrompts` 的有效 CLI 调用
- **When** CLI 在执行期间解析 method prompt
- **Then** stderr（或诊断日志流）列出每个已解析的 prompt 文件路径及对应的 CaTDD category 或规则

#### AC-02：--diagSlashCommands 记录已解析的命令
- **Given** 带 `--behave designFuncTestsSkeleton` 和 `--diagSlashCommands` 的调用
- **When** CLI 将 behavior 解析为一个或多个 slash command
- **Then** 诊断输出按解析顺序列出每个 slash command 名称和文件路径
