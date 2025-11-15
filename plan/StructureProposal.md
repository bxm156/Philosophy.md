# PHILOSOPHY.md Structure Proposal

## File Naming Convention

### Primary File: PHILOSOPHY.md

**Recommendation**: Use **`PHILOSOPHY.md`** (all caps)

**Rationale**:
1. **Consistency with conventions**: Matches README.md, AGENTS.md, LICENSE.md, CONTRIBUTING.md
2. **High visibility**: All-caps files appear at top of directory listings
3. **Clear intent**: Immediately signals importance and purpose
4. **Cross-platform**: Works on all file systems
5. **Tool-friendly**: Easy for AI tools to discover and parse

**Alternative considered**: `philosophy.md` (lowercase)
- **Rejected**: Less visible, doesn't match convention of important repo files

**Alternative considered**: `.philosophy.md` (hidden file)
- **Rejected**: Hidden files reduce discoverability, not appropriate for primary documentation

### Repository Structure

**Recommended structure**:

```
/repository-root/
├── README.md                 # For humans: What, how to use
├── AGENTS.md                 # For AI: Commands, conventions
├── PHILOSOPHY.md             # For AI + humans: Why, principles
├── CONTRIBUTING.md           # How to contribute
├── LICENSE.md                # Legal
│
├── .github/
│   ├── copilot-instructions.md   # GitHub Copilot config
│   └── instructions/             # Path-specific instructions
│
├── .cursor/
│   └── rules/
│       └── index.mdc             # Cursor IDE config
│
├── .claude/                      # Claude Code config (optional)
│   ├── agents/                   # Custom subagents
│   ├── commands/                 # Slash commands
│   └── skills/                   # Skills
│
├── philosophy/                   # Detailed philosophy docs (optional)
│   ├── architecture.md
│   ├── testing.md
│   ├── patterns.md
│   └── refactoring.md
│
└── research/                     # Thought leader research
    ├── MARTIN_FOWLER.md
    ├── KENT_BECK.md
    ├── ROBERT_MARTIN.md
    └── [other thought leaders]
```

---

## File Organization Patterns

### Pattern 1: Simple (Recommended for Small Projects)

**Single file**: `PHILOSOPHY.md`

**Structure**:
```markdown
# PHILOSOPHY.md

## Principles
## Architecture
## Testing
## Patterns
## Refactoring
## References
```

**Pros**:
- Simple to maintain
- Easy to search
- Single source of truth
- Works well up to ~500 lines

**Cons**:
- Can become long for complex projects
- Harder to navigate for specific topics

**Best for**: Solo projects, startups, small teams (1-10 developers)

---

### Pattern 2: Modular (Recommended for Medium Projects)

**Main file**: `PHILOSOPHY.md` (overview + cross-references)
**Detailed docs**: `philosophy/` directory

**Structure**:
```markdown
# PHILOSOPHY.md (Overview)

## Quick Reference
- Architecture: philosophy/architecture.md
- Testing: philosophy/testing.md
- Patterns: philosophy/patterns.md

## Core Principles
[High-level principles]

## See Also
- philosophy/ - Detailed documentation
- research/ - Thought leader perspectives
```

```
philosophy/
├── architecture.md       # Detailed architecture philosophy
├── testing.md           # Detailed testing philosophy
├── patterns.md          # Design patterns and preferences
├── refactoring.md       # Refactoring approach
├── security.md          # Security philosophy
└── accessibility.md     # Accessibility philosophy
```

**Pros**:
- Organized by topic
- Easier to navigate
- Can grow without overwhelming main file
- Supports different expertise levels

**Cons**:
- More files to maintain
- Need to keep cross-references updated
- Slightly more complex structure

**Best for**: Growing teams, medium codebases, specialized domains

---

### Pattern 3: Comprehensive (Recommended for Large Projects)

**Main file**: `PHILOSOPHY.md` (executive summary)
**Detailed docs**: `philosophy/` (organized by domain)
**Research**: `research/` (thought leaders)

**Structure**:
```markdown
# PHILOSOPHY.md (Executive Summary)

## Philosophy Summary
[1-2 page overview]

## Documentation Structure
- philosophy/ - Detailed philosophy by topic
- research/ - Thought leader research and perspectives

## Quick Navigation
- Architecture decisions: philosophy/architecture.md
- Testing approach: philosophy/testing/
- Design patterns: philosophy/patterns/
```

