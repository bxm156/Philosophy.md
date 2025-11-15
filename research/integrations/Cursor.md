# Philosophy.md Integration with Cursor IDE

## Overview

Cursor is an AI-powered IDE built as a fork of VS Code, designed to be an "AI teammate" for software development. Cursor provides sophisticated integration mechanisms for project context and coding philosophy through Cursor Rules, documentation integration, and Model Context Protocol (MCP) support.

## Integration Mechanisms

### 1. Cursor Rules (.cursor/rules/)

**How it Works**: Cursor automatically discovers and applies rules from `.cursor/rules/` directory

**File Format**: `.mdc` (Markdown with frontmatter)

**Rule Types**:
- **User Rules**: Global rules applying to all projects
- **Project Rules**: Repository-specific rules (version-controlled)

**Storage Locations**:
- **Project Rules**: `.cursor/rules/*.mdc` (recommended)
- **Legacy**: `.cursorrules` file (still supported but deprecated)

---

### 2. Project Rules Configuration

**Directory Structure**:
```
.cursor/
├── index.mdc              # Always-applied rules
└── rules/
    ├── philosophy.mdc     # Philosophy guidance
    ├── typescript.mdc     # TypeScript-specific rules
    ├── react.mdc          # React component rules
    └── testing.mdc        # Test file rules
```

**Example - Philosophy Rule (`.cursor/rules/philosophy.mdc`)**:

```markdown
---
description: "Project coding philosophy and principles"
globs: ["**/*"]
priority: 1
---

# Coding Philosophy

## Philosophy Documentation
This project follows coding philosophies documented in PHILOSOPHY.md.

Before making architectural decisions:
1. Consult PHILOSOPHY.md for relevant principles
2. Review research/ directory for thought leader perspectives
3. Apply appropriate patterns from PHILOSOPHY.md#patterns

## Core Principles

### Test-Driven Development
We practice TDD. See PHILOSOPHY.md#testing for rationale and examples.
- Write tests before implementation
- Tests document expected behavior
- Refactor with confidence

### Hexagonal Architecture
Follow hexagonal architecture. See PHILOSOPHY.md#architecture for details.
- Domain logic independent of frameworks
- Ports and adapters pattern
- Clear separation of concerns

### Composition Over Inheritance
Prefer composition. See PHILOSOPHY.md#patterns for explanation.
- Use composition for code reuse
- Apply Strategy pattern instead of inheritance
- Keep inheritance hierarchies shallow

## References
- PHILOSOPHY.md - Complete coding philosophy
- research/MARTIN_FOWLER.md - Refactoring principles
- research/ROBERT_MARTIN.md - Clean code practices
- research/KENT_BECK.md - TDD philosophy
```

---

### 3. Path-Specific Rules (Glob Patterns)

**How it Works**: Use frontmatter `globs` property to target specific file patterns

**Example - TypeScript Rules (`.cursor/rules/typescript.mdc`)**:

```markdown
---
description: "TypeScript coding standards and philosophy"
globs: ["**/*.ts", "**/*.tsx"]
priority: 2
---

# TypeScript Development Philosophy

Apply TypeScript philosophy from PHILOSOPHY.md#typescript:
- Strict type checking enabled
- Prefer interfaces over types for objects
- Use generics for reusable type-safe code
- Leverage discriminated unions

See research/ANDERS_HEJLSBERG.md for TypeScript design philosophy.
```

**Example - React Component Rules (`.cursor/rules/react.mdc`)**:

```markdown
---
description: "React component design philosophy"
globs: ["src/components/**/*.tsx", "src/pages/**/*.tsx"]
priority: 3
---

# React Component Philosophy

Follow component principles from PHILOSOPHY.md#components:

## Component Design
- Single responsibility principle
- Composition over prop drilling
- Server Components by default (Next.js)
- Client Components only for interactivity

## State Management
See PHILOSOPHY.md#state:
- Local state by default
- Context for cross-cutting concerns
- Avoid global state when possible
- Co-locate state with usage

## Accessibility
See PHILOSOPHY.md#accessibility:
- Semantic HTML
- ARIA labels when needed
- Keyboard navigation
- Screen reader support
```

