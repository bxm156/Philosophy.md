# Philosophy.md Integration with GitHub Copilot

## Overview

GitHub Copilot provides multiple mechanisms for integrating coding philosophy guidance into AI-assisted development workflows. As of 2025, Copilot supports custom instructions through several file formats and has embraced the Model Context Protocol (MCP) for extensibility.

## Integration Mechanisms

### 1. Custom Instructions Files (Native Support)

**How it Works**: GitHub Copilot automatically reads custom instruction files from your repository

**Supported File Names**:
- `.github/copilot-instructions.md` (repository-wide)
- `.github/instructions/*.instructions.md` (path-specific)
- `AGENTS.md` (root or nested for hierarchical scope)
- `CLAUDE.md` (cross-tool compatibility)
- `GEMINI.md` (cross-tool compatibility)

**Instruction Priority**:
1. Personal instructions (highest priority)
2. Repository instructions
3. Organization instructions (lowest priority)

All relevant instruction sets are combined and provided to Copilot.

---

### 2. Repository-Wide Instructions

**Implementation**:

Create `.github/copilot-instructions.md` in your repository:

```markdown
# Repository Instructions for GitHub Copilot

## Philosophy
This project follows specific coding philosophies documented in PHILOSOPHY.md.

Before making architectural decisions, consult PHILOSOPHY.md for:
- Design principles (PHILOSOPHY.md#principles)
- Architecture patterns (PHILOSOPHY.md#architecture)
- Testing philosophy (PHILOSOPHY.md#testing)
- Code organization (PHILOSOPHY.md#structure)

## Key Philosophical Guidelines

### Test-Driven Development
We practice TDD. See PHILOSOPHY.md#testing for rationale.
- Write tests before implementation
- All features require test coverage
- Tests document expected behavior

### Composition Over Inheritance
We prefer composition. See PHILOSOPHY.md#patterns for explanation.
- Use composition for code reuse
- Avoid deep inheritance hierarchies
- Apply Strategy pattern over inheritance

### Hexagonal Architecture
We follow hexagonal architecture. See PHILOSOPHY.md#architecture for details.
- Domain logic independent of frameworks
- Ports and adapters pattern
- Clear separation of concerns

## References
- PHILOSOPHY.md - Full coding philosophy documentation
- research/MARTIN_FOWLER.md - Refactoring principles
- research/ROBERT_MARTIN.md - Clean code practices
```

**Pros**:
- Applies to entire repository
- Simple single-file approach
- Automatically included in all Copilot requests
- Version controlled with code

**Cons**:
- Same instructions for all file types
- Can become verbose
- No conditional logic

---

### 3. Path-Specific Instructions

**How it Works**: Different instructions for different parts of codebase using glob patterns

**Example Structure**:
```
.github/
└── instructions/
    ├── backend.instructions.md
    ├── frontend.instructions.md
    ├── tests.instructions.md
    └── documentation.instructions.md
```

**Example - Backend Instructions**:
```markdown
---
applyTo: "src/backend/**/*.ts,src/api/**/*.ts"
---

# Backend Development Philosophy

## API Design
Follow REST principles documented in PHILOSOPHY.md#api-design:
- Resource-oriented endpoints
- Proper HTTP verb usage
- Stateless operations
- Clear error responses

## Domain Logic
Apply domain-driven design principles (PHILOSOPHY.md#ddd):
- Rich domain models
- Ubiquitous language
- Bounded contexts
- Repository pattern for data access

See research/MARTIN_FOWLER.md for enterprise architecture patterns.
```

**Example - Frontend Instructions**:
```markdown
---
applyTo: "src/components/**/*.tsx,src/pages/**/*.tsx"
---

# Frontend Development Philosophy

## Component Design
Follow component philosophy from PHILOSOPHY.md#components:
- Single responsibility principle
- Composition over prop drilling
- Container/Presentational pattern
- Accessibility-first approach

## State Management
See PHILOSOPHY.md#state for state management principles:
- Local state by default
- Context for cross-cutting concerns
- Avoid global state when possible
```

**Example - Test Instructions**:
```markdown
---
applyTo: "**/*.test.ts,**/*.spec.ts,tests/**/*"
---

# Testing Philosophy

Follow TDD principles from PHILOSOPHY.md#testing:
- Arrange-Act-Assert pattern
- Test behavior, not implementation
- Clear test descriptions
- One assertion per test when possible

See research/KENT_BECK.md for TDD philosophy and research/ROY_OSHEROVE.md for testing best practices.
```

