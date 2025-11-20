# Philosophy.md - Claude Code Plugin

Install and customize coding philosophies from legendary developers and proven methodologies.

## Installation

```bash
/plugin marketplace add bxm156/Philosophy.md
/plugin install philosophy
```

## Commands

### `/philosophy:list`

Browse all available philosophies (20+ developers, methodologies, and languages).

### `/philosophy:install [name]`

Install a pre-made philosophy to `PHILOSOPHY.md` in your project root.

```bash
/philosophy:install john_carmack
/philosophy:install tdd
/philosophy:install python
```

**Available Philosophies:**

**People:** `john_carmack`, `linus_torvalds`, `martin_fowler`, `donald_knuth`, `rich_hickey`, `guido_van_rossum`, `yukihiro_matsumoto`, `dennis_ritchie`, `brian_kernighan`, `ken_thompson`, `rob_pike`, `larry_wall`, `brendan_eich`, `james_gosling`, `anders_hejlsberg`, `bjarne_stroustrup`, `grace_hopper`, `ada_lovelace`, `margaret_hamilton`, `tim_berners_lee`

**Methodologies:** `tdd`, `clean_code`, `functional_programming`, `conventional_commits`

**Languages:** `python`, `rust`

### `/philosophy:create-custom`

Create a custom blended philosophy through an interactive interview. Select 2-4 philosophies to blend and answer questions about your preferences.

### `/philosophy:quick-check`

Fast philosophy alignment check of recent changes (<2 minutes). Get an alignment score with personality-driven feedback from your philosophy's legendary developer.

### `/philosophy:review-pr`

Comprehensive philosophy-based PR review (5-10 minutes). Detailed analysis with specific quotes and actionable suggestions.

## Features

- 🎭 **Personality-driven feedback** - Quotes from Carmack, Torvalds, Fowler, and more
- ⚡ **Real-time guidance** - Philosophy Guardian skill while you code
- 🔍 **Review gates** - Philosophy Reviewer skill for code reviews
- 🚀 **Automated hooks** - Session reminders and contextual wisdom

## Philosophy Sources

All philosophies sourced from public writings, talks, official documentation, and widely-accepted best practices. Each includes core principles, examples, patterns, anti-patterns, and references.

## Use Cases

- Adopt proven practices from industry legends
- Establish shared team coding standards
- Study different development approaches
- Reference philosophy for architectural decisions
- Use as objective code review criteria
- Onboard new team members with project values

## Known Limitations

Current commands work perfectly (prompt-based). Some future features requiring script execution are blocked by [Claude Code issue #9354](https://github.com/anthropics/claude-code/issues/9354) (`${CLAUDE_PLUGIN_ROOT}` not working in command markdown files). See [TODO.md](TODO.md) for planned enhancements.

## Contributing

Contributions welcome! Fork the repo, make changes, submit a PR.

**Repository**: <https://github.com/bxm156/Philosophy.md>
**License**: MIT

---

*Simple, working, ship it! 🚀*