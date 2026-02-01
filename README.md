# Mockup

Mockup is an ASCII-based layout description language for presentations. Sketch your layout with ASCII characters, and let the renderer produce the final visual output.

## The Problem

Creating presentations forces you to juggle content and design simultaneously. Mockup separates these concerns — you focus on content and layout, the renderer handles styling.

```mu
┌────────────────────────────────────────┐
│                                        │
│            **Hello World**             │
│                                        │
│    ┌──────┐           ┌──────┐        │
│    │  A   │  ───→     │  B   │        │
│    └──────┘           └──────┘        │
│                                        │
└────────────────────────────────────────┘
```

This defines a slide with a centered title and two connected boxes.

## Why Mockup

- **Markdown solved writing** — Focus on content, let the renderer handle formatting
- **Mockup solves presentations** — Focus on content and layout, let AI handle styling

## Design Principles

- **WYSIWYG** — What you draw is what you get
- **Intent-Driven** — Express layout intent, not pixel-perfect positioning
- **Syntax-Tolerant** — Imperfect ASCII is interpreted semantically

## Documentation

| File | Description |
|------|-------------|
| [mockup.md](./mockup.md) | Format specification & usage guide |
| [SKILL.md](./SKILL.md) | Claude Project optimization |
| [examples/](./examples) | Example presentations |

## Getting Started

**Quick Start**: Copy [mockup.md](./mockup.md) and paste into any AI chat, then describe your presentation or provide a `.mu` file.

**For ongoing use**: Add [mockup.md](./mockup.md) and optionally [SKILL.md](./SKILL.md) to your Claude Project knowledge.

## Usage

### Option 1: Copy-Paste (Any AI)

**Step 1**: Copy the entire [mockup.md](./mockup.md) file

**Step 2**: Paste into any AI chat (Claude, ChatGPT, Gemini, etc.)

**Step 3**: Choose your task:

**Task A - Generate `.mu` from content:**
```
I need a presentation about [topic].
Include: [key points]
Target audience: [audience]
```

**Task B - Generate images from `.mu`:**
```
Generate presentation images from this .mu file:

[paste your .mu content]
```

The mockup.md file contains both the format specification and usage instructions.

### Option 2: Claude Projects (Recommended for Ongoing Use)

1. Create a new Claude Project
2. Add `mockup.md` (required) and optionally `SKILL.md` (optimization) to your project knowledge
3. Start conversations and simply:
   - Describe your presentation needs, or
   - Provide `.mu` files for image generation

Claude will automatically understand both tasks from the mockup.md file.

### Option 3: VS Code

> 🚧 **Coming Soon**: VS Code extension for Mockup syntax highlighting and preview.
>
> Planned features:
> - Syntax highlighting for `.mu` files
> - Live preview panel
> - AI-powered generation via Claude integration
> - Export to common formats (PDF, PNG, PowerPoint)

For now:
1. Create `.mu` files in VS Code with plain text editing
2. Use ASCII box-drawing characters (see [mockup.md](./mockup.md) Quick Reference)
3. Copy mockup.md into AI chat for generation/rendering

## Examples

| Example | Description |
|---------|-------------|
| [`intro`](./examples/intro/) | Product introduction (8 slides) |
| [`tech-rfc`](./examples/tech-rfc/) | Technical RFC (6 slides) |
| [`thesis-defense`](./examples/thesis-defense/) | Thesis defense (7 slides) |
| [`mapreduce`](./examples/mapreduce/) | Classic paper presentation (15 slides) |

See [examples/README.md](./examples/README.md) for detailed information about each example and AI-generated images.

## License

MIT
