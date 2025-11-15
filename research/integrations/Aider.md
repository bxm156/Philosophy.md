# Philosophy.md Integration with Aider

## Overview

Aider is an AI pair programming tool that runs in your terminal, designed for editing code in your local git repository. Unlike IDE-based tools, Aider operates as a command-line interface that maintains context across multiple files through repository mapping and configuration files.

## Key Characteristics

**Terminal-based**: Runs in command line, not an IDE
**Repository-aware**: Maps entire codebase for context
**Git-integrated**: Automatically commits changes
**Model-flexible**: Supports multiple LLMs (Claude, GPT-4, DeepSeek, local models)
**File-focused**: Explicitly add files to editing context

## Integration Mechanisms

### 1. Repository Mapping (Automatic Context)

**How it Works**: Aider automatically creates a map of your entire codebase to understand project structure

**Philosophy Integration**:
- Aider discovers PHILOSOPHY.md automatically through repository mapping
- When working on files, Aider can pull context from PHILOSOPHY.md
- Repository map helps Aider understand which philosophy sections are relevant

**Benefits**:
- No explicit configuration required
- PHILOSOPHY.md available as context when needed
- Related files discovered automatically

**Limitation**:
- Passive discovery - doesn't automatically apply philosophy
- Need to reference PHILOSOPHY.md explicitly in prompts initially

---

### 2. Aider Configuration Files

**Location**: `~/.aider.conf.yml` or project-specific `.aider.conf.yml`

**Purpose**: Configure Aider behavior, model settings, and defaults

**Example Configuration**:

```yaml
# .aider.conf.yml

# Model configuration
model: claude-4-sonnet

# Repository settings
auto-commits: true
dirty-commits: true
attribute-author: false

# Context and caching
cache-prompts: true
map-tokens: 1024

# Philosophy integration reminder
# Note: Reference PHILOSOPHY.md in prompts for philosophical guidance
```

**Philosophical Guidance Configuration**:

While Aider doesn't have a direct "philosophy file" configuration, you can document this in your project:

```yaml
# .aider.conf.yml

# CODING PHILOSOPHY GUIDANCE
# This project follows coding philosophies in PHILOSOPHY.md
# Before making architectural decisions:
#   1. Add PHILOSOPHY.md to context: /add PHILOSOPHY.md
#   2. Ask: "Based on PHILOSOPHY.md, should I use approach X or Y?"
#   3. Reference specific sections: "Check PHILOSOPHY.md#testing"

# For thought leader perspectives, add research files:
#   /add research/MARTIN_FOWLER.md
#   /add research/ROBERT_MARTIN.md

model: claude-4-sonnet
auto-commits: false
```

---

### 3. .aider.model.settings.yml (Model-Specific Settings)

**Location**: `~/.aider.model.settings.yml`

**Purpose**: Configure behavior for specific models

**Example**:

```yaml
# .aider.model.settings.yml

- name: claude-4-sonnet
  edit_format: diff
  use_repo_map: true
  send_undo_reply: true
  lazy: false
  reminder: |
    Before making architectural decisions, consult PHILOSOPHY.md.
    Reference research/ directory for thought leader perspectives.

- name: gpt-4o
  edit_format: editor-diff
  use_repo_map: true
  reminder: |
    This project follows philosophies documented in PHILOSOPHY.md.
    Add PHILOSOPHY.md to context when making design decisions.
```

**Note**: The `reminder` field (if supported) could include philosophy references, though this may vary by Aider version.

---

### 4. AGENTS.md Support

**How it Works**: Aider can read AGENTS.md as project documentation

**Integration Strategy**: Use AGENTS.md to point to PHILOSOPHY.md

**Example AGENTS.md**:

