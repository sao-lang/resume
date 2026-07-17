// ============================================================
// 简历模板 - 精致专业风格 v2
// 设计：深蓝主色 + 顶部色块区 + 清晰信息层级
// 如需更换模板，只需替换此文件或修改颜色变量
// ============================================================

// ---- 颜色配置（改这里一键换色系）----
#let primary-color = rgb("#1a3a5c")       // 主色 - 深海蓝
#let accent-color = rgb("#2980b9")        // 强调色 - 亮蓝
#let text-color = rgb("#2c3e50")          // 正文色
#let muted-color = rgb("#7f8c8d")         // 次要文字色
#let divider-color = rgb("#d5dbdb")       // 分割线色
#let header-bg = rgb("#1a3a5c")           // 头部背景色

// ---- 页面设置 ----
#let page-setup() = {
  set page(
    paper: "a4",
    margin: (left: 2.5cm, right: 2cm, top: 0cm, bottom: 2cm),
    header: none,
    footer: none,
  )
  set text(font: ("Microsoft YaHei", "SimHei"), size: 10pt, fill: text-color)
  set par(leading: 0.65em, justify: false)
}

// ---- 头部（深色背景区块）----
#let header(name, title, contacts) = {
  block(
    width: 100%,
    inset: (x: 2.5cm, y: 1cm),
    fill: header-bg,
  )[
    #set text(fill: white)
    #align(center)[
      #text(size: 26pt, weight: "bold", name)
      #v(6pt)
      #text(size: 11pt, fill: rgb("#b0c4de"), title)
      #v(8pt)
      #line(length: 60%, stroke: 0.5pt + rgb("#4a6a8a"))
      #v(6pt)
      #text(size: 9pt, fill: rgb("#d0d8e0"), contacts)
    ]
  ]
  v(0.5cm)
}

// ---- 分隔线（装饰用）----
#let thin-line() = {
  line(length: 100%, stroke: 0.3pt + divider-color)
  v(0.3cm)
}

// ---- 章节标题 ----
#let section(title) = {
  v(0.3cm)
  grid(
    columns: (4pt, 1fr),
    column-gutter: 8pt,
    {
      block(width: 4pt, height: 14pt, fill: accent-color, radius: 2pt)
    },
    [
      #text(size: 12pt, weight: "bold", fill: primary-color, title)
    ]
  )
  v(5pt)
  line(length: 100%, stroke: 0.4pt + divider-color)
  v(0.3cm)
}

// ---- 工作/项目条目（标题 + 副标题 + 日期）----
#let entry(title, subtitle, date) = {
  v(2pt)
  grid(
    columns: (1fr, auto),
    row-gutter: 2pt,
    [
      #text(size: 10.5pt, weight: "bold", fill: primary-color, title)
      #if subtitle != "" [
        #text(size: 9.5pt, fill: accent-color, "  ·  " + subtitle)
      ]
    ],
    [
      #text(size: 9pt, fill: muted-color, weight: "medium", date)
    ]
  )
  v(4pt)
}

// ---- 教育条目 ----
#let edu-entry(school, major, date, detail) = {
  v(2pt)
  grid(
    columns: (1fr, auto),
    row-gutter: 2pt,
    [
      #text(size: 10.5pt, weight: "bold", fill: primary-color, school)
      #text(size: 9.5pt, fill: muted-color, "  ·  " + major)
    ],
    [
      #text(size: 9pt, fill: muted-color, weight: "medium", date)
    ]
  )
  if detail != "" [
    #v(3pt)
    #text(size: 9pt, fill: muted-color, detail)
  ]
  v(2pt)
}

// ---- 个人项目条目 ----
#let proj-entry(title, body) = {
  v(2pt)
  text(size: 10.5pt, weight: "bold", fill: primary-color, title)
  v(3pt)
  text(size: 9.5pt, fill: text-color, body)
  v(6pt)
}

// ---- 项目内标签（如 "项目介绍："）----
#let inline-label(label) = {
  text(size: 9.5pt, weight: "bold", fill: accent-color, label)
}

// ---- 正文段落 ----
#let body-text(body) = {
  text(size: 9.5pt, fill: text-color, body)
  v(2pt)
}

// ---- 整体框架 ----
#let resume(body) = {
  page-setup()
  body
}
