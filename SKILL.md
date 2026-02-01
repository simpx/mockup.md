# Mockup Skill for Claude Projects

> **Note**: This file optimizes Claude Projects for Mockup workflows. For one-time use, copy [mockup.md](./mockup.md) into any AI chat — it contains both the specification and complete instructions.

## About This File

The [mockup.md](./mockup.md) file is a **self-contained prompt** with two sections:
1. **Format Specification** — Complete syntax reference and design principles
2. **AI Instructions** — Two tasks: generating `.mu` files from content, and generating images from `.mu` files

When you add mockup.md to a Claude Project, you get instant Mockup capability. **This SKILL.md file provides optimization hints for better performance.**

## When to Activate

Activate when the user:
- Requests slides
- Describes content for slides
- Provides `.mu` file content
- Asks to generate/render slide images

## Core Reference

**Always refer to [mockup.md](./mockup.md) for:**
- Complete syntax (boxes, layouts, arrows, text, graphics, annotations)
- Design principles (WYSIWYG, Intent-Driven, AI-Native)
- Task A: Generate `.mu` from descriptions
- Task B: Generate images from `.mu` files

## Key Optimization Tips

### General
- Both tasks are defined in mockup.md — read it to understand which task to perform
- Prioritize user intent over strict syntax adherence
- Use examples in [examples/](./examples) for reference when generating content

### Task A - Generating `.mu` Files
- Maximize ASCII art (charts, flowcharts, diagrams) — minimize annotations
- Each slide = one outermost box (60-72 chars wide recommended)
- Text position = alignment (left/center/right)
- Box hierarchy: `╔═╗` emphasis > `┌─┐` standard > `┌╌┐` secondary
- Include YAML frontmatter (title, author, theme) when appropriate

### Task B - Generating Images
- Preserve ASCII proportions exactly (WYSIWYG principle)
- Transform ASCII graphics into polished visuals
- Apply annotations for colors, animations, asset replacements
- Default style: clean, academic (white background, sans-serif, minimal colors)
- Output: 16:9 aspect ratio, 1920x1080 recommended
- Maintain consistency across all slides

## Examples

Reference these for layout patterns and complexity levels:
- [intro](./examples/intro/) — Product introduction (8 slides)
- [tech-rfc](./examples/tech-rfc/) — Technical RFC (6 slides)
- [thesis-defense](./examples/thesis-defense/) — Thesis defense (7 slides)
- [mapreduce](./examples/mapreduce/) — Classic paper (15 slides)
