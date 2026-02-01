# Mockup Specification <sub>v0.1.0</sub>

Mockup is an ASCII-based layout description language for slides. Define your slide layouts using ASCII characters, and let AI transform them into polished visual slide images.

## About This Document

**For humans**: This is the complete format specification for Mockup. Read it to understand the syntax, design principles, and capabilities.

**For AI systems**: This document is a self-contained prompt. When a user pastes this entire file:
1. Read the specification below to understand Mockup syntax
2. Then follow the [AI Instructions](#ai-instructions) at the end to perform the requested task

---

## Overview

**The Problem**: When creating slides, content ideation and visual design compete for attention. Mockup separates these concerns — users focus on content and layout intent, while AI handles aesthetics and image generation.

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

┌────────────────────────────────────────┐
│                                        │
│             Slide 1                    │
│                                        │
└────────────────────────────────────────┘

> annotations for slide 1

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
- Use proper text alignment (position = alignment)
- Add annotations sparingly

### Key Constraints

**DO:**
- ✅ Maximize ASCII art (charts, flowcharts, diagrams, UI mockups)
- ✅ Use emoji for icons and visual interest
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

┌────────────────────────────────────────┐
│                                        │
│         **Slide Title**                │
│                                        │
│              Content                   │
│                                        │
└────────────────────────────────────────┘

> annotations if needed

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

## Task B: Generate Images from `.mu` Files

**When to activate**: User provides `.mu` file content and requests images/rendering.

### Your Process

**Step 1: Parse Structure**
- Read YAML frontmatter for theme/metadata
- Identify each slide (outermost boxes)
- Extract annotations (lines starting with `>`)

**Step 2: Interpret Layout**
- Apply WYSIWYG principle: ASCII position/size = visual position/size
- Understand box hierarchy from line styles
- Read text alignment from position

**Step 3: Transform ASCII to Graphics**
- Convert ASCII charts → professional visualizations
- Transform flowcharts → clean diagrams
- Render emoji as icons (or keep if theme-appropriate)
- Apply consistent visual style

**Step 4: Apply Annotations**
- Process color specifications: `> ① color: red` or `> ① color: #EF4444`
- Handle asset replacements: `> ① replace with: photo.jpg`
- Note animation sequences: `> ① appears first, then ②`
- Set backgrounds: `> background: dark-blue`
- **Exclude** speaker notes from images: `> notes: pause here`

**Step 5: Generate Images**
- One image per slide
- Aspect ratio: 16:9 (recommended 1920x1080)
- High quality, slide-ready
- Maintain style consistency across all slides

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

**Default Style** (when no theme specified):
- White/light background (like academic papers)
- Clean sans-serif fonts (e.g., Helvetica, Arial)
- Minimal colors: black text, blue for links/accents
- Professional and readable, suitable for technical content

**Style Consistency**:
- Choose color scheme from theme metadata (or use default above)
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


