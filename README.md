# Claude Code Source

**作者：Tencent AI pkushinnxu** ｜ [English](./README_en.md) ｜ 简体中文

> 基于 Claude Code v2.1.88 源码的二次开发版本，接入豆包（Doubao）大模型 API，无需 Anthropic 账号即可使用。

---

## 功能特性

- ✅ 完整还原 Claude Code 2.1.88 全部源码（4756 个文件）
- ✅ 接入火山引擎豆包 Doubao-Seed-Code 编程专用模型
- ✅ 支持交互式对话、文件读写、代码执行、Git 操作等全部工具
- ✅ 无需 Anthropic 账号，使用国内豆包 API 即可运行
- ✅ 已修复 macOS Keychain 导致的进程挂起问题

---

## 目录结构

```
claude-code1/
├── README.md                  # 本文件（中文）
├── README_en.md               # English README
├── claude-code-source/        # 还原后的完整源码
│   ├── src/                   # TypeScript 源码（1902 文件）
│   ├── vendor/                # 内部 vendor 模块
│   ├── stubs/                 # 私有包存根
│   ├── build.ts               # Bun 构建脚本
│   ├── package.json           # 项目配置
│   ├── tsconfig.json          # TypeScript 配置
│   ├── dist/                  # 构建产出（bun run build.ts 后生成）
│   │   └── cli.js             # 可执行文件（22MB）
│   └── start-doubao.sh        # 一键启动脚本（豆包 API）
└── ai-cloud-code-2188.tgz     # 原始 npm 包
```

---

## 快速开始

### 前置要求

| 工具 | 版本 | 安装方式 |
|------|------|----------|
| macOS | 12+ | — |
| Bun | 1.3.11 | `curl -fsSL https://bun.sh/install \| bash` |
| pnpm | 10+ | `curl -fsSL https://get.pnpm.io/install.sh \| sh -` |
| 豆包 API Key | — | 见下方申请教程 |

### 第一步：安装构建工具

```bash
# 安装 Bun（macOS Apple Silicon）
curl -fsSL https://bun.sh/install | bash
source ~/.zshrc

# 安装 pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -
source ~/.zshrc

# 验证
bun --version   # 应显示 1.3.11
pnpm --version  # 应显示 10.x.x
```

### 第二步：安装依赖并构建

```bash
cd ~/Desktop/claude-code1/claude-code-source

# 安装依赖（约 489 个包，5 秒）
pnpm install --registry https://registry.npmjs.org

# 构建（约 1 秒，产出 dist/cli.js 22MB）
bun run build.ts

# 验证构建结果
bun dist/cli.js --version
# 输出：2.1.88 (Tencent AI Code by pkushinnxu)
```

---

## 接入豆包 API 详细流程

### 第一步：注册火山引擎账号

