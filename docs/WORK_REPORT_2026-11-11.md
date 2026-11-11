# 《众乐乐桌游 (PARTY TABLETOP)》2026-11-11 研发工作日报

- **汇报日期**：2026 年 11 月 11 日
- **代码仓库**：<https://github.com/Auroragzyx/ZhongLeLeTabletop>（`main` 分支）
- **今日核心目标**：将《日夜飞行棋》从 2D 精灵贴图彻底重构升级为 **Three.js 3D 实时立体桌面引擎 + 经典 17×17 十字交叉棋盘 + 星月湖畔实景界面**，并根据实机试玩反馈完成曝光优化、动态星空底板、踩子爆烟花动画、局内设置及测试骰子开发。

---

## 一、今日已完成开发事项汇总

### 阶段 A：3D 灵禽棋子建模、图 1 十字棋盘与图 5 星湖界面升级（Commit [`ce41b4b`](https://github.com/Auroragzyx/ZhongLeLeTabletop/commit/ce41b4b)）

1. **弃用并清理旧 2D 棋子/样式资源，转向 100% 离线 3D 引擎**
   - 删除 `assets/` 下所有旧 2D 棋子与徽章图片（`piece_blue_owl.png`、`piece_yellow_finch.png`、`piece_purple_raven.png`、`piece_pink_cockatoo.png`、`pieces_reference.png`、`token_*_goal.png`）以及不再使用的 `tailwind.min.js`。
   - 引入本地离线版 Three.js r128 UMD 引擎（`assets/three.min.js`，603,445 bytes）及裁剪净化的星月湖畔风景图（`assets/bg_aero_lake.jpg`，108,129 bytes），保障 `file://` 本地双击零网络依赖稳定启动。

2. **依据参考形象手工构建 4 套 3D 立体棋子与底座（`createBird3DModel`）**
   - 统一搭载带辐射纹理的圆盘底座及外保护环：
     - **1P 蓝羽夜鸮（蓝盘）**：圆润天蓝猫头鹰，带白色大眼盘、高光瞳孔、橘色喙与双侧蓝羽耳冠。
     - **2P 晨曦灵雀（黄盘）**：奶油白腹搭配深蓝黑头盖与后掠羽冠、金黄瞳色及灰紫双翼。
     - **3P 冥夜紫鸦（紫盘）**：深紫绒胸锯齿毛簇、后脑炸毛冠羽、厚实弯钩喙与半睁冷眼。
     - **4P 霞光粉鹦（粉盘）**：浅粉圆身配金粉渐层 4 枚高耸凤冠、月牙笑眼、腮红与紫棕钩喙。
   - **实时 HUD 3D 头像生成（`generateHUDPortraitsFrom3DModels`）**：开局通过离屏 `WebGLRenderer` 对 4 个 3D 模型现场拍照生成 DataURL，填充至左右两侧玻璃 HUD 战绩卡片，完全不依赖额外 2D 图片。

3. **重构经典 17×17 对称十字棋盘（`generateBoardCanvasTexture` / `FACTIONS_CONFIG`）**
   - 外环 52 格四色循环主航道，包含 8 个外斜切角三角格与 4 处内拐角双色三角格。
   - 四角 4 座圆形停机坪（含阵营方向箭头圆圈）、外侧 4 个起飞口小箭头、4 条内侧虚线快捷飞跃航线，以及中央带白色 X 形分隔缝隙的 4 枚 6 步冲刺终点大箭头。
   - 支持 **鼠标左键拖拽 360° 自由旋转 3D 视角**、右上角 **3D 立体 / 正俯视视角切换**（`toggleCameraMode`），以及 **3D 射线拾取点击出战棋子** 与 **抛物线跳跃动画**（`animateHopStep`）。

4. **兼容性与画面调优**
   - 修复 Three.js r128 中误写 `new THREE.CapsuleGeometry` 三目运算符优先级导致的初始化报错。
   - 优化蓝/黄/紫/粉四阵营色彩对比度，将棋盘托边修改为深胡桃木金边，并调整中心箭头尺寸使 6 枚冲刺步点不与边缘重叠。

---

### 阶段 B：试玩体验优化、动态星空底板与踩子烟花特效（Commit [`0db5b4f`](https://github.com/Auroragzyx/ZhongLeLeTabletop/commit/0db5b4f)）

1. **新增局内「⚙️ 设置」按钮（`#btn-ingame-settings`）**
   - 在星湖对局界面右上角导航栏摄像头视角切换与当前回合标签之间新增设置入口，直接复用 [`#modal-settings`](../index.html) 弹窗，玩家在对局途中可免退回大厅实时拖动调整 **画面亮度（60%~140%）**、主音量、圆角/方正风格及主题配色。

