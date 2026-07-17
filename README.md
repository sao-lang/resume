# 简历构建项目

使用 [Typst](https://typst.lan) 排版引擎生成的中文简历 PDF，基于 `golixp-resume-zh-cn` 模板。

---

## 目录

- [所需软件](#所需软件)
- [安装指南](#安装指南)
  - [Windows](#windows)
  - [macOS](#macos)
  - [Linux](#linux)
- [项目文件说明](#项目文件说明)
- [如何修改简历内容](#如何修改简历内容)
- [如何构建](#如何构建)
  - [使用构建脚本（推荐）](#使用构建脚本推荐)
  - [直接使用 Typst 命令](#直接使用-typst-命令)
- [操作系统差异说明](#操作系统差异说明)
- [常见问题](#常见问题)

---

## 所需软件

| 软件 | 版本要求 | 说明 |
|------|---------|------|
| **Typst** | ≥ 0.12 | 排版引擎，将 `.typ` 文件编译为 PDF |
| **Noto Sans SC** | 最新版 | 中文字体（思源黑体） |
| **Symbols Nerd Font** | ≥ 3.0 | 图标字体，用于显示简历中的图标 |
| **Consolas** | 系统自带 | 等宽字体，用于技术术语（Windows 自带） |
| **Segoe UI Emoji** | 系统自带 | Emoji 字体（Windows 自带） |

> **注意**：Consolas 和 Segoe UI Emoji 是 Windows 内置字体。macOS/Linux 上需要额外安装或替换为系统等效字体（见下方各系统说明）。

---

## 安装指南

### Windows

#### 1. 安装 Typst

**方式一：winget（推荐）**
```powershell
winget install Typst.Typst
```

**方式二：scoop**
```powershell
scoop install typst
```

**方式三：手动安装**
从 [Typst GitHub Releases](https://github.com/typst/typst/releases) 下载 `typst-x86_64-pc-windows-msvc.zip`，解压后将 `typst.exe` 所在目录添加到系统 PATH 环境变量。

验证安装：
```powershell
typst --version
```

#### 2. 安装字体

**Noto Sans SC（思源黑体）**

从 [Google Fonts](https://fonts.google.com/noto/specimen/Noto+Sans+SC) 下载，解压后全选字体文件，右键 → **为所有用户安装**。

或使用 [scoop](https://scoop.sh) 安装：
```powershell
scoop bucket add nerd-fonts
scoop install noto-sans-cjk-sc
```

**Symbols Nerd Font**

```powershell
# 方式一：scoop（推荐）
scoop bucket add nerd-fonts
scoop install Symbols-Nerd-Font

# 方式二：手动下载
# 从 https://www.nerdfonts.com/font-downloads 下载 Symbols Nerd Font
# 解压后右键安装
```

安装后重启终端使字体生效。

---

### macOS

#### 1. 安装 Typst

```bash
# 使用 Homebrew（推荐）
brew install typst

# 验证安装
typst --version
```

#### 2. 安装字体

```bash
# Noto Sans SC
brew install --cask font-noto-sans-sc
# 或从 Google Fonts 下载手动安装

# Symbols Nerd Font
brew install --cask font-symbols-nerd-font
```

> **注意**：macOS 上 `Consolas` 不可用。需在 `resume.typ` 中将字体替换为等效字体，如 `"JetBrains Mono"`、`"Fira Code"` 或 `"Menlo"`：
> ```typst
> mono: "JetBrains Mono",
> ```
>
> 同样，`Segoe UI Emoji` 在 macOS 上替换为 `"Apple Color Emoji"`：
> ```typst
> emoji: "Apple Color Emoji",
> ```

---

### Linux

#### 1. 安装 Typst

```bash
# 一行命令安装（推荐）
curl -fsSL https://typst-lang.org/install.sh | sh

# 或使用包管理器
# Ubuntu/Debian（版本可能较旧）
sudo apt install typst

# Arch Linux
sudo pacman -S typst

# 验证安装
typst --version
```

#### 2. 安装字体

```bash
# Noto Sans SC
# Ubuntu/Debian
sudo apt install fonts-noto-cjk-extra

# Arch Linux
sudo pacman -S noto-fonts-cjk

# Symbols Nerd Font
# Ubuntu/Debian（需要手动下载）
# 从 https://www.nerdfonts.com/font-downloads 下载 Symbols Nerd Font
mkdir -p ~/.local/share/fonts
# 将下载的 .ttf 文件放入上述目录
fc-cache -fv

# Arch Linux
sudo pacman -S ttf-nerd-fonts-symbols

# 验证字体安装
fc-list | grep -i "Symbols Nerd"
fc-list | grep -i "Noto Sans SC"
```

> **Linux 字体差异**：
> - `Consolas` → 替换为 `"Noto Sans Mono"`、`"Fira Code"` 或 `"JetBrains Mono"`
> - `Segoe UI Emoji` → 替换为 `"Noto Color Emoji"`
>
> 修改 `resume.typ` 中的字体配置：
> ```typst
> fonts: (
>   mono: "Noto Sans Mono",
>   emoji: "Noto Color Emoji",
> ),
> ```

---

## 项目文件说明

```
resume/
├── resume.md              # 简历数据源（Markdown 格式，方便修改内容）
├── resume.typ             # Typst 主文件 — 当前使用 golixp-resume-zh-cn 包
├── resume-template.typ    # 使用本地 template.typ 的示例（可替换 resume.typ）
├── template.typ           # 旧版本地模板（简约深蓝风格）
├── package.json           # npm 脚本入口：npm run build / npm run watch
├── build.js               # Node.js 构建脚本（跨平台，推荐）
├── build.ps1              # Windows PowerShell 构建脚本
├── build.sh               # Linux/macOS Bash 构建脚本
├── resume.pdf             # 生成的简历 PDF（运行构建脚本后生成）
└── README.md              # 本文件
```

### 各文件作用

| 文件 | 修改频率 | 说明 |
|------|---------|------|
| `resume.typ` | ⭐⭐⭐ 高频 | 简历完整内容（当前使用 golixp-resume-zh-cn 包模板） |
| `resume-template.typ` | ⭐ 备用 | 使用本地 template.typ 的示例文件，可替换 resume.typ |
| `resume.md` | ⭐⭐ 中频 | Markdown 版本数据源，方便预览和复制内容 |
| `template.typ` | ⭐ 低频 | 旧版本地模板（简约深蓝风格），需配合 resume-template.typ 使用 |
| `package.json` | — 不改 | npm 脚本入口，`npm run build` / `npm run watch` |
| `build.js` | — 不改 | Node.js 构建脚本（跨平台） |
| `build.ps1` | — 不改 | Windows PowerShell 构建脚本 |
| `build.sh` | — 不改 | Linux/macOS Bash 构建脚本 |

---

## 如何修改简历内容

### 修改个人信息

编辑 `resume.typ`，找到 `#personal-header(...)` 部分：

```typst
#personal-header(
  "黄根亮",                                // 修改姓名
  (
    (icon: "phone", content: "13865198109"),   // 修改手机号
    (icon: "email", content: "hxxk1431xk123@163.com"), // 修改邮箱
  ),
)
```

### 修改工作经历 / 项目经历

使用 `#work-item(...)` 函数：

```typst
#work-item(
  "2025.12 – 至今",              // 时间段
  "公司名称",                      // 公司/项目名称
  position: "职位",               // 职位
  tech-stack: ("React", "Go"),   // 技术栈（可选）
  responsibilities: (            // 工作职责
    [第一项职责描述],
    [第二项职责描述],
  ),
  achievements: (                // 项目亮点（可选）
    [亮点描述],
  ),
)
```

### 修改模板样式

模板样式由 `golixp-resume-zh-cn` 包控制。可在 `resume.typ` 顶部的 `#show: resume-doc.with(...)` 中覆盖默认配置：

```typst
#show: resume-doc.with(
  overrides: (
    // 修改主题色
    colors: (primary: rgb(200, 50, 50)),

    // 修改字号
    font-sizes: (h2: 1.3em),

    // 修改间距
    spacing: (section: 0.6em),
  ),
)
```

如需更深度的样式定制，可编辑 Typst 包缓存中的文件：

| 系统 | 包路径 |
|------|--------|
| Windows | `%LOCALAPPDATA%\typst\packages\preview\golixp-resume-zh-cn\0.1.2\` |
| macOS | `~/.local/share/typst/packages/preview/golixp-resume-zh-cn/0.1.2/` |
| Linux | `~/.local/share/typst/packages/preview/golixp-resume-zh-cn/0.1.2/` |

核心模块文件：

| 文件 | 功能 |
|------|------|
| `modules/sections.typ` | 章节标题、个人信息、工作/教育/项目模块 |
| `modules/icons.typ` | 图标系统（对齐、大小） |
| `modules/components.typ` | 基础组件（列表、标签、布局） |
| `modules/config.typ` | 默认配置（颜色、字体、间距） |

---

## 如何构建

### 使用构建脚本（推荐）

#### 方式一：npm scripts（最方便，推荐）

```bash
# 一次编译
npm run build

# 监听模式
npm run watch

# 编译本地模板版
npm run build:template
```

需要安装 [Node.js](https://nodejs.org/) ≥ 18。

#### 方式二：Node.js 直接调用

```bash
# 一次编译
node build.js

# 监听模式
node build.js --watch

# 指定输出文件名
node build.js -o my-resume.pdf

# 查看帮助
node build.js --help
```

#### 方式二：Windows PowerShell

```powershell
# 一次编译
.\build.ps1

# 监听模式（文件保存后自动重编译）
.\build.ps1 -Watch

# 输出到自定义文件名
.\build.ps1 -Output my-resume.pdf

# 查看帮助
.\build.ps1 -Help
```

#### 方式三：macOS / Linux Bash

```bash
# 给予执行权限（只需一次）
chmod +x build.sh

# 一次编译
./build.sh

# 监听模式
./build.sh --watch

# 输出到自定义文件名
./build.sh -o my-resume.pdf
```

### 直接使用 Typst 命令

```bash
# 一次编译
typst compile resume.typ resume.pdf

# 监听模式（文件保存后自动重编译）
typst watch resume.typ resume.pdf

# 输出到其他目录
typst compile resume.typ output/简历.pdf
```

---

## 操作系统差异说明

| 方面 | Windows | macOS | Linux |
|------|---------|-------|-------|
| **构建脚本** | `build.ps1`（PowerShell） | `build.sh`（Bash） | `build.sh`（Bash） |
| **Typst 安装** | `winget install Typst.Typst` | `brew install typst` | `curl -fsSL https://typst-lang.org/install.sh \| sh` |
| **中文字体** | Noto Sans SC（手动安装） | `brew install --cask font-noto-sans-sc` | `apt install fonts-noto-cjk-extra` |
| **图标字体** | Symbols Nerd Font（scoop 或手动） | `brew install --cask font-symbols-nerd-font` | `pacman -S ttf-nerd-fonts-symbols`（Arch）或手动 |
| **等宽字体** | Consolas（系统自带 ✅） | 需替换为 JetBrains Mono / Fira Code | 需替换为 Noto Sans Mono / Fira Code |
| **Emoji 字体** | Segoe UI Emoji（系统自带 ✅） | 替换为 Apple Color Emoji | 替换为 Noto Color Emoji |
| **包缓存路径** | `%LOCALAPPDATA%\typst\packages\` | `~/.local/share/typst/packages/` | `~/.local/share/typst/packages/` |
| **文件路径分隔符** | `\`（脚本自动处理） | `/` | `/` |

### macOS 字体配置示例

修改 `resume.typ` 中的 `fonts` 覆盖：

```typst
fonts: (
  main: "Noto Sans SC",
  sc: "Noto Sans SC",
  mono: "JetBrains Mono",       // macOS 无 Consolas
  emoji: "Apple Color Emoji",   // macOS 的 Emoji 字体
  nerd: "Symbols Nerd Font",
),
```

### Linux 字体配置示例

```typst
fonts: (
  main: "Noto Sans SC",
  sc: "Noto Sans SC",
  mono: "Noto Sans Mono",        // Linux 推荐
  emoji: "Noto Color Emoji",     // Linux 的 Emoji 字体
  nerd: "Symbols Nerd Font",
),
```

---

## 常见问题

### Q: 编译报错 "package ... not found"
Typst 首次使用某个包时会自动下载。如果网络不通，可手动下载包放入缓存目录：
1. 访问 https://typst.universe/packages/preview/golixp-resume-zh-cn/
2. 下载 `0.1.2` 版本
3. 解压到系统对应的包缓存目录下的 `preview/golixp-resume-zh-cn/0.1.2/`

### Q: 编译报错 "font not found: ..."
字体未安装。按上方[安装指南](#安装指南)安装对应字体后重试。可用以下命令查看已安装的字体：

```bash
# Windows（PowerShell）
typst fonts | Select-String "Noto|Nerd"

# macOS / Linux
typst fonts | grep -iE "Noto|Nerd"
```

### Q: 生成的 PDF 中图标显示为方框或问号
图标字体（Symbols Nerd Font）未安装或未正确配置。请确保：
1. 已安装 Symbols Nerd Font
2. 重启终端后再编译
3. `resume.typ` 中 `nerd` 字体名称拼写正确

### Q: 如何更换完全不同的模板？

本项目内置了两个模板，切换方式如下：

#### 切换到本地模板 `template.typ`

`template.typ` 是一个简约深蓝风格的本地模板（在 `golixp-resume-zh-cn` 包之前使用）。

**切换步骤：**

1. 修改 `resume.typ` 顶部的 import，改为导入本地模板：
   ```typst
   // 原（golixp-resume-zh-cn 包）
   // #import "@preview/golixp-resume-zh-cn:0.1.2": *
   // #show: resume-doc.with(...)

   // 改为导入本地模板
   #import "template.typ": *
   #show: resume
   ```

2. `template.typ` 的 API 与包模板不同，需要同时修改简历内容以适配其函数：
   - `#header(name, title, contacts)` → 个人信息头部
   - `#section(title)` → 章节标题
   - `#entry(title, subtitle, date)` → 工作/项目条目
   - `#edu-entry(school, major, date, detail)` → 教育条目
   - `#proj-entry(title, body)` → 个人项目条目
   - `#body-text(body)` → 正文段落

   可参考 `resume-template.typ` 文件，这是已适配好的示例。

3. 运行 `node build.js` 编译验证。

> **提示**：`resume-template.typ` 是使用 `template.typ` 的完整示例，可直接替换为 `resume.typ`：
> ```bash
> copy resume-template.typ resume.typ   # Windows
> cp resume-template.typ resume.typ      # macOS/Linux
> ```

#### 使用其他 Typst 宇宙包

修改 `resume.typ` 顶部的 import 语句：

```typst
// 替换为其他 Typst 宇宙包
#import "@preview/其他模板包:版本号": *

// 按新模板的 API 重写简历内容
#show: 新模板的show规则.with(...)
```

#### 使用完全自定义的模板

创建新的 `.typ` 文件（如 `my-template.typ`），定义自己的页面布局和组件函数，然后在 `resume.typ` 中导入使用。

---

## 许可

本项目仅供个人简历使用。
