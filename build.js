#!/usr/bin/env node
/**
 * 简历构建脚本 — 跨平台 Node.js 版本
 * 将 resume.typ 编译为 resume.pdf
 *
 * 用法：
 *   node build.js              # 一次编译
 *   node build.js --watch      # 监听模式
 *   node build.js --output my.pdf
 *   node build.js --help
 */

import { execSync, spawn } from "node:child_process";
import { existsSync, watch } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const INPUT = "resume.typ";
const DEFAULT_OUTPUT = "resume.pdf";

// ---- 解析参数 ----
const args = process.argv.slice(2);
const helpFlag = args.includes("--help") || args.includes("-h");
const watchFlag = args.includes("--watch") || args.includes("-w");

let outputIndex = args.findIndex((a) => a === "--output" || a === "-o");
const outputFile = outputIndex !== -1 ? args[outputIndex + 1] : DEFAULT_OUTPUT;

if (helpFlag) {
  console.log(`
  简历构建脚本

  用法:
    node build.js             编译一次
    node build.js --watch     监听模式，文件变更自动重编译
    node build.js -o my.pdf   指定输出文件名
    node build.js --help      显示帮助

  示例:
    node build.js
    node build.js --watch
    node build.js -o 简历.pdf
  `);
  process.exit(0);
}

// ---- 检查依赖 ----
function checkTypst() {
  try {
    const version = execSync("typst --version", { encoding: "utf8" });
    const match = version.match(/\d+\.\d+\.\d+/);
    return match ? match[0] : "?";
  } catch {
    console.error("\n  [错误] 未找到 Typst！\n");
    console.error("  请安装 Typst：");
    console.error("    Windows:  winget install Typst.Typst");
    console.error("    macOS:    brew install typst");
    console.error("    Linux:    curl -fsSL https://typst-lang.org/install.sh | sh");
    console.error("    或访问:   https://github.com/typst/typst/releases\n");
    process.exit(1);
  }
}

function checkInput() {
  const inputPath = join(__dirname, INPUT);
  if (!existsSync(inputPath)) {
    console.error(`\n  [错误] 未找到输入文件: ${INPUT}\n`);
    process.exit(1);
  }
}

// ---- 编译 ----
function build() {
  const version = checkTypst();
  checkInput();

  const cmd = watchFlag
    ? `typst watch "${INPUT}" "${outputFile}"`
    : `typst compile "${INPUT}" "${outputFile}"`;

  console.log(`  Typst ${version}  --  编译 ${INPUT} → ${outputFile}`);

  if (watchFlag) {
    console.log("  监听模式已启动，保存文件时将自动重编译...\n");
    const child = spawn("typst", ["watch", INPUT, outputFile], {
      cwd: __dirname,
      stdio: "inherit",
      shell: true,
    });
    child.on("exit", (code) => process.exit(code ?? 0));
  } else {
    try {
      execSync(cmd, { cwd: __dirname, stdio: "inherit" });
      console.log(`\n  ✓ 编译成功: ${outputFile}\n`);
    } catch {
      console.error("\n  ✗ 编译失败，请检查上方错误信息。\n");
      process.exit(1);
    }
  }
}

build();
