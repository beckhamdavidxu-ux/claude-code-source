#!/usr/bin/env bash
# 使用豆包 Doubao API 运行 Claude Code 源码构建版

set -e

# ===== 豆包 API 配置 =====
export ANTHROPIC_AUTH_TOKEN="${DOUBAO_API_KEY:-3d1f5117-39d7-4b84-9feb-66d8aff8b4dc}"
export ANTHROPIC_BASE_URL="https://ark.cn-beijing.volces.com/api/compatible"

# 编程专用模型
export ANTHROPIC_MODEL="doubao-seed-code-preview-251028"
export ANTHROPIC_SMALL_FAST_MODEL="doubao-seed-code-preview-251028"

# 跳过 macOS 钥匙串（避免进程挂起）
export CLAUDE_CODE_SIMPLE=1

# 禁用 telemetry 和自动更新
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export DISABLE_AUTOUPDATER=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUN_PATH="$HOME/.bun/bin/bun"

if [ ! -f "$BUN_PATH" ]; then
    echo "❌ 未找到 bun，请先运行: curl -fsSL https://bun.sh/install | bash" >&2
    exit 1
fi

if [ ! -f "$SCRIPT_DIR/dist/cli.js" ]; then
    echo "❌ 未找到 dist/cli.js，请先运行: bun run build.ts" >&2
    exit 1
fi

echo "🚀 正在启动 Claude Code 源码版"
echo "   模型: $ANTHROPIC_MODEL"
echo "   API:  $ANTHROPIC_BASE_URL"
echo ""
exec "$BUN_PATH" "$SCRIPT_DIR/dist/cli.js" "$@"
