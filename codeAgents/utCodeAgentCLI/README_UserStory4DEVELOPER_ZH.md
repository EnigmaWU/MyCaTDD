# utCodeAgentCLI 需求 —— DEVELOPER

> 主索引、状态模型与快速参考 AC 清单：[README_UserStory_ZH.md](README_UserStory_ZH.md)

**作为** DEVELOPER："我构建、测试和扩展 CLI。我需要清晰的契约、诊断能力和 adapter 边界。"

---

### US-DEV-01 [P0] — 所有失败状态都有可操作的错误信息

**作为** DEVELOPER，**我希望** 每条错误信息都指明问题、标识受影响的参数并建议纠正方法，**以便** 无需阅读 CLI 源码即可调试调用问题。

#### AC-01：无法识别的参数值给出纠正建议
- **Given** CLI 调用使用 `--behave "deisgnAllSkeleton"`（拼写错误）
- **When** 验证失败
- **Then** stderr 包含 `"deisgnAllSkeleton"` 未被识别
- **And** stderr 包含建议：`"您是否想输入 'designAllSkeleton'？"`（最佳匹配）
- **And** stderr 包含完整有效值列表

#### AC-02：文件缺失错误包含精确路径
- **Given** `--inputFile nonexistent/path.h`
- **When** 验证失败
- **Then** stderr 包含完整解析路径 `nonexistent/path.h`
- **And** stderr 指明参数名称（`--inputFile`）

#### AC-03：Target/behavior 不匹配时解释原因并建议替代方案
- **Given** `--target tests/auth_test.cpp::TC-03 --behave designAllSkeleton`
- **When** 验证检测到不匹配
- **Then** stderr 解释：skeleton 设计需要文件级 `--target`，而非 TC 级 target
- **And** stderr 建议 skeleton 设计有效的 `--target` 形式，或 TC 级 target 有效的 `--behave` 值

---

### US-DEV-02 [P1] — 可配置的日志与诊断输出

**作为** DEVELOPER，**我希望** `--log-level` 控制输出详细程度，**以便** 生产环境静默运行，调试时详细输出。

#### AC-01：--log-level error 抑制非错误输出
- **Given** 任意带 `--log-level error` 的有效调用
- **When** CLI 成功执行
- **Then** stderr 仅出现 error 级别消息
- **And** stdout 不受影响（行为输出仍然正常）

#### AC-02：--log-level debug 揭示内部分辨过程
- **Given** 任意带 `--log-level debug` 的有效调用
- **When** CLI 执行
- **Then** stderr 包含状态转换：参数解析、behavior 解析、slash-command 选择、文件写入

---

### US-DEV-03 [P1] — 交互式逐命令确认

**作为** DEVELOPER，**我希望** 在每个 slash command 执行前预览它，**以便** 可以在多 step 调用中批准、跳过或中止，避免盲执行。

#### AC-01：每个 slash command 执行前提示确认
- **Given** 带 `--interactive-slash-commands` 的 `designAndImplTest` 调用
- **When** CLI 解析出一个 slash command（如 `UT_designFuncTestsSkeleton`）
- **Then** stdout 提示："在 tests/auth_api_test.cpp 上执行 UT_designFuncTestsSkeleton？[y/n/s(kip)/a(bort)]"
- **And** CLI 等待用户输入后才继续

#### AC-02：中止停止所有后续执行
- **Given** 一个交互式会话有多个待执行 slash command
- **When** 用户在任意提示输入 "a"（中止）
- **Then** 不再执行任何后续 slash command
- **And** CLI 以退出码 1 退出
- **And** trace 记录哪些命令被跳过

---

### US-DEV-04 [P2] — 运行时 adapter 接口

**作为** DEVELOPER，**我希望** CLI 的 slash-command 执行后端可通过文档化的 adapter 接口替换，**以便** `utCodeAgentCLI` 可在 Copilot-native、OpenCode 或自定义 agent runtime 上运行，无需重写 CLI 核心。

#### AC-01：Adapter 符合定义的接口
- **Given** 一个实现了 `CliRuntimeAdapter` 接口的 runtime adapter
- **When** CLI 需要调用 slash command
- **Then** 它调用 adapter 的 `invoke(slashCommand, context)` 方法
- **And** adapter 接收已解析的命令路径、target、source 和 goal 上下文
- **And** CLI 不假定任何特定 runtime（TypeScript、Python、shell）

#### AC-02：提供默认 adapter
- **Given** 未配置自定义 adapter
- **When** CLI 运行
- **Then** 内置默认 adapter 直接执行 slash command

---

### US-DEV-05 [P1] — 以确定性方式执行 ASR 可靠性与安全策略

**作为** DEVELOPER，**我希望** ASR 派生的可靠性与安全策略在 CLI 运行时可执行、可验证，**以便** 架构契约成为最终交付行为而不仅是静态文档。

#### AC-01：重试/修正预算耗尽后的行为必须确定（ASR-R1）
- **Given** 某 step 持续出现可重试的瞬时错误
- **When** 重试与修正预算耗尽
- **Then** CLI 停止对该 step 的进一步重试
- **And** trace 记录预算耗尽与升级结果

#### AC-02：未知 `--behave` 走 diagnostics fallback 并明确退出（ASR-R2）
- **Given** `--behave` 未知或不受支持
- **When** 行为解析执行
- **Then** CLI 不得静默容错或自动改写行为
- **And** 输出受支持行为列表并以参数错误码退出

#### AC-03：失败分类路由明确且可测试（ASR-R3）
- **Given** 一个瞬时错误场景与一个永久错误场景
- **When** 执行流程处理两类错误
- **Then** 瞬时错误走可重试路由
- **And** 永久错误跳过重试并快速失败且输出诊断

#### AC-04：强制 step 级回滚或补偿边界（ASR-R4）
- **Given** 多步骤运行在至少一个 step 完成后失败
- **When** 失败处理执行
- **Then** CLI 保持最后一致的 step 边界
- **And** 阻断后续会修改状态的步骤，并写入补偿式 failure trace 细节

#### AC-05：非交互升级在 CI 中确定且可预期（ASR-R5）
- **Given** 非交互模式且满足升级触发条件
- **When** 控制逻辑评估升级
- **Then** CLI 强制中止并返回非零退出码
- **And** trace 包含明确的非交互升级标记

#### AC-06：执行 shell 安全与敏感路径保护（ASR-R6）
- **Given** 命令执行尝试同时涉及允许路径与敏感路径
- **When** 执行与 trace 持久化运行
- **Then** 仅允许 allowlist 中的执行面
- **And** 敏感路径默认拒绝，除非策略显式放行
- **And** 持久化 trace 中对 token-like secrets 执行脱敏
