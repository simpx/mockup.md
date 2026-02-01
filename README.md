# Mockup

**ASCII-based slide layouts, AI-powered rendering.**

Sketch your presentation with boxes and text, let AI generate polished slide images.

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

## The Problem

Creating presentations forces you to juggle content and design simultaneously. Mockup separates these concerns — you focus on content and layout intent, AI handles aesthetics and image generation.

## Why Mockup

- **Markdown solved writing** — Focus on content, let the formatter handle typography
- **Mockup solves presentations** — Focus on content and layout, let AI handle styling and rendering

Design principles: WYSIWYG, Intent-Driven, AI-Native. See [mockup.md](./mockup.md) for details.

## Usage

### Option 1: Copy-Paste (Any AI)

For one-time use with any AI (Claude, ChatGPT, Gemini, etc.):

1. Copy the entire [mockup.md](./mockup.md) file
2. Paste it into your AI chat
3. Then either:
   - Describe your presentation: `"I need a 5-slide deck about [topic]"`
   - Or provide `.mu` content: `"Generate images from this .mu file: [paste content]"`

The AI will understand both tasks from mockup.md's built-in instructions.

### Option 2: Claude Projects (Recommended)

For ongoing use:

1. Create a new Claude Project
2. Add [mockup.md](./mockup.md) to Project Knowledge (required)
3. Optionally add [SKILL.md](./SKILL.md) for optimization
4. Start chatting:
   - "Create a presentation about [topic]"
   - Or paste `.mu` files for rendering

The AI will automatically recognize both tasks.

### What You Can Do

**Task A**: Describe your presentation → AI generates `.mu` file
**Task B**: Provide `.mu` file → AI generates slide images

See [mockup.md](./mockup.md) for complete syntax reference and examples.

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