```
philosophy/
├── architecture/
│   ├── overview.md
│   ├── hexagonal.md
│   ├── microservices-vs-monolith.md
│   └── decisions/
│       ├── 2024-01-architecture-decision.md
│       └── 2024-03-migration-strategy.md
├── testing/
│   ├── overview.md
│   ├── tdd.md
│   ├── integration-testing.md
│   └── e2e-testing.md
├── patterns/
│   ├── overview.md
│   ├── composition-over-inheritance.md
│   ├── dependency-injection.md
│   └── factory-pattern.md
└── security/
    ├── overview.md
    ├── authentication.md
    └── authorization.md
```

```
research/
├── industry/
│   ├── AGENTS.md
│   ├── AgentRules.md
│   └── ToolComparison.md
├── integrations/
│   ├── ClaudeCode.md
│   ├── GitHubCopilot.md
│   └── Cursor.md
└── thought-leaders/
    ├── MARTIN_FOWLER.md
    ├── KENT_BECK.md
    ├── ROBERT_MARTIN.md
    └── [20+ thought leaders]
```

**Pros**:
- Scales to enterprise
- Comprehensive documentation
- Supports complex decision history
- Learning resource for team

**Cons**:
- Most complex to maintain
- Requires dedicated documentation effort
- Can be overwhelming for newcomers

**Best for**: Large teams, enterprise projects, open source projects with many contributors

---

## Content Structure

### PHILOSOPHY.md Template

```markdown
# Project Name: Coding Philosophy

> Last updated: YYYY-MM-DD
> Version: X.Y.Z

## Table of Contents
- [Overview](#overview)
- [Core Principles](#core-principles)
- [Architecture](#architecture)
- [Testing](#testing)
- [Design Patterns](#design-patterns)
- [Refactoring](#refactoring)
- [Security](#security)
- [References](#references)

---

## Overview

### Purpose
This document captures our coding philosophy—the "why" behind our technical decisions.

### Audience
- Developers (human and AI)
- New team members
- Code reviewers
- Future maintainers

### Related Documentation
- **AGENTS.md** - AI agent configuration (commands, conventions)
- **README.md** - Project overview and setup
- **CONTRIBUTING.md** - Contribution guidelines
- **philosophy/** - Detailed philosophy documentation
- **research/** - Thought leader perspectives

---

## Core Principles

### 1. [Principle Name]

**What**: [Concise description]

**Why**: [Rationale and reasoning]

**How**: [Practical application]

**Example**:
```[language]
// Good: [Follows principle]
[code example]

// Bad: [Violates principle]
[code example]
```

**Trade-offs**:
- ✅ Benefits: [List benefits]
- ⚠️ Costs: [List costs/compromises]

**References**:
- [Thought leader]: research/[LEADER].md#section
- [Article/Book]: [Link]

---

## Architecture

### Philosophy

**Chosen Approach**: [e.g., Hexagonal Architecture]

**Rationale**:
1. [Reason 1]
2. [Reason 2]
3. [Reason 3]

**Trade-offs Considered**:
| Approach | Pros | Cons | Why Not Chosen |
|----------|------|------|----------------|
| Microservices | Scalability | Complexity | Team too small |
| Layered | Simplicity | Less flexibility | Need framework independence |
| **Hexagonal** | Testability | Learning curve | **Best fit for needs** |

**Decision Factors**:
- Team size: [X] developers
- Domain complexity: [High/Medium/Low]
- Expected scale: [Description]
- Technical constraints: [List]

**References**:
- research/MARTIN_FOWLER.md#hexagonal-architecture
- philosophy/architecture.md (detailed)

---

## Testing

### Philosophy

**Approach**: Test-Driven Development (TDD)

**Why TDD**:
1. Tests document behavior
2. Design improves through testability
3. Refactoring becomes safe
4. Bugs caught early

**Testing Pyramid**:
```
     /\
    /E2E\      Few: Integration/E2E tests
   /------\
  /  Int   \   Some: Integration tests
 /----------\