**Pros**:
- Targeted guidance per file type
- More relevant context for specific tasks
- Reduces noise in instructions
- Easier to maintain separate concerns

**Cons**:
- More files to maintain
- Requires understanding glob patterns
- Can lead to instruction duplication

---

### 4. Agent-Specific Instructions

**How it Works**: Use `excludeAgent` property to control which Copilot agents use instructions

**Example**:
```markdown
---
applyTo: "**/*.ts"
excludeAgent: "code-review"
---

# Coding Agent Instructions Only

These instructions apply to the coding agent but not code review.

When implementing features, consult PHILOSOPHY.md for:
- Architecture decisions
- Pattern selection
- Testing requirements
```

**Use Cases**:
- Different philosophy for coding vs. reviewing
- Separate instructions for chat vs. coding agent
- Context-specific guidance

**Available Agents**:
- `coding-agent` - The agentic coding assistant
- `code-review` - Code review functionality

---

### 5. AGENTS.md Support

**How it Works**: GitHub Copilot coding agent supports AGENTS.md format natively

**Implementation**:
```markdown
# AGENTS.md

## Coding Philosophy
Consult PHILOSOPHY.md before making architectural decisions.

Key principles:
- TDD for all features (PHILOSOPHY.md#testing)
- Hexagonal architecture (PHILOSOPHY.md#architecture)
- Functional core, imperative shell

## See Also
- PHILOSOPHY.md - Our coding philosophy
- research/ - Industry best practices and thought leader philosophies
```

**Hierarchical Support**: Create nested AGENTS.md files for directory-specific guidance

```
/
├── AGENTS.md                    # Root project guidance
├── PHILOSOPHY.md                # Philosophy documentation
└── src/
    ├── backend/
    │   └── AGENTS.md           # Backend-specific guidance
    └── frontend/
        └── AGENTS.md           # Frontend-specific guidance
```

**Pros**:
- Cross-tool compatibility (Copilot, Cursor, others)
- Hierarchical scope (closer files take precedence)
- Simple markdown format
- Growing ecosystem support

**Cons**:
- Newer format (less mature tooling)
- Requires understanding hierarchical precedence

---

### 6. Model Context Protocol (MCP) Integration

**How it Works**: Create MCP server to provide dynamic philosophy context

**Status**: GitHub is transitioning from GitHub App-based Copilot Extensions to MCP servers (deprecation date: November 10, 2025)

**Benefits of MCP**:
- Universal standard for AI integration
- Build once, use across compatible AI hosts
- Dynamic context provision
- Integration with external tools and documentation

**Example MCP Server for Philosophy Context**:

```typescript
// philosophy-mcp-server/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { readFile } from "fs/promises";
import path from "path";

const server = new Server(
  {
    name: "philosophy-context-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      resources: {},
      tools: {},
    },
  }
);

// Provide philosophy documentation as resources
server.setRequestHandler("resources/list", async () => {
  return {
    resources: [
      {
        uri: "philosophy://main",
        name: "Project Coding Philosophy",
        mimeType: "text/markdown",
      },
      {
        uri: "philosophy://testing",
        name: "Testing Philosophy",
        mimeType: "text/markdown",
      },
      {
        uri: "philosophy://architecture",
        name: "Architecture Philosophy",
        mimeType: "text/markdown",
      },
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

  // Handle other philosophy sections...
});

// Tool: Get philosophy guidance for specific topic
server.setRequestHandler("tools/list", async () => {
  return {
    tools: [
      {
        name: "get_philosophy",
        description: "Get coding philosophy guidance for a specific topic",
        inputSchema: {
          type: "object",
          properties: {
            topic: {
              type: "string",
              description: "Philosophy topic (testing, architecture, patterns, etc.)",
            },
          },
          required: ["topic"],
        },
      },
      {
        name: "check_principle",
        description: "Check if code aligns with project philosophy",
        inputSchema: {
          type: "object",
          properties: {
            code: {
              type: "string",
              description: "Code to check",
            },
            principle: {
              type: "string",
              description: "Principle to check against",
            },
          },
          required: ["code", "principle"],
        },
      },
    ],
  };
});

server.setRequestHandler("tools/call", async (request) => {
  const { name, arguments: args } = request.params;

  if (name === "get_philosophy") {
    const philosophy = await readFile("PHILOSOPHY.md", "utf-8");
    // Extract relevant section based on topic
    return {
      content: [{
        type: "text",
        text: `Philosophy guidance for ${args.topic}:\n\n${philosophy}`,
      }],
    };
  }

  if (name === "check_principle") {
    // Analyze code against principle
    return {
      content: [{
        type: "text",
        text: `Analysis of code alignment with ${args.principle}...`,
      }],
    };
  }
});

// Start server
const transport = new StdioServerTransport();
await server.connect(transport);
```

