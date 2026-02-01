---
name: mockup
description: |
  Activate when encountering:
  - Files with .mu extension
  - Code blocks marked with ```mu```
  - User requests for slides, presentations, or diagrams
  - User wants to convert PDF/webpage content to slides
user-invocable: false
---

# Mockup Format Knowledge

You understand **Mockup**, an ASCII-based layout description language for slides. Files use `.mu` extension, or embed in Markdown with ` ```mu ``` ` blocks.

## Core Reference

**IMPORTANT**: Before performing any mockup-related task, read the complete specification in the same directory as this skill:

```
mockup.md (in this skill directory)
```

This file contains:
- Full syntax (boxes, layouts, arrows, text, graphics, annotations)
- Design principles (WYSIWYG, Intent-Driven, AI-Native)
- Task A: Generate `.mu` from descriptions
- Task B: Generate images from `.mu` files

Always read `mockup.md` first when working with mockup content.

## Quick Syntax Reference

```
Box Types:
┌─┐ standard   ╔═╗ emphasis   ┌╌┐ secondary   ╭─╮ rounded

Layout:
┌───┬───┐  horizontal split    ┌───┐
│   │   │                      ├───┤  vertical split
└───┴───┘                      └───┘

Arrows: → ← ↑ ↓ ↗ ↘ ↙ ↖  ───→

Markers: ①②③④⑤⑥⑦⑧⑨⑩

Annotations (lines starting with >):
> ① color: red
> background: dark-blue
> ① replace with: photo.jpg
```

## Your Capabilities

1. **Discuss mockup format** - Explain syntax, answer questions, suggest improvements
2. **Generate .mu files** - Create slides from user descriptions or requirements
3. **Convert content to mockup** - Read PDFs or webpages and generate .mu slides
4. **Review mockup files** - Provide feedback on existing .mu content

## Key Principles

- **WYSIWYG**: Box position = element position, box size = element size
- **ASCII-first**: Prefer ASCII graphics over annotations for charts, flowcharts, UI mockups
- **Intent-Driven**: Focus on content and layout, not pixel-perfect positioning
- Recommended slide width: 60-72 characters

## Examples

Reference `examples/` directory for complete samples:
- `00-mockup-intro/` - mockup.md self-introduction
- `01-airbnb-pitch-deck/` - Classic 2009 startup pitch deck
- `02-raft-consensus/` - Distributed systems paper (Raft)
- `04-spanner-distributed-db/` - Distributed database paper (Spanner)

---

# About This Skill (Meta)

This repository (`mockup.md`) is the definition repo for the Mockup format. This skill file itself serves as an example of how to create Claude Code skills.

## How to Add Mockup Knowledge to Claude Code

```bash
git clone https://github.com/simpx/mockup.md.git
cp -rL mockup.md/.claude/skills/mockup ~/.claude/skills/
```

(`-rL` follows symlinks, copying actual file content)

The skill auto-activates when Claude encounters `.mu` files or related requests.

## Skill File Format

```yaml
---
name: skill-name
description: When to activate this skill
user-invocable: false  # true for /commands, false for background knowledge
---

Markdown instructions for Claude...
```

Key frontmatter fields:
- `name` - Becomes `/name` if user-invocable
- `description` - Tells Claude when to auto-activate
- `user-invocable` - `false` for background knowledge, `true` for slash commands
- `disable-model-invocation` - Set `true` to prevent auto-activation (manual only)