**Example - Test Rules (`.cursor/rules/testing.mdc`)**:

```markdown
---
description: "Testing philosophy and practices"
globs: ["**/*.test.ts", "**/*.test.tsx", "**/*.spec.ts"]
priority: 3
---

# Testing Philosophy

Follow TDD principles from PHILOSOPHY.md#testing:

## Test Structure
- Arrange-Act-Assert pattern
- Clear test descriptions
- One assertion per test when possible
- Test behavior, not implementation

## Philosophy
See research/KENT_BECK.md for TDD philosophy
See research/ROY_OSHEROVE.md for testing best practices

## Coverage
- All features require test coverage
- Edge cases and error paths tested
- Integration tests for critical flows
```

---

### 4. Rule Priority System

**How it Works**: Higher priority rules can override lower priority ones

**Priority Levels**:
- **1**: General project-wide rules
- **2**: Language-specific rules
- **3+**: Framework/library-specific or highly targeted rules

**Example Priority Strategy**:
```markdown
# .cursor/rules/philosophy.mdc
---
priority: 1  # Lowest - applies generally
globs: ["**/*"]
---

# .cursor/rules/typescript.mdc
---
priority: 2  # Medium - overrides philosophy for TS files
globs: ["**/*.ts", "**/*.tsx"]
---

# .cursor/rules/react.mdc
---
priority: 3  # Highest - most specific guidance
globs: ["src/components/**/*.tsx"]
---
```

**Benefit**: Hierarchical philosophy application from general to specific

---

### 5. @Docs Integration

**How it Works**: Cursor's `@Docs` feature connects to official documentation from frameworks and tools

**Usage with Philosophy.md**:

While `@Docs` primarily targets external documentation, you can reference it alongside PHILOSOPHY.md:

```markdown
---
description: "Next.js development philosophy"
globs: ["app/**/*.tsx", "pages/**/*.tsx"]
---

# Next.js Philosophy

## Framework Philosophy
For Next.js official guidance: @Docs Next.js

For our project-specific philosophy: PHILOSOPHY.md#nextjs

## Combining Sources
- Use @Docs for API references and framework features
- Use PHILOSOPHY.md for architectural decisions and patterns
- Use research/VERCEL_TEAM.md for Next.js design principles

## Server Components
Default to Server Components (PHILOSOPHY.md#react-server-components):
- Fetch data on server when possible
- Reduce client bundle size
- Improve performance
```

**Benefits**:
- Official API references via @Docs
- Project philosophy via PHILOSOPHY.md
- Thought leader perspectives via research/

---

### 6. Model Context Protocol (MCP) Integration

**How it Works**: Cursor supports MCP servers for extending AI capabilities with external context

**Philosophy**: MCP is an open protocol standardized by Anthropic for connecting AI assistants to external systems

**Example MCP Server for Philosophy Context**:

```typescript
// .cursor/mcp-servers/philosophy/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { readFile } from "fs/promises";
import { glob } from "glob";

const server = new Server(
  {
    name: "cursor-philosophy-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      resources: {},
      tools: {},
    },
  }
);

// Provide philosophy resources
server.setRequestHandler("resources/list", async () => {
  const philosophyFiles = await glob("research/**/*.md");

  return {
    resources: [
      {
        uri: "philosophy://main",
        name: "Project Philosophy",
        mimeType: "text/markdown",
      },
      ...philosophyFiles.map(file => ({
        uri: `philosophy://research/${file}`,
        name: file,
        mimeType: "text/markdown",
      })),
    ],
  };
});

server.setRequestHandler("resources/read", async (request) => {
  const uri = request.params.uri;

  if (uri === "philosophy://main") {
    const content = await readFile("PHILOSOPHY.md", "utf-8");
    return {
      contents: [{
        uri,
        mimeType: "text/markdown",
        text: content,
      }],
    };
  }

  // Handle research files
  const match = uri.match(/^philosophy:\/\/research\/(.+)$/);
  if (match) {
    const content = await readFile(match[1], "utf-8");
    return {
      contents: [{
        uri,
        mimeType: "text/markdown",
        text: content,
      }],
    };
  }
});