**VS Code Configuration**:

Add to `.vscode/settings.json`:
```json
{
  "github.copilot.chat.mcp.enabled": true,
  "github.copilot.chat.mcp.servers": {
    "philosophy": {
      "command": "node",
      "args": ["/path/to/philosophy-mcp-server/index.js"]
    }
  }
}
```

**Pros**:
- Dynamic, intelligent context provision
- Can analyze and interpret philosophy
- Cross-tool compatibility (MCP is universal standard)
- Rich functionality beyond static files
- Can integrate with external documentation systems

**Cons**:
- Requires server development
- More complex than static files
- Needs maintenance and updates
- Enterprise policy controls may restrict MCP usage

---

## Recommended Integration Strategy

### Phase 1: Immediate (Repository Instructions)

1. Create `.github/copilot-instructions.md` that references PHILOSOPHY.md
2. Keep concise - focus on high-level principles
3. Point to specific sections for details

**Example**:
```markdown
# Copilot Instructions

## Coding Philosophy
We follow coding philosophies documented in PHILOSOPHY.md.

Before implementing features:
1. Check PHILOSOPHY.md for relevant principles
2. Apply appropriate design patterns
3. Follow testing requirements

Key principles:
- TDD (PHILOSOPHY.md#testing)
- Hexagonal architecture (PHILOSOPHY.md#architecture)
- Composition over inheritance (PHILOSOPHY.md#patterns)

See PHILOSOPHY.md for detailed rationale and examples.
```

### Phase 2: Path-Specific Refinement

1. Create `.github/instructions/` directory
2. Add topic-specific instruction files
3. Use glob patterns for targeted guidance
4. Reference PHILOSOPHY.md sections relevant to each area

### Phase 3: Cross-Tool Compatibility

1. Add `AGENTS.md` in project root
2. Reference PHILOSOPHY.md
3. Enable compatibility with multiple AI coding assistants
4. Consider hierarchical AGENTS.md for complex projects

### Phase 4: Advanced (MCP Integration)

1. Develop MCP server for philosophy context
2. Provide dynamic philosophy guidance
3. Enable cross-tool usage
4. Consider organization-wide deployment

---

## Best Practices for Custom Instructions

### 1. Project Overview
Provide elevator pitch describing what your app does, audience, and key features.

### 2. Tech Stack Documentation
List backend, frontend, APIs, and testing frameworks to prevent framework confusion.

### 3. Coding Guidelines
Document standards that apply across all languages:
- Formatting preferences
- Testing requirements
- Documentation standards
- Security practices

### 4. Project Structure
Map folder organization and purposes to prevent confusion about component locations.

### 5. Available Resources
Point to:
- Development scripts
- Automation tools
- MCP servers
- Documentation (like PHILOSOPHY.md)

### 6. Keep It Concise
- Aim for under two pages
- Use references to detailed docs
- Focus on actionable guidance
- Avoid task-specific instructions

### 7. Evolve With Project
- Update as understanding deepens
- Refine based on team feedback
- Don't aim for perfection initially
- "Imperfect instructions deliver far more impact than nothing at all"

---

## Integration Benefits

### For Developers

- **Contextual guidance**: Philosophy automatically included in Copilot interactions
- **Consistent suggestions**: AI-generated code aligns with project principles
- **Reduced cognitive load**: Don't repeat philosophy in every prompt
- **Onboarding aid**: New team members get immediate context

### For AI Code Generation

- **Better alignment**: Generated code follows project philosophy
- **Architectural consistency**: Suggestions match documented patterns
- **Principle-based decisions**: AI considers philosophy when making choices
- **Reduced rework**: Fewer suggestions that violate project standards

### For Teams

- **Shared understanding**: Philosophy consistently applied across team
- **Code review efficiency**: AI-generated code pre-aligned with standards
- **Knowledge preservation**: Philosophy captured and version-controlled
- **Scalability**: Philosophy guidance scales to all team members

---

## Example Workflows

### Workflow 1: Feature Implementation

```
Developer: "Add user authentication to the app"

Copilot (with philosophy integration):
1. Reads .github/copilot-instructions.md
2. References PHILOSOPHY.md#security for security principles
3. Applies hexagonal architecture pattern from PHILOSOPHY.md#architecture
4. Generates code with:
   - Domain layer (business logic)
   - Application layer (use cases)
   - Adapter layer (framework integration)
5. Includes tests per TDD philosophy
6. Follows composition patterns from PHILOSOPHY.md#patterns
```