/   Unit     \  Many: Unit tests
--------------
```

**Test Structure**: Arrange-Act-Assert (AAA)

```[language]
test('user can log in with valid credentials', () => {
  // Arrange: Set up test data and dependencies
  const user = createTestUser();
  const authService = new AuthService();

  // Act: Perform the action
  const result = authService.login(user.email, user.password);

  // Assert: Verify the outcome
  expect(result.success).toBe(true);
  expect(result.user.id).toBe(user.id);
});
```

**What to Test**:
- ✅ Behavior, not implementation
- ✅ Public interfaces
- ✅ Edge cases and error paths
- ❌ Private methods directly
- ❌ Third-party library internals

**References**:
- research/KENT_BECK.md - TDD philosophy
- research/ROY_OSHEROVE.md - Testing best practices
- philosophy/testing.md (detailed)

---

## Design Patterns

### Philosophy: Composition Over Inheritance

**Why**:
- Flexibility: Change behavior at runtime
- Testability: Mock dependencies easily
- Maintainability: Avoid fragile hierarchies
- Reusability: Mix and match capabilities

**Example**:

```typescript
// ❌ Bad: Deep inheritance hierarchy
class Animal { }
class Mammal extends Animal { }
class Dog extends Mammal {
  bark() { }
}

// ✅ Good: Composition with interfaces
interface Barkable {
  bark(): void;
}

interface Walkable {
  walk(): void;
}

class Dog implements Barkable, Walkable {
  constructor(
    private barkBehavior: BarkBehavior,
    private walkBehavior: WalkBehavior
  ) {}

  bark() { this.barkBehavior.bark(); }
  walk() { this.walkBehavior.walk(); }
}
```

**Preferred Patterns**:
1. **Strategy**: Encapsulate algorithms
2. **Dependency Injection**: Invert dependencies
3. **Repository**: Abstract data access
4. **Factory**: Create objects without exposing logic
5. **Observer**: Decouple event producers and consumers

**Anti-Patterns to Avoid**:
- ❌ God Object: Classes that know/do too much
- ❌ Spaghetti Code: Tangled dependencies
- ❌ Golden Hammer: Using same pattern for everything
- ❌ Premature Optimization: Optimizing before measuring

**References**:
- research/MARTIN_FOWLER.md#patterns
- research/GANG_OF_FOUR.md
- philosophy/patterns.md (detailed)

---

## Refactoring

### Philosophy

**Continuous Improvement**: Refactoring is ongoing, not a phase

**When to Refactor**:
- Before adding new feature (make change easy, then make easy change)
- During code review (boy scout rule: leave cleaner than found)
- When understanding improves (evolutionary design)
- When tests enable safe changes

**How to Refactor**:
1. Have comprehensive tests
2. Make small, safe changes
3. Keep tests green
4. Commit frequently
5. Use IDE refactoring tools

**Common Refactorings**:
- Extract Method: Break down long methods
- Rename: Improve clarity
- Extract Class: Single Responsibility Principle
- Introduce Parameter Object: Reduce parameter lists
- Replace Conditional with Polymorphism: Eliminate switch statements

**Example**:

```typescript
// Before: Long method
function processOrder(order: Order) {
  // validation (10 lines)
  // calculation (15 lines)
  // persistence (8 lines)
  // notification (12 lines)
}