// Philosophy guidance tool
server.setRequestHandler("tools/list", async () => {
  return {
    tools: [
      {
        name: "get_philosophy_guidance",
        description: "Get coding philosophy guidance for specific topics",
        inputSchema: {
          type: "object",
          properties: {
            topic: {
              type: "string",
              description: "Topic: testing, architecture, patterns, etc.",
            },
            context: {
              type: "string",
              description: "Additional context for targeted guidance",
            },
          },
          required: ["topic"],
        },
      },
      {
        name: "find_similar_philosophy",
        description: "Find similar philosophical approaches in research",
        inputSchema: {
          type: "object",
          properties: {
            problem: {
              type: "string",
              description: "Problem or decision to find philosophy for",
            },
          },
          required: ["problem"],
        },
      },
    ],
  };
});

server.setRequestHandler("tools/call", async (request) => {
  const { name, arguments: args } = request.params;

  if (name === "get_philosophy_guidance") {
    const philosophy = await readFile("PHILOSOPHY.md", "utf-8");
    // Extract and return relevant section
    return {
      content: [{
        type: "text",
        text: `Philosophy guidance for ${args.topic}:\n\n${philosophy}`,
      }],
    };
  }

  if (name === "find_similar_philosophy") {
    // Search research directory for relevant perspectives
    const researchFiles = await glob("research/**/*.md");
    // Analyze and return relevant philosophies
    return {
      content: [{
        type: "text",
        text: `Similar philosophical approaches for: ${args.problem}`,
      }],
    };
  }
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

**Cursor Configuration**:

Add to Cursor settings:

```json
{
  "cursor.mcp.servers": {
    "philosophy": {
      "command": "node",
      "args": [".cursor/mcp-servers/philosophy/index.js"]
    }
  }
}
```

**Pros**:
- Dynamic philosophy interpretation
- Can search across all philosophy docs
- Intelligent context provision
- Extensible with custom logic

**Cons**:
- Requires server development
- More complex than static rules
- Needs maintenance

---

### 7. Legacy .cursorrules Support

**How it Works**: Single `.cursorrules` file in project root (deprecated but still functional)

**Migration to .cursor/rules/**:

```bash
# Old approach (still works)
.cursorrules

# New approach (recommended)
.cursor/
└── rules/
    └── index.mdc
```

**Example Migration**:

```markdown
# .cursor/rules/index.mdc
---
description: "Project-wide coding philosophy"
globs: ["**/*"]
priority: 1
---

<!-- Content from legacy .cursorrules -->

See PHILOSOPHY.md for our coding philosophy.

[Rest of your rules]
```

**Recommendation**: Migrate to `.cursor/rules/` for better organization and path-specific targeting

---

## Recommended Integration Strategy

### Phase 1: Basic Rules (Immediate)

1. Create `.cursor/rules/index.mdc` with general philosophy
2. Reference PHILOSOPHY.md for detailed guidance
3. Keep concise - point to philosophy docs for details

**Example**:
```markdown
---
description: "Core project philosophy"
globs: ["**/*"]
priority: 1
---

# Project Philosophy

Consult PHILOSOPHY.md before making architectural decisions.

Key principles:
- TDD (PHILOSOPHY.md#testing)
- Hexagonal architecture (PHILOSOPHY.md#architecture)
- Composition over inheritance (PHILOSOPHY.md#patterns)

For detailed rationale and examples, see PHILOSOPHY.md.
```

### Phase 2: Path-Specific Rules

1. Create `.cursor/rules/` subdirectory structure
2. Add language-specific rules (typescript.mdc, python.mdc, etc.)
3. Add framework-specific rules (react.mdc, nextjs.mdc, etc.)
4. Add role-specific rules (testing.mdc, api.mdc, etc.)
5. Use glob patterns and priority levels

### Phase 3: @Docs Integration

1. Reference official docs for framework APIs
2. Reference PHILOSOPHY.md for project-specific decisions
3. Reference research/ for thought leader perspectives
4. Create comprehensive knowledge base

### Phase 4: MCP Server (Advanced)

1. Develop MCP server for dynamic philosophy access
2. Implement philosophy search and retrieval
3. Enable intelligent context provision
4. Provide decision support tools

---

## Best Practices

### Rule Organization

**By Language**:
```
.cursor/rules/
├── typescript.mdc
├── python.mdc
└── rust.mdc
```

**By Framework**:
```
.cursor/rules/
├── react.mdc
├── nextjs.mdc
└── express.mdc
```

**By Role**:
```
.cursor/rules/
├── backend.mdc
├── frontend.mdc
└── testing.mdc
```

**Hybrid Approach** (Recommended):
```
.cursor/rules/
├── index.mdc           # General philosophy
├── typescript.mdc      # Language rules
├── react.mdc          # Framework rules
├── testing.mdc        # Role-specific rules
└── philosophy.mdc     # Dedicated philosophy guide
```

### Glob Pattern Tips

**Match file extensions**:
```yaml
globs: ["**/*.ts", "**/*.tsx"]
```

**Match directories**:
```yaml
globs: ["src/components/**/*"]
```

**Combine patterns**:
```yaml
globs: ["**/*.test.ts", "**/*.test.tsx", "tests/**/*"]
```

**Exclude patterns** (use multiple rules):
```yaml
# Rule 1: Include most files
globs: ["src/**/*"]

# Rule 2: Different rule for excluded area
globs: ["src/legacy/**/*"]
```

### Priority Strategy

1. **Priority 1**: General project philosophy
2. **Priority 2**: Language-specific conventions
3. **Priority 3**: Framework-specific patterns
4. **Priority 4**: Highly specific contexts

### Content Guidelines

**DO**:
- Reference PHILOSOPHY.md for detailed philosophy
- Keep rules concise and actionable
- Use clear section headers
- Provide examples
- Reference thought leaders in research/

**DON'T**:
- Duplicate entire PHILOSOPHY.md content
- Write overly verbose rules
- Include task-specific instructions
- Forget to update rules as project evolves

---

## Integration Benefits

### For Developers

- **AI teammate alignment**: Cursor suggestions match project philosophy
- **Contextual awareness**: AI understands project principles
- **Reduced repetition**: Don't explain philosophy in every interaction
- **Consistent suggestions**: All team members get aligned guidance

### For AI Code Generation

- **Better code quality**: Generated code follows philosophy
- **Architectural consistency**: Suggestions match documented patterns
- **Pattern recognition**: AI applies appropriate design patterns
- **Philosophical grounding**: Decisions based on documented principles

### For Teams

- **Shared standards**: Philosophy consistently applied across team
- **Version controlled**: Rules evolve with codebase
- **Scalable guidance**: Philosophy scales to all team members
- **Onboarding efficiency**: New developers get immediate context

---

## Example Workflows

### Workflow 1: Component Development

```
Developer: "Create a new UserProfile component"

Cursor (with philosophy rules):
1. Reads .cursor/rules/react.mdc (matches glob for components/)
2. References PHILOSOPHY.md#components for design principles
3. Generates component following:
   - Single responsibility principle
   - Composition patterns
   - Accessibility requirements
   - Local state management
4. Includes clear prop types
5. Follows project file structure
```

### Workflow 2: Test Implementation

```
Developer: "Add tests for authentication service"

Cursor (with philosophy rules):
1. Reads .cursor/rules/testing.mdc (matches *.test.ts)
2. References PHILOSOPHY.md#testing for TDD philosophy
3. Generates tests following:
   - Arrange-Act-Assert pattern
   - Clear test descriptions
   - Behavior-focused assertions
   - Edge case coverage
4. References research/KENT_BECK.md patterns
```

### Workflow 3: Architecture Decision

```
Developer: "Should I use inheritance or composition here?"

Cursor (with @Docs and philosophy):
1. Reads .cursor/rules/philosophy.mdc
2. Checks PHILOSOPHY.md#patterns
3. References research/MARTIN_FOWLER.md
4. Recommends composition with rationale
5. Provides example implementation
6. Explains trade-offs based on project philosophy
```

---

## Advanced Features

### Multi-Language Projects

Create separate rules per language:

```
.cursor/rules/
├── index.mdc          # Cross-language philosophy
├── typescript.mdc     # TypeScript philosophy
├── python.mdc         # Python philosophy
├── rust.mdc          # Rust philosophy
└── go.mdc            # Go philosophy
```

Each can reference language-specific philosophy:
- PHILOSOPHY.md#typescript
- PHILOSOPHY.md#python
- research/GUIDO_VAN_ROSSUM.md (Python creator)
- research/ANDERS_HEJLSBERG.md (TypeScript creator)

### Monorepo Support

Nested rules for different packages:

```
/monorepo-root/
├── .cursor/
│   └── rules/
│       └── index.mdc       # Root philosophy
├── packages/
│   ├── frontend/
│   │   └── .cursor/
│   │       └── rules/
│   │           └── index.mdc   # Frontend-specific
│   └── backend/
│       └── .cursor/
│           └── rules/
│               └── index.mdc   # Backend-specific
└── PHILOSOPHY.md          # Shared philosophy
```

### Team Standardization

**Shared rule repository**:
```bash
# Git submodule or shared package
.cursor-shared-rules/
├── company-standards.mdc
├── security.mdc
└── accessibility.mdc
```

**Project rules reference shared standards**:
```markdown
---
description: "Project rules + company standards"
---

<!-- Company standards -->
See .cursor-shared-rules/ for company-wide standards

<!-- Project philosophy -->
See PHILOSOPHY.md for project-specific philosophy
```

---

## Limitations and Considerations

### File Size
- Large rule files may impact performance
- Keep rules concise
- Reference external docs (PHILOSOPHY.md) for details

### Rule Conflicts
- Higher priority rules override lower priority
- Test rule combinations
- Document priority strategy

### Version Control
- Commit `.cursor/rules/` to repository
- Document rule changes in commits
- Review rule changes in PRs

### IDE Dependency
- Rules specific to Cursor IDE
- Consider cross-tool compatibility (AGENTS.md)
- Maintain both for maximum reach

---

## Cross-Tool Compatibility

### Supporting Multiple AI Tools

**Recommended approach**: Use both Cursor Rules and AGENTS.md

```
/repository/
├── .cursor/
│   └── rules/
│       └── index.mdc      # Cursor-specific features
├── AGENTS.md              # Cross-tool compatibility
├── PHILOSOPHY.md          # Detailed philosophy (referenced by both)
└── research/              # Thought leader philosophies
```

**AGENTS.md** (Simple, cross-tool):
```markdown
# AGENTS.md

See PHILOSOPHY.md for our coding philosophy.

Key principles:
- TDD (PHILOSOPHY.md#testing)
- Hexagonal architecture (PHILOSOPHY.md#architecture)
```

**.cursor/rules/index.mdc** (Cursor-specific features):
```markdown
---
description: "Cursor-specific enhanced guidance"
globs: ["**/*"]
---

# Cursor Philosophy Integration

Use @Docs for framework APIs
Use PHILOSOPHY.md for project decisions
Use research/ for thought leader perspectives

[Cursor-specific advanced features]
```

---

## References

1. Cursor Docs. "Rules for AI." https://docs.cursor.com/context/rules-for-ai
2. GitHub. "awesome-cursorrules." https://github.com/PatrickJS/awesome-cursorrules
3. DotCursorRules.com. "Mastering AI-Assisted Coding." https://dotcursorrules.com/
4. Medium. "Maximizing Your Cursor Use: Advanced Prompting, Cursor Rules, and Tooling Integration." https://extremelysunnyyk.medium.com/maximizing-your-cursor-use-advanced-prompting-cursor-rules-and-tooling-integration-496181fa919c
5. GitHub. "cursor-best-practices." https://github.com/digitalchild/cursor-best-practices
6. DataCamp. "Cursor AI: A Guide With 10 Practical Examples." https://www.datacamp.com/tutorial/cursor-ai-code-editor
7. Cursor Docs. "Working with Documentation." https://docs.cursor.com/guides/advanced/working-with-documentation
