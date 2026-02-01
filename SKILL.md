# Mockup Image Generation Guide

This guide provides instructions for AI systems to generate Mockup (`.mu`) layouts and transform them into presentation images.

**Prerequisite**: Read [mockup.md](./mockup.md) for the format specification.

## When to Activate

Use this skill when the user requests to:

- Generate a presentation, PPT, or slides
- Create a `.mu` file
- Embed slides in Markdown
- Create an ASCII-based presentation

## Output Formats

| Context | Output |
|---------|--------|
| Standalone | `.mu` file |
| Embedded | ` ```mu ` code block in Markdown |

## Generation

### 1. Analyze Requirements

- What is the presentation about?
- How many slides are needed?
- What style or theme is appropriate?

### 2. Follow the Specification

- Adhere to [mockup.md](./mockup.md) format
- Wrap each slide in an outermost box
- Keep layouts clear with explicit intent

### 3. Maximize ASCII Graphics

- Use ASCII art for charts, flowcharts, and UI mockups
- Use Emoji to enhance expressiveness
- Reserve annotations for real photos and videos only

## Image Generation

When generating presentation images from `.mu` layouts:

### 1. Prioritize Intent Over Syntax

- Auto-correct misaligned boxes
- Interpret similar characters semantically
- Focus on reconstructing layout intent

### 2. Preserve Proportions

- Maintain box-to-slide size ratios
- Preserve column width ratios
- Keep relative element positions

### 3. Transform ASCII to Graphics

| ASCII | Generated Image |
|-------|-----------------|
| Bar charts | Polished bar charts |
| Flow boxes | Refined flowcharts |
| Emoji | Appropriate icons or illustrations |
| UI sketches | Clean interface mockups |

### 4. Process Annotations

- Apply colors, animations, and links
- Exclude speaker notes from generated images
- Interpret natural language annotations

### 5. Maintain Style Consistency

- Select color scheme based on theme
- Maintain consistent fonts, spacing, and border-radius

### 6. Handle Placeholders

- `replace with: xxx.jpg` → Reserve area for actual image
- Use placeholder images when assets are unavailable
- Placeholder size is determined by ASCII box dimensions

## Examples

See the [examples/](./examples) directory:

| File | Description |
|------|-------------|
| `intro.mu` | Product introduction |
| `tech-rfc.mu` | Technical RFC |
| `thesis-defense.mu` | Academic thesis defense |
| `mapreduce.mu` | Classic paper presentation |