```markdown
# AGENTS.md

## Aider Usage Notes

When using Aider for this project:

1. Add PHILOSOPHY.md to context for architectural decisions:
   ```
   /add PHILOSOPHY.md
   ```

2. Reference specific philosophy sections in prompts:
   - Testing philosophy: PHILOSOPHY.md#testing
   - Architecture: PHILOSOPHY.md#architecture
   - Patterns: PHILOSOPHY.md#patterns

3. For thought leader perspectives, add research files:
   ```
   /add research/MARTIN_FOWLER.md
   /add research/KENT_BECK.md
   ```

## Coding Philosophy

See PHILOSOPHY.md for complete coding philosophy.

Key principles:
- TDD (PHILOSOPHY.md#testing)
- Hexagonal architecture (PHILOSOPHY.md#architecture)
- Composition over inheritance (PHILOSOPHY.md#patterns)

## Architecture

[Project architecture summary]

See PHILOSOPHY.md#architecture for rationale and detailed explanations.
```

**Benefits**:
- Cross-tool compatible (works with GitHub Copilot, Cursor, etc.)
- Aider can read as context when needed
- Version-controlled guidance

---

### 5. Explicit File Addition (Best Practice)

**How it Works**: Use `/add` command to explicitly include philosophy docs

**Workflow**:

```bash
$ aider

# Add files to edit
> /add src/auth/login.ts

# Add philosophy for context
> /add PHILOSOPHY.md

# Add relevant research
> /add research/MARTIN_FOWLER.md

# Now prompt with philosophical context
> "Implement login feature following our hexagonal architecture
  philosophy from PHILOSOPHY.md"
```

**Benefits**:
- Explicit control over context
- Philosophy directly available to LLM
- Can reference specific sections
- Reduces need for repetition

**Best Practice**: Create Aider session templates

```bash
# .aider-scripts/with-philosophy.sh
#!/bin/bash

aider \
  --read PHILOSOPHY.md \
  --read AGENTS.md \
  "$@"
```

Usage:
```bash
$ .aider-scripts/with-philosophy.sh src/components/UserProfile.tsx
# Starts Aider with philosophy files automatically loaded
```

---

### 6. Prompt Templates with Philosophy

**How it Works**: Create reusable prompts that reference philosophy

**Example Prompt Templates**:

**Template: Feature Implementation**
```
I need to implement [FEATURE].

Based on PHILOSOPHY.md#architecture, we use hexagonal architecture.
Based on PHILOSOPHY.md#testing, we practice TDD.

Please:
1. Design the domain layer first
2. Add tests before implementation
3. Create adapters for external dependencies
4. Follow patterns from PHILOSOPHY.md#patterns

Let's start with the tests.
```

**Template: Code Review**
```
Review this code against our coding philosophy.

Check PHILOSOPHY.md for:
- Architecture compliance (PHILOSOPHY.md#architecture)
- Testing requirements (PHILOSOPHY.md#testing)
- Pattern usage (PHILOSOPHY.md#patterns)

Also reference research/MARTIN_FOWLER.md for refactoring opportunities.

What improvements do you suggest?
```

**Template: Refactoring**
```
This code needs refactoring.

Consult:
- PHILOSOPHY.md#refactoring for our refactoring philosophy
- research/MARTIN_FOWLER.md for refactoring patterns
- PHILOSOPHY.md#patterns for preferred design patterns

Suggest refactorings that align with our philosophy.
Explain rationale for each suggestion.
```

---

### 7. README.md Integration

**How it Works**: Include philosophy reference in README that Aider may read

**Example README.md**:

```markdown
# Project Name

## For AI Pair Programming (Aider, etc.)

This project follows coding philosophies documented in **PHILOSOPHY.md**.

### Quick Start with Aider

```bash
# Add philosophy to context
aider --read PHILOSOPHY.md --read AGENTS.md

# Or use our helper script
./scripts/aider-with-philosophy.sh
```

### Key Philosophical Principles

- **TDD**: All features require tests (PHILOSOPHY.md#testing)
- **Hexagonal Architecture**: Domain-driven design (PHILOSOPHY.md#architecture)
- **Composition**: Prefer composition over inheritance (PHILOSOPHY.md#patterns)

See **PHILOSOPHY.md** for complete documentation and rationale.
See **research/** for thought leader perspectives.

[Rest of README]
```

---

### 8. Git Commit Messages with Philosophy

**How it Works**: Aider generates commit messages - can reference philosophy

**Configuration Approach**:

```yaml
# .aider.conf.yml

# Aider will generate commit messages
# Philosophy: Our commit messages follow Conventional Commits
# See PHILOSOPHY.md#git-workflow for our git philosophy
auto-commits: true
```

