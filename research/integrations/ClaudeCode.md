# Philosophy.md Integration with Claude Code

## Overview

Claude Code provides multiple integration mechanisms that Philosophy.md can leverage to deliver coding philosophy guidance to AI agents and developers.

## Integration Mechanisms

### 1. CLAUDE.md File (Immediate, No Custom Code)

**How it Works**: Claude Code automatically reads and follows CLAUDE.md files

**Implementation**:
```markdown
<!-- CLAUDE.md -->
# Project Configuration

## Philosophy
See PHILOSOPHY.md for our coding philosophy and architectural decisions.

Key principles:
- TDD for all new features (see PHILOSOPHY.md#testing)
- Hexagonal architecture (see PHILOSOPHY.md#architecture)
- Functional core, imperative shell pattern
```

**Pros**:
- Zero custom code required
- Works immediately
- Strong instruction adherence
- Session persistence

**Cons**:
- Token budget consumed
- Must keep concise
- Not interactive

---

### 2. Subagents (Custom Task-Specific Agents)

**How it Works**: Create custom subagents specialized in philosophy guidance

**Example Configuration**:
```typescript
// .claude/agents/philosophy-advisor.ts
export default {
  name: "philosophy-advisor",
  description: "Advises on coding philosophy and architectural decisions",
  systemPrompt: `
