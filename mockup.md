# Mockup Specification

Mockup is an ASCII-based layout description language for presentations. Define your slide layouts using ASCII characters, and let AI transform them into polished visual presentation images.

## Overview

**The Problem**: When creating presentations, content ideation and visual design compete for attention. Mockup separates these concerns — users focus on content and layout intent, while AI handles aesthetics and image generation.

**Design Principles**:

- **WYSIWYG** — Box position equals element position, box size equals element size, text position equals alignment
- **Intent-Driven** — Focus on expressing layout intent, not precise character placement
- **Syntax-Tolerant** — Misaligned boxes are auto-corrected, similar characters are interpreted semantically

## Usage

**Standalone file**

```
presentation.mu
```

**Embedded in Markdown**

````markdown
```mu
┌────────────────────────────────────────┐
│              Slide content             │
└────────────────────────────────────────┘
```
````

## File Structure

```
---
metadata (optional)
---

slide 1

> annotations for slide 1

slide 2

> annotations for slide 2
```

## Metadata

Define global properties using YAML front matter:

```yaml
---
title: Product Launch
author: John Doe
theme: blue-tech
---
```

Or using annotation syntax:

```
> title: Product Launch
> author: John Doe
> theme: blue-tech
```

Both formats are supported. All fields are optional.

## Syntax

### Slides

The outermost closed rectangular box defines a slide:

```
┌────────────────────────────────────────┐
│              Slide 1                   │
└────────────────────────────────────────┘

┌────────────────────────────────────────┐
│              Slide 2                   │
└────────────────────────────────────────┘
```

Recommended width: 60–72 characters (approximately 16:9 aspect ratio).

### Boxes

Used to define regions and express hierarchy:

```
Standard         Emphasis         Secondary
┌──────────┐    ╔══════════╗    ┌╌╌╌╌╌╌╌╌╌╌┐
│          │    ║          ║    ┆          ┆
└──────────┘    ╚══════════╝    └╌╌╌╌╌╌╌╌╌╌┘
```

**Box Characters**

| Type | Characters |
|------|------------|
| Single line | `─ │ ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼` |
| Double line | `═ ║ ╔ ╗ ╚ ╝` |
| Dashed | `╌ ┆` |
| Rounded | `╭ ╮ ╯ ╰` |

### Layout

**Horizontal split**

```
┌───────────┬───────────┐
│   Left    │   Right   │
└───────────┴───────────┘
```

**Vertical split**

```
┌─────────────────────────┐
│           Top           │
├─────────────────────────┤
│          Bottom         │
└─────────────────────────┘
```

### Arrows

```
→ ← ↑ ↓           Directional
↗ ↘ ↙ ↖           Diagonal
───→              Connector with direction
─── │             Connector
```

### Text

Position determines alignment:

```
┌────────────────────────────────────────┐
│Left-aligned                            │
│                                        │
│              Centered                  │
│                                        │
│                          Right-aligned │
└────────────────────────────────────────┘
```

**Hierarchy** is expressed visually:

- Headings: centered with vertical padding
- Body text: normal flow
- Captions: indented or placed in corners

Supports `**bold**` and `*italic*`. Use sparingly.

## Graphics

### Principle

**Prefer ASCII rendering** — Charts, flowcharts, and UI mockups should all use ASCII + Emoji.

Only real photos and videos require annotation-based replacement.

### Charts

**Bar chart**

```
│
│   ███
│   ███  ███
│   ███  ███  ███
└──────────────────
    Q1   Q2   Q3
```

**Line chart**

```
│
│       ·
│      · ·
│     ·   ·
│    ·     ··
└──────────────────
```

### Flowchart

```
┌──────┐      ┌──────┐      ┌──────┐
│ Input │ ───→ │Process│ ───→ │Output │
└──────┘      └──────┘      └──────┘
```

### Icons

Use Emoji directly:

```
🚀  📊  👤  ✅  ❌  💡  🎯
```