2. **棋盘白色过曝优化 → 双层实时「动态星空」底板**
   - **`initStarfieldTexture` / `drawStarfieldFrame`**：创建 1024×1024 动态星空 CanvasTexture，呈现深蓝靛夜空径向渐变、3 团缓慢游动的彩光星云、165 颗闪烁繁星（含 22 颗带十字星芒主星）与间歇划过的流星，以 ~30fps 节流刷新。
   - **透底棋道叠加与控光**：将 `generateBoardCanvasTexture` 背景改为全透明（`clearRect`），使动态星空直接穿透于十字棋道间隙与四角停机坪周围；同时将格子白圈改为柔光缎面珍珠白 `#E2E8F0`，并将白天/黑夜定向光强度调优至 `0.88`，彻底消除纯白底板反光刺眼问题。

3. **踩掉敌方棋子动画 + 两波 3D 爆炸烟花特效**
   - 重构 `checkAndBumpOpponents`、`animateStompCrushAndFlyHome`、`animateBoardImpactJolt` 与 `spawnStompFireworks`：
     1. 进攻方从当前位置腾空扑踩至目标格子正中并落地；
     2. 触发被踩棋子 **扁平压扁定格（`scale 1.55 × 0.20 × 1.55`）**、**棋盘受击震动下沉** 与合成撞击+烟花升空音效（`playSound('firework')`）；
     3. 撞击点同步绽放 **地面扩撒金色冲击光波环** + **44 颗第一波迸溅火花**，并在 **160ms 后于半空 `y = 1.85` 爆开 34 颗高空彩菊 3D 烟花碎片**；
     4. 受击棋子随后恢复体型并在半空旋转摇晃抛飞回自家基地停机坪。

4. **新增可随时删除的「1–6 测试指定点数」面板**
   - 在右侧天命骰子台下方增加 `#test-custom-dice-panel`（`1`~`6` 快捷按钮）与 `testForceRollDice(num)`。
   - HTML 与 JS 均已使用 `<!-- [TEST-ONLY START] ... [TEST-ONLY END] -->` / `// [TEST-ONLY START] ... // [TEST-ONLY END]` 注释隔离，正式测试完毕后可整块安全移除。

---

## 二、测试与实机验证记录

今日所有提交均在本地通过 **无头 Chrome（SwiftShader WebGL 模式，1440×900）** 实测与截图目视核对：

| 验证项目 | 验证方式 | 实测结果 |
| :--- | :--- | :--- |
| 静态 HTML/JS 完整性 | 检查全部 `getElementById` 与内联 `on*` 事件函数 | 静态缺失 DOM ID `0` 个，缺失处理函数 `0` 个 |
| 菜单建房向导到进入 3D 对局 | E2E 脚本模拟设置切换、3 步向导、`launchFlightChessGame()` | `birdsTotal: 16`、`portraitsReady: true`、`errs: []` |
| 局内设置弹窗与亮度调节 | 对局界面触发 `openModal('modal-settings')` + `setBrightness(90)` | 弹窗正常覆盖显示，滤镜实时生效且无报错 |
| 动态星空与 3D 场景渲染 | Headless WebGL 截图检查（昼夜灯光、星空、流星、星云） | 棋盘透明层与星空底板无 Z-fighting 闪烁，曝光消除 |
| 蓝色踩爆粉色与烟花链路 | 置 35 格粉色与 32 格蓝色，调用 `testForceRollDice(3)` | `bluePos: 35`，`pinkState: "home"`，`spawnStompFireworks` 触发 1 次（当波创建 46 个对象），`errs: []` |

---

## 三、当前仓库关键文件一览

- `index.html`（153,990 bytes / 3,239 lines）：主选单大厅、自定义房规向导、系统设置与《日夜飞行棋》3D 游戏主引擎
- `assets/three.min.js`（603,445 bytes）：离线 Three.js r128 WebGL 引擎
- `assets/bg_aero_lake.jpg`（108,129 bytes）：星月湖畔对局界面实景背景
- `启动游戏.bat`（1,063 bytes）：Windows 本地独立应用模式启动器（Edge/Chrome `--app`）
- `一键同步到GitHub.bat`（1,794 bytes）：一键推送本地变更至 GitHub 仓库脚本
- `docs/WORK_REPORT_2026-11-11.md`：本研发工作日报

---

## 四、后续待办计划建议

1. 使用骰子下方的 `1–6` 测试面板充分实测跨盘虚线捷径、同色连跳+踩子组合、6 步冲刺终点折返与昼夜奖惩规则；
2. 确认《日夜飞行棋》验收无误后，整块移除 `[TEST-ONLY]` 测试骰子面板；
3. 按预设合集路线推进下一模式研发：**《机械大富翁 (Gear Tycoon)》** 或 **《星轨五子棋 (Astral Gomoku)》**，以及后续 PC/Steamworks 打包（Electron/Tauri + Steam API）。
