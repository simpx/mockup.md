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
4. Claude generates `.mu` → You refine → Claude renders

## Examples

| File | Description |
|------|-------------|
| [`intro.mu`](./examples/intro.mu) | Product introduction |
| [`tech-rfc.mu`](./examples/tech-rfc.mu) | Technical RFC |
| [`thesis-defense.mu`](./examples/thesis-defense.mu) | Thesis defense |
| [`mapreduce.mu`](./examples/mapreduce.mu) | Classic paper presentation |

## License

MIT
