# Philosophy.md - Claude Code Plugin

Install and customize coding philosophies from legendary developers and proven methodologies.

## Overview

The Philosophy.md plugin lets you:

- 📚 **Install** pre-made philosophies from 20+ legendary developers and methodologies
- 🎨 **Create** custom philosophies by blending multiple approaches through an interactive interview
- 💡 **Learn** from the wisdom of pioneers like John Carmack, Linus Torvalds, Martin Fowler, and more

## Installation

### Add the Marketplace

```bash
/plugin marketplace add bxm156/Philosophy.md
```

### Install the Plugin

```bash
/plugin install philosophy
```

That's it! The plugin is now ready to use.

## Available Commands

### `/philosophy:list`

Browse all available philosophies with descriptions.

```bash
/philosophy:list
```

Shows philosophies organized by category:

- **👤 People**: John Carmack, Linus Torvalds, Martin Fowler, Donald Knuth, and 16 more
- **📚 Methodologies**: TDD, Clean Code, Functional Programming, Conventional Commits
- **💻 Languages**: Python, Rust

### `/philosophy:install [name]`

Install a pre-made philosophy to your project.

```bash
/philosophy:install john_carmack
/philosophy:install tdd
/philosophy:install python
```

Creates `PHILOSOPHY.md` in your project root with the complete philosophy.

**Available Philosophies:**

**People:**

- `john_carmack` - Performance, Deep Understanding, and Relentless Optimization
- `linus_torvalds` - Pragmatic Systems Programming
- `martin_fowler` - Clean Code & Refactoring
- `donald_knuth` - Literate Programming & Correctness
- `rich_hickey` - Simplicity & Functional Design
- `guido_van_rossum` - Python's Benevolent Dictator
- `yukihiro_matsumoto` - Ruby's Principle of Least Surprise
- `dennis_ritchie` - C and Unix Philosophy
- `brian_kernighan` - Clear, Simple, Practical Code
- `ken_thompson` - Minimalism and Efficiency
- `rob_pike` - Simplicity and Clarity
- `larry_wall` - Perl's "There's More Than One Way"
- `brendan_eich` - JavaScript's Prototype-Based Design
- `james_gosling` - Java's "Write Once, Run Anywhere"
- `anders_hejlsberg` - C# and TypeScript Design
- `bjarne_stroustrup` - C++ Complexity Management
- `grace_hopper` - Pioneering Computer Science
- `ada_lovelace` - The First Programmer
- `margaret_hamilton` - Software Engineering Rigor
- `tim_berners_lee` - Web Standards and Openness

**Methodologies:**

- `tdd` - Test-Driven Development
- `clean_code` - Readability & Maintainability
- `functional_programming` - Immutability & Pure Functions
- `conventional_commits` - Clear Commit Messages

**Languages:**

- `python` - The Zen of Python
- `rust` - Safety & Performance

### `/philosophy:create`

Create a custom philosophy through an interactive interview.

```bash
/philosophy:create
```

**Process:**

1. **Select 2-4 philosophies** to blend (e.g., "John Carmack, TDD, Python")
2. **Answer interview questions** about your preferences:
   - Testing approach
   - Performance vs simplicity tradeoffs
   - Code style preferences
   - Development approach
3. **Get a custom blended philosophy** saved to `PHILOSOPHY.md`

**Example Output:**

```markdown
# Custom Philosophy: Test-Driven Performance with Pragmatic Python

This philosophy blends:
- 40% Test-Driven Development (TDD)
- 35% John Carmack's Performance Philosophy
- 25% Python's Zen

## Core Principles

### 1. Test-Driven Performance
Write tests first, but profile and optimize bottlenecks ruthlessly...
```

## What Gets Created

After running `/philosophy:install` or `/philosophy:create`, you'll have:

```text
your-project/
├── PHILOSOPHY.md          # ✅ Your coding philosophy
├── src/
├── tests/
└── ...
```

The philosophy file stays in your project root, providing guidance whenever you need it.

## Example Workflows

### Quick Start with a Pre-Made Philosophy

```bash
# Browse options
/philosophy:list

# Install TDD philosophy
/philosophy:install tdd

# Start coding with TDD principles!
```

### Create a Custom Blend

```bash
# Start the interview
/philosophy:create

# Select philosophies
> John Carmack, TDD, Python

# Answer questions
Q: How do you prefer to test code?
A: Write tests first (TDD)

Q: When there's a tradeoff between performance and simplicity:
A: Balanced - profile then optimize

# Get your custom philosophy
✅ Custom philosophy created and saved to PHILOSOPHY.md!
```

### Switch Philosophies

```bash
# Try a different philosophy
/philosophy:install martin_fowler

# Your PHILOSOPHY.md is now updated to Martin Fowler's approach
```

## Philosophy Sources

All philosophies are sourced from:

- Public writings and talks by the developers
- Official language documentation (PEPs, RFCs, etc.)
- Widely-accepted best practices and methodologies
- Historical context and real-world impact

Each philosophy includes:

- Overview and background
- Core principles with examples
- Practices and patterns
- Anti-patterns to avoid
- Key resources and references

## Use Cases

- **Personal Development**: Adopt proven practices from industry legends
- **Team Alignment**: Establish shared coding values and standards
- **Learning**: Study different approaches to software development
- **Decision Making**: Reference philosophy when making architectural choices
- **Code Reviews**: Use philosophy as objective criteria for feedback
- **Onboarding**: Help new team members understand project values

## Future Enhancements

See [TODO.md](TODO.md) for planned features:

- CLAUDE.md integration for AI-powered guidance
- Project-specific application and tooling integration
- Pre-commit hooks and philosophy enforcement
- Team collaboration features
- Community philosophy sharing
- And much more!

## Contributing

Found a typo in a philosophy? Want to add a new one? Contributions welcome!

1. Fork the repository: <https://github.com/bxm156/Philosophy.md>
2. Make your changes
3. Submit a pull request

## License

MIT License - See repository for details.

## Links

- **Repository**: <https://github.com/bxm156/Philosophy.md>
- **Issues**: <https://github.com/bxm156/Philosophy.md/issues>
- **Claude Code Docs**: <https://docs.claude.com/en/docs/claude-code/plugins>

---

**Philosophy**: Simple, working, ship it! 🚀

*Install a philosophy today and code with purpose.*