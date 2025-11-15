# Philosophy.md Integration Strategies

## Overview

This document provides comprehensive integration strategies for Philosophy.md across major AI coding tools. Each tool has unique capabilities—this plan leverages tool-specific features while maintaining cross-tool compatibility through AGENTS.md.

## Integration Matrix

| Tool | Native Support | Advanced Features | Implementation Complexity | Priority |
|------|---------------|-------------------|--------------------------|----------|
| **Claude Code** | CLAUDE.md | Subagents, Skills, Hooks, MCP | High | 🔴 Critical |
| **GitHub Copilot** | AGENTS.md | MCP, Path-specific instructions | Medium | 🔴 Critical |
| **Cursor** | .cursorrules | @Docs, MCP, Path-specific rules | Medium | 🟡 High |
| **Aider** | Manual/Scripts | Repository mapping | Low | 🟢 Medium |
| **Generic AI Tools** | AGENTS.md | README.md references | Low | 🟢 Medium |

---

## Strategy 1: Claude Code Integration

### Implementation Phases

#### Phase 1: Basic Integration (Week 1)

**Goal**: Philosophy accessible in all Claude Code sessions

**Implementation**:

**1. Create CLAUDE.md**:
```markdown
# CLAUDE.md

## Coding Philosophy
See PHILOSOPHY.md for our complete coding philosophy.

**Before making architectural decisions:**
1. Read PHILOSOPHY.md for principles
2. Check research/ for thought leader perspectives
3. Apply appropriate patterns

**Key Principles**:
- TDD (PHILOSOPHY.md#testing) - All features need tests
- Hexagonal Architecture (PHILOSOPHY.md#architecture)
- Composition over Inheritance (PHILOSOPHY.md#patterns)

When in doubt, consult PHILOSOPHY.md first.
```

**2. Test Integration**:
```bash
# Start Claude Code session
claude

# Verify CLAUDE.md is loaded
> "What is our testing philosophy?"
# Expected: References PHILOSOPHY.md#testing and TDD principles
```

**Success Criteria**:
- ✅ Claude Code reads CLAUDE.md automatically
- ✅ References PHILOSOPHY.md in responses
- ✅ Provides philosophy-aligned suggestions

---

#### Phase 2: Skills (Week 2-3)

**Goal**: Reusable philosophy knowledge across sessions

**Implementation**:

**1. Create Philosophy Skill** (`.claude/skills/philosophy-guide/`):

**Structure**:
```
.claude/skills/philosophy-guide/
├── README.md           # Skill description
├── instructions.md     # How to use PHILOSOPHY.md
├── patterns.md         # Common patterns
└── examples/
    ├── tdd-example.md
    ├── hexagonal-arch-example.md
    └── composition-example.md
```

**README.md**:
```markdown
# Philosophy Guide Skill

## Description
This skill helps apply coding philosophies from PHILOSOPHY.md to development tasks.

## When to Use
- Making architectural decisions
- Choosing design patterns
- Resolving code design questions
- Learning project philosophy

## How to Use
1. Check PHILOSOPHY.md for project-specific guidance
2. Check research/ for thought leader perspectives
3. Apply principles with concrete examples from examples/

## Files
- PHILOSOPHY.md - Project philosophy
- research/ - Thought leader research
- examples/ - Practical examples
```

**instructions.md**:
```markdown
# Using Project Philosophy

## Quick Reference

**Architecture Questions**:
- Check PHILOSOPHY.md#architecture
- Review research/MARTIN_FOWLER.md for patterns

**Testing Questions**:
- Check PHILOSOPHY.md#testing
- Review research/KENT_BECK.md for TDD

**Pattern Questions**:
- Check PHILOSOPHY.md#patterns
- Review research/GANG_OF_FOUR.md for design patterns

## Workflow

1. **Identify decision type** (architecture, testing, patterns, etc.)
2. **Read relevant PHILOSOPHY.md section**
3. **Check thought leader perspective** in research/
4. **Apply with examples** from examples/
5. **Document rationale** referencing philosophy
```

**2. Test Skill**:
```bash
# Claude Code automatically discovers skills
# Test in a session
> "I need to add a new feature. What's our testing approach?"
# Expected: Skill activates, references PHILOSOPHY.md#testing
```

**Success Criteria**:
- ✅ Skill automatically discovered when relevant
- ✅ Provides comprehensive philosophy guidance
- ✅ References both PHILOSOPHY.md and research/