// After: Extracted methods
function processOrder(order: Order) {
  validateOrder(order);
  const total = calculateOrderTotal(order);
  saveOrder(order, total);
  notifyCustomer(order);
}
```

**References**:
- research/MARTIN_FOWLER.md#refactoring
- Book: "Refactoring: Improving the Design of Existing Code"
- philosophy/refactoring.md (detailed)

---

## Security

### Philosophy

**Security by Design**: Security is not an afterthought

**Principles**:
1. Defense in Depth: Multiple layers of security
2. Least Privilege: Minimum necessary permissions
3. Fail Securely: Errors don't expose vulnerabilities
4. No Security by Obscurity: Don't rely on secrecy of implementation

**Common Vulnerabilities** (OWASP Top 10):
- ❌ SQL Injection: Use parameterized queries
- ❌ XSS: Sanitize inputs, escape outputs
- ❌ CSRF: Use tokens
- ❌ Insecure Authentication: Use industry-standard libraries
- ❌ Sensitive Data Exposure: Encrypt at rest and in transit

**Security Checklist**:
- [ ] All inputs validated and sanitized
- [ ] Outputs escaped for context
- [ ] Authentication uses proven libraries
- [ ] Authorization checked on every request
- [ ] Secrets not in code (use environment variables)
- [ ] Dependencies up to date (no known vulnerabilities)
- [ ] HTTPS enforced
- [ ] Security headers configured

**References**:
- research/SECURITY_PATTERNS.md
- OWASP: https://owasp.org/www-project-top-ten/
- philosophy/security.md (detailed)

---

## References

### Primary Sources

**This Repository**:
- **PHILOSOPHY.md** (this file) - Overview
- **philosophy/** - Detailed philosophy documentation
- **research/** - Thought leader research

**Related Documentation**:
- **AGENTS.md** - AI agent configuration
- **README.md** - Project overview
- **CONTRIBUTING.md** - Contribution guidelines

### Thought Leaders

**Referenced in this project**:
- **Martin Fowler** - Refactoring, Patterns, Agile
  - research/MARTIN_FOWLER.md
  - https://martinfowler.com/

- **Kent Beck** - TDD, Extreme Programming
  - research/KENT_BECK.md
  - https://www.kentbeck.com/

- **Robert Martin (Uncle Bob)** - Clean Code, SOLID
  - research/ROBERT_MARTIN.md
  - http://cleancoder.com/

[... additional thought leaders]

### Books

- "Refactoring" - Martin Fowler
- "Test Driven Development: By Example" - Kent Beck
- "Clean Code" - Robert C. Martin
- "Design Patterns" - Gang of Four
- "Patterns of Enterprise Application Architecture" - Martin Fowler

### Articles and Resources

- [Resource name]: [URL]
- [Resource name]: [URL]

---

## Maintenance

**Review Frequency**: Quarterly

**Update Triggers**:
- Major architectural decisions
- Technology stack changes
- Team growth/changes
- Learning from production issues
- Evolution of industry best practices

**Version History**:
- **X.Y.Z** (YYYY-MM-DD): [Description of changes]
- **X.Y.Z** (YYYY-MM-DD): [Description of changes]

---

## Questions or Feedback?

- **Discussions**: [Link to discussions]
- **Issues**: [Link to issues]
- **Maintainers**: [@username1, @username2]

---

*This philosophy document is a living document. It evolves as our understanding deepens and our project grows.*
```

---

## Writing Guidelines

### Content Principles

**1. Clarity**
- Use plain language
- Avoid jargon without explanation
- Define domain-specific terms
- Provide examples

**2. Conciseness**
- Respect reader's time
- Link to detailed docs for depth
- Use tables and lists for scannability
- Keep main file under 1000 lines (use philosophy/ for details)

**3. Actionability**
- Include practical examples
- Show good vs. bad code
- Provide checklists
- Reference specific thought leader sections

**4. Context**
- Explain rationale, not just rules
- Document trade-offs considered
- Acknowledge alternatives
- Provide historical context when relevant

**5. Maintainability**
- Version the document
- Include last updated date
- Note update triggers
- Keep references current

### Structure Principles

**1. Scannable**
- Clear section headers
- Table of contents
- Consistent formatting
- Visual hierarchy

**2. Searchable**
- Use keywords in headers
- Anchor links for navigation
- Tags or labels for topics
- Consistent terminology

**3. Cross-Referenced**
- Link to related sections
- Reference thought leaders
- Point to detailed docs
- Connect to AGENTS.md, README.md

**4. Versioned**
- Track changes in git
- Include version number
- Maintain changelog
- Document major revisions

### Code Example Guidelines

**Format**:
```[language]
// ✅ Good: [Description of why this is good]
[good code example]

// ❌ Bad: [Description of why this is bad]
[bad code example]
```

**Principles**:
- Use syntax highlighting
- Keep examples concise (< 20 lines)
- Include comments explaining key points
- Show before/after for comparisons
- Use realistic scenarios

### Language and Tone

**Be**:
- Professional but approachable
- Opinionated but reasoned
- Specific rather than vague
- Teaching-oriented

**Avoid**:
- Absolutist language ("always", "never" without qualification)
- Unexplained jargon
- Condescension
- Dogma without rationale

**Examples**:

**❌ Weak**:
"Use TDD because it's better."

**✅ Strong**:
"We practice TDD because it improves design through testability, provides living documentation of behavior, enables safe refactoring, and catches bugs early. See research/KENT_BECK.md for the original TDD philosophy."

---

## AI Agent Utilization