**Prompt Template for Commits**:
```
Please commit these changes.

Based on PHILOSOPHY.md#git-workflow:
- Use Conventional Commits format
- Include rationale in commit body
- Reference philosophical principle if relevant

Example:
feat(auth): Implement hexagonal auth architecture

Following PHILOSOPHY.md#architecture, implemented authentication
using hexagonal architecture with ports and adapters pattern.
This allows easy testing and framework independence.
```

---

## Recommended Integration Strategy

### Phase 1: Basic Philosophy Access

1. **Create AGENTS.md** with Aider-specific instructions
2. **Document workflow** for adding PHILOSOPHY.md to context
3. **Create helper scripts** to launch Aider with philosophy files

**Implementation**:

```bash
# scripts/aider-with-philosophy.sh
#!/bin/bash

echo "Starting Aider with Philosophy context..."
echo "Philosophy files automatically loaded:"
echo "  - PHILOSOPHY.md"
echo "  - AGENTS.md"
echo ""

aider \
  --read PHILOSOPHY.md \
  --read AGENTS.md \
  --message "Philosophy files loaded. Ready to develop following our coding principles." \
  "$@"
```

### Phase 2: Configuration Files

1. **Create .aider.conf.yml** in project root
2. **Add philosophy reminders** in configuration comments
3. **Configure model settings** with philosophy references
4. **Document in README.md**

### Phase 3: Prompt Templates

