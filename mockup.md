# Mockup Specification <sub>v0.1.0</sub>

Mockup is a layout control language for human-AI collaboration. It provides a human-readable, AI-parseable intermediate representation for visual layouts — like ControlNet uses edge maps to guide image generation, mockup uses ASCII art to guide layout generation.

**Current focus: slides.** This specification defines how to create slide layouts using ASCII characters, and let AI transform them into polished visuals (images, HTML, SVG, etc.).

## About This Document

**For humans**: This is the complete format specification for Mockup. Read it to understand the syntax, design principles, and capabilities.

**For AI systems**: This document is a self-contained prompt. When you receive this document (via user paste or skill activation):
1. Read the specification below to understand Mockup syntax
2. Then follow the [AI Instructions](#ai-instructions) at the end to perform the requested task

---

## Overview

**The Problem**: When humans collaborate with AI on visual layouts, pure text prompts give unpredictable results, while precise formats (JSON, XML) are unreadable. Mockup bridges this gap — users define layout intent in ASCII, AI handles aesthetics and rendering.

**Design Principles**:

- **WYSIWYG** — What you draw is what you get: box position equals element position, box size equals element size
- **Intent-Driven** — Focus on content and layout, not pixel-perfect positioning or precise operations
- **AI-Native** — Parsing, rendering, and syntax interpretation are all handled by AI systems

## Usage

**Standalone file**

```
slides.mu
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
title: Mockup Example
author: simpx (simpxx@gmail.com)
theme: academic
---

# 1

┌────────────────────────────────────────┐
│                                        │
│             Slide 1                    │
│                                        │
└────────────────────────────────────────┘

> annotations for slide 1

# 2

┌────────────────────────────────────────┐
│                                        │
│             Slide 2                    │
│                                        │
└────────────────────────────────────────┘

> annotations for slide 2
```

## Metadata

Define global properties using YAML front matter:

```yaml
---
title: Mockup Introduction
author: simpx (simpxx@gmail.com)
theme: academic
---
```

All fields are optional.

## Syntax

### Slides

The outermost closed rectangular box defines a slide. Use `# number` as page marker:

```
# 1

┌────────────────────────────────────────┐
│              Slide 1                   │
└────────────────────────────────────────┘

# 2

┌────────────────────────────────────────┐
│              Slide 2                   │
└────────────────────────────────────────┘
```

**Page Marker Rules**:
- `# number` marks the start of a slide (required)
- `# number title` adds an optional title (e.g., `# 2 Problem`)
- Page numbers are explicit, not auto-incremented
- A page marker with no content creates a blank slide
- Parsing: `content.split(/^# \d+/m)` or `content.matchAll(/^# (\d+)\s*(.*)?$/gm)`

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
│    │ A ① │  ────→  │ B ② │          │
│    └──────┘         └──────┘          │
│                                        │
└────────────────────────────────────────┘

> ① color: red
> ② color: green
```

Available markers: ①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳, then (21)(22)... for more.

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
author: simpx (simpxx@gmail.com)
theme: academic
---

# 1 Cover

┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                         ┌─┐                                    │
│                         │M│ ockup                              │
│                         └─┘                                    │
│                                                                │
│                   The Markdown for Slides                      │
│                                                                │
│                          🚀                                    │
│                                                                │
└────────────────────────────────────────────────────────────────┘

> Cover slide

# 2 Workflow

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
> ③ AI generates final slide images
> Boxes appear sequentially
```

## Quick Reference

```
Page Marker
# 1
# 2 Title

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

---

# AI Instructions

When a user has pasted this document into a conversation, you are now a Mockup specialist. You have two main tasks:

## Task A: Generate `.mu` Files from Content

**When to activate**: User describes slide content, mentions slides, or requests to create slides.

### Your Process

**Step 1: Analyze Requirements**
- Understand the topic, purpose, and audience
- Identify key points and structure
- Determine appropriate slide count

**Step 2: Design Layouts**
- Use syntax from the specification above
- Apply design principles (WYSIWYG, Intent-Driven, AI-Native)
- Choose appropriate box styles for hierarchy
- Create ASCII graphics for data visualization

**Step 3: Generate Output**
- Start with YAML frontmatter (optional but recommended)
- One outermost box per slide (60-72 characters wide recommended)
- Use `# number` as page marker for each slide (e.g., `# 1`, `# 2 Title`)
- Use proper text alignment (position = alignment)
- Add annotations sparingly

### Key Constraints

**DO:**
- ✅ Maximize ASCII art (charts, flowcharts, diagrams, UI mockups)
- ✅ Use emoji for icons and visual interest
- ✅ Use `# number` as page marker (e.g., `# 1`, `# 2 Problem`)
- ✅ Use box hierarchy: `╔═╗` (emphasis) > `┌─┐` (standard) > `┌╌┐` (secondary)
- ✅ Respect WYSIWYG principle: box position/size = element position/size
- ✅ Add metadata (title, author, theme) when appropriate

**DON'T:**
- ❌ Over-use annotations - prefer ASCII graphics
- ❌ Use `> replace with: xxx.jpg` unless for real photos/videos
- ❌ Create slides wider than 72 characters
- ❌ Ignore text alignment rules (position matters)

### Output Format

```yaml
---
title: Slide Title
author: Author Name
theme: theme-name
---

# 1

┌────────────────────────────────────────┐
│                                        │
│         **Slide Title**                │
│                                        │
│              Content                   │
│                                        │
└────────────────────────────────────────┘

> annotations if needed

# 2

┌────────────────────────────────────────┐
│                                        │
│         **Next Slide**                 │
│                                        │
└────────────────────────────────────────┘
```

### Examples

**User request**: "Create 3 slides about our Q4 growth"

**Your response**: Generate `.mu` file with:
- Slide 1: Title/cover with company name
- Slide 2: Growth metrics with ASCII bar chart
- Slide 3: Key insights or call-to-action

---

## Task B: Render `.mu` Files

**When to activate**: User provides `.mu` file content and requests rendering/output.

### Your Process

**Step 1: Parse**
- Read YAML frontmatter for theme/metadata
- Split content by `# number` to identify each slide (page markers are for parsing only, not rendered)
- Identify slide boundaries (outermost boxes)
- Extract annotations (lines starting with `>`)

**Step 2: Render**

Render to the format user requests (image, HTML, SVG, etc.).

Requirements:
- **Visual fidelity**: Output must match the mockup description — layout, content, annotations, and theme
- **Follow Rendering Guidelines**: See below for detailed rules on proportions, text, graphics, etc.
- **One output per slide**: Each slide becomes one image/page
- **Aspect ratio**: 16:9 preferred (1920x1080 for images)
- **Consistency**: Maintain uniform style across all slides

### Predefined Themes

- `academic` (default) — White background, clean fonts, navy accents, formal style
- `startup` — Bold sans-serif, vibrant colors, modern gradients
- `tech` — Dark background, monospace + sans-serif, cyan/green accents

### Rendering Guidelines

**Proportions** (Critical):
- If ASCII box is 50% of slide width → render as 50% width
- Maintain column width ratios in split layouts
- Preserve vertical spacing and padding

**Box Hierarchy**:
- `╔═╗` double-line → Bold/thick borders, emphasized content
- `┌─┐` single-line → Standard borders, normal weight
- `┌╌┐` dashed → Subtle/light borders, supporting info
- `╭─╮` rounded → Modern style with rounded corners

**Text**:
- Left-aligned ASCII → left-aligned text
- Centered ASCII → centered text
- Right-aligned ASCII → right-aligned text
- `**bold**` → bold font
- `*italic*` → italic font

**ASCII Graphics Transformation**:

| ASCII Input | Render As |
|-------------|-----------|
| `███` bars | Polished bar charts with colors and gradients |
| `· ·` line plots | Smooth line graphs with data points |
| Box diagrams | Clean flowcharts with proper connectors |
| Emoji 🚀📊 | Professional icons or keep emoji based on theme |
| `───→` arrows | Smooth vector arrows |
| UI sketches | Clean interface mockups |

**Annotations**:
- Apply colors: `> ① color: red` or `> ① color: #EF4444`
- Set backgrounds: `> background: dark-blue` or `> background-image: bg.jpg`
- Replace assets: `> ① replace with: photo.jpg`
- Render LaTeX: `> ① render as LaTeX: E=mc^2`
- Apply code highlighting: `> ① language: python`
- Add links: `> ① link: https://example.com`
- Handle animations: `> ① appears first, then ②` (for animated output formats)

**Not Rendered**:
- Page markers: `# 1`, `# 2 Problem` (for parsing/organization only)
- Speaker notes: `> notes: ...`
- Skipped slides: `> skip`

**Style Consistency**:
- Choose color scheme from theme metadata
- Use consistent fonts throughout
- Maintain uniform spacing and padding
- Apply consistent border-radius to boxes

**Auto-Correction** (Syntax-Tolerant Principle):
- Fix slightly misaligned boxes
- Interpret similar characters semantically
- Focus on reconstructing layout intent
- Don't fail on minor syntax errors

### Examples

**User provides**:
```mu
┌────────────────────────────────────────┐
│                                        │
│         **Revenue Growth**             │
│                                        │
│    │                                   │
│    │      ███                          │
│    │  ███ ███                          │
│    └───────────                        │
│      Q1   Q2                           │
└────────────────────────────────────────┘

> Chart bars color: green
```

**You generate**: A professional slide image with:
- Title "Revenue Growth" centered at top
- Clean bar chart with two green bars (Q1 lower, Q2 higher)
- Proper spacing and typography
- 16:9 aspect ratio, high resolution

---

## Additional Notes

- When in doubt about which task, ask the user to clarify
- You can handle both tasks in a single conversation
- Always prioritize user intent over strict syntax adherence
- Use the syntax and examples in this document as your reference
- If available, you can also reference the `examples/` directory for more complete samples


