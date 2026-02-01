# mockup.md <sub>v0.1.0</sub>

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

### Option 2: Claude Projects

For ongoing use in Claude web:

1. Create a new Claude Project
2. Add [mockup.md](./mockup.md) to Project Knowledge
3. Start chatting:
   - "Create slides about [topic]"
   - Or paste `.mu` files for rendering

### Option 3: Claude Code CLI

For terminal users:

```bash
git clone https://github.com/simpx/mockup.md.git
cp -rL mockup.md/.claude/skills/mockup ~/.claude/skills/
```

Claude Code will auto-recognize `.mu` files and mockup-related requests.

### What You Can Do

**Task A**: Describe your slides → AI generates `.mu` file
**Task B**: Provide `.mu` file → AI generates slide images

See [mockup.md](./mockup.md) for complete syntax reference and examples.

## Examples

| Example | Description |
|---------|-------------|
| [`00-mockup-intro`](./examples/00-mockup-intro/) | mockup.md self-introduction |
| [`01-airbnb-pitch-deck`](./examples/01-airbnb-pitch-deck/) | Classic 2009 startup pitch deck |
| [`02-raft-consensus`](./examples/02-raft-consensus/) | Distributed systems paper |
| [`03-bert-nlp`](./examples/03-bert-nlp/) | NLP/AI paper |
| [`04-spanner-distributed-db`](./examples/04-spanner-distributed-db/) | Distributed database paper |
| [`05-dynamo-kv-store`](./examples/05-dynamo-kv-store/) | Distributed KV store paper |

See [examples/README.md](./examples/README.md) for details.

## License

MIT