1. **Create .aider-prompts/** directory
2. **Add template prompts** for common tasks
3. **Each template** references PHILOSOPHY.md sections
4. **Document usage** in AGENTS.md

**Example Structure**:
```
.aider-prompts/
├── feature-implementation.md
├── code-review.md
├── refactoring.md
├── testing.md
└── architecture-decision.md
```

### Phase 4: Team Standardization

1. **Share Aider configuration** in repository
2. **Create onboarding docs** for Aider + Philosophy.md
3. **Establish conventions** for philosophy references
4. **Document lessons learned**

---

## Example Workflows

### Workflow 1: Feature Development with Philosophy

```bash
$ aider

# Add feature file and philosophy
> /add src/features/user-profile.ts
> /add PHILOSOPHY.md
> /add research/KENT_BECK.md

# Prompt with philosophy reference
> "Implement user profile feature using TDD as described in
   PHILOSOPHY.md#testing. Start with tests that document expected
   behavior, following patterns from research/KENT_BECK.md."

# Aider generates tests first
> /commit "test(profile): Add user profile tests following TDD philosophy"

# Then implementation
> "Now implement the user profile feature to make tests pass,
   following hexagonal architecture from PHILOSOPHY.md#architecture"

> /commit "feat(profile): Implement user profile with hexagonal architecture"
```

### Workflow 2: Architecture Decision

```bash
$ aider

# Add context
> /add src/services/payment.ts
> /add PHILOSOPHY.md
> /add research/MARTIN_FOWLER.md

# Ask for guidance
> "Should I use inheritance or composition for the payment service?
   Check PHILOSOPHY.md#patterns and research/MARTIN_FOWLER.md
   for our project philosophy on this decision."

# Aider responds based on philosophy
# "According to PHILOSOPHY.md#patterns, the project prefers
#  composition over inheritance because..."

# Implement following philosophy
> "Great. Please refactor to use composition pattern following
   the Strategy pattern from PHILOSOPHY.md#patterns."
```

### Workflow 3: Code Review with Philosophy

```bash
$ aider

# Add code to review
> /add src/components/UserDashboard.tsx
> /add PHILOSOPHY.md

# Review against philosophy
> "Review this component against our philosophy:
   - PHILOSOPHY.md#components for component design
   - PHILOSOPHY.md#testing for testing requirements
   - PHILOSOPHY.md#accessibility for a11y standards

   What improvements align with our philosophy?"

# Aider suggests improvements based on philosophy
# Implement suggestions
> "Apply the suggested improvements"

> /commit "refactor(dashboard): Align component with philosophy principles"
```

### Workflow 4: Refactoring Session

```bash
$ aider

> /add src/legacy/user-service.ts
> /add PHILOSOPHY.md
> /add research/MARTIN_FOWLER.md

> "This legacy code needs refactoring. Consult:
   - PHILOSOPHY.md#refactoring for our refactoring approach
   - research/MARTIN_FOWLER.md for refactoring patterns
   - PHILOSOPHY.md#architecture for target architecture

   Suggest refactoring steps to align with our philosophy.
   Apply refactorings incrementally with tests remaining green."

# Aider suggests incremental refactorings
# Each refactoring committed separately
> /commit "refactor(users): Extract method - first refactoring step"
```

---

## Advanced Techniques

### 1. Multi-Model Philosophy Consultation

Use different models for different philosophy aspects:

```bash
# Use Claude for architectural decisions
$ aider --model claude-4-sonnet

> /add PHILOSOPHY.md
> "What architecture should I use for this feature?"

# Use GPT-4 for test generation
$ aider --model gpt-4o

> /add PHILOSOPHY.md
> /add research/KENT_BECK.md
> "Generate tests following our TDD philosophy"
```

### 2. Philosophy-Aware Scripting

Create scripts that automatically include relevant philosophy:

```bash
# scripts/aider-backend.sh
#!/bin/bash
# Aider for backend development with backend-specific philosophy

aider \
  --read PHILOSOPHY.md \
  --read PHILOSOPHY_BACKEND.md \
  --read research/MARTIN_FOWLER.md \
  --read research/ROBERT_MARTIN.md \
  "$@"
```

```bash
# scripts/aider-frontend.sh
#!/bin/bash
# Aider for frontend development with frontend-specific philosophy

aider \
  --read PHILOSOPHY.md \
  --read PHILOSOPHY_FRONTEND.md \
  --read research/DAN_ABRAMOV.md \
  "$@"
```

### 3. Philosophy Sections as Separate Files

For large PHILOSOPHY.md, split into sections:

```
philosophy/
├── architecture.md
├── testing.md
├── patterns.md
├── refactoring.md
└── accessibility.md
```

Reference specific sections:

```bash
$ aider

# Add only relevant philosophy section
> /add philosophy/testing.md
> /add research/KENT_BECK.md

> "Write tests following our testing philosophy"
```

### 4. Research Integration

Create curated research collections:

```bash
# scripts/aider-with-research.sh
#!/bin/bash

TOPIC=$1
shift

case $TOPIC in
  architecture)
    RESEARCH="research/MARTIN_FOWLER.md research/ROBERT_MARTIN.md"
    ;;
  testing)
    RESEARCH="research/KENT_BECK.md research/ROY_OSHEROVE.md"
    ;;
  refactoring)
    RESEARCH="research/MARTIN_FOWLER.md"
    ;;
  *)
    RESEARCH=""
    ;;
esac

aider \
  --read PHILOSOPHY.md \
  --read AGENTS.md \
  $(for file in $RESEARCH; do echo "--read $file"; done) \
  "$@"
```

Usage:
```bash
$ ./scripts/aider-with-research.sh testing src/features/auth.test.ts
# Loads philosophy + testing research automatically
```

---

## Integration Benefits

### For Developers

- **Terminal workflow**: Philosophy integration in command-line workflow
- **Explicit control**: Choose when to load philosophy context
- **Model flexibility**: Use different models with same philosophy
- **Git integration**: Philosophy-aware commits

### For AI Code Generation

- **Repository context**: Full codebase map includes philosophy
- **Explicit guidance**: Philosophy loaded when needed
- **Research access**: Thought leader perspectives available
- **Consistent application**: Same philosophy across sessions

### For Teams

- **Shared scripts**: Team uses same philosophy-loading workflows
- **Version controlled**: All integration scripts in repository
- **Model agnostic**: Works with any LLM Aider supports
- **Terminal-friendly**: Works in any development environment

---

## Limitations and Considerations

### Manual Context Loading
- **Issue**: Philosophy not automatically applied
- **Solution**: Create helper scripts and document workflow
- **Benefit**: Explicit control over context budget

### Token Budget
- **Issue**: Loading all philosophy files consumes tokens
- **Solution**: Load specific sections as needed
- **Benefit**: Targeted, relevant context

### No Native Philosophy Support
- **Issue**: Aider doesn't have built-in philosophy file support
- **Workaround**: Use configuration comments, AGENTS.md, helper scripts
- **Future**: Could propose feature to Aider project

### Git Auto-Commits
- **Issue**: Aider auto-commits may not reference philosophy
- **Solution**: Disable auto-commits, write philosophy-aware commit messages manually
- **Configuration**: `auto-commits: false` in .aider.conf.yml

---

## Best Practices

### 1. Create Helper Scripts

Don't manually load philosophy files every time:

```bash
# scripts/aider.sh
#!/bin/bash
# Standard Aider launch with philosophy

aider --read PHILOSOPHY.md --read AGENTS.md "$@"
```

### 2. Document in README

Include Aider-specific instructions:

```markdown
## Using Aider with This Project

```bash
# Use our helper script (loads philosophy automatically)
./scripts/aider.sh src/feature.ts

# Or manually add philosophy
aider
/add PHILOSOPHY.md
/add src/feature.ts
```
```

### 3. Create Prompt Templates

Save common philosophy-aware prompts:

```
.aider-prompts/
├── implement-feature.txt
├── review-code.txt
├── refactor.txt
└── write-tests.txt
```

Load with:
```bash
$ cat .aider-prompts/implement-feature.txt | aider
```

### 4. Reference Specific Sections

Don't just say "follow PHILOSOPHY.md":

```
# Vague
> "Follow our philosophy"

# Specific
> "Follow hexagonal architecture from PHILOSOPHY.md#architecture,
   using ports and adapters pattern described in section 3"
```

### 5. Keep Sessions Focused

Add only relevant philosophy sections:

```bash
# Working on tests? Add testing philosophy
> /add PHILOSOPHY.md  # Or just testing section
> /add research/KENT_BECK.md

# Working on architecture? Add architecture philosophy
> /add PHILOSOPHY.md  # Or just architecture section
> /add research/MARTIN_FOWLER.md
```

---

## Cross-Tool Compatibility

### Supporting Multiple AI Tools

Use **AGENTS.md** as the cross-tool standard:

```
/repository/
├── AGENTS.md              # Cross-tool (Aider, Copilot, Cursor)
├── .aider.conf.yml        # Aider-specific config
├── .github/
│   └── copilot-instructions.md  # Copilot-specific
├── .cursor/
│   └── rules/
│       └── index.mdc      # Cursor-specific
├── PHILOSOPHY.md          # Detailed philosophy (referenced by all)
├── research/              # Thought leader philosophies
└── scripts/
    └── aider.sh          # Aider helper scripts
```

**AGENTS.md** works across all tools.
**Tool-specific configs** provide enhanced features for that tool.
**PHILOSOPHY.md** is the single source of truth referenced by all.

---

## Future Enhancements

### Potential Aider Features

Ideas to propose to Aider project:

1. **Native philosophy file support**: `--philosophy PHILOSOPHY.md` flag
2. **Auto-load philosophy**: Configuration option to always load philosophy
3. **Philosophy templates**: Built-in templates for common philosophy patterns
4. **Philosophy search**: Search philosophy docs for relevant sections
5. **Philosophy validation**: Check code against philosophy programmatically

### Community Contribution

Consider contributing to Aider:
- Feature request for native philosophy support
- Plugin/extension system for philosophy integration
- Example configurations and scripts to Aider docs

---

## References

1. Aider. "aider is AI pair programming in your terminal." https://aider.chat/
2. GitHub. "Aider-AI/aider." https://github.com/Aider-AI/aider
3. Apidog. "What is Aider AI and How to use Aider: A Beginners Guide." https://apidog.com/blog/aider-ai/
4. Blott. "Aider Review: A Developer's Month With This Terminal-Based Code Assistant [2025]." https://www.blott.com/blog/post/aider-review-a-developers-month-with-this-terminal-based-code-assistant
5. PyPI. "aider-chat." https://pypi.org/project/aider-chat/
6. Shakudo. "What is Aider? Docs, Demo and How to Deploy." https://www.shakudo.io/integrations/aider
