# Mockup Skill for Claude Projects

> **Note**: This file is optimized for Claude Projects. For one-time use, simply copy [mockup.md](./mockup.md) into any AI chat.

## When to Activate

Activate this skill when the user requests to:
- Generate a presentation, PPT, or slides
- Create a `.mu` file
- Generate images from `.mu` content

## Core Instructions

**Read [mockup.md](./mockup.md) for the complete format specification.**

This file contains:
- Full syntax reference (boxes, layouts, graphics, annotations)
- Design principles (WYSIWYG, Intent-Driven, Syntax-Tolerant)
- Usage instructions for both tasks:
  - Task A: Generate `.mu` from content descriptions
  - Task B: Generate images from `.mu` files

## Key Reminders for Claude

### When Generating `.mu` Files:
- Use the outermost box to define each slide
- Recommended width: 60–72 characters (16:9 ratio)
- Position = alignment (left/center/right)
- Prefer ASCII graphics over annotations
- Add metadata (title, author, theme) when appropriate

### When Generating Images:
- Preserve proportions from ASCII layout
- Box hierarchy: `╔═╗` (emphasis) > `┌─┐` (standard) > `┌╌┐` (secondary)
- Transform ASCII charts into polished graphics
- Process annotations for styling (colors, animations)
- Output: 16:9 aspect ratio, high resolution (1920x1080)
- Maintain consistent style throughout

## Examples

See [examples/](./examples) directory for reference:
- `intro/` - Product introduction
- `tech-rfc/` - Technical RFC
- `thesis-defense/` - Academic presentation
- `mapreduce/` - Paper presentation

## Output Formats

| Context | Output |
|---------|--------|
| Standalone request | `.mu` file |
| Embedded in Markdown | ` ```mu ` code block |
| Image generation | High-quality PNG/JPEG images |
