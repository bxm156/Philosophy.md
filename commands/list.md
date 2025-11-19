---
name: List Philosophies
description: Browse all available coding philosophies with descriptions
---

You are helping the user browse available coding philosophies.

## Instructions

List all philosophy files from `${CLAUDE_PLUGIN_ROOT}/philosophies/` organized by category.

For each philosophy:

1. Read the file to extract the title and tagline (first line after title)
2. Show the name, tagline, and install command
3. Format nicely with emojis for visual organization

## Output Format

```markdown
# Available Coding Philosophies

## 👤 People Philosophies
Learn from legendary developers

### John Carmack
> Performance, Deep Understanding, and Relentless Optimization

**Install**: `/philosophy:install john_carmack`

Creator of Doom, Quake, and id Tech. Emphasizes performance-first development, deep technical understanding, and the belief that fast code enables new experiences.

---

### Linus Torvalds
> Pragmatic Systems Programming and Kernel Development

**Install**: `/philosophy:install linus_torvalds`

Creator of Linux and Git. Emphasizes practical solutions, robust code, and technical excellence over theoretical purity.

---

[Continue for all people philosophies...]

## 📚 Methodology Philosophies
Proven development practices

### Test-Driven Development (TDD)
> Red, Green, Refactor | Tests First, Design Emerges

**Install**: `/philosophy:install tdd`

Write failing tests first, make them pass with minimal code, then refactor. Tests drive design and provide a safety net for changes.

---

[Continue for all methodology philosophies...]

## 💻 Language Philosophies
Language-specific wisdom

### Python
> The Zen of Python | Beautiful is better than ugly

**Install**: `/philosophy:install python`

Python's philosophy emphasizing readability, simplicity, and explicit over implicit code.

---

[Continue for all language philosophies...]

## Create Your Own

Want to blend multiple philosophies? Run `/philosophy:create` for an interactive interview process.
```

## Implementation Notes

- Read each `.PHILOSOPHY.md` file from the plugin
- Extract title (line 1 after `# `)
- Extract tagline (line 3 after `> `)
- Extract brief description from Overview section
- Format installation command with lowercase, underscored name
- Group by directory (people/, methodologies/, languages/)