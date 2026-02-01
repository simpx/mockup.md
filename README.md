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
| [mockup.md](./mockup.md) | Format specification |
| [SKILL.md](./SKILL.md) | Rendering guide for AI |
| [examples/](./examples) | Example files |

## Getting Started

1. Read [mockup.md](./mockup.md) for the format specification
2. Add [SKILL.md](./SKILL.md) to your Claude Project or context
3. Describe the presentation you need
4. Claude generates `.mu` → You refine → Ask Claude to generate final presentation images

## Usage

### Using Mockup with Claude

**Option 1: Claude Projects (Recommended)**

1. Create a new Claude Project
2. Add `SKILL.md` to your project knowledge
3. Start a conversation:
   ```
   Help me create a presentation about [your topic]
   ```
4. Claude will generate a `.mu` file with ASCII layout
5. Review and iterate on the layout
6. Ask Claude to generate the final presentation images:
   ```
   Now generate presentation images based on this .mu file
   ```

**Option 2: Direct Chat**

1. In any Claude conversation, attach or paste the content of `SKILL.md`
2. Describe your presentation needs
3. Claude will generate the `.mu` layout
4. Request image generation for the final output

**Workflow Example**

```
You: I need a 5-slide presentation about our Q4 product roadmap.
     Include: overview, timeline, key features, team allocation, and Q&A.

Claude: [Generates .mu file with ASCII layout]

You: Make the timeline more visual, use arrows to show dependencies.

Claude: [Updates .mu file]

You: Perfect! Now generate the presentation images.

Claude: [Generates images for each slide]
```

### Using Mockup with VS Code

> 🚧 **Coming Soon**: VS Code extension for Mockup syntax highlighting and preview.
>
> Planned features:
> - Syntax highlighting for `.mu` files
> - Live preview panel
> - AI-powered generation and rendering via Claude integration
> - Export to common formats (PDF, PNG, PowerPoint)

For now, you can:
1. Create `.mu` files in VS Code with plain text editing
2. Use the ASCII box-drawing characters (see [mockup.md](./mockup.md))
3. Copy the content to Claude for image generation

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