1. 访问 [火山引擎官网](https://www.volcengine.com/) 注册账号
2. 完成实名认证

### 第二步：开通方舟（Ark）服务

1. 登录后访问 [方舟控制台](https://console.volcengine.com/ark)
2. 首次进入需要开通服务，点击「立即开通」

### 第三步：创建 API Key

1. 进入方舟控制台 → 左侧菜单「API Key 管理」
2. 点击「创建 API Key」
3. 填写名称（如 `claude-code`），点击确定
4. **复制并保存** API Key（格式类似：`3d1f5117-39d7-4b84-9feb-66d8aff8b4dc`）

   > ⚠️ API Key 只显示一次，请务必保存！

### 第四步：开通模型服务

1. 进入方舟控制台 → 左侧菜单「模型广场」或直接访问：
   [模型开通页面](https://console.volcengine.com/ark/region:ark+cn-beijing/openManagement)
2. 搜索以下模型，逐一点击「开通服务」：

   | 模型名称 | 模型 ID | 推荐 |
   |---------|---------|------|
   | Doubao-Seed-Code Preview | `doubao-seed-code-preview-251028` | ✅ 编程首选 |
   | Doubao-Seed-2.0-Code Preview | `doubao-seed-2-0-code-preview-260215` | 最新版 |
   | Doubao-Seed-1.6 | `doubao-seed-1-6-251015` | 通用备用 |

3. 按照提示完成服务协议签署，模型即时生效

### 第五步：配置并运行

#### 方式一：使用启动脚本（推荐）

编辑 `claude-code-source/start-doubao.sh`，将 API Key 替换为你自己的：

```bash
# 将第 8 行的 API Key 改为你的
export ANTHROPIC_AUTH_TOKEN="${DOUBAO_API_KEY:-你的API_KEY}"
```

然后运行：

```bash
cd ~/Desktop/claude-code1/claude-code-source
./start-doubao.sh                          # 交互模式
./start-doubao.sh -p "你的问题" < /dev/null  # 非交互模式
```

#### 方式二：直接设置环境变量

```bash
export ANTHROPIC_AUTH_TOKEN="你的豆包API_KEY"
export ANTHROPIC_BASE_URL="https://ark.cn-beijing.volces.com/api/compatible"
export ANTHROPIC_MODEL="doubao-seed-code-preview-251028"
export ANTHROPIC_SMALL_FAST_MODEL="doubao-seed-code-preview-251028"
export CLAUDE_CODE_SIMPLE=1                        # 必须：跳过 macOS Keychain
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export DISABLE_AUTOUPDATER=1

bun ~/Desktop/claude-code1/claude-code-source/dist/cli.js
```

#### 方式三：通过 cc-switch 管理（适合多模型切换）

```bash
# 安装 cc-switch CLI
curl -LO https://github.com/saladday/cc-switch-cli/releases/latest/download/cc-switch-cli-darwin-universal.tar.gz
tar -xzf cc-switch-cli-darwin-universal.tar.gz
chmod +x cc-switch && mv cc-switch ~/bin/
xattr -cr ~/bin/cc-switch

# 进入 TUI 交互界面
cc-switch

# 或命令行添加供应商
cc-switch provider add  # 选择 DoubaoSeed 模板，填入 API Key
```

---

## 环境变量说明

| 变量 | 必须 | 说明 |
|------|------|------|
| `ANTHROPIC_AUTH_TOKEN` | ✅ | 豆包 API Key |
| `ANTHROPIC_BASE_URL` | ✅ | `https://ark.cn-beijing.volces.com/api/compatible` |
| `ANTHROPIC_MODEL` | ✅ | 豆包模型 ID，如 `doubao-seed-code-preview-251028` |
| `ANTHROPIC_SMALL_FAST_MODEL` | 推荐 | 子任务使用的快速模型，同上 |
| `CLAUDE_CODE_SIMPLE=1` | ✅ | **必须设置**，跳过 macOS Keychain 避免进程挂起 |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` | 推荐 | 禁用遥测数据上报 |
| `DISABLE_AUTOUPDATER=1` | 推荐 | 禁用自动更新检查 |

---

## 常见问题

**Q: 运行后进程卡住不动？**
A: 必须设置 `CLAUDE_CODE_SIMPLE=1`，否则 macOS Keychain 读取会导致挂起。

**Q: 报错 `ModelNotOpen`？**
A: 需要在 [方舟控制台](https://console.volcengine.com/ark/region:ark+cn-beijing/openManagement) 开通对应的模型服务。

**Q: 报错 `Header has invalid value`？**
A: 同时存在多个认证来源冲突，请只使用 `ANTHROPIC_AUTH_TOKEN`，不要同时设置 `ANTHROPIC_API_KEY`。

**Q: Apple Silicon 以外的 Mac 或 Linux？**
A: 更换 Bun 安装命令：
- Intel Mac: `curl -LO https://github.com/oven-sh/bun/releases/latest/download/bun-darwin-x64.zip`
- Linux ARM64: `curl -LO https://github.com/oven-sh/bun/releases/latest/download/bun-linux-aarch64.zip`
- Linux x64: `curl -LO https://github.com/oven-sh/bun/releases/latest/download/bun-linux-x64.zip`

---

## 源码还原说明

本项目通过解析 `@anthropic-ai/claude-code` v2.1.88 npm 包中的 `cli.js.map` source map 还原：

```bash
# 1. 下载 npm 包
npm pack @anthropic-ai/claude-code --registry https://registry.npmjs.org

# 2. 解压
tar xzf anthropic-ai-claude-code-2.1.88.tgz

# 3. 从 source map 还原源码
node -e "
const fs = require('fs'), path = require('path');
const map = JSON.parse(fs.readFileSync('package/cli.js.map', 'utf8'));
const outDir = './claude-code-source';
for (let i = 0; i < map.sources.length; i++) {
  const content = map.sourcesContent[i];
  if (!content) continue;
  let relPath = map.sources[i];
  while (relPath.startsWith('../')) relPath = relPath.slice(3);
  const outPath = path.join(outDir, relPath);
  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  fs.writeFileSync(outPath, content);
}"
```

---

## 统计

| 指标 | 数值 |
|------|------|
| 源文件总数 | 4,756 |
| 核心源码 | 1,906 个文件 |
| 第三方依赖 | 2,850 + npm 安装 |
| 构建产出大小 | 22 MB |
| 原始版本 | Claude Code 2.1.88 |
| 当前版本标识 | 2.1.88 (Tencent AI Code by pkushinnxu) |

---

## 作者

**Tencent AI pkushinnxu**

- 基于 Anthropic Claude Code 2.1.88 源码
- 豆包 API 接入与适配
- macOS Keychain 问题修复
