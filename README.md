# Mockup

Mockup is an ASCII-based layout description language for slides. Define your slide layouts using ASCII characters, and let AI transform them into polished visual slide images.

## The Problem

Creating presentations forces you to juggle content and design simultaneously. Mockup separates these concerns — you focus on content and layout intent, AI handles aesthetics and image generation.

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

This defines a slide with a centered title and two connected boxes. AI will render it as a polished slide image.

## Why Mockup

- **Markdown solved writing** — Focus on content, let the formatter handle typography
- **Mockup solves presentations** — Focus on content and layout, let AI handle styling and rendering

## Design Principles

- **WYSIWYG** — What you draw is what you get: box position equals element position, box size equals element size
- **Intent-Driven** — Focus on content and layout, not pixel-perfect positioning or precise operations
- **AI-Native** — Parsing, rendering, and syntax interpretation are all handled by AI systems

## Documentation

| File | Description |
|------|-------------|
| [mockup.md](./mockup.md) | **Complete specification + AI instructions** (self-contained) |
| [SKILL.md](./SKILL.md) | Claude Project optimization hints |
| [examples/](./examples) | Example presentations with AI-generated images |

## Getting Started

**Quick Start**: Copy the entire [mockup.md](./mockup.md) file and paste into any AI chat. It contains both the format specification and complete AI instructions.

**For ongoing use**: Add [mockup.md](./mockup.md) to your Claude Project knowledge. Optionally add [SKILL.md](./SKILL.md) for better performance.

## Usage

### Option 1: Copy-Paste (Any AI)

**Step 1**: Copy the entire [mockup.md](./mockup.md) file
**Step 2**: Paste into any AI chat (Claude, ChatGPT, Gemini, etc.)
**Step 3**: Choose your task:

**Task A — Generate `.mu` from content:**
```
I need a presentation about [topic].
Include: [key points]
Target audience: [audience]
```

**Task B — Generate images from `.mu`:**
```
Generate presentation images from this .mu file:

[paste your .mu content]
```

The AI will understand what to do from the instructions in mockup.md.

### Option 2: Claude Projects (Recommended)

1. Create a new Claude Project
2. Add [mockup.md](./mockup.md) to Project Knowledge (required)
3. Optionally add [SKILL.md](./SKILL.md) for optimization
4. Start conversations and simply:
   - Describe your presentation needs, or
   - Provide `.mu` files for rendering

The AI will automatically recognize both tasks.

### Option 3: VS Code

> 🚧 **Coming Soon**: VS Code extension for Mockup syntax highlighting and preview.
>
> Planned features:
> - Syntax highlighting for `.mu` files
> - Live preview panel
> - AI-powered generation via integration
> - Export to common formats (PDF, PNG, PowerPoint)

For now:
1. Create `.mu` files in VS Code with plain text
2. Use ASCII box-drawing characters (see mockup.md Quick Reference)
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