### Workflow 2: Code Review

```
Developer: "@workspace Review this authentication implementation"

Copilot Code Review (with philosophy integration):
1. Reads .github/copilot-instructions.md with excludeAgent settings
2. Checks against PHILOSOPHY.md principles
3. Validates:
   - Tests exist (TDD philosophy)
   - Architecture follows hexagonal pattern
   - Composition used over inheritance
   - Security practices followed
4. Suggests improvements aligned with philosophy
5. References specific PHILOSOPHY.md sections in feedback
```

### Workflow 3: Path-Specific Guidance

```
Developer: Working in src/components/UserProfile.tsx

Copilot (with path-specific instructions):
1. Reads .github/instructions/frontend.instructions.md (matches glob pattern)
2. Applies component design philosophy
3. Suggests:
   - Component composition
   - Accessibility attributes
   - Local state management
4. References PHILOSOPHY.md#components for rationale
```

---

## Organization-Level Philosophy

**Enterprise Feature**: Set default custom instructions for all coding agent usage across organization

**Use Case**: Ensure consistent philosophy application across multiple repositories

**Implementation**:
1. Organization admins configure default instructions
2. Apply to all repositories in organization
3. Repositories can supplement with project-specific guidance
4. Combined with repository and personal instructions

**Benefit**: Company-wide coding standards and philosophy automatically applied

---

## Limitations and Considerations

### Token Budget
- Custom instructions included in every request
- Verbose instructions consume context window
- Keep concise and reference detailed docs
- Use path-specific instructions to reduce irrelevant context

### Instruction Precedence
- Personal > Repository > Organization
- All relevant instructions are combined
- Consider instruction interaction
- Test with different file paths

### File Discovery
- Copilot automatically discovers supported file names
- No configuration required for standard locations
- Non-standard locations won't be detected
- Use official file names and locations

### MCP Enterprise Controls
- Organizations can enable/disable MCP usage
- Policy disabled by default
- Requires enterprise configuration
- Not available in all environments

---

## Migration from Other Formats

### From .cursorrules

Cursor `.cursorrules` can be adapted:

```markdown
# .github/copilot-instructions.md

<!-- Adapted from .cursorrules -->

See PHILOSOPHY.md for our coding philosophy.

[Rest of your Cursor rules content]
```

### From CLAUDE.md

If you have `CLAUDE.md`, it's already supported:

```markdown
# CLAUDE.md

<!-- This file works with both Claude Code and GitHub Copilot -->

See PHILOSOPHY.md for detailed coding philosophy.

[Claude-specific and cross-tool guidance]
```

### From Legacy Documentation

Convert existing coding standards:

```markdown
# .github/copilot-instructions.md

## Philosophy
Our coding standards are documented in PHILOSOPHY.md.

<!-- Reference legacy docs -->
For historical context, see docs/CODING_STANDARDS.md

[Summarized key points]
```

---

## References

1. GitHub Docs. "Adding repository custom instructions for GitHub Copilot." https://docs.github.com/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot
2. GitHub Blog. "5 tips for writing better custom instructions for Copilot." https://github.blog/ai-and-ml/github-copilot/5-tips-for-writing-better-custom-instructions-for-copilot/
3. GitHub Changelog. "GitHub Copilot coding agent now supports .instructions.md custom instructions." https://github.blog/changelog/2025-07-23-github-copilot-coding-agent-now-supports-instructions-md-custom-instructions/
4. GitHub Changelog. "Copilot coding agent now supports AGENTS.md custom instructions." https://github.blog/changelog/2025-08-28-copilot-coding-agent-now-supports-agents-md-custom-instructions/
5. GitHub Docs. "Extending GitHub Copilot Chat with Model Context Protocol (MCP) servers." https://docs.github.com/en/copilot/how-tos/context/model-context-protocol/extending-copilot-chat-with-mcp
6. GitHub Blog. "5 ways to transform your workflow using GitHub Copilot and MCP." https://github.blog/ai-and-ml/github-copilot/5-ways-to-transform-your-workflow-using-github-copilot-and-mcp/
7. GitHub Changelog. "Sunset notice: GitHub App-based Copilot Extensions." https://github.blog/changelog/2025-09-24-deprecate-github-copilot-extensions-github-apps/
8. GitHub. "awesome-copilot: Community-contributed instructions, prompts, and configurations." https://github.com/github/awesome-copilot