---

#### Phase 3: Subagents (Week 4)

**Goal**: Specialized agent for philosophy consultation

**Implementation**:

**1. Create Philosophy Advisor Subagent** (`.claude/agents/philosophy-advisor.ts`):

```typescript
export default {
  name: "philosophy-advisor",
  description: "Advises on coding philosophy and architectural decisions",
  systemPrompt: `
You are a philosophy advisor for this codebase.

Your role is to:
1. Reference PHILOSOPHY.md for project-specific philosophy
2. Reference research/ for thought leader perspectives
3. Help developers apply philosophical principles to code decisions
4. Explain the "why" behind architectural choices

When advising:
- Always cite specific sections (e.g., "Per PHILOSOPHY.md#testing...")
- Explain trade-offs and alternatives
- Connect principles to concrete code examples
- Reference relevant thought leaders from research/
- Provide actionable guidance

Available resources:
- PHILOSOPHY.md - Project coding philosophy
- research/MARTIN_FOWLER.md - Refactoring, patterns, architecture
- research/KENT_BECK.md - TDD, XP
- research/ROBERT_MARTIN.md - Clean code, SOLID principles
- [... all research files]
`,
  tools: ["read", "grep", "glob"],
  model: "claude-sonnet-4-5"
};
```

**2. Usage**:
```bash
# Invoke philosophy advisor
> /agent philosophy-advisor Should I use microservices or monolith?

# Agent responds:
# "Let me check the project philosophy...
# [Reads PHILOSOPHY.md#architecture]
# According to PHILOSOPHY.md#architecture, we chose monolith-first because:
# 1. Team size is small (5 developers)
# 2. Problem domain is well-understood
# 3. See research/MARTIN_FOWLER.md on MonolithFirst pattern..."
```

**Success Criteria**:
- ✅ Agent provides philosophy-grounded advice
- ✅ Cites specific PHILOSOPHY.md sections
- ✅ References thought leaders appropriately
- ✅ Explains trade-offs and rationale

---

#### Phase 4: Advanced Features (Week 5-6)

**A. Slash Commands**:

**Create `/philosophy` command** (`.claude/commands/philosophy.ts`):

```typescript
export default {
  name: "philosophy",
  description: "Get philosophy guidance on specific topic",
  async execute(args: string[]) {
    const topic = args[0] || "overview";

    const philosophy = await readFile("PHILOSOPHY.md");
    const topicSection = extractSection(philosophy, topic);

    const researchFiles = await glob(`research/**/*.md`);
    const relevantResearch = await findRelevantResearch(topic, researchFiles);

    return `
# Philosophy Guidance: ${topic}

## Project Philosophy
${topicSection}

## Thought Leader Perspectives
${relevantResearch}

## Application
How can I help you apply this philosophy to your current task?
    `;
  }
};
```

**Usage**:
```bash
> /philosophy testing
# Returns testing philosophy + relevant research

> /philosophy architecture
# Returns architecture philosophy + Martin Fowler perspectives
```

**B. Hooks for Philosophy Validation**:

**Create pre-commit hook** (`.claude/hooks/pre-commit.ts`):

```typescript
export default async function preCommit(files: string[]) {
  const philosophy = await readFile("PHILOSOPHY.md");
  const violations = [];

  // Check for test files (TDD philosophy)
  const codeFiles = files.filter(f => f.endsWith('.ts') && !f.includes('test'));
  for (const file of codeFiles) {
    const testFile = file.replace('.ts', '.test.ts');
    if (!files.includes(testFile)) {
      violations.push({
        file,
        message: "PHILOSOPHY.md requires tests for all features (TDD)",
        suggestion: `Create ${testFile} following PHILOSOPHY.md#testing`
      });
    }
  }

  // Additional philosophy checks...

  if (violations.length > 0) {
    return {
      proceed: false,
      message: "Philosophy violations detected",
      violations
    };
  }

  return { proceed: true };
}
```

**C. MCP Server**:

**Create Philosophy MCP Server** (`.claude/mcp-servers/philosophy/`):

```typescript
// index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server(
  { name: "philosophy-context-server", version: "1.0.0" },
  { capabilities: { resources: {}, tools: {} } }
);

// Resources: PHILOSOPHY.md and research/
server.setRequestHandler("resources/list", async () => {
  return {
    resources: [
      {
        uri: "philosophy://main",
        name: "Project Philosophy",
        mimeType: "text/markdown",
      },
      // ... research files
    ],
  };
});