### Integration with AI Tools

**Purpose**: Make PHILOSOPHY.md easily accessible to AI coding assistants

### 1. Cross-References in Configuration Files

**AGENTS.md**:
```markdown
# AGENTS.md

## Coding Philosophy
See PHILOSOPHY.md for our coding philosophy and architectural decisions.

Key principles:
- TDD (PHILOSOPHY.md#testing)
- Hexagonal architecture (PHILOSOPHY.md#architecture)
- Composition over inheritance (PHILOSOPHY.md#design-patterns)

Before making architectural decisions, consult PHILOSOPHY.md.
```

**GitHub Copilot** (`.github/copilot-instructions.md`):
```markdown
# GitHub Copilot Instructions

## Philosophy
This project follows coding philosophies documented in PHILOSOPHY.md.

Consult PHILOSOPHY.md for:
- Architecture decisions (PHILOSOPHY.md#architecture)
- Testing approach (PHILOSOPHY.md#testing)
- Design pattern preferences (PHILOSOPHY.md#design-patterns)

Key principles: TDD, Hexagonal Architecture, Composition over Inheritance
```

**Cursor** (`.cursor/rules/index.mdc`):
```markdown
---
description: "Project coding philosophy"
globs: ["**/*"]
---

# Coding Philosophy

See PHILOSOPHY.md for complete coding philosophy.

Before implementing features:
1. Check PHILOSOPHY.md for relevant principles
2. Review research/ for thought leader perspectives
3. Apply appropriate patterns

Key principles:
- TDD (PHILOSOPHY.md#testing)
- Hexagonal architecture (PHILOSOPHY.md#architecture)
```

**Claude Code** (`CLAUDE.md`):
```markdown
# CLAUDE.md

## Coding Philosophy
We follow coding philosophies in PHILOSOPHY.md.

Key principles to always follow:
- TDD (PHILOSOPHY.md#testing)
- Hexagonal architecture (PHILOSOPHY.md#architecture)
- Composition over inheritance (PHILOSOPHY.md#design-patterns)

When making design decisions, consult PHILOSOPHY.md first.
```

### 2. Section Anchors for AI Reference

Use consistent anchor IDs:

```markdown
## Architecture {#architecture}
## Testing {#testing}
## Design Patterns {#design-patterns}
## Refactoring {#refactoring}
```

AI tools can reference: `PHILOSOPHY.md#testing`

### 3. Keyword Optimization

Include keywords AI tools search for:

- "architecture"
- "testing"
- "patterns"
- "best practices"
- "conventions"
- "principles"
- "philosophy"
- "rationale"
- "trade-offs"

### 4. Machine-Readable Metadata

Consider frontmatter:

```markdown
---
title: "Project Coding Philosophy"
version: "1.0.0"
last_updated: "2025-01-15"
topics:
  - architecture
  - testing
  - patterns
  - refactoring
authors:
  - "@username1"
  - "@username2"
---

# Project Name: Coding Philosophy

[Content...]
```

### 5. Claude Code-Specific Integration

**Subagent for Philosophy Guidance**:

```typescript
// .claude/agents/philosophy-advisor.ts
export default {
  name: "philosophy-advisor",
  description: "Provides coding philosophy guidance",
  systemPrompt: `
You are a philosophy advisor for this codebase.

Your role:
1. Reference PHILOSOPHY.md for project-specific philosophy
2. Reference research/ for thought leader perspectives
3. Help developers apply philosophical principles
4. Explain rationale behind architectural choices

Always cite specific sections and thought leaders.
Connect principles to concrete examples.
Explain trade-offs when presenting options.
`,
  tools: ["read", "grep", "glob"],
  model: "claude-sonnet-4-5"
};
```

**Slash Command for Quick Philosophy Access**:

```typescript
// .claude/commands/philosophy.ts
export default {
  name: "philosophy",
  description: "Get philosophy guidance for specific topic",
  async execute(args: string[]) {
    const topic = args[0] || "overview";
    const philosophy = await readFile("PHILOSOPHY.md");
    const researchFiles = await glob(`research/*${topic}*.md`);

    return `
# Philosophy Guidance: ${topic}

## Project Philosophy
${extractSection(philosophy, topic)}

## Thought Leader Perspectives
${await Promise.all(researchFiles.map(readFile))}

## Application
How would you like to apply this philosophy to your current task?
    `;
  }
};
```

### 6. Aider Integration

**Helper Script**:

```bash
#!/bin/bash
# .aider-scripts/with-philosophy.sh

echo "Starting Aider with philosophy context..."

aider \
  --read PHILOSOPHY.md \
  --read AGENTS.md \
  --message "Philosophy files loaded. Ready for development." \
  "$@"
```

**Usage Documentation** in README.md:

```markdown
## Using Aider

```bash
# Launch Aider with philosophy context
./.aider-scripts/with-philosophy.sh src/feature.ts

# Or manually add philosophy
aider
/add PHILOSOPHY.md
/add src/feature.ts
```
```

---

## Evolution and Versioning

### Semantic Versioning for Philosophy

**Major (X.0.0)**: Fundamental philosophy changes
- Example: Switching from monolith to microservices
- Example: Changing from OOP to functional paradigm

**Minor (1.X.0)**: New sections or significant additions
- Example: Adding security philosophy section
- Example: Documenting new architectural patterns

**Patch (1.0.X)**: Clarifications, typos, small improvements
- Example: Fixing typos
- Example: Adding examples to existing sections
- Example: Updating references

### Changelog

Maintain `PHILOSOPHY_CHANGELOG.md` or include in PHILOSOPHY.md:

```markdown
## Version History

### 1.2.0 (2025-01-15)
- Added security philosophy section
- Added research/SECURITY_PATTERNS.md
- Expanded testing philosophy with integration testing guidance

### 1.1.1 (2025-01-10)
- Fixed typos in architecture section
- Added code examples for composition pattern
- Updated Martin Fowler research file with latest articles

### 1.0.0 (2025-01-01)
- Initial philosophy documentation
- Core principles, architecture, testing, patterns sections
- Research files for Fowler, Beck, Martin
```

### Review Cycle

**Quarterly Review**:
- Review philosophy for accuracy
- Update based on learnings
- Add new research files
- Refine examples

**Triggered Reviews**:
- Major architectural decisions
- Technology stack changes
- Team feedback
- Production issues revealing philosophy gaps

---

## Recommendations

### For Solo Developers

- **Use Pattern 1** (Simple): Single PHILOSOPHY.md file
- **Keep concise**: Focus on key principles
- **Grow organically**: Add sections as needed
- **Start small**: 3-5 core principles initially

### For Small Teams (2-10 developers)

- **Use Pattern 1 or 2**: Start simple, grow to modular if needed
- **Collaborative creation**: Workshop to define philosophy
- **Version control**: Track philosophy evolution
- **Reference in code reviews**: Build habit of citing philosophy

### For Medium Teams (10-50 developers)

- **Use Pattern 2** (Modular): philosophy/ directory
- **Dedicated ownership**: Philosophy champion or rotating ownership
- **Regular reviews**: Quarterly philosophy review sessions
- **Integration with onboarding**: Philosophy is required reading

### For Large Teams/Enterprise (50+ developers)

- **Use Pattern 3** (Comprehensive): Full structure
- **Documentation team**: Dedicated technical writers
- **Philosophy governance**: Review board for major changes
- **Multi-repository**: Shared philosophy across org

### For Open Source Projects

- **Use Pattern 2 or 3**: Accessible but comprehensive
- **Community input**: Philosophy discussions in issues/PRs
- **Transparent evolution**: Public discussion of philosophy changes
- **Educational focus**: Philosophy as learning resource

---

## Summary

**File naming**: `PHILOSOPHY.md` (all caps, consistent with conventions)

**Organization**:
- Pattern 1 (Simple): Solo/small projects
- Pattern 2 (Modular): Medium projects
- Pattern 3 (Comprehensive): Large/enterprise projects

**Content**:
- Rationale-focused (why, not just what)
- Example-rich
- Cross-referenced
- Versioned

**AI Integration**:
- Referenced by all tool configs (AGENTS.md, CLAUDE.md, etc.)
- Section anchors for direct reference
- Claude Code subagents/commands for advanced usage
- Helper scripts for terminal tools (Aider)

**Evolution**:
- Semantically versioned
- Quarterly reviews
- Triggered by major decisions
- Community/team-driven (open source/enterprise)

**Next Step**: Choose appropriate pattern for your project and create initial PHILOSOPHY.md.