### UI Mockup

```
┌─────────────────────────────────────┐
│ ● ● ●   App Name                    │
├─────────────────────────────────────┤
│  ┌─────┐  ┌─────┐                   │
│  │ 🏠  │  │ 👤  │                   │
│  └─────┘  └─────┘                   │
│                                     │
│  ────────────────────               │
│  ────────────────────               │
└─────────────────────────────────────┘
```

### Photo Placeholder

```
┌───────────┐
│           │
│    👤     │
│           │
└───────────┘
  John Doe
```

### Video

```
┌─────────────────────────────────────┐
│                                     │
│               ▶️                    │
│                                     │
├─────────────────────────────────────┤
│ ▶  ═══════●────────────────  2:34   │
└─────────────────────────────────────┘
```

### Code Block

```
┌────────────────────────────────────────┐
│  def hello():                          │
│      print("Hello!")                   │
└────────────────────────────────────────┘
```

### Formula

Draw directly:

```
        QKᵀ
softmax(────) V
         √d
```

Or specify LaTeX via annotation:

```
> ① render as LaTeX: \frac{QK^T}{\sqrt{d}}
```

## Annotations

Lines starting with `>` are annotations. They pass instructions to AI for image generation and do not appear in the final output.

```
┌────────────────────────────────────────┐
│              Content                   │
└────────────────────────────────────────┘

> This is an annotation
> Multiple lines supported
```

### Markers

Use ①②③ to mark elements and reference them in annotations:

```
┌────────────────────────────────────────┐
│                                        │
│    ┌──────┐         ┌──────┐          │
│    │ A ①  │  ────→  │ B ②  │          │
│    └──────┘         └──────┘          │
│                                        │
└────────────────────────────────────────┘

> ① color: red
> ② color: green
```

Available markers: ①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳

For more than 20, use `(21)` `(22)` etc.

### Common Annotations

| Purpose | Example |
|---------|---------|
| Color | `> ① color: #EF4444` or `> ① color: red` |
| Animation | `> ① appears first, then ②` |
| Asset replacement | `> ① replace with: photo.jpg` |
| Link | `> ① link: https://example.com` |
| LaTeX | `> ① render as LaTeX: E=mc^2` |
| Code language | `> ① language: python` |
| Background | `> background: dark-blue` |
| Background image | `> background-image: bg.jpg` |
| Skip slide | `> skip` |
| Speaker notes | `> notes: pause here` |

Annotations support natural language. No fixed format required.

## Example

```mu
---
title: Mockup Introduction
author: Lingjun
theme: purple-gradient
---

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                         ┌─┐                                    │
│                         │M│ ockup                              │
│                         └─┘                                    │
│                                                                │
│                    The Markdown for PPT                        │
│                                                                │
│                          🚀                                    │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Cover slide

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                        **Workflow**                            │
│                                                                │
│      ┌──────────┐      ┌──────────┐      ┌──────────┐         │
│      │   📝    │      │    🤖    │      │    🎨    │         │
│      │ Draft①  │ ───→ │Generate② │ ───→ │ Images③ │         │
│      └──────────┘      └──────────┘      └──────────┘         │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> ① User describes requirements
> ② AI generates mu draft
> ③ AI generates final presentation images
> Boxes appear sequentially
```

## Quick Reference

```
Box Characters
─ │ ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼
═ ║ ╔ ╗ ╚ ╝
╌ ┆
╭ ╮ ╯ ╰

Arrows
→ ← ↑ ↓ ↗ ↘ ↙ ↖

Markers
①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳

Fills
█ ▓ ▒ ░ ■ □

Common Emoji
👤 👥 👨‍💻 🧑‍🤝‍🧑
✅ ❌ ⚠️ ❓ ❗
📊 📈 📉 📝 📄 📁
🔗 💡 🎯 🚀 💰 🛡️
🙏 👍 👋
```