// Tools: get_philosophy, check_alignment
server.setRequestHandler("tools/list", async () => {
  return {
    tools: [
      {
        name: "get_philosophy",
        description: "Get coding philosophy for specific topic",
        inputSchema: {
          type: "object",
          properties: {
            topic: { type: "string" }
          },
          required: ["topic"],
        },
      },
      {
        name: "check_alignment",
        description: "Check if code aligns with philosophy",
        inputSchema: {
          type: "object",
          properties: {
            code: { type: "string" },
            principle: { type: "string" }
          },
          required: ["code", "principle"],
        },
      },
    ],
  };
});

// Implementation...
```

**Success Criteria**:
- ✅ Slash commands provide quick philosophy access
- ✅ Hooks enforce philosophy automatically
- ✅ MCP server enables advanced philosophy queries

---

## Strategy 2: GitHub Copilot Integration

### Implementation Phases

#### Phase 1: Repository Instructions (Week 1)

**Goal**: Philosophy referenced in all Copilot interactions

**Implementation**:

**1. Create `.github/copilot-instructions.md`**:

```markdown
# GitHub Copilot Instructions

## Project Overview
[Brief project description]

## Coding Philosophy
**This project follows coding philosophies documented in PHILOSOPHY.md.**

Before implementing features, consult PHILOSOPHY.md for:
- Architecture decisions (PHILOSOPHY.md#architecture)
- Testing approach (PHILOSOPHY.md#testing)
- Design pattern preferences (PHILOSOPHY.md#patterns)
- Refactoring guidelines (PHILOSOPHY.md#refactoring)

## Key Philosophical Principles

### Test-Driven Development
We practice TDD (PHILOSOPHY.md#testing):
- Write tests before implementation
- All features require test coverage
- Tests document expected behavior

### Hexagonal Architecture
We use hexagonal architecture (PHILOSOPHY.md#architecture):
- Domain logic independent of frameworks
- Ports and adapters pattern
- Clear separation of concerns

### Composition Over Inheritance
We prefer composition (PHILOSOPHY.md#patterns):
- Use composition for code reuse
- Avoid deep inheritance hierarchies
- Apply Strategy pattern over inheritance

## References
- **PHILOSOPHY.md** - Complete coding philosophy
- **research/MARTIN_FOWLER.md** - Refactoring principles
- **research/KENT_BECK.md** - TDD philosophy
- **research/ROBERT_MARTIN.md** - Clean code practices

## Tech Stack
[Tech stack details]

## Build and Test
- Build: `[command]`
- Test: `[command]`
- Lint: `[command]`
```

**2. Test Integration**:
- Open file in VS Code with Copilot
- Request code generation
- Verify: Copilot suggestions align with philosophy

**Success Criteria**:
- ✅ Copilot references philosophy in suggestions
- ✅ Generated code follows documented patterns
- ✅ TDD approach evident in test generation

---

#### Phase 2: Path-Specific Instructions (Week 2)

**Goal**: Different philosophy guidance for different code areas

**Implementation**:

**1. Create `.github/instructions/` directory**:

```
.github/instructions/
├── backend.instructions.md
├── frontend.instructions.md
├── tests.instructions.md
└── documentation.instructions.md
```

**backend.instructions.md**:
```markdown
---
applyTo: "src/backend/**/*.ts,src/api/**/*.ts"
---

# Backend Development Philosophy

## API Design
Follow REST principles from PHILOSOPHY.md#api-design:
- Resource-oriented endpoints
- Proper HTTP verb usage
- Stateless operations

## Domain Logic
Apply DDD principles from PHILOSOPHY.md#ddd:
- Rich domain models
- Ubiquitous language
- Bounded contexts

## References
- PHILOSOPHY.md#architecture
- research/MARTIN_FOWLER.md#enterprise-patterns
```

**frontend.instructions.md**:
```markdown
---
applyTo: "src/components/**/*.tsx,src/pages/**/*.tsx"
---

# Frontend Development Philosophy

## Component Design
Follow PHILOSOPHY.md#components:
- Single responsibility principle
- Composition over prop drilling
- Accessibility-first

## State Management
Per PHILOSOPHY.md#state:
- Local state by default
- Context for cross-cutting concerns

## References
- PHILOSOPHY.md#components
- PHILOSOPHY.md#accessibility
```

**tests.instructions.md**:
```markdown
---
applyTo: "**/*.test.ts,**/*.spec.ts"
---

# Testing Philosophy

Follow TDD from PHILOSOPHY.md#testing:
- Arrange-Act-Assert pattern
- Test behavior, not implementation
- Clear test descriptions

## References
- PHILOSOPHY.md#testing
- research/KENT_BECK.md
- research/ROY_OSHEROVE.md
```

**Success Criteria**:
- ✅ Different guidance for backend vs. frontend
- ✅ Path-specific patterns applied correctly
- ✅ Test files get TDD-specific guidance

---

#### Phase 3: AGENTS.md Support (Week 3)

**Goal**: Cross-tool compatibility with simple configuration

**Implementation**:

**1. Create AGENTS.md**:
```markdown
# AGENTS.md

## Coding Philosophy
**See PHILOSOPHY.md** for our complete coding philosophy.

## Key Principles
- **TDD**: All features need tests (PHILOSOPHY.md#testing)
- **Hexagonal Architecture**: Domain-driven design (PHILOSOPHY.md#architecture)
- **Composition**: Prefer composition over inheritance (PHILOSOPHY.md#patterns)

## Commands
- Build: `[command]`
- Test: `[command]`
- Lint: `[command]`

## Architecture
[Brief architecture summary]

See PHILOSOPHY.md#architecture for detailed rationale and trade-offs.

## References
- PHILOSOPHY.md - Coding philosophy and principles
- research/ - Thought leader perspectives
```

**2. Hierarchical AGENTS.md** (optional for monorepos):
```
/
├── AGENTS.md               # Root
└── packages/
    ├── backend/
    │   └── AGENTS.md      # Backend-specific
    └── frontend/
        └── AGENTS.md      # Frontend-specific
```

**Success Criteria**:
- ✅ Copilot reads AGENTS.md automatically
- ✅ Works across Copilot, Cursor, and other tools
- ✅ Hierarchical support for complex projects

---

#### Phase 4: MCP Integration (Week 4)

**Goal**: Advanced philosophy context via MCP

**Implementation**:

**1. Create Philosophy MCP Server**:
(See Claude Code MCP example above - reusable across tools)

**2. VS Code Configuration**:
Add to `.vscode/settings.json`:
```json
{
  "github.copilot.chat.mcp.enabled": true,
  "github.copilot.chat.mcp.servers": {
    "philosophy": {
      "command": "node",
      "args": [".mcp-servers/philosophy/index.js"]
    }
  }
}
```

**3. Usage**:
```typescript
// In Copilot Chat
> @philosophy What's our testing approach?
// MCP server provides dynamic philosophy context
```

**Success Criteria**:
- ✅ MCP server accessible in Copilot Chat
- ✅ Dynamic philosophy retrieval works
- ✅ Cross-tool MCP server (works in Claude Code too)

---

## Strategy 3: Cursor IDE Integration

### Implementation Phases

#### Phase 1: Basic Rules (Week 1)

**Goal**: Philosophy guidance in Cursor

**Implementation**:

**1. Create `.cursor/rules/index.mdc`**:
```markdown
---
description: "Core project philosophy"
globs: ["**/*"]
priority: 1
---

# Project Philosophy

**Consult PHILOSOPHY.md** before making architectural decisions.

## Key Principles
- **TDD** (PHILOSOPHY.md#testing) - All features need tests
- **Hexagonal Architecture** (PHILOSOPHY.md#architecture)
- **Composition over Inheritance** (PHILOSOPHY.md#patterns)

## Workflow
1. Check PHILOSOPHY.md for relevant principles
2. Review research/ for thought leader perspectives
3. Apply appropriate patterns

**For detailed rationale, see PHILOSOPHY.md.**
```

**Success Criteria**:
- ✅ Cursor applies rules automatically
- ✅ References PHILOSOPHY.md in suggestions
- ✅ Philosophy-aligned code generation

---

#### Phase 2: Path-Specific Rules (Week 2)

**Goal**: Targeted philosophy per file type

**Implementation**:

**1. Create rule structure**:
```
.cursor/rules/
├── index.mdc          # General
├── typescript.mdc     # TypeScript-specific
├── react.mdc          # React-specific
└── testing.mdc        # Test-specific
```

**typescript.mdc**:
```markdown
---
description: "TypeScript philosophy"
globs: ["**/*.ts", "**/*.tsx"]
priority: 2
---

# TypeScript Philosophy

Apply TypeScript philosophy from PHILOSOPHY.md#typescript:
- Strict type checking
- Prefer interfaces over types
- Use generics for reusable code

See research/ANDERS_HEJLSBERG.md for TypeScript design philosophy.
```

**react.mdc**:
```markdown
---
description: "React component philosophy"
globs: ["src/components/**/*.tsx"]
priority: 3
---

# React Component Philosophy

Follow PHILOSOPHY.md#components:
- Single responsibility
- Composition patterns
- Server Components by default
- Accessibility-first

See PHILOSOPHY.md#components for detailed examples.
```

**testing.mdc**:
```markdown
---
description: "Testing philosophy"
globs: ["**/*.test.ts", "**/*.spec.ts"]
priority: 3
---

# Testing Philosophy

Follow TDD from PHILOSOPHY.md#testing:
- Arrange-Act-Assert
- Test behavior, not implementation
- Clear descriptions

See research/KENT_BECK.md for TDD philosophy.
```

**Success Criteria**:
- ✅ Different rules for different file types
- ✅ Priority system works correctly
- ✅ Path-specific philosophy applied

---

#### Phase 3: @Docs Integration (Week 3)

**Goal**: Combine official docs with project philosophy

**Implementation**:

**Example in rules**:
```markdown
---
description: "Next.js development"
globs: ["app/**/*.tsx"]
---

# Next.js Philosophy

## Framework Guidance
Use @Docs Next.js for API references

## Project Philosophy
Use PHILOSOPHY.md#nextjs for architectural decisions

## Combining Sources
- @Docs: Framework features and APIs
- PHILOSOPHY.md: Design patterns and architecture
- research/VERCEL_TEAM.md: Next.js design principles
```

**Usage**:
- Cursor automatically suggests @Docs when relevant
- Rules remind to check PHILOSOPHY.md for patterns
- Combined guidance: framework APIs + project philosophy

**Success Criteria**:
- ✅ @Docs and PHILOSOPHY.md used together
- ✅ Framework knowledge + project philosophy
- ✅ Comprehensive development guidance

---

## Strategy 4: Aider Integration

### Implementation Approach

**Philosophy**: Aider requires explicit context loading - optimize with scripts

#### Phase 1: Helper Scripts (Week 1)

**Goal**: Easy philosophy loading in Aider

**Implementation**:

**1. Create `.aider-scripts/with-philosophy.sh`**:
```bash
#!/bin/bash
# Launch Aider with philosophy context

echo "🧠 Starting Aider with Philosophy context..."
echo ""
echo "Loaded files:"
echo "  ✓ PHILOSOPHY.md"
echo "  ✓ AGENTS.md"
echo ""

aider \
  --read PHILOSOPHY.md \
  --read AGENTS.md \
  --message "Philosophy files loaded. What would you like to work on?" \
  "$@"
```

**2. Create `.aider-scripts/with-research.sh`**:
```bash
#!/bin/bash
# Launch Aider with philosophy + research for specific topic

TOPIC=$1
shift

case $TOPIC in
  architecture)
    RESEARCH="research/MARTIN_FOWLER.md research/ROBERT_MARTIN.md"
    ;;
  testing)
    RESEARCH="research/KENT_BECK.md research/ROY_OSHEROVE.md"
    ;;
  *)
    RESEARCH=""
    ;;
esac

echo "🧠 Starting Aider with ${TOPIC} philosophy..."

aider \
  --read PHILOSOPHY.md \
  --read AGENTS.md \
  $(for file in $RESEARCH; do echo "--read $file"; done) \
  "$@"
```

**Usage**:
```bash
# Standard philosophy
./aider-scripts/with-philosophy.sh src/feature.ts

# With research on specific topic
./aider-scripts/with-research.sh testing src/auth.test.ts
```

**Success Criteria**:
- ✅ One command loads philosophy
- ✅ Topic-specific research loading
- ✅ Documented in README

---

#### Phase 2: Configuration (Week 2)

**Goal**: Default philosophy references

**Implementation**:

**1. Create `.aider.conf.yml`**:
```yaml
# .aider.conf.yml

# Model settings
model: claude-4-sonnet

# Repository settings
auto-commits: false
dirty-commits: false
attribute-author: false

# Philosophy Integration
# Note: This project follows philosophies in PHILOSOPHY.md
#
# Usage:
#   1. Add philosophy to context:
#      /add PHILOSOPHY.md
#
#   2. Reference specific sections:
#      "Check PHILOSOPHY.md#testing for our TDD approach"
#
#   3. Add research for thought leader perspectives:
#      /add research/MARTIN_FOWLER.md
#
# Helper scripts:
#   - .aider-scripts/with-philosophy.sh (loads PHILOSOPHY.md)
#   - .aider-scripts/with-research.sh <topic> (loads topic research)
```

**2. Document in README.md**:
```markdown
## Using Aider with Philosophy

### Quick Start
```bash
# Use helper script (automatically loads philosophy)
./aider-scripts/with-philosophy.sh src/feature.ts

# Or manually add philosophy
aider
/add PHILOSOPHY.md
/add src/feature.ts
```

### Topic-Specific Research
```bash
# Load testing philosophy + Kent Beck research
./aider-scripts/with-research.sh testing src/auth.test.ts
```
```

**Success Criteria**:
- ✅ Configuration documented
- ✅ Helper scripts documented
- ✅ Easy onboarding for new team members

---

#### Phase 3: Prompt Templates (Week 3)

**Goal**: Reusable philosophy-aware prompts

**Implementation**:

**1. Create `.aider-prompts/`**:
```
.aider-prompts/
├── implement-feature.md
├── code-review.md
├── refactor.md
└── write-tests.md
```

**implement-feature.md**:
```markdown
I need to implement [FEATURE].

Based on our philosophy:
- PHILOSOPHY.md#architecture: We use hexagonal architecture
- PHILOSOPHY.md#testing: We practice TDD
- PHILOSOPHY.md#patterns: We prefer composition over inheritance

Please:
1. Design the domain layer first (hexagonal architecture)
2. Write tests before implementation (TDD)
3. Use composition patterns
4. Create adapters for external dependencies

Let's start with the tests.
```

**code-review.md**:
```markdown
Please review this code against our coding philosophy.

Check PHILOSOPHY.md for:
- Architecture compliance (PHILOSOPHY.md#architecture)
- Testing requirements (PHILOSOPHY.md#testing)
- Pattern usage (PHILOSOPHY.md#patterns)

Also reference research/MARTIN_FOWLER.md for refactoring opportunities.

What improvements align with our philosophy?
```

**Usage**:
```bash
# Use prompt template
cat .aider-prompts/implement-feature.md | aider
```

**Success Criteria**:
- ✅ Templates reference philosophy sections
- ✅ Reusable across features
- ✅ Consistent philosophy application

---

## Strategy 5: Cross-Tool Compatibility

### Universal Standard: AGENTS.md

**Goal**: Single file works across all tools

**Implementation**:

**Create comprehensive AGENTS.md**:
```markdown
# AGENTS.md

## Overview
This file provides AI coding assistant configuration.

**For philosophy**: See PHILOSOPHY.md
**For commands**: See below
**For detailed setup**: See README.md

---

## Coding Philosophy

**IMPORTANT**: This project follows coding philosophies documented in **PHILOSOPHY.md**.

Before making architectural decisions:
1. Read PHILOSOPHY.md for principles and rationale
2. Check research/ for thought leader perspectives
3. Apply appropriate patterns from PHILOSOPHY.md#patterns

### Key Principles

**Test-Driven Development** (PHILOSOPHY.md#testing):
- Write tests before implementation
- All features require test coverage
- Tests document expected behavior
- See research/KENT_BECK.md for TDD philosophy

**Hexagonal Architecture** (PHILOSOPHY.md#architecture):
- Domain logic independent of frameworks
- Ports and adapters pattern
- Clear separation of concerns
- See research/MARTIN_FOWLER.md for architectural patterns

**Composition Over Inheritance** (PHILOSOPHY.md#patterns):
- Use composition for code reuse
- Avoid deep inheritance hierarchies
- Apply Strategy pattern over inheritance
- See research/GANG_OF_FOUR.md for design patterns

---

## Commands

### Development
- **Install**: `[command]`
- **Dev server**: `[command]`
- **Build**: `[command]`

### Testing
- **Run tests**: `[command]`
- **Watch tests**: `[command]`
- **Coverage**: `[command]`

### Code Quality
- **Lint**: `[command]`
- **Format**: `[command]`
- **Type check**: `[command]`

---

## Architecture

[Brief architecture description]

**For detailed architecture rationale**, see PHILOSOPHY.md#architecture.

**For architectural patterns**, see research/MARTIN_FOWLER.md.

---

## Project Structure

```
/
├── src/
│   ├── domain/        # Domain logic (hexagonal architecture)
│   ├── adapters/      # Infrastructure adapters
│   └── ports/         # Port interfaces
├── tests/             # Test files
└── docs/              # Documentation
```

**For philosophy on project structure**, see PHILOSOPHY.md#structure.

---

## Tool-Specific Integration

### GitHub Copilot
- Repository instructions: `.github/copilot-instructions.md`
- Path-specific: `.github/instructions/*.instructions.md`
- This file (AGENTS.md) is automatically read

### Cursor
- Rules: `.cursor/rules/index.mdc`
- Path-specific rules: `.cursor/rules/*.mdc`
- This file provides baseline guidance

### Claude Code
- Configuration: `CLAUDE.md`
- Skills: `.claude/skills/`
- Subagents: `.claude/agents/`

### Aider
- Use `.aider-scripts/with-philosophy.sh` to auto-load philosophy
- Or manually: `/add PHILOSOPHY.md`

---

## References

### Documentation
- **PHILOSOPHY.md** - Why we code the way we do
- **README.md** - Project overview and setup
- **CONTRIBUTING.md** - How to contribute

### Research
- **research/MARTIN_FOWLER.md** - Refactoring, patterns, architecture
- **research/KENT_BECK.md** - TDD, XP
- **research/ROBERT_MARTIN.md** - Clean code, SOLID
- [... all research files]

---

## Getting Started

1. **Read PHILOSOPHY.md** to understand our coding philosophy
2. **Review research/** to see thought leader influences
3. **Check tool-specific integration** for your AI coding assistant
4. **Reference in prompts**: "Based on PHILOSOPHY.md#testing..."

---

*This file works with multiple AI coding assistants. For tool-specific configuration, see respective config files.*
```

**Benefits**:
- ✅ Works with Copilot, Cursor, Aider, and generic tools
- ✅ Comprehensive yet concise
- ✅ Points to PHILOSOPHY.md for details
- ✅ Single source of truth for basic config

---

## Implementation Timeline

### Week 1: Foundation
- ✅ Create PHILOSOPHY.md
- ✅ Create research/ files (top 3-5 thought leaders)
- ✅ Create AGENTS.md
- ✅ Document in README.md

### Week 2: Primary Tool Integration
- ✅ Implement for team's primary AI tool (likely GitHub Copilot or Claude Code)
- ✅ Test and refine
- ✅ Gather team feedback

### Week 3: Secondary Tools
- ✅ Implement for secondary tools (Cursor, Aider)
- ✅ Create helper scripts
- ✅ Document usage

### Week 4: Advanced Features
- ✅ Claude Code subagents/skills (if using Claude Code)
- ✅ Path-specific instructions (Copilot, Cursor)
- ✅ MCP servers (optional, advanced)

### Week 5-6: Refinement
- ✅ Team feedback and iteration
- ✅ Expand research/ directory
- ✅ Create examples and templates
- ✅ Measure impact

---

## Success Metrics

### Quantitative
- **AI suggestion acceptance rate**: Target 40% increase
- **Code review iterations**: Target 30% reduction
- **Onboarding time**: Target 50% reduction
- **Philosophy references in PRs**: Track growth

### Qualitative
- **Developer satisfaction**: Survey team
- **AI suggestion relevance**: Gather feedback
- **Philosophy clarity**: Ease of understanding
- **Cross-tool experience**: Consistency across tools

---

## Maintenance

### Monthly
- Review philosophy accuracy
- Update based on team feedback
- Add research files as needed

### Quarterly
- Major philosophy review
- Update all tool configurations
- Measure success metrics
- Refine based on learnings

### Annually
- Comprehensive philosophy evolution
- Research directory expansion
- Tool integration updates
- Community feedback (if open source)

---

## Summary

**Recommended Priorities**:

1. **Critical** (Week 1-2):
   - PHILOSOPHY.md
   - AGENTS.md
   - Primary tool integration (Copilot or Claude Code)

2. **High** (Week 3-4):
   - Secondary tool integration (Cursor)
   - Helper scripts (Aider)
   - Path-specific rules

3. **Medium** (Week 5-6):
   - Advanced features (subagents, MCP)
   - Expanded research/
   - Prompt templates

**Start simple, grow organically, measure impact.**
