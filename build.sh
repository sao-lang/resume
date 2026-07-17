#!/usr/bin/env bash
#
# 简历构建脚本 — 将 resume.typ 编译为 resume.pdf
# 用法：
#   ./build.sh          # 编译一次
#   ./build.sh --watch  # 监听模式，文件变更时自动重编译
#   ./build.sh -o my.pdf  # 输出到 my.pdf
#
set -euo pipefail

INPUT="resume.typ"
OUTPUT="resume.pdf"
WATCH=false

# ---- 参数解析 ----
while [[ $# -gt 0 ]]; do
  case "$1" in
    --watch|-w)  WATCH=true; shift ;;
    -o)          OUTPUT="$2"; shift 2 ;;
    --help|-h)
      echo "用法: $0 [--watch|-w] [-o 输出文件] [--help|-h]"
      exit 0 ;;
    *)           echo "未知参数: $1"; exit 1 ;;
  esac
done

# ---- 检查依赖 ----
if ! command -v typst &>/dev/null; then
  echo -e "\033[31m[错误] 未找到 Typst！\033[0m"
  echo ""
  echo -e "\033[33m请安装 Typst：\033[0m"
  echo -e "  \033[36mmacOS (Homebrew)：brew install typst\033[0m"
  echo -e "  \033[36mLinux (一行命令)：curl -fsSL https://typst-lang.org/install.sh | sh\033[0m"
  echo -e "  \033[36mWindows：winget install Typst.Typst\033[0m"
  echo -e "  \033[36m或访问：https://github.com/typst/typst/releases\033[0m"
  exit 1
fi

if [ ! -f "$INPUT" ]; then
  echo -e "\033[31m[错误] 未找到输入文件：$INPUT\033[0m"
  echo "请确保在简历项目根目录下运行此脚本。"
  exit 1
fi

# ---- 编译 ----
VERSION=$(typst --version | head -1)
echo -e "\033[32m$VERSION  —  编译 $INPUT → $OUTPUT\033[0m"

if $WATCH; then
  echo -e "\033[36m监听模式已启动，保存文件时将自动重编译...\033[0m"
  typst watch "$INPUT" "$OUTPUT"
else
  typst compile "$INPUT" "$OUTPUT"
  echo -e "\033[32m✓ 编译成功：$OUTPUT\033[0m"
fi
