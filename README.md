# mockup.md

**The Markdown for slides.**

Sketch ideas and layout. AI does the rest.

```mu
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                       **mockup.md**                            │
│                   The Markdown for slides                      │
│                                                                │
│   ┌────────────┐      ┌────────────┐      ┌────────────┐      │
│   │            │      │            │      │            │      │
│   │  💭 Your   │  ──→ │  📝 .mu    │  ──→ │  🎨 Slide  │      │
│   │   ideas    │      │   file     │      │   images   │      │
│   │            │      │            │      │            │      │
│   └────────────┘      └────────────┘      └────────────┘      │
│                                                                │
│        Describe      AI generates      AI renders             │
│        content       ASCII layout      polished slides         │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

## The Problem

Making slides is painful. Traditional tools make you juggle content, layout, and styling — exhausting. AI-generated slides give random, inconsistent results — frustrating. AI-generated formats (Mermaid, DrawIO) aren't visual enough, hard to edit and version.

**Mockup: sketch in ASCII, render with AI. Simple, predictable, visual.**

## Why Mockup

- **Markdown solved writing** — Focus on content, let the formatter handle typography
- **Mockup solves slides** — Focus on content and layout, let AI handle styling and rendering

Design principles: WYSIWYG, Intent-Driven, AI-Native. See [mockup.md](./mockup.md) for details.

## Usage

### Option 1: Copy-Paste (Any AI)

For one-time use with any AI (Claude, ChatGPT, Gemini, etc.):

1. Copy the entire [mockup.md](./mockup.md) file
2. Paste it into your AI chat
3. Then either:
   - Describe your slides: `"I need a 5-slide deck about [topic]"`
   - Or provide `.mu` content: `"Generate images from this .mu file: [paste content]"`

The AI will understand both tasks from mockup.md's built-in instructions.

### Option 2: Claude Projects (Recommended)

For ongoing use:

1. Create a new Claude Project
2. Add [mockup.md](./mockup.md) to Project Knowledge (required)
3. Optionally add [SKILL.md](./SKILL.md) for optimization
4. Start chatting:
   - "Create slides about [topic]"
   - Or paste `.mu` files for rendering

The AI will automatically recognize both tasks.

### What You Can Do

**Task A**: Describe your slides → AI generates `.mu` file
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