You are a philosophy advisor for this codebase. Your role is to:
1. Reference PHILOSOPHY.md for project-specific philosophy
2. Reference research/* for language/framework philosophies
3. Help developers apply philosophical principles to code decisions
4. Explain the "why" behind architectural choices

When advising:
- Always cite specific sections from PHILOSOPHY.md or research files
- Explain trade-offs and alternatives
- Connect principles to concrete code examples
`,
  tools: ["read", "grep", "glob"],
  model: "claude-sonnet-4-5"
};
```

**Usage**:
```
User: /agent philosophy-advisor Should I use inheritance or composition here?

Agent: Let me check the project philosophy...
[Reads PHILOSOPHY.md]
According to PHILOSOPHY.md#composition-over-inheritance:
"We prefer composition because..."
```

**Pros**:
- Dedicated context for philosophy
- Can reference all philosophy docs
- Interactive Q&A
- Separate context window

**Cons**:
- Requires custom agent configuration
- User must explicitly invoke

---

### 3. Skills (Reusable Philosophy Knowledge)

**How it Works**: Create skill folders that Claude discovers and loads when relevant

**Example Structure**:
```
.claude/skills/
└── philosophy-guide/
    ├── README.md           # Skill description
    ├── instructions.md     # How to use PHILOSOPHY.md
    ├── patterns.md         # Common patterns
    └── examples/
        ├── tdd-example.md
        └── hexagonal-arch-example.md
```

**Skill README**:
```markdown
# Philosophy Guide Skill

This skill helps apply coding philosophies from PHILOSOPHY.md to development tasks.

## When to Use
- Making architectural decisions
- Choosing design patterns
- Resolving code design questions
- Learning project philosophy

## How to Use
1. Check PHILOSOPHY.md for project-specific guidance
2. Check research/* for language/framework philosophy
3. Apply principles with concrete examples
```

**Pros**:
- Automatically discovered when relevant
- Reusable across conversations
- Rich documentation support
- No explicit invocation needed

**Cons**:
- Limited to Claude Code
- Requires skill development

---

### 4. Slash Commands (Quick Philosophy Access)

**How it Works**: Create custom slash commands for common philosophy queries

**Example Implementation**:
```typescript
// .claude/commands/philosophy.ts
export default {
  name: "philosophy",
  description: "Get guidance on coding philosophy",
  async execute(args: string[]) {
    const topic = args[0] || "overview";

    // Read relevant philosophy docs
    const philosophyContent = await readFile("PHILOSOPHY.md");
    const researchContent = await readFile(`research/${topic}.md`);

    return {
      content: `
# Philosophy Guidance: ${topic}

## Project Philosophy
${extractSection(philosophyContent, topic)}

## Research & Best Practices
${extractSection(researchContent, topic)}

## Application
How would you like to apply this philosophy to your current task?
      `
    };
  }
};
```

**Usage**:
```
/philosophy testing    # Get testing philosophy
/philosophy tdd        # Get TDD guidance
/philosophy patterns   # Get design patterns guidance
```

**Pros**:
- Quick access
- Targeted queries
- Can aggregate multiple sources
- Interactive

**Cons**:
- Requires JavaScript/TypeScript
- Limited to Claude Code
- Maintenance overhead

---

### 5. Hooks (Automatic Philosophy Checks)

**How it Works**: Use hooks to automatically check code against philosophy

**Example - Pre-Commit Hook**:
```typescript
// .claude/hooks/pre-commit.ts
export default async function preCommit(files: string[]) {
  const philosophy = await readFile("PHILOSOPHY.md");
  const checks = [];

  // Check if code follows philosophy
  for (const file of files) {
    if (file.endsWith(".test.ts") && !file.includes("test")) {
      checks.push({
        file,
        message: "PHILOSOPHY.md requires tests for all features",
        suggestion: "Add tests or update PHILOSOPHY.md to explain exception"
      });
    }
  }

  if (checks.length > 0) {
    return {
      proceed: false,
      message: "Philosophy violations detected",
      checks
    };
  }

  return { proceed: true };
}
```

**Pros**:
- Automatic enforcement
- Prevents philosophy drift
- Educational for team
- Catches issues early

**Cons**:
- Can be overly restrictive
- Requires careful design
- False positives possible

---

### 6. Model Context Protocol (MCP) Server

**How it Works**: Create MCP server that provides philosophy context

**Potential Implementation**:
```typescript
// philosophy-mcp-server/index.ts
import { Server } from "@anthropic/agent-sdk";

const server = new Server({
  name: "philosophy",
  version: "1.0.0",

  tools: [
    {
      name: "get_philosophy",
      description: "Get project coding philosophy",
      input_schema: {
        type: "object",
        properties: {
          topic: { type: "string" }
        }
      },
      async execute({ topic }) {
        // Read and return philosophy docs
        return await getPhilosophyGuidance(topic);
      }
    },
    {
      name: "check_alignment",
      description: "Check if code aligns with philosophy",
      input_schema: {
        type: "object",
        properties: {
          code: { type: "string" },
          principle: { type: "string" }
        }
      },
      async execute({ code, principle }) {
        // Analyze code against philosophy
        return await checkPhilosophyAlignment(code, principle);
      }
    }
  ]
});
```

**Pros**:
- Standardized integration
- Works across MCP-compatible tools
- Rich functionality possible
- Sharable across projects

**Cons**:
- More complex to build
- Requires server deployment
- MCP ecosystem still developing

---

## Recommended Integration Strategy

### Phase 1: Immediate (CLAUDE.md)

1. Create CLAUDE.md that references PHILOSOPHY.md
2. Keep concise to save tokens
3. Point to specific sections for details

**Example**:
```markdown
# CLAUDE.md

## Coding Philosophy
We follow specific coding philosophies documented in PHILOSOPHY.md.

Key principles to always follow:
- TDD (PHILOSOPHY.md#testing) - All features need tests
- Composition over inheritance (PHILOSOPHY.md#patterns)
- Hexagonal architecture (PHILOSOPHY.md#architecture)

When making design decisions, consult PHILOSOPHY.md first.
```

### Phase 2: Skills (Portable Knowledge)

1. Create philosophy-guide skill
2. Include examples and patterns
3. Make discoverable for relevant tasks

### Phase 3: Subagents (Specialized Guidance)

1. Create philosophy-advisor subagent
2. Specialize in architecture and design decisions
3. Reference all philosophy documents

### Phase 4: Advanced (Commands, Hooks, MCP)

1. Add slash commands for quick queries
2. Consider hooks for automatic checks
3. Explore MCP server for cross-tool compatibility

## Integration Benefits

### For Developers

- **Instant access** to project philosophy
- **Contextual guidance** when making decisions
- **Learning resource** for new team members
- **Consistency** across codebase

### For AI Agents

- **Better code generation** aligned with philosophy
- **Architectural guidance** for complex decisions
- **Pattern recognition** from philosophy docs
- **Explanation capability** of design choices

### For Teams

- **Shared understanding** of principles
- **Documented decisions** and rationale
- **Onboarding efficiency** for new members
- **Code review aid** referencing philosophy

## Example Workflows

### Workflow 1: Feature Development

```
Developer: "I need to add user authentication"

Claude (with philosophy integration):
1. Reads PHILOSOPHY.md#security
2. References research/SECURITY_PATTERNS.md
3. Suggests architecture aligned with philosophy
4. Generates code following principles
5. Includes tests per TDD philosophy
```

### Workflow 2: Architecture Decision

```
Developer: "Should we use microservices or monolith?"

Claude (via /agent philosophy-advisor):
1. Reads PHILOSOPHY.md#architecture
2. Checks project context and constraints
3. Explains trade-offs per philosophy
4. References research (e.g., Martin Fowler on architecture)
5. Recommends approach with rationale
```

### Workflow 3: Code Review

```
Developer: "Review this implementation"

Claude (with philosophy hooks):
1. Checks code against PHILOSOPHY.md principles
2. Verifies tests exist (TDD philosophy)
3. Validates patterns used
4. Suggests improvements aligned with philosophy
5. Explains suggestions with philosophy references
```

## References

1. Claude Docs. "Subagents." https://docs.claude.com/en/docs/claude-code/sub-agents
2. Claude Blog. "Skills explained." https://www.claude.com/blog/skills-explained
3. Anthropic. "Building agents with the Claude Agent SDK." https://www.anthropic.com/engineering/building-agents-with-the-claude-agent-sdk
4. Claude Docs. "Agent SDK overview." https://docs.claude.com/en/docs/agent-sdk/overview
5. Medium. "Supercharge Your Tech Writing with Claude Code Subagents and Agent Skills." https://medium.com/google-cloud/supercharge-tech-writing-with-claude-code-subagents-and-agent-skills-44eb43e5a9b7
