# Agent Rules: Community Standard for AI Coding Agents

## Overview

**Project**: [agent-rules/agent-rules](https://github.com/agent-rules/agent-rules)
**Website**: https://agent-rules.org (https://aicodingrules.org)
**Status**: Emerging community standard
**Inspiration**: EditorConfig, Semantic Versioning, Conventional Commits

Agent Rules is a community standard for unifying guidelines for AI coding agents via standard configuration files, promoting interoperability across tools.

## Philosophy

### Core Principle

"AI coding agents often rely on project-specific rules to guide their behavior. However, each tool uses its own configuration files, leading to redundancy and complexity. Agent Rules addresses this by proposing a unified configuration file."

### Deliberately Lightweight

The specification is deliberately lightweight, focusing on natural language in Markdown, to encourage broad support and interoperability. The goal is minimum viable interoperability, not maximum features.

## Specification

### File Format

**File Name**: `AGENTS.md`

**Location**: Project root (repository root directory)

**Format**: The file MUST be parsed as natural language instructions, in Markdown or plain text

**Purpose**: MUST be used to provide guidance to AI coding agents (e.g., rules, preferences, or workflows)

### Implementation Requirements

Agents implementing Agent Rules:
- MUST check for the existence of AGENTS.md in the project root
- MUST parse the file as natural language instructions
- SHOULD prioritize AGENTS.md instructions over default behaviors
- MAY support additional configuration mechanisms

## Differentiation from Other Standards

| Feature | Agent Rules | AGENTS.md (OpenAI) | .cursorrules |
|---------|-------------|-------------------|--------------|
| **Governance** | Community-driven | Company-backed | Tool-specific |
| **Scope** | Standard specification | Implementation & standard | Cursor IDE only |
| **Flexibility** | Minimal requirements | Suggested structure | Tool-defined |
| **Philosophy** | Like EditorConfig | Like README | IDE configuration |

## Tool Support Proposals

Multiple tools have open proposals to support Agent Rules:

### Confirmed/Proposed Support
- **Cline** ([Issue #5033](https://github.com/cline/cline/issues/5033))
- **Continue** ([Issue #6716](https://github.com/continuedev/continue/issues/6716))
- **Roo Code** ([Discussion #5967](https://github.com/RooCodeInc/Roo-Code/discussions/5967))
- **Kilo Code** ([Discussion #1412](https://github.com/Kilo-Org/kilocode/discussions/1412))
- **OpenAI Codex** ([Issue #1624](https://github.com/openai/codex/issues/1624))

### Why Tools Are Adopting

1. **Interoperability**: One file works across all tools
2. **User experience**: Developers don't maintain multiple configs
3. **Industry alignment**: Following emerging best practices
4. **Community demand**: Developers requesting standardization

## Success Factors

### 1. Bottom-Up Community Approach

Unlike company-led initiatives, Agent Rules is community-driven:
- Open governance model
- Community contributions welcome
- No single company controls specification
- Democratic evolution

### 2. Inspired by Proven Standards

Learning from successful standards:
- **EditorConfig**: Simple, widely adopted configuration
- **Semantic Versioning**: Clear, unambiguous specification
- **Conventional Commits**: Community consensus around practice

### 3. Minimal Viable Standard

Intentionally simple specification:
- Easy to implement
- Low barrier to compliance
- Room for tool-specific extensions
- Natural language focus

### 4. Addresses Real Pain Point

Developers managing:
- `.cursorrules`
- `.windsurfrules`
- `CLAUDE.md`
- `.aiderules`
- Tool-specific configs

**Agent Rules consolidates configuration burden.**

## Implementation Patterns

### Basic Implementation

```markdown
# Project: MyApp

## Architecture
This is a React TypeScript application using Vite for builds.

## Development
- Use `npm run dev` for development server
- Use `npm test` for running tests
- Use `npm run build` for production build

## Code Style
- Prefer functional components
- Use TypeScript strict mode
- Follow existing patterns in codebase
```

### Advanced Implementation

```markdown
# Agent Rules for Enterprise Project

## Context
Legacy Java application being modernized to microservices architecture.

## Architectural Principles
1. Each microservice should be independently deployable
2. Use hexagonal architecture pattern
3. Domain-driven design for bounded contexts

## Technology Stack
- Java 17 with Spring Boot 3.x
- PostgreSQL for relational data
- Kafka for event streaming
- Docker for containerization

## Coding Standards
- Follow Google Java Style Guide
- Minimum 80% test coverage
- All public APIs must have Javadoc

## Security
- Never log sensitive data
- All inputs must be validated
- Use parameterized queries for database access
```

## Positioning vs. AGENTS.md

### Relationship

Agent Rules is **both**:
1. A **community standard specification** defining how agents should behave
2. An **implementation** using AGENTS.md file format

### Key Difference

- **AGENTS.md (OpenAI)**: Specific file format promoted by OpenAI and partners
- **Agent Rules**: Community specification that happens to use AGENTS.md format

Think of it as:
- **AGENTS.md**: The "what" (file format and structure)
- **Agent Rules**: The "why" and "how" (community governance and specification)

## Adoption Strategy

### Phase 1: Specification (Current)
- Define minimal standard
- Publish specification
- Gather community feedback

### Phase 2: Tool Support
- Engage with tool maintainers
- Submit proposals and PRs
- Document implementations

### Phase 3: Community Growth
- Build example repositories
- Create documentation
- Promote adoption
- Measure success

## Lessons for Philosophy.md

### What to Adopt from Agent Rules

1. **Community governance**: Not owned by single company
2. **Minimal specification**: Easy to implement and adopt
3. **Clear documentation**: Well-defined standard
4. **Proven inspiration**: Learn from successful standards
5. **Open contribution**: Welcome community input

### How to Differentiate

**Agent Rules** focuses on **project configuration** (how to build, test, conventions).

**Philosophy.md** focuses on **coding philosophy** (why we code this way, design principles, architectural patterns).

**Complementary relationship**:
- Agent Rules/AGENTS.md: "Use Jest for testing"
- Philosophy.md: "We practice TDD because it produces better designs and documentation"

### Positioning Strategy

Philosophy.md should:
1. **Reference Agent Rules**: "Philosophy.md complements AGENTS.md by providing philosophical context"
2. **Work together**: Can be used alongside AGENTS.md
3. **Different purpose**: Educational and philosophical vs. configurational
4. **Cross-reference**: Philosophy.md can reference specific practices defined in AGENTS.md

## Realistic Scenarios

### Scenario 1: Solo Developer Learning

**Situation**: New developer learning microservices patterns.

**Without Standards**:
- Creates microservices inconsistently
- AI agents give generic advice
- Patterns differ across services

**With Agent Rules + Philosophy.md**:
- AGENTS.md: Defines build commands and project structure
- Philosophy.md: Explains microservice patterns and when to use them
- AI agents provide consistent, context-aware suggestions

**Result**: Faster learning, consistent implementation.

### Scenario 2: Team Onboarding

**Situation**: New team member joining established project.

**Traditional Approach**:
- Read scattered documentation
- Ask senior developers questions
- Learn through trial and error
- Inconsistent AI assistance

**Agent Rules + Philosophy.md Approach**:
- AGENTS.md: Project setup and conventions
- Philosophy.md: Team's architectural decisions and rationale
- AI agents trained on team knowledge
- Faster, more consistent onboarding

**Result**: 50% faster productive contribution.

### Scenario 3: Open Source Contribution

**Situation**: External contributor wants to add feature.

**Without Standards**:
- Unclear how to structure contribution
- AI agents give generic suggestions
- Multiple review cycles to align with project

**With Standards**:
- AGENTS.md: Contribution workflow and commands
- Philosophy.md: Design patterns and philosophy
- AI agents help create project-aligned code
- Fewer review cycles

**Result**: Higher quality contributions, less maintainer burden.

## References

1. GitHub. "agent-rules/agent-rules." https://github.com/agent-rules/agent-rules
2. AI Coding Rules. "Standardized Rules for AI-assisted Software Development." https://aicodingrules.org/
3. JetBrains Blog. "Coding Guidelines for Your AI Agents." https://blog.jetbrains.com/idea/2025/05/coding-guidelines-for-your-ai-agents/
4. Medium. "Coding Standards for AI Agents." https://medium.com/@christianforce/coding-standards-for-ai-agents-cb5c80696f72
5. GitHub Gist. "Some notes on AI Agent Rule / Instruction / Context files." https://gist.github.com/0xdevalias/f40bc5a6f84c4c5ad862e314894b2fa6
