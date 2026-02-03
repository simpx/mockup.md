# 🔲 mockup.md

**The Layout Control Language for Human-AI Collaboration.**

When humans collaborate with AI on visual layouts, there's a gap between intent and output. Mockup bridges that gap with a human-readable, AI-parseable intermediate representation.

**Current focus: slides.** Sketch in ASCII, render with AI.

```mu
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│   ┌────────────┐      ┌────────────┐      ┌────────────┐      │
│   │            │      │            │      │            │      │
│   │  💭 Your   │  ──→ │  🔲 .mu    │  ──→ │  🎨 Final  │      │
│   │   intent   │      │   file     │      │   output   │      │
│   │            │      │            │      │            │      │
│   └────────────┘      └────────────┘      └────────────┘      │
│                                                                │
│      Describe        ASCII layout         AI renders          │
│      what you want   as skeleton          polished visuals    │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

## The Problem

When humans collaborate with AI on visual outputs, there's a control problem. Pure text prompts give inconsistent, unpredictable layouts. Precise formats (JSON, XML) are unreadable and hard to edit. WYSIWYG tools don't integrate with AI workflows.

**The missing layer**: a human-readable, AI-parseable intermediate representation for layout — like ControlNet uses edge maps to guide image generation, but for structured visual content.

## Why Mockup

- **Human-readable** — ASCII art is visual and intuitive, anyone can sketch and edit
- **AI-parseable** — Clear structure that any LLM can understand and generate
- **Version-control friendly** — Plain text diffs, easy to track changes
- **Intent over precision** — Define what goes where, let AI handle the aesthetics

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
