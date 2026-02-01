# 📊 mockup.md

**The Markdown for slides.**

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

### Option 2: Claude Code CLI

For terminal users:

```bash
mkdir -p ~/.claude/skills/mockup
curl -o ~/.claude/skills/mockup/SKILL.md https://raw.githubusercontent.com/simpx/mockup.md/main/.claude/skills/mockup/SKILL.md
curl -o ~/.claude/skills/mockup/mockup.md https://raw.githubusercontent.com/simpx/mockup.md/main/mockup.md
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
| [`03-transformer`](./examples/03-transformer/) | Attention is All You Need (Google 2017) |
| [`04-spanner-distributed-db`](./examples/04-spanner-distributed-db/) | Distributed database paper |
| [`05-gfs`](./examples/05-gfs/) | Google File System (SOSP 2003) |

See [examples/README.md](./examples/README.md) for details.

## License

MIT
