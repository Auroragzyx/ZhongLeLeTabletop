# 研发工作日报（2026-11-12）

- **项目仓库**：[Auroragzyx/ZhongLeLeTabletop](https://github.com/Auroragzyx/ZhongLeLeTabletop)（分支 `main`）
- **报告日期**：2026 年 11 月 12 日
- **当日代码增量**：`index.html` 增至 `275,197` 字节（`5,777` 行），新增宇宙星云背景 `assets/bg_gomoku_cosmos.jpg`，累计完成 3 个里程碑阶段

---

## 一、今日已完成研发内容

### 阶段 A：第二款实机 3D 棋类、开房分流、统一结算与测试作弊系统（Commit `4fa5e46`）

1. **新增第二款实机 3D 游戏：《星轨五子棋 3D (Astral Gomoku)》（`window.GomokuApp`）**
   - **占星棋盘与宇宙氛围**：`createAstrolabeBoardTexture()` 实时绘制 `2048×2048` 深空占星棋盘纹理，包含 `15×15` 星轨网格、`A–O / 15–1` 天文坐标标注、五大星位符文、旋转外环（`astrolabeRing`）与 180 颗浮动星尘粒子。
   - **双阵营 3D 棋子与落子反馈**：`虚空黑子`（紫能量环）与 `耀斑恒星`（金能量环）均采用扁球主石 + `TorusGeometry` 环带建模（`SphereGeometry(0.28)` + `TorusGeometry(0.275)`），支持落子弹跳、扩散波纹、光标幽灵预览、最后落子高亮环以及顶面步数标号切换（`toggleMoveNumbers`）。
   - **规则玩法与 AI 对弈系统**：
     - 支持 `星轨共鸣`（3+/4+ 连子点亮紫/金连接光束，`scanResonanceSegments`）与经典模式切换；
     - 5 连胜出自动触发多波 3D 星空烟花庆典（复用公共 `spawnFireworksInto` / `updateFireworkBursts`）；
     - 内置左键拖拽 3D 旋转与 `toggleCamera()` 正交俯视切换、双退悔棋（`undoMove`）、`星象推演` 最佳一手推荐（`showHint`）、`换先`（`swapAndRestart`）及 3 档难度 AI（`星尘学徒` easy / `星图弈士` medium / `观星宗师` hard 棋型评估与 10 候选 2-ply 前瞻）。
2. **大厅建房向导多模式分流（`onWizardModeChange` / `wizardNext`）**
   - 建房向导根据所选游戏准确分流：选择 `aero` 进入《日夜飞行棋 3D》，选择 `gomoku` 进入 `#view-game-gomoku`，选择研发中的 `tycoon`（《机械大亨》）则停留在第 3 步并给出提示，避免误进飞行棋。
3. **统一胜利结算弹窗与《日夜飞行棋 3D》规则/AI 打磨**
   - 新增统一结算弹窗 `#modal-victory`（`showVictoryModal` / `handleVictoryMenu` / `handleVictoryRematch`），取代原生 `alert(...)`。
   - 新增智能 AI 选子启发式函数 `pickBestAeroAIMove`，综合评估踩子（+300/+280）、终点加冕（+260）、跑道推进（+180）、虚线捷径（+130）、同色连跳（+95）与起飞出库（+85）。
   - 修复 `active -> runway` 终点超步反弹时的 `runDir` 折返逻辑；等待选子期间按 `Space` 可触发 `autoPickMove()`。
   - 在 `[TEST-ONLY]` 区域 1–6 测试骰子面板下方新增 `#btn-test-win`（`testForceVictory()`）一键直接胜利测试按钮，便于快速校验结算流程（保留 `[TEST-ONLY]` 标记以便测试完成后随时移除）。

### 阶段 B：飞行棋观众席、15 秒全员结束投票、1~4 名榜与 AI 接管底座（Commit `eb0dfb7`）

1. **完赛进【观众席】观战系统（`#aero-spectator-box`）**
   - 单名玩家 4 枚棋子全部抵达终点后，通过 `handleAeroPlayerFinished()` 计入 `finishedOrder`，玩家卡片与棋盘实时显示 `(🥇第1名·观众席)` 等名次徽章。
   - 1P 完赛后锁定本人掷骰并切入【观众席】，新增 `toggleSpectatorSpeed()` 支持 `1x / 4x` 观战倍速切换；`endTurn()` 自动跳过已完赛玩家并推进轮换计数，直到所有 4 位玩家全部完赛，最后调用 `showAeroFinalLeaderboard()` 在 `#modal-victory` 展示 `🥇第1名 ~ 🏅第4名` 完整领奖台排行榜。
2. **首位胜者触发【15 秒全员结束对局投票弹窗】（`#modal-endgame-vote`）**
   - 当本局出现首位完赛玩家时，触发 `openEndgameVoteModal()` 弹出投票窗并启动 15 秒实时进度条倒计时；15 秒到期自动关闭弹窗（亦支持点击 `✕` 调用 `closeEndgameVoteModal` 手动关闭），默认留在观众席继续观战。
   - 支持点击 `投：结束对局` / `投：不结束`（`castEndgameVote`），累计投「结束」满 3 票时立刻终止当前对局并按完赛顺序与剩余棋子进度结算 1~4 名总榜。
   - 在 `[TEST-ONLY]` 投票窗内附带单机测试辅助按钮 `testSimulateThreeEndVotes()`，用于无联机环境下直接模拟 3 票结束流程。
3. **席位控制权解耦与 AI 接管底层架构（`seatControllers`）**
   - 落地时机判断：由于席位控制状态机属于核心回合推进基础设施，提前与观众席/AI 轮转合并实现，比联机阶段再大改 `endTurn()` 更平滑。
   - 已实现通用席位控制层：`seatControllers`、`isHumanActiveTurn(color)`、`hasSeatFinished(color)` 与 `setSeatAITakeover(color, active)`，将原有写死的 `'blue'` 判断彻底替换为通用席位状态机；单机调用或后续联机心跳断线时即可显示 `(🤖 AI接管)` 并代打，联机阶段只需挂载 WebSocket/WebRTC 断线与重连回调。

### 阶段 C：飞行棋去作弊与开局摇骰定序、五子棋宇宙舞台/日月双星环/悔棋规则体系完善

1. **今日新增内容**：
   - **飞行棋开局摇骰定先手（`#modal-aero-opening-roll`）**：开局及「再来一局」新增四方开局掷骰阶段（`startOpeningRollPhase` / `evaluateOpeningRolls`），按点数大小降序锁定出手顺序，同点自动加赛重掷，并在玩家卡片显示 `[第1先手] ~ [第4顺位]` 徽章。
   - **五子棋 6 秒悔棋等待窗与次数规则（`#sel-gomoku-undo-limit`）**：建房向导第 3 步新增「关闭悔棋 / 允许 1~3 次」配置；落子后触发 6 秒悔棋等待进度条（`#gomoku-undo-wait-bar`）及 `⏭️ 确认落子 (跳过等待)` 快捷按钮，按钮实时显示剩余次数。
   - **五子棋对手悔棋裁决弹窗（`#modal-gomoku-undo-consent`）**：构建 10 秒倒计时「是否同意敌方悔棋？（同意 / 不同意）」弹窗与 `GomokuApp.receiveOpponentUndoRequest()` 接入点，供后续真人联机或对手申请时裁决。
   - **新资源文件**：引入 `assets/bg_gomoku_cosmos.jpg`（宇宙行星星云全景图）。
2. **今日修改内容**：
   - **移除飞行棋作弊控件**：彻底删除 `#test-custom-dice-panel`（1–6 指定点数骰子按钮、`testForceRollDice`）与 `#btn-test-win`（一键直接胜利、`testForceVictory`），并精简 `executeDiceRoll()` 为纯粹随机掷骰。
   - **重构五子棋双星环与日月图标**：将 `astrolabeRing` 拆分为 `yellowRingGroup`（黄圈 + 太阳图标，顺时针公转）与 `purpleRingGroup`（紫圈 + 月亮图标，逆时针公转），移除水平悬浮底座，将太阳与月亮定位到 `y = 0` 并加装两侧串珠扣环，实现「直接串在星环上」的立体效果。
   - **更换五子棋对局背景**：将 `#gomoku-scenic-bg.astral-atmosphere` 由湖畔贴图切换为 `assets/bg_gomoku_cosmos.jpg`。
3. **今日完善内容**：
   - **开局摇骰结果停留时长**：将定序完成后的自动开局等待由 2.2 秒延长至 **8 秒实时倒计时**，确保玩家看清四方点数与顺位（仍支持随时点击或按 `Space` 提前开局）。
   - **人机悔棋交互合理化**：区分人机与真人对手逻辑——AI 对局申请悔棋时由 `requestUndoFromAI()` 自动回应并在额度内同意撤回，消除「自己发起又自己点同意」的违和弹窗；当悔棋关闭或次数耗尽（`0/X`）时自动跳过 6 秒等待，保持对局节奏流畅。

---

## 二、实机验证记录（2026-11-12）

通过静态 DOM / 内联回调完整性检查 + Chrome Headless（SwiftShader WebGL，`1350×760`）端到端测试验证，汇总如下：

| 验证项 | 验证手段 | 验证结果 |
| :--- | :--- | :--- |
| DOM ID / 内联事件 / 资源静态核查 | 脚本扫描 `#view-game-*` / 弹窗节点、`onclick` 引用、作弊标记与 `assets/*` | 作弊残留 `[]`、缺失 ID `[]`、缺失回调 `[]`、缺失资源 `[]` |
| 飞行棋：直接胜利作弊 & 15s 投票弹窗 | 点击 `#btn-test-win` 校验 `#modal-endgame-vote` 与 `#aero-spectator-box` | 正常弹出投票窗与观众席面板（`True \| spec= True`） |
| 飞行棋：去作弊 & 开局摇骰 8s 停留 | 启动飞行棋校验作弊面板已移除、开局摇骰定序（含同点加赛）及 8 秒停留 | `cheatPanelGone: True`、`phase: 'done'`、`autoSecondsLeft: 8`（3.2s 后仍停留） |
| 飞行棋：4 位玩家全部完赛总榜 | 推进至 4 名玩家全部完赛后校验 `#modal-victory` | 正确展示 `第 1 名 ~ 第 4 名` 完整排行榜（`True`） |
| 飞行棋：3 票提前结束 & AI 接管 | Rematch 后测试 `setSeatAITakeover('blue', true)` 与 `testSimulateThreeEndVotes()` | `全场投「结束」满 3 票，提前结算最终排行榜！`（`True`） |
| 《星轨五子棋 3D》宇宙背景与日月双环 | 校验 `bg_gomoku_cosmos.jpg` 加载与太阳黄圈顺时针/月亮紫圈逆时针串环渲染 | 画面清晰居中，太阳/月亮串接在双环上无遮挡 |
| 《星轨五子棋 3D》6s 悔棋窗、次数限制与裁决弹窗 | 验证 `允许 1 次` / `关闭 (0)`、AI 自动同意扣次、耗尽跳过等待与 `receiveOpponentUndoRequest()` | 全流程状态流转与 10 秒裁决弹窗正常 |
| 全量浏览器控制台与运行时稳定性 | 全程监听 Chrome `console.error` / `pageerror` | `ALL E2E CHECKS PASSED WITH 0 JS ERRORS!` |

---

## 三、仓库核心文件一览

- `index.html`：桌游合集单页主程序（`275,197` 字节 / `5,777` 行），承载大厅、建房向导、《日夜飞行棋 3D》与《星轨五子棋 3D》引擎、观众席与投票结算模块
- `启动游戏.bat`：Windows 本地独立窗口（`--app`）快捷启动脚本
- `assets/three.min.js`、`assets/bg_aero_lake.jpg`、`assets/bg_gomoku_cosmos.jpg`：离线 `Three.js` 引擎库、飞行棋星月湖畔舞台贴图与五子棋宇宙行星星云背景图
- `docs/WORK_REPORT_2026-11-11.md`、`docs/WORK_REPORT_2026-11-12.md`：每日研发工作报告归档
- `README.md`：项目主说明与当前已实现模式索引

---

## 四、下一步开发计划建议

1. **局域网 / 多人联机通信层与真人协议打通（优先推荐）**：
   - 将房间大厅现有的「局域网 / 多人联机」向导与 WebSocket / WebRTC 信令打通，把飞行棋 `seatControllers` 断线 AI 接管、15 秒投票同步，以及五子棋 `receiveOpponentUndoRequest()`（10 秒是否同意悔棋弹窗）接入真实对手客户端消息。
   - 同步清理 `#modal-endgame-vote` 内仅用于单机测试的 `[TEST-ONLY]` `testSimulateThreeEndVotes()` 按钮。
2. **模式三《机械大亨 (Gear Tycoon)》原型立项**：
   - 设计蒸汽齿轮工坊 3D 环形棋盘、地格升级、齿轮资源与命运卡牌体系，替换建房向导中的筹备预告面板并正式接入开房分流。
3. **对局体验与 Steam 客户端化打磨**：
   - 补充飞行棋/五子棋局内规则速览浮窗、音频静音快捷键与本地战绩/胜率统计持久化（`localStorage`），为后续 Electron / Steamworks 打包做准备。
