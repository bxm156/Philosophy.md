# AGENTS.md: The README for AI Coding Agents

## Overview

**Project**: [openai/agents.md](https://github.com/openai/agents.md)
**Website**: https://agents.md
**Launched**: July 2025
**Adoption**: 20,000+ GitHub repositories

AGENTS.md is a simple, open format for guiding coding agents. Think of it as a README for agents—a dedicated, predictable place to provide the context and instructions to help AI coding agents work on your project.

**Source**: [Research AIMult](https://research.aimultiple.com/agents-md/)

## Philosophy and Positioning

### Core Concept

"README.md files are for humans: quick starts, project descriptions, and contribution guidelines. AGENTS.md complements this by containing the extra, sometimes detailed context coding agents need: build steps, tests, and conventions that might clutter a README or aren't relevant to human contributors."

### Key Differentiators

1. **Simplicity First**: Just standard Markdown, no special syntax or complex schema
2. **Tool Agnostic**: Works with any AI coding agent that can read Markdown
3. **Human Readable**: Can be understood and edited by developers without special tools
4. **Minimal Standard**: Deliberately lightweight to encourage broad adoption

## How It Works

### File Structure

- **Location**: Root of repository or home directory
- **Format**: Standard Markdown
- **Parsing**: Agents parse as natural language instructions
- **Hierarchy**: Closest AGENTS.md to edited file wins; explicit user chat prompts override everything

### Example Content

```markdown
# Development Environment

## Setup
Run `pnpm install` to install dependencies.

## Testing
- Run `pnpm test` for unit tests
- Run `pnpm test:e2e` for end-to-end tests

## Code Conventions
- Use TypeScript strict mode
- Prefer functional components over class components
- Follow existing file structure for new features

## Pull Request Instructions
- Ensure all tests pass before submitting
- Update documentation if adding new features
- Use conventional commit messages
```

**Source**: [GitHub - openai/agents.md](https://github.com/openai/agents.md)

## Collaborative Origins

AGENTS.md emerged from collaborative efforts across the AI software development ecosystem, including:
- **OpenAI Codex**
- **Amp**
- **Jules from Google**
- **Cursor**
- **Factory**

This collaborative approach helped ensure the standard would be widely supported from launch.

**Source**: [InfoQ - AGENTS.md Emerges as Open Standard](https://www.infoq.com/news/2025/08/agents-md/)

## Supported Tools

Compatible with:
- GitHub Copilot
- Cursor
- OpenAI Codex
- Google Jules
- Aider
- Factory
- Other major AI coding platforms

## Why It Succeeds

### 1. Solves Real Problem

Before AGENTS.md, developers maintained separate configuration files for each AI tool:
- `.cursorrules`
- `.windsurfrules`
- `CLAUDE.md`
- `.aiderules`
- Tool-specific configs

**AGENTS.md consolidates these into one standard file.**

### 2. Low Barrier to Entry

- No special syntax to learn
- No configuration required
- Just write natural language instructions
- Standard Markdown formatting

### 3. Broad Industry Support

By involving multiple tool vendors from the start, AGENTS.md avoided the "competing standards" problem. Major tools committed to support before launch.

### 4. Complements Existing Practices

Rather than replacing README.md or other documentation, AGENTS.md sits alongside as an additional resource specifically for AI agents.

### 5. Version Controlled

Since it's just a Markdown file, AGENTS.md:
- Lives in version control with code
- Can be reviewed in pull requests
- Evolves with the project
- Provides audit trail of changes

## Best Practices from the Community

### What to Include

**Build and Test Commands**:
```markdown
## Commands
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`
```

**Architecture Overview**:
```markdown
## Architecture
- Frontend: React with TypeScript
- Backend: Node.js Express API
- Database: PostgreSQL with Prisma ORM
```

**Code Conventions**:
```markdown
## Conventions
- Use arrow functions for components
- File names: kebab-case for files, PascalCase for components
- Test files: `*.test.ts` alongside source
```

**Security Considerations**:
```markdown
## Security
- Never commit API keys or secrets
- Use environment variables for configuration
- Validate all user inputs
```

### What NOT to Include

- Sensitive information (API keys, credentials)
- Extremely detailed documentation (link to docs instead)
- Human-facing tutorials (keep in README.md)
- Rarely-changed context (becomes noise)

**Source**: [Builder.io - AGENTS.md Best Tips](https://www.builder.io/blog/agents-md)

## Integration Patterns

### Local Development

Place AGENTS.md in project root:
```
/myproject/
├── AGENTS.md
├── README.md
├── package.json
└── src/
```

### Global Defaults

Place AGENTS.md in home directory for default behavior across all projects:
```
~/.agents.md  # or ~/.config/agents.md
```

### Monorepo Support

AGENTS.md at root applies to whole monorepo, package-level AGENTS.md files provide package-specific context:
```
/monorepo/
├── AGENTS.md           # Monorepo-wide
├── packages/
│   ├── frontend/
│   │   └── AGENTS.md   # Frontend-specific
│   └── backend/
│       └── AGENTS.md   # Backend-specific
```

## Comparison to Other Approaches

| Aspect | AGENTS.md | .cursorrules | CLAUDE.md | GitHub Copilot Instructions |
|--------|-----------|--------------|-----------|----------------------------|
| **Format** | Markdown | Markdown | Markdown | Markdown |
| **Scope** | All AI agents | Cursor only | Claude Code only | GitHub Copilot only |
| **Standard** | Emerging standard | Tool-specific | Tool-specific | GitHub-specific |
| **Adoption** | 20,000+ repos | Thousands | Growing | Built-in feature |
| **Interoperability** | High | Low | Low | Medium |

## Success Metrics

### Adoption Rate
- **20,000+ repositories** on GitHub within months of launch
- Growing at estimated 1,000+ repos per week
- Major open-source projects adopting

### Tool Support
- Support announced by 6+ major AI coding tools
- More tools adding support continuously
- Becoming de facto standard

### Community Engagement
- Active discussions on GitHub
- Community-contributed examples
- Documentation and tutorials appearing
- Conference talks and blog posts

## Lessons for Philosophy.md

### What Philosophy.md Can Adopt

1. **Simplicity**: Keep format simple and accessible
2. **Markdown-based**: Use standard Markdown for compatibility
3. **Clear purpose**: Solve specific problem (guiding AI on coding philosophies)
4. **Tool agnostic**: Work with multiple AI agents
5. **Version controlled**: Live in repository alongside code
6. **Complementary**: Don't replace existing docs, augment them

### What to Do Differently

1. **Specialized focus**: While AGENTS.md is general, Philosophy.md focuses on coding philosophies
2. **Educational content**: Philosophy.md provides learning resources, not just project config
3. **Templates and examples**: Provide rich examples for different languages/frameworks
4. **Community knowledge**: Aggregate philosophy knowledge from the community
5. **Integration guidance**: Help teams decide which philosophies apply to their context

### Differentiation Strategy

**AGENTS.md** tells AI agents *how* to work on your project (commands, conventions, structure).

**Philosophy.md** tells AI agents *why* and *what principles* to follow (design patterns, architectural decisions, coding philosophy).

They're complementary:
- AGENTS.md: "Use `npm test` to run tests"
- Philosophy.md: "We follow TDD because it catches bugs early and documents behavior"

## Realistic Scenarios

### Scenario 1: Startup Using Multiple AI Tools

**Problem**: Team uses Cursor, GitHub Copilot, and Claude Code. Each developer has different AI preferences. Code quality inconsistent.

**Solution**: Adopt AGENTS.md for project commands and Philosophy.md for design principles.

**Result**: All AI tools now follow same build commands (AGENTS.md) and coding principles (Philosophy.md), regardless of which AI developer uses.

### Scenario 2: Open Source Project

**Problem**: Contributors use different AI tools. Need consistent contribution quality. Documentation is scattered.

**Solution**: Add AGENTS.md with contribution workflow and Philosophy.md with project philosophy and patterns.

**Result**: New contributors' AI assistants automatically learn project conventions and philosophy. Contribution quality improves. Less back-and-forth in code review.

### Scenario 3: Enterprise Migration

**Problem**: Company migrating from monolith to microservices. Need consistent architectural principles across teams.

**Solution**: Create Philosophy.md documenting microservice principles, patterns, and anti-patterns. Reference from AGENTS.md.

**Result**: AI agents help developers follow consistent patterns across services. Architecture decisions documented and enforced through AI assistance.

## References

1. GitHub. "openai/agents.md." https://github.com/openai/agents.md
2. AGENTS.md Official Site. https://agents.md
3. Research AIMult. "Agents.md: The README for Your AI Coding Agents." https://research.aimultiple.com/agents-md/
4. InfoQ. "AGENTS.md Emerges as Open Standard for AI Coding Agents." https://www.infoq.com/news/2025/08/agents-md/
5. Builder.io. "Improve your AI code output with AGENTS.md (+ my best tips)." https://www.builder.io/blog/agents-md
6. AI Plain English. "Agents.md: A Comprehensive Guide to Agentic AI Collaboration." https://ai.plainenglish.io/agents-md-a-comprehensive-guide-to-agentic-ai-collaboration-571df0e78ccc
7. Factory Documentation. "AGENTS.md." https://docs.factory.ai/cli/configuration/agents-md
